---
title: Proxy
html_title: Kibana Proxy Authentication
permalink: kibana-authentication-proxy
category: kibana-authentication
order: 300
layout: docs
edition: community
description: How to use an authenticating proxy in front of Kibana to implement Single-Sign-On.
---
<!--- Copyright 2021 floragunn GmbH -->

# Kibana Proxy authentication
{: .no_toc}

{% include toc.md %}

Proxy authentication depends on a proxy running in front of Kibana and adding the necessary authentication and authorization information to the headers of the HTTP requests.

To securely use proxy authentication with Kibana, you must ensure that Kibana is only available via the proxy and not via direct connections. If Kibana were available via direct connections, users could spoof authentication or authorization information.
{: .note .js-note .note-warning}

## Prerequisites

To use proxy authentication, you need a proxy in front of Kibana, which adds authentication information to the HTTP requests.

## Search Guard Backend Setup

To use proxy authentication with Kibana, you have to also set up a suitable authentication mechanism in the Search Guard backend configuration `sg_authc.yml`.

The type of the setup depends on the information provided by the proxy in the HTTP headers:

- If the proxy transmits username and role information as plain headers, go for a [trusted_origin](../_docs_auth_auth/auth_auth_proxy.md) authenticator in the backend. When configuring `network.trusted_proxies` inside `sg_authc.yml`, you need to make sure that you both include the IP of the outer proxy and the IP of Dashboards/Kibana, which also acts as a proxy in this case.
- If the proxy transmits authorization as a JWT in a header, go for a  [JWT](../_docs_auth_auth/auth_auth_jwt.md) authenticator in the backend.

## Kibana Setup

Additionally, you need to edit the file `config/kibana.yml`:

* Add the line `searchguard.auth.type: "proxy"`
* Make sure to whitelist all HTTP headers set by your proxy in the header whitelist:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant", "x-proxy-user", "x-proxy-roles" ]
```

You do not need to add the `x-forwarded-for` header, as this is automatically handled by the Search Guard plugin. The Search Guard plugin acts here like Dashboards/Kibana is a proxy. This means:

- If there is no `x-forwarded-for` header, the Search Guard plugin adds the header and adds the IP of the host connecting to Dashboards/Kibana to the header value.
- If there is an `x-forwarded-for` header, the Search Guard plugin appeands the IP of the host connecting to Dashboards/Kibana to the end of the header value.

