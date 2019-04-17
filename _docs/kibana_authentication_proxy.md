---
title: Proxy authentication
html_title: Proxy authentication
slug: kibana-authentication-proxy
category: kibana-authentication
order: 600
layout: docs
edition: community
description: How to an authenticating proxy in front of Kibana to implement Single Sign On.
---
<!---
Copryight 2016-2017 floragunn GmbH
-->

# Using Kibana with Proxy authentication
{: .no_toc}

{% include_relative _includes/toc.md %}

Activate proxy authentication by adding the following to `kibana.yml`:

**For v13 and below:**

```
searchguard.basicauth.enabled: false
```

**For v14 and above:**

```
searchguard.auth.type: "proxy"
```

## Whitelist the proxy headers

Make sure to whitelist all HTTP headers set by your proxy in the header whitelist in kibana.yml, leaving `Authorization`intact:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant", "x-forwarded-for", "x-proxy-user", "x-proxy-roles" ]
```

Note that the Search Guard proxy authenticator requires the `x-forwarded-for`header to function properly.

## Configuration example

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-yaml">
<code class=" js-code language-markup">

# v13 and below: Disable HTTP Basic Authentication
searchguard.basicauth.enabled: false

# v14 and above: Enable Proxy
searchguard.auth.type: "proxy"

# Use HTTPS instead of HTTP
elasticsearch.hosts: ["https://&lt;hostname&gt;.com:&lt;http port&gt;"]

# Configure the Kibana internal server user
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"

# Disable SSL verification when using self-signed demo certificates
elasticsearch.ssl.verificationMode: none

# Whitelist basic headers and multi tenancy header
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant", "x-forwarded-for", "x-proxy-user", "x-proxy-roles" ]
</code>
</pre>
</div>

## Elasticsearch configuration

If you're using HTTP Basic Authentication and the internal user database for the Kibana server user, make sure that both authentication domains are active in `sg_config.yml`:

```yaml
proxy_auth_domain:
  enabled: true
  order: 0
  http_authenticator:
    type: proxy
    challenge: false
    config:
      user_header: "x-proxy-user"
      roles_header: "x-proxy-roles"
  authentication_backend:
    type: noop
basic_internal_auth_domain: 
  enabled: true
  order: 1
  http_authenticator:
    type: basic
    challenge: false
    ...
```
