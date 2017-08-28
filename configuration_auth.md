# Configuring authentication and authorisation

Search Guard comes with pluggable authentication and authorisation modules. Depending on your use case and infrastructure, you can use one or multiple authentication and authorisation modules like:

* [Search Guard Internal user database](configuration_internalusers.md)
* [LDAP and Active Directory](ldap.md)
* [Kerberos](kerberos.md)
* [JSON Web token](jwt.md)
* [Proxy Authentication](proxy_auth.md)



The main configuration file for authentication and authorization modules  is `sg_config.yml`. It defines how Search Guard retrieves the user credentials, how it verifies these credentials, and how additional user roles are fetched from backend systems (optional).

It has two main parts:

```
searchguard:
  dynamic:
    authc:
      ...
    authz:
      ...
```

## Authentication

The `authc` section has the following format:

```
<name>:
  enabled: <true|false>
  order: <integer>
    http_authenticator:
      ...
    authentication_backend:
      ...
```

An entry in the `authc` section is called an `authentication domain`. It specifies where to get the user credentials from, and against which backend they should be authenticated.

You can use more than one authentication domain. Each authentication domain has a freely selectable name (e.g. `basic_auth_internal`), an `enabled` flag and an `order`. This makes it possible to chain authentication domains together.  Search Guard will execute them in the order provided.

The `http_authenticator` specifies which authentication method you want to use on the HTTP layer.

The syntax for defining an authenticator on the HTTP layer is:

```
http_authenticator:
  type: <type>
  challenge: <true|false>
  config:
    ...
```

Allowed values for `type` are:

* basic
 * HTTP basic authentication. No additional configuration is needed. See [HTTP Basic Authentication](httpbasic.md) for further details.
* kerberos
 * Kerberos authentication. Additional, [Kerberos-specific configuration](kerberos.md) is needed.
* jwt
  * JSON web token authentication. Additional, [JWT-specific configuration](jwt.md) is needed.
* proxy
  * Use an external, proxy based authentication. Additional, proxy-specific configuration is needed, and the "X-forwarded-for" module has to be enabled as well. See [Running Search Guard behind a proxy](proxies.md) and [Proxy authentication](proxy_auth.md) for further details.
* clientcert
  * Authentication via a client TLS certificate. This certificate must be trusted by one of the Root CAs in the truststore of your nodes.

After the HTTP authenticator was executed, you need to specify against which backend system you want to authenticate the user. This is specified in the `authentication_backend` section and has the following format:

```
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
  * authenticate users against an LDAP server. This requires [additional, LDAP specific](ldap.md) configuration settings.

## Authorization

After the user has been authenticated, Search Guard can optionally collect additional user roles from backend systems. The authorization configuration has the following format:

```
authz:
  <name>:
    enabled: <true|false>
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
  * Fetch additional roles from an LDAP server. This requires [additional, LDAP specific](ldap.md) configuration settings.

## Examples

The [sg_config.yml](https://github.com/floragunncom/search-guard/blob/master/sgconfig/sg_config.yml) that ships with Search Guard contains configuration examples for all support modules. Use these examples as a startung point and customize them to your needs.