---
title: Running Search Guard behind a proxy
html_title: Search Guard and proxies
slug: search-guard-proxy
category: configuration
order: 900
layout: docs
edition: community
description: How to setup, configure and run Search Guard behind one or more proxies.
---
<!---
Copryight 2017 floragunn GmbH
-->

# Running Search Guard behing a proxy
{: .no_toc}

Search Guard supports Elasticsearch installations running behind one or more proxies or loadbalancers. This can be a single nginx, load balancer or forwarding requests to an Elasticsearch cluster or a chain of proxies.

If a request is routed via one or more proxies or loadbalancers, the host field of the HTTP request only contains the proxies/loadbalancers hostname.  The remote IP is set to the proxy's IP. This effectively hides the client's hostname and IP, which means that you cannot configure permissions based on hostname or IP.

To mitigate this, a proxy/loadbalancer usually sets its own hostname in the hosts field of the request and appends the previous value of this field to a special HTTP header field, usually "x-fowarded-for". If you are running several proxies, this field contains a comma separated list of all proxies, including the client the request originated from ("proxy chain"). Search Guard can extract the original hostname and apply permissions accordingly.

If you are not familiar with proxies/loadbalancers and how they affect HTTP header fields, please refer to this [Wikipedia article](https://en.wikipedia.org/wiki/X-Forwarded-For){:target="_blank"} or the [the original RFC](https://tools.ietf.org/html/rfc7239){:target="_blank"}.

Search Guard supports proxies/loadbalancers by a special section in the configuration called `xff`:

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
| searchguard.dynamic.http.xff.internalProxies | A regular expression containing all trusted proxies. Search Guard compares the remote address of the HTTP request with the list of internal proxies. If the remote address is not in the list of trusted proxies, it is treated like a client request. [Proxy authentication](proxy_auth.md) will not work in this case.   |
| searchguard.dynamic.http.xff.remoteIpHeader | String, name of the HTTP header field where the chain of hostnames are stored. Default: `x-forwarded-for` |

