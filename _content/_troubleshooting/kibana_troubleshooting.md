---
title: Kibana Troubleshooting
slug: troubleshooting-kibana
category: troubleshooting
order: 500
layout: troubleshooting
description: Step-by-step instructions on how to troubleshoot Kibana issues with the Search Guard plugin.
---

<!--- Copyright 2022 floragunn GmbH -->

# Kibana troubleshooting

## Kibana optimization is very slow, stalls or exit unexpectedly

The Kibana [optimization process is shaky](https://github.com/elastic/kibana/issues/19678){:target="_blank"} and problems are typically not related to Search Guard.
Most issues can be resolved by giving the process more memory:

```
NODE_OPTIONS="--max-old-space-size=8192" /usr/share/kibana/bin/kibana-plugin install <Plugin URL>
```

If you are on ES 6.5.x or higher you can also try with `--no-optimize` (especially if you install the plugin in a Dockerfile).

## Plugin hapi-auth-cookie already registered 

Kibana fails to start and display 

```
Plugin hapi-auth-cookie already registered 
```

in the log files. This means you have X-Pack installed and X-Pack Security is enabled. Disable it by setting:

```
xpack.security.enabled: false
```

{% include es8_migration_note.html deprecated_property="xpack.security.enabled" %}

## No living connections

### Check connection settings

If Kibana cannot connect to Elasticsearch, check the `elasticsearch.hosts` in  `kibana.yml`:

```
elasticsearch.hosts: "https://example.com:9200"
```

Make sure that the hostname and the port are correct.

### Check HTTPS settings

Check if you configured Search Guard to use HTTPS instead of HTTP in `elasticsearch.yaml`:

```
searchguard.ssl.http.enabled: true
```

If this is the case, you need to use `https://` instead of `http://` in the 
`elasticsearch.hosts`:

```
elasticsearch.hosts: "https://example.com:9200"
```

### Unable to get local issuer certificate

If you use self signed certificate you may see the following error in the Kibana log file:

```
HEAD https://example.com:9200/ => unable to get local issuer certificate
```

This means that Kibana does not trust the self-signed root CA certificate. You can either disable the certificate certification or install the root CA in Kibana.

#### Disabling certificate verification

In `kibana.yml`, disable the certificate verification like:

```
elasticsearch.ssl.verificationMode: none
```
 
#### Installing the root CA (recommended)

In `kibana.yml`, configure the path to your root CA in PEM format like:

```
elasticsearch.ssl.certificateAuthorities: [ "/path/to/your/CA.pem" ]
```

## Constant redirection to login page

When you try to log in using the Search Guard login dialogue, after pressing the login button you are redirected to the login page again even though you provided the correct credentials. No error message is displayed.

### Check HTTP/HTTPS settings for cookies

Search Guard stores the credentials of authenticated users in an encrypted cookie. If you are accessing Kibana with HTTP instead of HTTPS, check the following setting in `kibana.yml`:

```
searchguard.cookie.secure: <true|false>
```

If this is set to true, Search Guard will only accept cookies if they are transmitted via HTTPS. If it receives a cookie via unsecure HTTP, the cookie is discarded. This means the authenticated credentials are not stored and you are redirected to the login page again.

Either access Kibana with HTTPS instead of HTTP, or set:

```
searchguard.cookie.secure: false
```

## Debugging the authentication flow with extra logging

In order to debug the authentication flow, you can enable authentication logging in `kibana.yml`.

**Caution: the logged information may contain sensitive authentication information.**

```yaml
searchguard.auth.debug: true
```

## Cookies not readable

In case the Search Guard cookies are not readable anymore, e.g. if you changed the encryption key, simply delete them. The plugin uses these cookies:

* searchguard_authentication: Stores the users login credentials.
* searchguard_tenant: Stores the currently selected tenant.
* searchguard_preferences: Stores the user's preferred tenants.

## Login fails even if credentials are correct

### Kibana HTTP header whitelisting

Kibana only sends HTTP headers that are explicitly whitelisted in `kibana.yml` to Elasticsearch. If a header is not whitelisted, it is silently discarded, just as if was not present in the HTTP request. This is a Kibana feature independent from Search Guard. You can whitelist headers in `kibana.yml` like:

```
elasticsearch.requestHeadersWhitelist: [ "...", "..." ]
```

A common source of error is that a HTTP header required by the configured authentication module(s) is not whitelisted, and thus authentication fails. Since the header is just discarded by Kibana, you won't see any error message.

By default, the whitelist includes the standardized `Authorization` header, but only if no other headers are configured. If you add any other header, for example `sgtenant`, make sure to add `Authorization` explicitly as well:

```
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant" ]
```

### Single-Sign-On header whitelisting

If you are using an SSO authentication mechanism like Kerberos or JWT, or if you use proxy authentication, make sure you list all required authentication headers in `kibana.yml`.

#### JWT: Token in HTTP header
For JWT, add the HTTP header you configured in the JWT section of `sg_authc.yml` to the header whitelist. For example, if you configured the header like:

```yaml
jwt_auth_domain:
  ...
  http_authenticator:
    ...
    config:
      ...
      jwt_header: "jwtheader"
      ...
```

You also need to set this header explicitly in `kibana.yml` like:

```
elasticsearch.requestHeadersWhitelist: [ "Authorization", "jwtheader", "sgtenant" ]
```

#### JWT: Token as request parameter

If you want to transmit the JSON web token as request parameter to Kibana, Search Guard needs to  grab the token from the request, and add it to all calls to Elasticsearch as HTTP request parameter. The reason is that Kibana does not allow to add arbitrary request parameters to HTTP call.

First, configure the name of the request parameter you use and the HTTP header Search Guard should copy the JSON web token to: 

```yaml
searchguard.jwt.enabled: true
searchguard.jwt.url_param: jwtparam
searchguard.jwt.header: jwtheader
```

Search Guard looks for the token in the request parameter `jwtparam` and will copy it to the HTTP header `jwtheader`.

Next, make sure the HTTP header is whitelisted:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "jwtheader", "sgtenant" ]
```

Last, configure the HTTP header in the JWT section of `sg_authc.yml`:

```yaml
jwt_auth_domain:
  ...
  http_authenticator:
    ...
    config:
      ...
      jwt_header: "jwtheader"
      ...
```

#### Proxy authentication

For proxy authentication you need to configure all headers that your proxy uses, for example:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "x-forwarded-for", "x-forwarded-by", "x-proxy-user", "x-proxy-roles", "sgtenant" ]
```

## Timelion displays Security Exceptions

If you do not specify any index in the timelion query, it will simply use a wildcard ('*') for the index name. If the currently logged in user does not have READ permission on all indices, a security exception is displayed.


