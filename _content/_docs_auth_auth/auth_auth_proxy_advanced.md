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