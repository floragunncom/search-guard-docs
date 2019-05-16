---
title: Proxy authentication
html_title: Kibana Proxy
slug: kibana-authentication-proxy
category: kibana-authentication
order: 600
layout: docs
edition: community
description: How to an authenticating proxy in front of Kibana to implement Single Sign On.
---
<!---
Copyright 2019 floragunn GmbH
-->

# Using Kibana with Proxy authentication
{: .no_toc}

{% include toc.md %}

Activate proxy authentication by adding the following to `kibana.yml`:

```
searchguard.auth.type: "proxy"
```

It's also possible to use:

```yaml
searchguard.auth.type: "proxycache"

# The header that identifies the user - (required, no default)
searchguard.proxycache.user_header: x-proxy-user

# The header that identifies the user's role(s) - (required, no default)
searchguard.proxycache.roles_header: x-proxy-roles

# HTTP header field which the proxy uses to forward the IP chain to the endpoint, usually x-forwarded-for. 
# (optional, default: x-forwarded-for)
#searchguard.proxycache.proxy_header: x-forwarded-for

# IP where Kibana is running on - (required, no default)
# Used to add it to the x-forwarded-for IP chain (see above)
# This IP must be added as trusted IP in sg_config.yml under 
# searchguard.dynamic.http.xff.internalProxies. 
# It's also possible to us a environment variable here like ${IP_ADDRESS}
searchguard.proxycache.proxy_header_ip: "127.0.0.1"

# Redirect to this URL if the user isn't authenticated - (optional, no default)
#searchguard.proxycache.login_endpoint: "https://login.sso.company.com"
```

which works similar to "proxy" auth but only transmit the headers once by storing them in a cookie.


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

# Enable Proxy
searchguard.auth.type: "proxy"

# Use HTTPS instead of HTTP
elasticsearch.hosts: "https://&lt;hostname&gt;.com:&lt;http port&gt;"

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