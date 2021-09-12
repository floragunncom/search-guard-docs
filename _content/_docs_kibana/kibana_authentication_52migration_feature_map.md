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

### `http_authenticator` of type `saml`


| Legacy Config | New Config | Details |
|---|---|---|
|`challenge` | No longer necessary | - |
|`config.idp.metadata_url` | Property `idp.metadata_url` in an `authcz` entry of type `saml` in `sg_frontend_config.yml` | See [SAML](kibana_authentication_saml.md) |
|`config.idp.metadata_file` | Property `idp.metadata_xml` in an `authcz` entry of type `saml` in `sg_frontend_config.yml` | Files can be referenced with the special syntax `idp.metadata_xml: "${file:/path/to/file}"`. See [SAML](kibana_authentication_saml.md) |
|`config.idp.entity_id` | Property `idp.entity_id` in an `authcz` entry of type `saml` in `sg_frontend_config.yml` | See [SAML](kibana_authentication_saml.md) |
|`config.sp.entity_id` | Property `sp.entity_id` in an `authcz` entry of type `saml` in `sg_frontend_config.yml` | See [SAML](kibana_authentication_saml.md) |
|`config.sp.signature_private_key` | Property `sp.signature_private_key` in an `authcz` entry of type `saml` in `sg_frontend_config.yml` | See [SAML](kibana_authentication_saml.md) |
|`config.sp.signature_algorithm` | Property `sp.signature_algorithm` in an `authcz` entry of type `saml` in `sg_frontend_config.yml` | See [SAML](kibana_authentication_saml.md) |
|`config.kibana_url` | Property `server.publicBaseUrl` or `searchguard.frontend_base_url` in `kibana.yml` | See [SAML](kibana_authentication_saml.md) |
|`config.subject_key` | Property `user_mapping.subject` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`| See [SAML](kibana_authentication_saml.md) |
|`config.subject_pattern` | Property `user_mapping.subject_pattern` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`| See [SAML](kibana_authentication_saml.md) |
|`config.roles_key` | Property `user_mapping.roles` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`| See [SAML](kibana_authentication_saml.md) |
|`config.exchange_key` |  No longer necessary  | |
|`config.idp.enable_ssl` | No longer necessary | Just specify TLS settings in `idp.tls`. Explicit enabling them is no longer necessary. See [SAML](kibana_authentication_saml.md) |
|`config.idp.verify_hostnames` |  Property `idp.tls.verfiy_hostnames` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`  | See [SAML](kibana_authentication_saml.md) |
|`config.idp.pemtrustedcas_filepath` |  Property `idp.tls.trusted_cas` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`  |  Files can be referenced with the special syntax `idp.tls.trusted_cas: "${file:/path/to/file}"`. See [SAML](kibana_authentication_saml.md) |
|`config.idp.pemtrustedcas_content` |  Property `idp.tls.trusted_cas` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`  |  See [SAML](kibana_authentication_saml.md) |
|`config.idp.enable_ssl_client_auth` | No longer necessary | Just specify client auth settings in `idp.tls.client_auth`. Explicit enabling them is no longer necessary. See [SAML](kibana_authentication_saml.md) |
|`config.idp.pemcert_filepath` |  Property `idp.tls.client_auth.certificate` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`  | Files can be referenced with the special syntax `idp.tls.client_auth.certificate: "${file:/path/to/file}"`.  See [SAML](kibana_authentication_saml.md) |
|`config.idp.pemcert_content` |  Property `idp.tls.client_auth.certificate` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`  |  See [SAML](kibana_authentication_saml.md) |
|`config.idp.pemkey_filepath` |  Property `idp.tls.client_auth.private_key` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`  |  Files can be referenced with the special syntax `idp.tls.client_auth.private_key: "${file:/path/to/file}"`. See [SAML](kibana_authentication_saml.md) |
|`config.idp.pemkey_content` |  Property `idp.tls.client_auth.private_key` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`  |  See [SAML](kibana_authentication_saml.md) |
|`config.idp.pemkey_password` |  Property `idp.tls.client_auth.private_key_password` in an `authcz` entry of type `saml` in `sg_frontend_config.yml`  |  See [SAML](kibana_authentication_saml.md) |


### `http_authenticator` of type `openid`


| Legacy Config | New Config | Details |
|---|---|---|
|`challenge` | No longer necessary | - |
|`config.openid_connect_url` | Property `idp.openid_configuration_url` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml` | See [OIDC](kibana_authentication_openid.md) |
|`config.jwt_header` |  No longer necessary  |  |
|`config.jwt_url_parameter` | No longer necessary |  |
|`config.proxy` | Property `proxy` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml` | See [OIDC](kibana_authentication_oidc.md) |
|`config.subject_key` | Property `user_mapping.subject` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`| See [OIDC](kibana_authentication_openid.md) |
|`config.subject_path` | Property `user_mapping.subject` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`| See [OIDC](kibana_authentication_openid.md) |
|`config.subject_pattern` | Property `user_mapping.subject_pattern` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`| [OIDC](kibana_authentication_openid.md) |
|`config.roles_key` | Property `user_mapping.roles` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`| [OIDC](kibana_authentication_openid.md) |
|`config.roles_path` | Property `user_mapping.roles` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`| [OIDC](kibana_authentication_openid.md) |
|`config.openid_connect_idp.enable_ssl` | No longer necessary | Just specify TLS settings in `idp.tls`. Explicit enabling them is no longer necessary. See [OIDC](kibana_authentication_openid.md) |
|`config.openid_connect_idp.verify_hostnames` |  Property `idp.tls.verfiy_hostnames` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`  | See [OIDC](kibana_authentication_openid.md) |
|`config.openid_connect_idp.pemtrustedcas_filepath` |  Property `idp.tls.trusted_cas` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`  |  Files can be referenced with the special syntax `idp.tls.trusted_cas: "${file:/path/to/file}"`. See [OIDC](kibana_authentication_openid.md) |
|`config.openid_connect_idp.pemtrustedcas_content` |  Property `idp.tls.trusted_cas` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`  |  See [OIDC](kibana_authentication_openid.md) |
|`config.openid_connect_idp.enable_ssl_client_auth` | No longer necessary | Just specify client auth settings in `idp.tls.client_auth`. Explicit enabling them is no longer necessary. See [OIDC](kibana_authentication_openid.md) |
|`config.openid_connect_idp.pemcert_filepath` |  Property `idp.tls.client_auth.certificate` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`  | Files can be referenced with the special syntax `idp.tls.client_auth.certificate: "${file:/path/to/file}"`.  See [OIDC](kibana_authentication_openid.md) |
|`config.openid_connect_idp.pemcert_content` |  Property `idp.tls.client_auth.certificate` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`  |  See [OIDC](kibana_authentication_saml.md) |
|`config.openid_connect_idp.pemkey_filepath` |  Property `idp.tls.client_auth.private_key` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`  |  Files can be referenced with the special syntax `idp.tls.client_auth.private_key: "${file:/path/to/file}"`. See [OIDC](kibana_authentication_openid.md) |
|`config.openid_connect_idp.pemkey_content` |  Property `idp.tls.client_auth.private_key` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`  |  See [OIDC](kibana_authentication_openid.md) |
|`config.openid_connect_idp.pemkey_password` |  Property `idp.tls.client_auth.private_key_password` in an `authcz` entry of type `oidc` in `sg_frontend_config.yml`  |  See [OIDC](kibana_authentication_openid.md) |

## `kibana.yml`

| Legacy Config | New Config | Details |
|---|---|---|
|`searchguard.auth.anonymous_auth_enabled` | Unchanged | See [Anonymous authentication](kibana_authentication_anonymous.md) |
|`searchguard.auth.type: "basicauth"` | `authcz` entry of type `basic` in `sg_frontend_config.yml` | See [Username based autentication](kibana_authentication_basicauth.md) |
|`searchguard.auth.type: "jwt"` | Multiple possibilities | Depends on the further configuration of `searchguard.jwt.url_parameter` and `searchguard.jwt.header`. See there. |
|`searchguard.auth.type: "kerberos"` | Unchanged | See [Kerberos authentication](kibana_authentication_kerberos.md) |
|`searchguard.auth.type: "openid"` | `authcz` entry of type `oidc` in `sg_frontend_config.yml` | See [OIDC](kibana_authentication_oidc.md) |
|`searchguard.auth.type: "proxy"` | Unchanged | See [Proxy authentication](kibana_authentication_proxy.md) |
|`searchguard.auth.type: "proxycache"` | No longer supported | Use [proxy authentication](kibana_authentication_proxy.md) instead |
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
|`searchguard.openid.logout_url`  | Property `logout_url` in an `authcz` entry of type `odic` in `sg_frontend_config.yml` |See [OIDC](kibana_authentication_oidc.md) |
|`searchguard.openid.root_ca`  | Property `idp.tls.trusted_cas` in an `authcz` entry of type `odic` in `sg_frontend_config.yml` |See [OIDC](kibana_authentication_oidc.md) |
|`searchguard.proxycache.*`  | No longer supported | Use [proxy authentication](kibana_authentication_proxy.md) instead |
