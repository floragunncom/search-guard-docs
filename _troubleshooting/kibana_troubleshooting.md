---
title: Kibana Troubleshooting
slug: troubleshooting-kibana
category: troubleshooting
order: 500
layout: troubleshooting
---

<!--- Copryight 2017 floragunn GmbH -->

# Kibana troubleshooting

## Constant redirection to login page

When you try to log in using the Search Guard login dialogue, after pressing the login button you are redirected to the login page again even though you provided the correct credentials. No error message is displayed.

Resolution:

Search Guard stores the credentials of authenticated users in an encrypted cookie. If you are accessing Kibana with HTTP instead of HTTPS, check the following setting in `kibana.yml`:

```
searchguard.cookie.secure: <true|false>
```

If this is set to true, Search Guard will only accept cookies if they are transmitted via HTTPS. If it receieves a cookie via unsecure HTTP, the cookie is discarded. Which means the authenticated credentials are not stored any our ar redirected to the login page again.

Either access Kibana with HTTPS instead of HTTP, or set:

```
searchguard.cookie.secure: false
```

## Cookies not readable

In case the Search Guard cookies are not readable anymore, e.g. if you changed the encryption key, simply delete them. The plugin uses three cookies:

* searchguard_authentication: Stores the users login credentials.
* searchguard_tenant: Stores the currently selected tenant.
* searchguard_preferences: Stores the user's preferred tenants.

## Login fails even if credentials are correct

### Kibana HTTP header whitelisting

Kibana only sends HTTP headers that are explicitely whitelisted in `kibana.yml` to Elasticsearch. If a header is not whitelisted, it is silently discarded, just as if was not present in the HTTP request. This is a Kibana feature independant from Search Guard. You can whitelist headers in `kibana.yml` like:

```
elasticsearch.requestHeadersWhitelist: [ "...", "..." ]
```

A common source of error is that a HTTP header required by the configured authentication module(s) is not whitelisted, and thus authentication fails. Since the header is just discarded by Kibana, you won't see any error message.

By default, the whitelist includes the standardized `Authorization` header, but only if no other headers are configured. If you add any other header, for example `sgtenant`, make sure to add `Authorization` explicitely as well:

```
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant" ]
```

### Single-Sign-On header whitelisting

If you are using an SSO authentication mechanism like Kerberos or JWT, or if you use proxy authentication, make sure you list all required authentication headers in `kibana.yml`.

#### JWT: Token in HTTP header
For JWT, add the HTTP header you configured in the JWT section of `sg_config.yml` to the header whitelist. For example, if you configured the header like:

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

You also need to set this header explicitely in `kibana.yml` like:

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

Last, configure the HTTP header in the JWT section of `sg_config.yml`:

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

## Multitenancy not working

### Headers not whitelisted

During Kibana startup, Search Guard checks whether the `sgtenant` header has been added to the `elasticsearch.requestHeadersWhitelist` condiguration key in `kibana.yml`. If this is not the case, the state of the pluin will be red, and you will see an error page when trying to access Kibana. Make sure you have whitelisted this header:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant", ... ]
```

### Elasticsearch: Multi tenancy not enabled

If the Search Guard multitenancy module is not installed or is disabled, you will see an error message on the "Tenants" page, like:

<p align="center">
<img src="kibana_mt_disabled.png" style="width: 80%" class="md_image"/>
</p>

Make sure the enterprise module is installed, and also check that `searchguard.dynamic.kibana.multitenancy_enabled` is not set to `false` in `sg_config.yml`.

### Kibana and Elasticsearch: Configuration mismatch

If either the configured Kibana server username or the configured Kibana index name do not match on Elasticsearch and Kibana, an error will be displayed on the "Tenants" page, like:

<p align="center">
<img src="kibana_config_mismatch.png" style="width: 80%" class="md_image"/>
</p>

Make sure the respective settings match in `sg_config.yml` (Elasticsearch) and `kibana.yml` (Kibana).


