---
title: Proxy
html_title: Kibana Proxy Authentication
slug: kibana-authentication-proxy
category: kibana-authentication
order: 300
layout: docs
edition: community
description: How to an authenticating proxy in front of Kibana to implement Single Sign On.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Kibana Proxy authentication
{: .no_toc}

{% include toc.md %}

Proxy authentication depends on a proxy running in front of Kibana and adding the necessary authentication and authorization information to the headers of the HTTP requests. 

In order to securely use proxy authentication with Kibana, you must make sure that Kibana is only available via the proxy and not via direct connections. If Kibana was available via direct connections, users could spoof authentication or authorization information.
{: .note .js-note .note-warning}

## Prerequisites

In order to use proxy authentication, you need a proxy in front of Kibana which adds authentication information to the HTTP requests.

## Search Guard Backend Setup

In order to use proxy authentication with Kibana, you have to also set up a suitable authentication mechanism in the Search Guard backend configuration `sg_config.yml`.

The type of the setup depends on the information provided by the proxy in the HTTP headers:

- If the proxy transmits username and role information as plain headers, go for a [proxy](../_docs_auth_auth/auth_auth_proxy.md) authenticator in the backend.
- If the proxy transmits authorization as a JWT in a header, go for a  [JWT](../_docs_auth_auth/auth_auth_jwt.md) authenticator in the backend.

## Kibana Setup

Additionally, you need to edit the file `config/kibana.yml` in your Kibana installation:

* Add the line `searchguard.auth.type: "proxy"`
* Make sure to whitelist all HTTP headers set by your proxy in the header whitelist in kibana.yml:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant", "x-forwarded-for", "x-proxy-user", "x-proxy-roles" ]
```

Note that the Search Guard proxy authenticator requires the `x-forwarded-for`header to function properly.
