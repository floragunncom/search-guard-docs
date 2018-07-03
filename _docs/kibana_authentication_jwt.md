---
title: JWT authentication
html_title: JWT authentication
slug: kibana-authentication-jwt
category: kibana-authentication
order: 300
layout: docs
edition: community
description: How to use JSON web tokens to implement Kibana Single Sign on.
---
<!---
Copryight 2016-2017 floragunn GmbH
-->

# Using Kibana with JWT

Activate JWT by adding the following to `kibana.yml`:

**For v13 and below:**

```
searchguard.basicauth.enabled: false
searchguard.jwt.enabled: true
```

**For v14 and above:**

```
searchguard.auth.type: "jwt"
```

## Bearer Authentication

If you're using the default `Authorization` HTTP header field for providing the JWT, you don't need to do anything else in Kibana. If you're using a different HTTP header field, configure it like:

```
searchguard.jwt.header: <HTTP header name>
```

Make sure to also add it to the header whitelist in `kibana.yml`, leaving Authorization intact:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant", "<JWT header name>"]
```

## JWT as URL parameter

Search Guard is capable of processing JWT passed as URL parameter rather than HTTP headers. Due to Kibana limitations Search Guard needs to copy the token from the URL parameter to an HTTP header field before sending it to Elasticsearch. You need to configure the name of the URL parameter, and optionally the name of the HTTP header the token gets copied to. The default is `Authorization`.

```
searchguard.jwt.url_parameter: <URL parameter name that carries the JWT>
searchguard.jwt.header: <HTTP header name the JWT gets copied to>
```

## Configuration example

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-yaml">
<code class=" js-code language-markup">
# Disable HTTP Basic Authentication and enabe JWT
searchguard.basicauth.enabled: false
searchguard.jwt.enabled: true

# v14 and above: Enable JWT authentication
searchguard.auth.type: "jwt"

# If the token is not in the default 'Authorization' HTTP header, 
# configure it here. This header name is also used when copying 
# the token from a request parameter to an HTTP header.
searchguard.jwt.header: 'Authorization'

# If the token is not passed as HTTP header, but as request parameter,
# configure the parameter name here
searchguard.jwt.url_param: 'jwtparam'

# Use HTTPS instead of HTTP
elasticsearch.url: "https://&lt;hostname&gt;.com:&lt;http port&gt;"

# Configure the Kibana internal server user
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"

# Disable SSL verification when using self-signed demo certificates
elasticsearch.ssl.verificationMode: none

# Whitelist basic headers and multi tenancy header
elasticsearch.requestHeadersWhitelist: ["Authorization", "sgtenant"]
</code>
</pre>
</div>

  
## Elasticsearch configuration

Finally, if you're using HTTP Basic Authentication and the internal user database for the Kibana server user, make sure that both authentication domains are active in `sg_config.yml`:

```yaml
jwt_auth_domain:
  enabled: true
  order: 0
  http_authenticator:
    type: jwt
    ...
basic_internal_auth_domain: 
  enabled: true
  order: 1
  http_authenticator:
    type: basic
    challenge: false
    ...
```