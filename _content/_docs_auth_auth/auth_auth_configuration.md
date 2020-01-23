---
title: Configuration
html_title: Authentication
slug: authentication-authorization
category: authauth
order: 100
layout: docs
edition: community
description: How to configure, mix and chain authentication and authorization domains for Search Guard.
resources:
  - "search-guard-presentations#configuration-basics|Search Guard configuration basics (presentation)"

---
<!---
Copyright 2020 floragunn GmbH
-->
# Configuring authentication and authorization
{: .no_toc}

{% include toc.md %}

Search Guard comes with pluggable authentication and authorization modules. Depending on your use case and infrastructure, you can use one or multiple authentication and authorization modules like:

* [Search Guard Internal user database](../_docs_roles_permissions/configuration_internalusers.md)
* [LDAP and Active Directory](../_docs_auth_auth/auth_auth_ldap.md)
* [Kerberos](../_docs_auth_auth/auth_auth_kerberos.md)
* [JSON Web token](../_docs_auth_auth/auth_auth_jwt.md)
* [Proxy Authentication](../_docs_auth_auth/auth_auth_proxy.md)

The main configuration file for authentication and authorization modules  is `sg_config.yml`. It defines how Search Guard retrieves the user credentials, how it verifies these credentials, and how additional user roles are fetched from backend systems (optional).

It has three main parts:

```yaml
---
_sg_meta:
  type: "config"
  config_version: 2

sg_config:
  dynamic:
    http:
      ...
    authc:
      ...
    authz:
      ...
```

## HTTP

The `http` section has the following format:

```yaml
anonymous_auth_enabled: <true|false>
xff: # non mandatory section
  enabled: <true|false>
  internalProxies: <string> # Regex pattern
  remoteIpHeader: <string> # Name of the header in which to look. Typically: x-forwarded-for
  proxiesHeader: <string>
  trustedProxies: <string> # Regex pattern
```

## Authentication

The `authc` section has the following format:

```yaml
<name>:
  http_enabled: <true|false>
  transport_enabled: <true|false>
  order: <integer>
    http_authenticator:
      ...
    authentication_backend:
      ...
```

An entry in the `authc` section is called an `authentication domain`. It specifies where to get the user credentials from, and against which backend they should be authenticated.

You can use more than one authentication domain. Each authentication domain has a freely selectable name (e.g. `basic_auth_internal`), `enabled` flags and an `order`. This makes it possible to chain authentication domains together.  Search Guard will execute them in the order provided. If the user could be authenticated by a domain, the rest of the chain is skipped, so "first one wins".

You can enable or disable an authentication domain for HTTP/REST and transport independantly. This is for example useful if you want to use differen autehentication methods for `TransportClients`.

The `http_authenticator` specifies which authentication method you want to use on the HTTP layer.

The syntax for defining an authenticator on the HTTP layer is:

```yaml
http_authenticator:
  type: <type>
  challenge: <true|false>
  config:
    ...
```

Allowed values for `type` are:

* basic
  * HTTP basic authentication. No additional configuration is needed. See [HTTP Basic Authentication](../_docs_auth_auth/auth_auth_httpbasic.md) for further details.
* kerberos
  * Kerberos authentication. Additional, [Kerberos-specific configuration](../_docs_auth_auth/auth_auth_kerberos.md) is needed.
* jwt
  * JSON web token authentication. Additional, [JWT-specific configuration](../_docs_auth_auth/auth_auth_jwt.md) is needed.
* openid
  * OpenID / OIDC. Additional, [OpenID-specific configuration](../_docs_auth_auth/auth_auth_openid.md) is needed.
* saml
  * SAML. Additional, [SAML-specific configuration](../_docs_auth_auth/auth_auth_saml_authentication.md) is needed.
* proxy
  * Use an external, proxy based authentication. Additional, proxy-specific configuration is needed, and the "X-forwarded-for" module has to be enabled as well. See [Proxy authentication](../_docs_auth_auth/auth_auth_proxy.md) for further details.
* clientcert
  * Authentication via a client TLS certificate. This certificate must be trusted by one of the Root CAs in the truststore of your nodes.

After the HTTP authenticator was executed, you need to specify against which backend system you want to authenticate the user. This is specified in the `authentication_backend` section and has the following format:

```yaml
authentication_backend:
  type: <type>
  config:
    ...
```

Possible vales for `type` are:

* noop
  * This means that no further authentication against any backend system is performed. Use `noop` if the HTTP authenticator has already authenticated the user completely, as in the case of JWT, Kerberos, Proxy or Client certificate authentication.
* internal
  * use the users and roles defined in `sg_internal_users` for authentication.
* ldap
  * authenticate users against an LDAP server. This requires [additional, LDAP specific](../_docs_auth_auth/auth_auth_ldap.md) configuration settings.

## Authorization

After the user has been authenticated, Search Guard can optionally collect additional user roles from backend systems. The authorization configuration has the following format:

```yaml
authz:
  <name>:
    http_enabled: <true|false>
    transport_enabled: <true|false>
    authorization_backend:
      type: <type>
      config:
        ...
```

You can also define multiple entries in this section the same way as you can for authentication entries. The execution order is not relevant here, hence there is no `order` field.

Possible vales for `type` are:

* noop
  * Used for skipping this step altogether
* ldap
  * Fetch additional roles from an LDAP server. This requires [additional, LDAP specific](../_docs_auth_auth/auth_auth_ldap.md) configuration settings.

## Examples

The [sg_config.yml](https://git.floragunn.com/search-guard/search-guard/blob/master/sgconfig/sg_config.yml){:target="_blank"} that ships with Search Guard contains configuration examples for all support modules. Use these examples as a starting point and customize them to your needs.