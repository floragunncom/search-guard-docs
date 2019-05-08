---
title: OpenID Connect authentication
html_title: OpenID Connect
slug: kibana-authentication-openid
category: kibana-authentication
order: 350
layout: docs
edition: enterprise
description: How to use OpenID Connect and your favorite identity provider to implement Kibana Single Sign-On.
resources:
  - "https://search-guard.com/kibana-openid-keycloak/|Kibana Single Sign-On with OpenID and Keycloak"

---
<!---
Copyright 2019 floragunn GmbH
-->

# Using Kibana with OpenID Connect
{: .no_toc}

{% include toc.md %}

Activate OpenID Connect by adding the following to `kibana.yml`:

```
searchguard.auth.type: "openid"
```

## Configuration

OpenID providers usually publish their configuration in JSON format under the *metadata url*. Therefore most settings can be pulled in automatically, so the Kibana configuration becomes minimal.

The most important settings are:

**Metadata Connect URL**

The metadata URL, sometimes also called connect URL or discovery URL, is the URL under which your IdP published its metadata. This URL varies from IdP to IdP. For example, Keycloak uses:

```
http://keycloak.example.com:8080/auth/realms/master/.well-known/openid-configuration
```

While Auth0 uses:

```
https://YOUR_AUTH0_DOMAIN/.well-known/openid-configuration
```

Please consult the documentation of your IdP for details.

**Client ID**

Every IdP can host multiple clients (sometimes also called applications) with different settings and authentication protocols. When enabling OpenID, you usually create a new client for Kibana in your IdP. The client id uniquely identifies this client. 

**Client secret**

Besides the ID, each client also has a client secret assigned. This is usually generated when the client is created. It adds an extra layer of security: An application can only obtain an identity token when it provides the client secret. You should find this secret in the settings of the client on your IdP. 

### Configuration parameters

| Name | Description |
|---|---|
| searchguard.openid.connect_url | The URL where the IdP publishes the OpenID metadata. Mandatory. |
| searchguard.openid.client_id | The ID of the OpenID client configured in your IdP. Mandatory. |
| searchguard.openid.client_secret | The [client secret](https://auth0.com/docs/applications/how-to-rotate-client-secret){:target="_blank"} of the OpenID client configured in your IdP. Mandatory. |
| searchguard.openid.scope | The [scope of the identity token](https://auth0.com/docs/scopes/current){:target="_blank"} issued by the IdP. Option. Default: 'openid profile email address phone'.|
| searchguard.openid.header | HTTP header name of the JWT token. Optional. Default: 'Authorization' |
| searchguard.openid.base\_redirect\_url | The URL where the IdP redirects to after successful authentication. Optional. If not set, the `server.host`, `server.port` and `server.basepath` from `kibana.yml` are used. |
| searchguard.openid.logout_url | The logout URL of your IdP. Optional. Only necessary if your IdP does not publish the logout URL in its metadata. |


## Configuration example

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-yaml">
<code class=" js-code language-markup">
# Enable OpenID authentication
searchguard.auth.type: "openid"

# the IdP metadata endpoint
searchguard.openid.connect_url: "http://keycloak.example.com:8080/auth/realms/master/.well-known/openid-configuration"

# the ID of the OpenID Connect client in your IdP
searchguard.openid.client_id: "kibana-sso"

# the client secret of the OpenID Connect client
searchguard.openid.client_secret: "a59c51f5-f052-4740-a3b0-e14ba355b520"

# optional: the scope of the identity token
# default: 'openid profile email address phone'
searchguard.openid.scope: "profile email"

# optional: the HTTP header name of the JWT. Default: 'Authorization'
searchguard.openid.header: "Authorization"

# optional: the logout URL of your IdP
# Only necessary if your IdP does not publish the logout url
# in the metadata
searchguard.openid.header: "Authorization"

# Use HTTPS instead of HTTP
elasticsearch.hosts: "https://&lt;hostname&gt;.com:&lt;http port&gt;"

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

Since Kibana requires that the internal Kibana server user can authenticate via HTTP Basic Authentication, you need to configure two authentication domains. For OpenID Connect, the HTTP Basic domain has to be placed first in the chain. Make sure you set the challenge flag to `false`.

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-yaml">
<code class=" js-code language-markup">
basic_internal_auth_domain: 
  enabled: true
  order: 0
  http_authenticator:
    type: basic
    <b>challenge: false</b>
  authentication_backend:
    type: internal
openid_auth_domain:
  enabled: true
  order: 1
  http_authenticator:
    type: openid
    challenge: false
    config:
      subject_key: preferred_username
      roles_key: roles
      openid_connect_url: https://keycloak.example.com:8080/auth/realms/master/.well-known/openid-configuration
  authentication_backend:
    type: noop
</code>
</pre>
</div>

For a more detailed description of the Elasticsearch configuration please see [Elasticsearch OpenID configuration](../_docs_auth_auth/auth_auth_openid.md).