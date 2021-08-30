---
title: Password based authentication
html_title: Username/password based authentication for Kibana
slug: kibana-authentication-http-basic
category: kibana-authentication
order: 200
layout: docs
edition: community
description: How to configure Kibana for Username/password based authentication. Secure Kibana access with a login screen.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Username/password based authentication for Kibana
{: .no_toc}

{% include toc.md %}

This approach is the most simple and most commonly used authentication type. If a user tries to access Kibana:  

* Search Guard checks whether the user has an active session with valid username/password credentials
* If so, the user is allowed to access Kibana and the underlying Elastisearch cluster.
* If the user does not have any active session, Search Guard will show a login form. The user now has to log in using their username and password.

This approach can be used to authenticate users using the [Search Guard internal user database](../_docs_roles_permissions/configuration_internalusers.md)  or using [LDAP](../_docs_auth_auth/auth_auth_ldap.md).

If the Search Guard Elasticsearch backend has been already configured with username/password based authentication, this should also work out of the box for Kibana.

In order to verify the configuration for this approach, do the following:

**Backend configuration:** Ensure that you configured authentication domains of type `basic` in the Search Guard `sg_config` configuration. In most cases, you already created this configuration when configuring the Elasticsearch backend. 

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

**Frontend configuration:** The Kibana-specific part of the authentication configuration is done in the file `sg_frontend_config.yml`. By default, this file contains this:

```
default:
  authcz:
  - type: basic
    label: "Login"
```

The entry with `type: basic` makes Kibana to use the username/password-based authentication domains available in the backend.


## Advanced Configuration

### Preventing users from logging in

You can prevent users from logging in to Kibana by listing them in `kibana.yml`. This is useful if you don't want system users like the Kibana server user or the logstash user to log in. In `kibana.yml`, set:

```
searchguard.basicauth.forbidden_usernames: ["kibanaserver", "logstash"]
```
