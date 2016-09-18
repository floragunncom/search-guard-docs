# Proxies and SSO authentication

## Proxies/Loadbalancers and XFF support

**Note: This chapter is only relevant if you plan to use SSO/HTTP header based authentication, or if you're behind one or more proxies and plan to use IP/hostname based authentication.**

Search Guard supports Elasticsearch installations running behind one or more proxies or loadbalancers. This can simply be an nginx, loadbalancing or forwarding requests to an Elasticsearch cluster, or a chain of proxies (e.g. including a single sign on proxy). 

If a request is routed via one or more proxies/loadbalancers, the host field of the HTTP request only contains the proxies/loadbalancers hostname, and the remote IP is set to the proxie's IP. This effectively hides the clients hostname and IP, which means that you cannot configure permissions based on hostname or IP.

To mitigate this, a proxy/loadbalancer usually sets its own hostname in the hosts field of the request, and appends the previous value of this field to a special HTTP header field, called "x-fowarded-for". If you are running several proxies, this field then contains a comma separated list of all proxies, including also the client the request originated from ("proxy chain"). Search Guard can extract the original hostname, and apply permissions accordingly.

If you are not familiar with proxies/loadbalancers and how they affect HTTP header fields, please refer to this [Wikipedia article](https://en.wikipedia.org/wiki/X-Forwarded-For) or the [the original RFC](https://tools.ietf.org/html/rfc7239)

Search Guard supports proxies/loadbalancers by a special section in the configuration called `xff`:

```
searchguard:
  dynamic:
    http:
      xff:
        enabled: true
        remoteIpHeader:  'x-forwarded-for'
        trustedProxies: '192\.168\.0\.10|192\.168\.0\.11'
        internalProxies: '192\.168\.0\.11'
```

You can configure the following settings:

**`enabled: <true|false>`**

Enable or disable XFF support. If you are using SSO/proxy authentication (see below), you need to enable this feature.

**`remoteIpHeader:  'x-forwarded-for'`**

The name of the HTTP header field where the chain of hostnames are stored. In almost all cases, this will be the pre-configured `x-forwarded-for`, so you can leave this setting alone. However, some special SSO products may use different names. If this is the case, you can configure the name of the header field here.

**`trustedProxies:  '<regex>'`**

HTTP header fields can be spoofed easily. Therefore you need to configure the IP addresses of all proxies Search Guard should trust via the `trustedProxies` config setting. This is especially necessary if you use proxy authentication. If the `x-forwarded-for` field contains an IP that does not match the configured regular expression, an error is thrown and the request is denied.

**`internalProxies:  '<regex>'`**

This setting defines the last proxy in the chain before the request is routed to the Elasticsearch cluster. If you have just one proxy, this is effectively the same as the `trustedProxies` setting. By using a regular expressions, you can also define more than one proxy here. If the last proxy does not match the configured regular expression, an error is thrown and the request is denied. 

## HTTP-header based authentication

In some cases, you might already have a (single sign on) authentication solution in place, and you want to use this instead of an authentication backend of Search Guard.

Most of these solutions work as a proxy in front of the actual application that needs an authenticated user (Search Guard in this case). Usually the request is routed to the SSO proxy first. The SSO proxy authenticates the user, and if authentication succeeds, the (verified) username and its (verified) roles are set in special HTTP header fields. The names of these fields are dependant on the SSO solution you have in place.

Search Guard can extract these HTTP header fields from the request, and use these values to determine the permissions a user has.

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

The relevant configuration entries are `user_header` (containing the authenticated username) and `roles_header`, containing the comma separated list of the authenticated users roles.

**Note: Please make sure that XFF support is configured correctly to avoid the following security flaw:**

If you are using proxy authentication, Search Guard assumes that the request stems from a trusted proxy/SSO server and also assumes that the entries in the header fields `user_header` and `roles_header` are correct and verified.

HTTP header fields can be easily spoofed, so an attacker could set these fields to some arbitrary values, gaining any privileges he wants. Make sure to set the `trustedProxies` and `internalProxies` in the `xff` section of the configuration correctly to only accept requests from trusted IPs (e.g. your SSO server).
