---
title: Anonymous authentication
slug: anonymous authentication 
category: authauth
order: 1000
layout: docs
edition: community
description: How to use Search Guard anonymous authentication to assign default permissions if a user is not authenticated.
---
<!---
Copyright 2019 floragunn GmbH
-->

# Anonymous authentication
{: .no_toc}

{% include toc.md %}

Search Guard supports anonymous authentication. Usually, if no user credentials are provided, Search Guard will decline the request with a security exception. However, if you enable anonymous authentication, unauthenticated requests get assigned to a default user and backend role automatically.

For example, you can grant unauthenticated users read-only access to certain indices, while requiring authentication for all other requests.

## Enabling anonymous authentication

To use anonymous authentication, enable it in sg_config.yml like:

```yaml
searchguard:
  dynamic:
    ...
    http:
      anonymous_auth_enabled: true
```

| Name | Description |
|---|---|
| anonymous\_auth\_enabled | Whether to enable anonymous authentication. Boolean. Default: false|

## User and role mapping

Anonymous users always have the username `sg_anonymous` and one backen role named `sg_anonymous_backendrole`. 

You can use the role mapping to assign one or more Search Guard role to this user:

sg\_roles\_mapping.yml:

```
sg_anonymous:
  backendroles:
    - sg_anonymous_backendrole
```

sg\_roles.yml:

```
sg_anonymous:
  cluster:
    - CLUSTER_COMPOSITE_OPS_RO
  indices:
    'public':
      '*':
        - READ
```
