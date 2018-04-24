---
title: Proxy Authentication
slug: proxy-authentication
category: authauth
order: 600
layout: docs
edition: community
description: Use Search Guard's Proxy authentication feature to connect Elasticsearch to any third-party identity provider.
---
<!---
Copryight 2017 floragunn GmbH
-->

# HTTP-header/Proxy based authentication

**This module is deprecated and will be replaced in future versions of Search Guard.**

You might already have a single sign on (SSO) authentication solution in place, and you want to use this instead of the Search Guard authentication backend.

Most of these solutions work as a proxy in front of Elasticsearch/Search Guard. Usually the request is routed to the SSO proxy first. The SSO proxy authenticates the user. If authentication succeeds, the (verified) username and its (verified) roles are set in HTTP header fields. The names of these fields are dependant on the SSO solution you have in place.

Search Guard can extract these HTTP header fields from the request, and use these values to determine the permissions a user has.

## Configuration

### Enabling proxy detection

To enable proxy detection, configure it in the `xff` section of `sg_config.yml`:

```yaml
searchguard:
  dynamic:
    http:
      xff:
        enabled: true
        remoteIpHeader: 'x-forwarded-for'
        internalProxies: '192\.168\.0\.11|192\.168\.0\.12'
```

You can configure the following settings:

| Name | Description |
|---|---|
| searchguard.dynamic.http.xff.enabled | Boolean, Enable or disable proxy support. Default: true |
| searchguard.dynamic.http.xff.internalProxies | A regular expression containing the IP addresses of all trusted proxies. |
| searchguard.dynamic.http.xff.remoteIpHeader | String, name of the HTTP header field where the chain of hostnames are stored. Default: `x-forwarded-for` |

In order to determine if a request comes from a trusted internal proxy, Search Guard compares the remote address of the HTTP request with the list of configured internal proxies.  If the remote address is not in the list of trusted proxies, it is treated like a client request. Proxy authentication will not work in this case.  

### Enabling proxy authentication

The names of the respective HTTP header fields which carry the authenticated username and role(s) can be configured in in the `proxy` HTTP authenticator section:

```yaml
proxy_auth_domain:
  enabled: true
  order: 1
  http_authenticator:
    type: proxy
    challenge: false
    config:
      user_header: "x-proxy-user"
      roles_header: "x-proxy-roles"
  authentication_backend:
    type: noop
```

| Name | Description |
|---|---|
| user_header | String, The HTTP header field containing the authenticated username. Default: `x-proxy-user` |
| roles_header | String, The HTTP header field containing the comma separated list of authenticated role names. Roles found in this header field will be used as backend roles and can be used to [map the user to Search Guard roles](configuration_roles_mapping.md). Default: `x-proxy-roles` |

### Kibana proxy authentication

If you plan to use proxy authentication with Kibana, the most common setup is to place an authenticating proxy in front of Kibana, and let Kibana pass the user and role header to Search Guard:

```
Authentication Proxy -> Kibana -> Search Guard
```

In this case the remote address of the HTTP call is the IP of Kibana, because it sits directly in front of Search Guard. Therefore you need to add the IP of Kibana to the list of internal proxies:

```yaml
searchguard:
  dynamic:
    http:
      xff:
        enabled: true
        remoteIpHeader: 'x-forwarded-for'
        internalProxies: '<Kibana IP>'
```

To pass the user and role headers that the authenticating proxy adds from Kibana to Search Guard, you need to add them to the HTTP header whitelist in `kibana.yml`:

```
elasticsearch.requestHeadersWhitelist: ["authorization", "sgtenant", "x-proxy-user", "x-proxy-roles"]

```

### Security considerations

If you are using proxy authentication, Search Guard assumes that the request stems from a trusted proxy/SSO server and also assumes that the entries in the header fields `user_header` and `roles_header` are correct and verified.

HTTP header fields can be easily spoofed, so an attacker could set these fields to arbitrary values. Make sure to set the `internalProxies` in the `xff` section of the configuration correctly to only accept requests from trusted IPs.