---
title: Advanced Configuration
html_title: HTTP Proxy Advanced Configuration
permalink: proxy-authentication-advanced
category: proxy
order: 200
layout: docs
edition: community
description: Use Search Guard's Proxy authentication feature to connect OpenSearch/Elasticsearch to any third-party identity provider.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Proxy based authentication advanced configuration
{: .no_toc}

{% include toc.md %}

## Originating IP addresses

Some features of Search Guard operate on the IP address of the client: For includes `accept.ips` and `skip.ips` in `sg_authc.yml`, or the IP-based role assignment in `sg_roles_mapping.yml`. 

When operating Search Guard behind a proxy, however, it is always the IP address of the proxy which creates the connections to Search Guard. To be able to
use the actual originating client IP anyway, Search Guard uses the `X-Forwarded-For` HTTP header to determine the originating client IP whenever a trusted proxy is configured.

Search Guard checks the IP addresses listed in the `X-Forwarded-For` HTTP header from right to the left; the first IP address which does not match the `network.trusted_proxies` CIDR pattern, will be considered the actual originating IP address.

**Note:** This IP address will be then used by the `sg_authc.yml` settings `accept.ips` and `skip.ips`. If you want to check the IP address of the direct connection, you can use `accept.direct_ips` and `skip.direct_ips`. 

If your proxy uses a different name of the `X-Forward-For` header, you can configure that name in `sg_authc.yml` with the option `network.http.remote_ip_header`. 

## Dashboards/Kibana proxy authentication

If you plan to use proxy authentication with Dashboards/Kibana, the most common setup is to place an authenticating proxy in front of Dashboards/Kibana, and let Dashboards/Kibana pass the user and role header to Search Guard:

```
Authentication Proxy -> Dashboards/Kibana -> Search Guard
```

In this case the remote address of the HTTP call is the IP of Dashboards/Kibana, because it sits directly in front of Search Guard. Therefore you need to add the IP of Dashboards/Kibana to the list of internal proxies:

```yaml
_sg_meta:
  type: "config"
  config_version: 2

sg_config:
  dynamic:
    http:
      xff:
        enabled: true
        remoteIpHeader: 'x-forwarded-for'
        internalProxies: '<Dashboards/Kibana IP>'
```

To activate proxy authentication in Dashboards/Kibana, add the following line to `opensearch_dashboards.yml`/`kibana.yml`:

```
searchguard.auth.type: "proxy"
```

To pass the user and role headers that the authenticating proxy adds from Dashboards/Kibana to Search Guard, you need to add them to the HTTP header whitelist in `opensearch_dashboards.yml`/`kibana.yml`:

```
elasticsearch.requestHeadersWhitelist: ["authorization", "sgtenant", "x-proxy-user", "x-proxy-roles"]

```