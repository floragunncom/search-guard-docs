---
title: Authentication Types
html_title: Kibana Authentication Types
slug: kibana-authentication-types
category: kibana-authentication
order: 100
layout: docs
edition: community
description: Use the Search Guard Kibana plugin to add authentication and session management to Kibana.
---
<!---
Copryight 2016-2017 floragunn GmbH
-->

# Authentication Types
{: .no_toc}

{% include_relative _includes/toc.md %}

The Search Guard Kibana plugin offers several ways of authenticating users. Regardless of which method you choose, please make sure it matches the configured authentication type configured in Search Guard. 

There are two general authentication approaches:

## HTTP Basic authentication

This is the default. If the user tries to access Kibana and has no active session, a login page is displayed. The credentials the user enters on this page are validated against Search Guard by adding them as HTTP Basic Authentication headers. Once authenticated the credentials are stored in an encrypted cookie on the user's browser. Make sure you use TLS on the REST layer of Elasticsearch so the transmitted credentials cannot be sniffed.

**Elasticsearch and Kibana configuration:**

| Elasticsearch Configuration | Kibana Configuration |
|---|---|
| [Internal user database](configuration_internalusers.md) | [Basic Authentication](kibana_authentication_basicauth.md) |
| [LDAP and Active Directory](ldap.md) | [Basic Authentication](kibana_authentication_basicauth.md) |

## Single sign on authentication

In this mode, the user is authenticated by a third party system, like an identity provider that issues JSON web tokens, a Kerberos realm or an authenticating proxy. The Kibana plugin will forward any HTTP headers containing user crendentials to Search Guard. As with Basic Authentication, Search Guard uses these credentials for assigning roles and permissions.

*Hint: You cannot the Basic Authentication login page and SSO authentication together.*

### Whitelisting HTTP headers

By default, Kibana does not pass any HTTP header other than `Authorization` to Elasticsearch. If you try to transmit any other header, it is silently discarded.

In order for SSO to work, make sure that any HTTP header that is required for yur configured authentication type is added to the `elasticsearch.requestHeadersWhitelist` configuration entry in `kibana.yml`. 

Example:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "x-forwarded-for", "x-forwarded-by", "x-proxy-user", "x-proxy-roles" ]
```

**Elasticsearch and Kibana configuration:**

| Elasticsearch Configuration | Kibana Configuration |
|---|---|
| [JSON web token](jwt.md) | [JWT Authentication](kibana_authentication_jwt.md) 
| [Proxy authentication](proxy_auth.md) | [Proxy Authentication](kibana_authentication_proxy.md) |
| [Kerberos authentication](kerberos.md) | [Kerberos Authentication](kibana_authentication_kerberos.md) |

## Kibana server user authentication

Regardless which authentication method you choose for your users, the internal Kibana server user will always pass its credentials as base64-encoded HTTP Basic Authentication header. You need to configure at least one Search Guard authentication domain on Elasticsearch side that supports HTTP Basic authentication.

This does not mean that you need to enable Basic Authentication for regular users. The Kibana server user operates under the hood and is independant from user authentication.