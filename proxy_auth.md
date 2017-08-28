<!---
Copryight 2017 floragunn GmbH
-->

# HTTP-header/Proxy based authentication

You might already have a single sign on (SSO) authentication solution in place, and you want to use this instead of the Searcg Guard authentication backend.

Most of these solutions work as a proxy in front of the actual application that needs an authenticated user (Search Guard in this case). Usually the request is routed to the SSO proxy first. The SSO proxy authenticates the user. If authentication succeeds, the (verified) username and its (verified) roles are set in special HTTP header fields. The names of these fields are dependant on the SSO solution you have in place.

Search Guard can extract these HTTP header fields from the request, and use these values to determine the permissions a user has.

## Installation

Search Guard already ships with proxy based authentication.  No additional installation steps are required.

## Configuration

The names of the respective HTTP header fields can be configured in `sg_config.yml` within the `proxy` HTTP authenticator section:

```
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

## Security considerations

If you are using proxy authentication, Search Guard assumes that the request stems from a trusted proxy/SSO server and also assumes that the entries in the header fields `user_header` and `roles_header` are correct and verified.

HTTP header fields can be easily spoofed, so an attacker could set these fields to arbitrary values. Make sure to set the `trustedProxies` and `internalProxies` in the `xff` section of the configuration correctly to only accept requests from trusted IPs. See chapter [Running Search Guard behing a proxy](proxies.md) on how to configure trusted proxy IPs.
