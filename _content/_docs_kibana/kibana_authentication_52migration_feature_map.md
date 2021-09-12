---
title: Feature Map
html_title: Migrating older SG authentication configuration
slug: kibana-authentication-migration-feature-map
category: kibana-authentication-migration-overview
order: 1100
layout: docs
edition: community
description: How to migrate older Kibana authentication configurations to sg_frontend_config.yml
---
<!---
Copyright 2020 floragunn GmbH
-->

# Feature Map: Legacy Config to New-Style Config
{: .no_toc}

This section serves as a reference by config file and config name how the classic authentication features map to the new authentication features.

## `sg_config.yml`

| Legacy Config | New Config | Details |
|---|---|---|
|`http_authenticator` of type `saml` | `authcz` entry of type `saml` in `sg_frontend_config.yml`| [SAML Configuration]() |


## `kibana.yml`

| Legacy Config | New Config | Details |
|---|---|---|
|`searchguard.auth.anonymous_auth_enabled` | Unchanged | See [Anonymous authentication](kibana_authentication_anonymous.md) |
|`searchguard.auth.type: "basicauth"` | `authcz` entry of type `basic` in `sg_frontend_config.yml` | See [Username based autentication](kibana_authentication_basicauth.md) |
|`searchguard.auth.type: "jwt"` | Multiple possibilities | Depends on the further configuration of `searchguard.jwt.url_parameter` and `searchguard.jwt.header`. See there. |
|`searchguard.auth.type: "kerberos"` | Unchanged | See [Kerberos authentication](kibana_authentication_kerberos.md) |
|`searchguard.auth.type: "openid"` | `authcz` entry of type `oidc` in `sg_frontend_config.yml` | See [OIDC](kibana_authentication_oidc.md) |
|`searchguard.auth.type: "proxy"` | Unchanged | See [Proxy authentication](kibana_authentication_proxy.md) |
|`searchguard.auth.type: "saml"` | `authcz` entry of type `saml` in `sg_frontend_config.yml` | See [SAML](kibana_authentication_saml.md) |
|`searchguard.basicauth.login.*` | Equally named properties in `sg_frontend_config.yml`  in the section `login_page` | See [Customizing the login page](kibana_customize_login.md) |
|`searchguard.basicauth.forbidden_usernames` | Role `SGS_KIBANA_USER` | The configuration was changed from a blacklist to a whitelist: All users which shall be able to log into Kibana, must have the Search Guard role Role `SGS_KIBANA_USER`  |
|`searchguard.jwt.header` | Use proxy authentication to forward the JWT header | See [Proxy authentication](kibana_authentication_proxy.md) |
|`searchguard.jwt.url_parameter` | `searchguard.auth.jwt_param.enabled: true` and `searchguard.auth.jwt_param.url_param: ...` | See [JWT URL Parameters](kibana_authentication_jwt.md) |
|`searchguard.jwt.login_endpoint` | `authcz` of type `link` in `sg_frontend_config.yml` | See TODO |
|`searchguard.openid.connect_url`  | Property `idp.openid_configuration_url` in an `authcz` entry of type `odic` in `sg_frontend_config.yml` | See [OIDC](kibana_authentication_oidc.md) |
|`searchguard.openid.client_id`  | Property `client_id` in an `authcz` entry of type `odic` in `sg_frontend_config.yml` | See [OIDC](kibana_authentication_oidc.md) |
|`searchguard.openid.client_secret`  | Property `client_secret` in an `authcz` entry of type `odic` in `sg_frontend_config.yml` | See [OIDC](kibana_authentication_oidc.md) |
|`searchguard.openid.scope`  | none | No longer necessary |
|`searchguard.openid.header`  | none | No longer necessary |
|`searchguard.openid.base_redirect_url`  | `server.publicBaseUrl` or `searchguard.frontend_base_url` |See [OIDC](kibana_authentication_oidc.md) |
