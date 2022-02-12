---
title: Feature Map
html_title: Migrating older SG authentication configuration
permalink: config-migration-feature-map
category: kibana-authentication-migration-overview
order: 1100
layout: docs
description: How to migrate older authentication configurations to new configurations
---
<!---
Copyright 2020 floragunn GmbH
-->

# Feature Map: Legacy config to new-style config

This section serves as a reference by config file and config name how the classic authentication features map to the new authentication features.

**Note:** You do not have to manually apply the changes listed here. You can use the `sgctl migrate-config` command. 

## `sg_config.yml`

### General

| Legacy Config | New Config | Details |
|---|---|---|
|`dynamic.do_not_fail_on_forbidden` | Property `ignore_unauthorized_indices` in `sg_authz.yml` | Semantics of `ignore_unauthorized_indices` have slightly changed and provide more expected results |
|`dynamic.do_not_fail_on_forbidden_empty` | No longer necessary | This behaviour has been integrated into the new semantics of `ignore_unauthorized_indices` |
|`dynamic.field_anonymization_salt2` | Property `field_anonymization.salt` in `sg_authz.yml` | |
|`dynamic.license` | Property `license` in `sg_license_key.yml` | |
|`dynamic.filtered_alias_mode` |  No longer supported | Search Guard no longer restricts the use of filtered aliases |
|`dynamic.multi_rolespan_enabled` | No longer supported | Multi-rolespan is now always active |
|`dynamic.hosts_resolver_mode` | No longer necessary | Search Guard will automatically lookup host names when any are specified in `sg_roles_mapping.yml`. Lookups can be avoided by specifiying IP addresses in the new `ip` attribute in `sg_roles_mapping.yml`. |
|`dynamic.http.anonymous_auth_enabled` | Authentication domain of type `anonymous` in `sg_authc.yml` | See [Anonymous authentication](../_docs_auth_auth/auth_auth_anon.md) |
|`dynamic.http.xff.internalProxies` | Property `network.trusted_proxies` in `sg_authc.yml` | While `xff.internalProxies` expects a regular expression, you can specify subnets in  `network.trusted_proxies` using CIDR expressions. See also [IP addresses of users behind proxies](../_docs_auth_auth/auth_auth_configuration.md#ip-addresses-of-users-behind-proxies). 
|`dynamic.http.xff.remoteIpHeader` | Property `network.http.remote_ip_header` in `sg_authc.yml` | |
|`dynamic.http.xff.enabled` | No longer necessary |  Just specify `network.trusted_proxies` in `sg_authc.yml` |
|`dynamic.auth_token_provider` | Config file `sg_auth_token_service.yml` | Structure of the configuration remains the same. |

### `kibana`

The settings relating to Kibana multi tenenancy have been moved to `sg_frontend_multi_tenancy.yml`.

| Legacy Config | New Config | Details |
|---|---|---|
|`dynamic.kibana.multi_tenancy_enabled` | Property `enabled` in `sg_frontend_multi_tenancy.yml` |  |
|`dynamic.kibana.server_username` | Property `server_user` in `sg_frontend_multi_tenancy.yml` |  |
|`dynamic.kibana.index` | Property `index` in `sg_frontend_multi_tenancy.yml` |  |


### `authc`

The authentication domain settings have been combined with the authorization domains and moved to `sg_authc.yml` and `sg_authc_transport.yml`. If you do not use the transport client, you will not need `sg_authc_transport.yml`.  Settings for authentication modes which are specific to Kibana/OpenSearch Dashboards (such as OIDC and SAML) have been moved to `sg_frontend_config.yml`. 

| Legacy Config | New Config | Details |
|---|---|---|
|`http_enabled` | Property `enabled` of an auth domain in `sg_authc.yml` |  |
|`transport_enabled` | Property `enabled` of an auth domain in `sg_authc_transport.yml` |  |
|`order` | No longer necessary | The order of authentication domains is now specified using the natural order of the entries in the config file |
|`skip_users` | Property `users.skip` of an auth domain in `sg_authc.yml` or  `sg_authc_transport.yml` |  |
|`enabled_only_for_ips` | Property `ips.accept` of an auth domain in `sg_authc.yml` or  `sg_authc_transport.yml` |  |
|`http_authenticator.type` | First part of the `type` property of an auth domain in `sg_authc.yml` |  |
|`http_authenticator.challenge` | No longer necessary | Search Guard will combine challenges if necessary |
|`http_authenticator.config` | The new property is named after the type of the authentication frontend |  |
|`authentication_backend.type` | Second part of the `type` property of an auth domain in `sg_authc.yml`. For `sg_authc_transport.yml`, this is the only part | If the `type` was `noop`, this can be now omitted. |
|`authentication_backend.config` | The new property is named after the type of the authentication backend |  |



### `http_authenticator` of type `jwt`

| Legacy Config | New Config | Details |
|---|---|---|
|`config.signing_key` | Property `jwt.signing.rsa.public_key` or  `jwt.signing.ec.public_key` of an auth domain in `sg_authc.yml` | You need to know whether the key is an RSA or Elliptic Curve key to properly configure it |
|`config.jwt_header` | Property `jwt.header` of an auth domain in `sg_authc.yml` | |
|`config.jwt_url_parameter` | Property `jwt.url_parameter` of an auth domain in `sg_authc.yml` | |
|`config.required_audience` | Property `jwt.required_audience` of an auth domain in `sg_authc.yml` | |
|`config.required_issuer` | Property `jwt.required_issuer` of an auth domain in `sg_authc.yml` | |
|`config.subject_key` | Property `user_mapping.user_name.from` of an auth domain in `sg_authc.yml` | You need to prefix the key with `jwt` to access the JWT claims. The new property expects JSON path expressions. If the key contains special characters, you might need to use the `$["jwt"]["..."]` JSON path syntax |
|`config.subject_path` | Property `user_mapping.user_name.from` of an auth domain in `sg_authc.yml` | You need to prefix the path with `jwt` to access the JWT claims. |
|`config.roles_key` | Property `user_mapping.roles.from_comma_separated_string` of an auth domain in `sg_authc.yml` | You need to prefix the key with `jwt` to access the JWT claims. The new property expects JSON path expressions. If the key contains special characters, you might need to use the `$["jwt"]["..."]` JSON path syntax |
|`config.roles_path` | Property `user_mapping.roles.from_comma_separated_string` of an auth domain in `sg_authc.yml` | You need to prefix the path with `jwt` to access the JWT claims.  |
|`config.map_claims_to_user_attrs` | Property `user_mapping.attrs.from` of an auth domain in `sg_authc.yml` | You need to prefix the path with `jwt` to access the JWT claims.  |

### `http_authenticator` of type `clientcert`

| Legacy Config | New Config | Details |
|---|---|---|
|`config.username_attribute` | Property `user_mapping.user_name.from` of an auth domain in `sg_authc.yml` | You need to prefix the key with `clientcert.subject.` to access the client certificate subject RDNs. The new property expects JSON path expressions. If the key contains special characters, you might need to use the `$.clientcert.subject["..."]` JSON path syntax |

### `http_authenticator` of type `proxy`

The `proxy` authenticator has been replaced by the `trusted_origin` authentication frontend.

| Legacy Config | New Config | Details |
|---|---|---|
|`config.user_header` | Property `user_mapping.user_name.from` of an auth domain in `sg_authc.yml` | You need to prefix the key with `request.headers.` to access the request headers. The new property expects JSON path expressions. If the key contains special characters, you might need to use the `$.request.headers["..."]` JSON path syntax |
|`config.roles_header` | Property `user_mapping.roles.from` of an auth domain in `sg_authc.yml` | You need to prefix the key with `request.headers.` to access the request headers. The new property expects JSON path expressions. If the key contains special characters, you might need to use the `$.request.headers["..."]` JSON path syntax. If the roles are specified in a comma separated string, use `user_mapping.roles.from_comma_separated_string`. If a different separator is used, you can use the properties `user_mapping.roles.from.json_path` combined with `user_mapping.roles.from.split` |

### `http_authenticator` of type `proxy2`

The `proxy2` authenticator in mode `ip` has been replaced by the `trusted_origin` authentication frontend. The mode `cert` has been replaced by the `clientcert` authenticator. The mode `either` can be achieved with using two different authentication domain. The mode `both` can be achived by the `clientcert` authenticator in combination with the `accept.trusted_ips` property.

| Legacy Config | New Config | Details |
|---|---|---|
|`config.auth_mode` | Auth frontend of type `trusted_origin` and/or `clientcert` | See description above |
|`config.user_header` | Property `user_mapping.user_name.from` of an auth domain in `sg_authc.yml` | You need to prefix the key with `request.headers.` to access the request headers. The new property expects JSON path expressions. If the key contains special characters, you might need to use the `$.request.headers["..."]` JSON path syntax |
|`config.roles_header` | Property `user_mapping.roles.from` of an auth domain in `sg_authc.yml` | You need to prefix the key with `request.headers.` to access the request headers. The new property expects JSON path expressions. If the key contains special characters, you might need to use the `$.request.headers["..."]` JSON path syntax. If the roles are specified in a comma separated string, use `user_mapping.roles.from_comma_separated_string`. If a different separator is used, you can use the properties `user_mapping.roles.from.json_path` combined with `user_mapping.roles.from.split` |



### `http_authenticator` of type `saml`

SAML configuration is now performed in `sg_frontend_config.yml`. 

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

OIDC configuration is now performed in `sg_frontend_config.yml`. 


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


### `authentication_backend` of type `internal`

The `internal` authentication backend now has the type `internal_users_db`.

| Legacy Config | New Config | Details |
|---|---|---|
|`config.map_db_attrs_to_user_attrs` | Property `user_mapping.attrs.from` of an auth domain in `sg_authc.yml` | You need to prefix the path with `user_entry.attributes` to access the user attributes.  |


### `authentication_backend` of type `ldap`

| Legacy Config | New Config | Details |
|---|---|---|
|`config.hosts` | Property `ldap.idp.hosts`  of an auth domain in `sg_authc.yml` | |
|`config.bind_dn` | Property `ldap.idp.bind_dn`  of an auth domain in `sg_authc.yml` | |
|`config.password` | Property `ldap.idp.password`  of an auth domain in `sg_authc.yml` | |
|`config.enable_start_tls` | Property `ldap.idp.tls.start_tls`  of an auth domain in `sg_authc.yml` | |
|`config.verify_hostnames` | Property `ldap.idp.tls.verify_hostnames`  of an auth domain in `sg_authc.yml` | |
|`config.pemtrustedcas_content` | Property `ldap.idp.tls.trusted_cas`  of an auth domain in `sg_authc.yml` | |
|`config.pemtrustedcas_filepath` | Property `ldap.idp.tls.trusted_cas` with a `#{file:...}` expression | |
|`config.pemcert_content` | Property `ldap.idp.tls.client_auth.certificate` of an auth domain in `sg_authc.yml` | |
|`config.pemcert_filepath` | Property `ldap.idp.tls.client_auth.certificate` with a `#{file:...}` expression | |
|`config.pemkey_content` | Property `ldap.idp.tls.client_auth.private_key` of an auth domain in `sg_authc.yml` | |
|`config.pemkey_filepath` | Property `ldap.idp.tls.client_auth.private_key` with a `#{file:...}` expression | |
|`config.pemkey_password` | Property `ldap.idp.tls.client_auth.private_key_password` of an auth domain in `sg_authc.yml` | |
|`config.enable_ssl_client_auth` | No longer necessary | Just specify the `ldap.idp.client_auth` config properties to use TLS client authentication |
|`config.userbase` | Property `ldap.user_search.base_dn`  of an auth domain in `sg_authc.yml` | |
|`config.usersearch` | Property `ldap.user_search.filter.raw`  of an auth domain in `sg_authc.yml` | Instead of the placeholder `{0}` you need to use the placeholder `${user.name}`  |
|`config.users.base` | Property `ldap.user_search.base_dn`  of an auth domain in `sg_authc.yml` | If you need to use several user searches, create one separate `ldap` authentication domain for each user search criteria |
|`config.users.search` | Property `ldap.user_search.filter.raw`  of an auth domain in `sg_authc.yml` | If you need to use several user searches, create one separate `ldap` authentication domain for each user search criteria  |
|`config.map_ldap_attrs_to_user_attrs` | Property `user_mapping.attrs.from` of an auth domain in `sg_authc.yml` | You need to prefix the path with `ldap_user_entry` to access the attributes.  |


### `authz`

The authorization domains have been replaced by user information backends. While authorization domains were configured globally, user information backends now need to be configured for each authentication domain separately. This gives you greater control over the association of user information backends with authentication modes.

### `authorization_backend` of type `ldap`

The functionality provided by the `ldap` authorization backend can be now used in two different ways: You can configure group searches directly inside the `ldap` authentication backend. You don't need to configure a separate user information backend for this. If you have an authentication backend of a type other than `ldap`, you can use a user information backend of type `ldap`. 

| Legacy Config | New Config | Details |
|---|---|---|
|`config.hosts` | Property `ldap.idp.hosts`  of a user information backend in `sg_authc.yml` | |
|`config.bind_dn` | Property `ldap.idp.bind_dn`  of a user information backend in `sg_authc.yml` | |
|`config.password` | Property `ldap.idp.password`  of a user information backend in `sg_authc.yml` | |
|`config.enable_start_tls` | Property `ldap.idp.tls.start_tls`  of a user information backend in `sg_authc.yml` | |
|`config.verify_hostnames` | Property `ldap.idp.tls.verify_hostnames`  of a user information backend in `sg_authc.yml` | |
|`config.pemtrustedcas_content` | Property `ldap.idp.tls.trusted_cas`  of a user information backend in `sg_authc.yml` | |
|`config.pemtrustedcas_filepath` | Property `ldap.idp.tls.trusted_cas` with a `#{file:...}` expression | |
|`config.pemcert_content` | Property `ldap.idp.tls.client_auth.certificate` of a user information backend in `sg_authc.yml` | |
|`config.pemcert_filepath` | Property `ldap.idp.tls.client_auth.certificate` with a `#{file:...}` expression | |
|`config.pemkey_content` | Property `ldap.idp.tls.client_auth.private_key` of a user information backend in `sg_authc.yml` | |
|`config.pemkey_filepath` | Property `ldap.idp.tls.client_auth.private_key` with a `#{file:...}` expression | |
|`config.pemkey_password` | Property `ldap.idp.tls.client_auth.private_key_password` of a user information backend in `sg_authc.yml` | |
|`config.enable_ssl_client_auth` | No longer necessary | Just specify the `ldap.idp.client_auth` config properties to use TLS client authentication |
|`config.userbase` | Property `ldap.user_search.base_dn`  of a user information backend in `sg_authc.yml` | |
|`config.usersearch` | Property `ldap.user_search.filter.raw`  of a user information backend in `sg_authc.yml` | Instead of the placeholder `{0}` you need to use the placeholder `${user.name}`  |
|`config.users.base` | Property `ldap.user_search.base_dn`  of a user information backend in `sg_authc.yml` | If you need to use several user searches, create one separate `ldap` user information backend entries for each user search criteria |
|`config.users.search` | Property `ldap.user_search.filter.raw`  of a user information backend in `sg_authc.yml` | If you need to use several user searches, create one separate `ldap` user information backend entries for each user search criteria  |
|`config.rolebase` | Property `ldap.group_search.base_dn` of an `ldap` auth domain or user information backend in `sg_authc.yml` |  |
|`config.rolesearch` | Property `ldap.group_search.filter.raw` of an `ldap` auth domain or user information backend in `sg_authc.yml` | Instead of the placeholder `{0}` you need to use the placeholder `${dn}` |
|`config.rolename` | Property `ldap.group_search.role_name_attribute` of an `ldap` auth domain or user information backend in `sg_authc.yml` |  |
|`config.roles.base` | Property `ldap.group_search.base_dn`  of  an `ldap` auth domain or  user information backend in `sg_authc.yml` | If you need to use several group searches, create one separate `ldap` user information backend entry for each group search criteria |
|`config.roles.search` | Property `ldap.group_search.filter.raw`  of  an `ldap` auth domain or  user information backend in `sg_authc.yml` | If you need to use several group searches, create one separate `ldap` user information backend entry for each group search criteria |
|`config.resolve_nested_roles` | Property `ldap.group_search.recursive.enabled` of an `ldap` auth domain or user information backend in `sg_authc.yml` |  |
|`config.nested_role_filter` | Property `ldap.group_search.recursive.enabled_for` of an `ldap` auth domain or user information backend in `sg_authc.yml` | `group_search.recursive.enabled_for` has the opposite meaning of `config.nested_role_filter`. While the new option whitelists group names, the old option blacklists them. |



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
