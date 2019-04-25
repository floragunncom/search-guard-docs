---
title: Anonymous authentication
html_title: Anonymous authentication
slug: kibana-authentication-anonymous
category: kibana-authentication
order: 220
layout: docs
edition: community
description: How to configure Kibana to allow anonymous access to indices, dashboards, and visualization

---
<!---
Copryight 2016-2017 floragunn GmbH
-->

# Using Kibana with anonymous authentication
{: .no_toc}

{% include toc.md %}

Search Guard supports [anonymous authenticaton](../_docs_auth_auth/auth_auth_anon.md) to enable access to specific indices for unauthenticated users. 

To use anonymous authentication with Kibana, please follow these steps:

## Activating anonymous authentication in Kibana

To enable anonymous authentication, enable it in kibana.yml like:

```
searchguard.auth.anonymous_auth_enabled: true
```

Effects:

* If the request is not already authenticated and there is no user active user session, Kibana will forward all requests to Elasticsearch without further checks
* Search Guard will assign the (unauthenticated) request to the anonymous role and evaluate the associated permissions
* Kibana will load and the user has access to all indices configured for the anonymous role
* In anonymous mode, Kibana will display a `login` button instead of the `logout` button. The `login` button will display the Search Guard login page where the user can use credentials to log in and enter authenticated mode.
* In authenticated mode, Kibana will display a `logout` button which ends the user session and enters anonymous mode again.

Kibana anonymous authentication only works in conjunction with Basic authentication. SSO authentication like JWT, OpenID or SAML is not supported
{: .note .js-note .note-warning}

## Activating anonymous authentication in Elasticsearch

To use anonymous authentication, enable it in sg_config.yml like:

```yaml
searchguard:
  dynamic:
    ...
    http:
      anonymous_auth_enabled: true
```


## Kibana access permissions for the anonymous user

Every Kibana user needs a minimum set of permissions to be able to access Kibana. In the Search Guard demo configuration, these permissions are defined in the `sg_kibana_user` role. You can assign these permissions by either:

**Mapping the backend role `sg_anonymous_backendrole` to the `sg_kibana_user` role.**

sg\_roles\_mapping.yml:

```
sg_kibana_user:
  backendroles:
    - sg_anonymous_backendrole
```

**Mapping the `sg_anonymous` user to the sg_kibana_user role.**

sg\_roles\_mapping.yml:

```
sg_kibana_user:
  users:
    - sg_anonymous
```
**Adding the permissions to the default `sg_anonymous_backendrole` directly (not recommended due to a lack of flexibility)**

```
sg_anonymous_backendrole:
  cluster:
    - INDICES_MONITOR
    - CLUSTER_COMPOSITE_OPS
  indices:
    '?kibana':
      '*':
        - MANAGE
        - INDEX
        - READ
        - DELETE
    '?kibana-6':
      '*':
        - MANAGE
        - INDEX
        - READ
        - DELETE
    '*':
      '*':
        - indices:data/read/field_caps*
```

## Index access permissions for the anonymous user

As with any other Kibana user, assign the index permissions you want to grant to the anonymous user by assign this user to a Search Guard role. For example:

sg_roles.yml:

```
sg_anonymous_role:
  cluster:
    - CLUSTER_COMPOSITE_OPS_RO
  indices:
    'public-*':
      '*':
        - READ
```

sg\_roles\_mapping.yml:        

```
sg_anonymous_role:
  backendroles:
    - sg_anonymous_backendrole
```

