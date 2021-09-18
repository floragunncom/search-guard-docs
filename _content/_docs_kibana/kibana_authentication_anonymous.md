---
title: Anonymous authentication
html_title: Dashboards/Kibana anon authentication
permalink: kibana-authentication-anonymous
category: kibana-authentication
order: 800
layout: docs
edition: community
description: How to configure Dashboards/Kibana to allow anonymous access to indices, dashboards, and visualization

---
<!---
Copyright 2020 floragunn GmbH
-->

# Dashboards/Kibana Anonymous Authentication
{: .no_toc}

{% include toc.md %}

Search Guard supports [anonymous authenticaton](../_docs_auth_auth/auth_auth_anon.md) to enable access to specific indices for unauthenticated users. 

To use anonymous authentication with Dashboards/Kibana, please follow these steps:

## Activating anonymous authentication in Dashboards/Kibana

To enable anonymous authentication, enable it in kibana.yml like:

```
searchguard.auth.anonymous_auth_enabled: true
```

Effects:

* If the request is not already authenticated and there is no user active user session, Dashboards/Kibana will forward all requests to OpenSearch/Elasticsearch without further checks
* Search Guard will assign the (unauthenticated) request to the anonymous role and evaluate the associated permissions
* Dashboards/Kibana will load and the user has access to all indices configured for the anonymous role
* In anonymous mode, Dashboards/Kibana will display a `login` button instead of the `logout` button. The `login` button will display the Search Guard login page where the user can use credentials to log in and enter authenticated mode.
* In authenticated mode, Dashboards/Kibana will display a `logout` button which ends the user session and enters anonymous mode again.

## Activating anonymous authentication in OpenSearch/Elasticsearch

To use anonymous authentication, enable it in sg_config.yml like:

```yaml
---
_sg_meta:
  type: "config"
  config_version: 2

sg_config:
  dynamic:
    ...
    http:
      anonymous_auth_enabled: true
```


## Dashboards/Kibana access permissions for the anonymous user

Every Dashboards/Kibana user needs a minimum set of permissions to be able to access Dashboards/Kibana. These permissions are defined in the built-in `SGS_KIBANA_USER` role. You can assign these permissions by either:

**Mapping the backend role `sg_anonymous_backendrole` to the `SGS_KIBANA_USER` role.**

sg\_roles\_mapping.yml:

```
SGS_KIBANA_USER:
  backend_roles:
    - sg_anonymous_backendrole
```

**Mapping the `sg_anonymous` user to the `SGS_KIBANA_USER` role.**

sg\_roles\_mapping.yml:

```
SGS_KIBANA_USER:
  users:
    - sg_anonymous
```

## Index access permissions for the anonymous user

As with any other Dashboards/Kibana user, assign the index permissions you want to grant to the anonymous user by assign this user to a Search Guard role. For example:

sg_roles.yml:

```
sg_anonymous_role:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS_RO
  index_permissions:
    - index_patterns:
      - "public-*"
      allowed_actions:
        - READ
```

sg\_roles\_mapping.yml:        

```
sg_anonymous_role:
  backend_roles:
    - sg_anonymous_backendrole
```

