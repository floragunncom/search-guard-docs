---
title: Anonymous authentication
html_title: Kibana anon authentication
slug: kibana-authentication-anonymous
category: kibana-authentication
order: 800
layout: docs
edition: community
description: How to configure Kibana to allow anonymous access to indices, dashboards, and visualization

---
<!---
Copyright 2022 floragunn GmbH
-->

# Kibana Anonymous Authentication
{: .no_toc}

{% include toc.md %}

Search Guard supports [anonymous authentication](../_docs_auth_auth/auth_auth_anon.md) to enable access to specific indices for unauthenticated users. 

## Backend configuration

In order to use anonymous authentication in Kibana, you first must configure the Elasticsearch backend to allow anonymous authentication. A minimal `sg_authc.yml` configuration for this looks like this:

```yaml
auth_domains:
- type: basic/internal_users_db
- type: anonymous
  user_mapping.user_name.static: anonymous
  user_mapping.roles.static: SGS_KIBANA_USER
```

See the [documentation](../_docs_auth_auth/auth_auth_anon.md) for more details on the backend configuration.

The role `SGS_KIBANA_USER` is needed because a certain set of permissions is necessary to access Kibana. If anonymous users shall not be able to access the default tenant, you should use the role `SGS_KIBANA_USER_NO_DEFAULT_TENANT` instead.

**Note:** Do not forget that the anonymous user also needs to have privileges for the indices they are supposed to access. For this, you need to map the user to more roles. See the [backend documentation](../_docs_auth_auth/auth_auth_anon.md) for details on this.

**Note:** If you want to allow anonymous authentication only for Kibana, you can restrict the `anonymous` auth domain to the IPs that Kibana uses to connect to the backend. This can look like this:

```yaml
auth_domains:
- type: basic/internal_users_db
- type: anonymous
  accept.ips: "10.12.123.0/24"
  user_mapping.user_name.static: anonymous
  user_mapping.roles.static: SGS_KIBANA_USER
```


## Kibana configuration

Finally, you need to tell the Kibana plugin to allow anonymous authentication. You do this by adding the following setting to `kibana.yml`: 

```
searchguard.auth.anonymous_auth_enabled: true
```

Effects:

* If the request is not already authenticated and there is no user active user session, Kibana will forward all requests to Elasticsearch without further checks
* Search Guard will evaluate the roles for the anonymous user and the associated permissions
* Kibana will load and the user has access to all indices configured for the anonymous role
* In anonymous mode, Kibana will display a `login` button instead of the `logout` button. The `login` button will display the Search Guard login page where the user can use credentials to log in and enter authenticated mode.
* In authenticated mode, Kibana will display a `logout` button which ends the user session and enters anonymous mode again.

