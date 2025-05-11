---
title: Anonymous authentication
permalink: anonymous-authentication
layout: docs
edition: community
description: How to use Search Guard anonymous authentication to assign default permissions
  if a user is not authenticated.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Anonymous authentication
{: .no_toc}

{% include toc.md %}

Search Guard supports anonymous authentication. Usually, if no user credentials are provided, Search Guard will decline the request. However, with anonymous authentication, you can grant basic rights to unauthenticated requests.

For example, you can grant unauthenticated users read-only access to certain indices, while requiring authentication for all other requests.

You can choose to enable anonymous authentication only for specific source IPs.

## Search Guard setup

To use anonymous authentication, edit `sg_authc.yml` and append an authentication domain of type `anonymous` to the end of the list of authentication domains:

```yaml
auth_domains:
- type: basic/internal_users_db
- type: anonymous
  user_mapping.user_name.static: anon
  user_mapping.roles.static: anon_role
```

You use the options `user_mapping.user_name.static` and `user_mapping.roles.static` to define which user name and which roles shall be assigned to the anonymous user.

You can also use the client IP address as the name of the anonymous user:

```yaml
auth_domains:
- type: basic/internal_users_db
- type: anonymous
  user_mapping.user_name.from: request.originating_ip_address
  user_mapping.roles.static: anon_role
```

Then, use `sg_roles_mapping.yml` and `sg_roles.yml` to assign the desired privileges to the `anon_role`: 


**sg\_roles\_mapping.yml:**

```
sg_anonymous:
  backend_roles:
    - anon_role
```

**sg\_roles.yml:**

```
sg_anonymous:
  cluster_permissions:
    - SGS_CLUSTER_COMPOSITE_OPS_RO
  indices_permissions:
    'public':
      - SGS_READ
```

### Client IP specific anonymous users

If you want to activate anonymous authentication only for specific source IPs, you can use the standard `accept.ips` config option of authentication domains:

```yaml
auth_domains:
- type: basic/internal_users_db
- type: anonymous
  accept.ips: "10.12.123.0/24"
  user_mapping.user_name.from: request.originating_ip_address
  user_mapping.roles.static: anon_role
```

Using this method, you can even define different privilege levels for anonymous users, based on their origin IP. Just define several `anonymous` auth domains for different CIDR subnets:

```yaml
auth_domains:
- type: basic/internal_users_db
- type: anonymous
  accept.ips: "10.12.123.0/24"
  user_mapping.user_name.from: request.originating_ip_address
  user_mapping.roles.static: anon_role_low_rights
- type: anonymous
  accept.ips: "172.10.1.0/24"
  user_mapping.user_name.from: request.originating_ip_address
  user_mapping.roles.static: anon_role_elevated_rights
```


## Activate the setup

After having applied the changes to `sg_authc.yml`, use `sgctl` to upload the file to Search Guard:

```
$ ./sgctl.sh update-config sg_authc.yml
```

That’s it. If you navigate in a browser to your Elasticsearch instance, you should get a basic authentication popup asking for your username and password. If you then click on "Cancel", you should be logged in as anonymous user.


