<!---
Copryight 2016 floragunn GmbH
-->

### Proxies/Loadbalancers and XFF support

**Note: If you do not run Elasticsearch behind any proxy or loadbalancer, you can ignore this chapter.**

Search Guard supports Elasticsearch installations running behind one or more proxies or loadbalancers. This can simply be an nginx, loadbalancing or forwarding requests to an Elasticsearch cluster, or a chain of proxies (e.g. including a single sign on proxy). 

If a request is routed via one or more proxies/loadbalancers, the host field of the HTTP request only contains the proxies/loadbalancers hostname, and the remote IP is set to the proxies IP. This effectively hides the clients hostname and IP, which means that you cannot configure permissions based on hostname or IP.

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

This feature is enabled by default, and you need to explicitly disable it if you are not behind any proxy/loadbalancer.

You can configure the following settings:

**`enabled: <true|false>`**

Enable or disable XFF support. If you are using SSO/proxy authentication (see below), you need to enable this feature.

**`remoteIpHeader:  'x-forwarded-for'`**

The name of the HTTP header field where the chain of hostnames are stored. In almost all cases, this will be the pre-configured `x-forwarded-for`, so you can leave this setting alone. However, some special SSO procucts use different names. If this is the case, you can configure the name of the header field here.

**`trustedProxies:  '<regex>'`**

HTTP header fields can be spoofed easily. Therefore you need to configure the IP addresses of all proxies Search Guard should trust via the `trustedProxies` config setting. This is especially necessary if you use proxy authentication. If the `x-forwarded-for` field contains an IP that does not match the configured regular expression, an error is thrown and the request is denied.

**`internalProxies:  '<regex>'`**

This setting defines the last proxy in the chain before the request is routed to the Elasticsearch cluster. If you have just one proxy, this is effectively the same as the `trustedProxies` setting. By using a regular expressions, you can also define more than one proxy here. If the last proxy does not match the configured regular expression, an error is thrown and the request is denied. 
