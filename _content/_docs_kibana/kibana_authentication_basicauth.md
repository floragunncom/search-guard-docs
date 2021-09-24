---
title: Quick Start
html_title: Username/password based authentication for Dashboards/Kibana
permalink: kibana-authentication-http-basic
category: kibana-authentication-basic-overview
order: 100
layout: docs
edition: community
description: How to configure Dashboards/Kibana for Username/password based authentication. Secure Dashboards/Kibana access with a login screen.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Password-based authentication for Dashboards/Kibana
{: .no_toc}

This approach is the simplest and most commonly used authentication type. If a user tries to access Dashboards/Kibana:

* Search Guard checks whether the user has an active session with valid username/password credentials
* If so, the user is allowed to access Dashboards/Kibana and the underlying Elastisearch/OpenSearch cluster.
* If the user does not have an active session, Search Guard will show a login form. The user now has to log in using their username and password.

This approach can be used to authenticate users using the [Search Guard internal user database](../_docs_roles_permissions/configuration_internalusers.md)  or using [LDAP](../_docs_auth_auth/auth_auth_ldap.md).

Suppose the Search Guard OpenSearch/Elasticsearch backend has been already configured with username/password-based authentication. In that case, this should also work out of the box for Dashboards/Kibana.<br>You only have to make sure that users who are supposed to log into Dashboards/Kibana have the role `SGS_KIBANA_USER`.
{: .note .js-note .note-warning}

To verify the configuration for this approach, follow the steps described in the following sections.

## Search Guard Setup

Ensure that you configured authentication domains of type `basic` in the Search Guard `sg_config` configuration. In most cases, you already created this configuration when configuring the OpenSearch/Elasticsearch backend.

For the internal user database, such an entry in `sg_config.yml` might look like this:

```yaml
sg_config:
  dynamic:
    authc:
     basic_internal_auth_domain:
       http_enabled: true
       order: 1
     http_authenticator:
       type: basic
       challenge: true
     authentication_backend:
       type: internal
```

See the chapters on the [Search Guard internal user database](../_docs_roles_permissions/configuration_internalusers.md) and [LDAP](../_docs_auth_auth/auth_auth_ldap.md) for more details on setting up such auth domains.

The Dashboards/Kibana-specific part of the authentication configuration is done in the file `sg_frontend_config.yml`. By default, this file contains this entry:

```yaml
default:
  authcz:
  - type: basic
    label: "Login"
```

This makes Dashboards/Kibana use the username/password-based authentication domains available in the backend.

Username/password-based authentication requires no specific settings in the `opensearch_dashboards.yml`/`kibana.yml` Dashboards/Kibana configuration file.