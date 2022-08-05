---
title: Advanced Configuration
html_title: JWT Advanced Configuration
permalink: json-web-tokens-advanced
category: jwt
order: 200
layout: docs
edition: enterprise
description: How to configure JSON web tokens (JWT) to implement Single-Sign-On access to your Elasticsearch cluster.
resources:
  - "https://search-guard.com/jwt-secure-elasticsearch/|Using JSON web tokens to secure Elasticsearch (blog post)"
  - "https://jwt.io/|jwt.io - useful tools for generating and validating JWT (website)"

---
<!---
Copyright 2022 floragunn GmbH
-->

# JWT Authentication Advanced Configuration
{: .no_toc}

{% include toc.md %}

This chapter lists all advanced configuration options for OIDC. Most of them are only needed for specific setups.

## JWK sources

You can configure the sources of signing keys using the following options:

**jwt.signing.jwks_endpoint.url:** An endpoint which serves JWKS documents. Search Guard will automatically refresh the document whenever an unknown key (identified by the `kid` claim) is encountered.

**jwt.signing.jwks_endpoint.tls:** TLS settings for the endpoint. See [common TLS settings](#common-tls-settings) below.

**jwt.signing.jwks_endpoint.proxy:** If you need an HTTP proxy to connect to the endpoint, you can specify the proxy here as an HTTP URL.

**jwt.signing.jwks_from_openid_configuration.url:** An OIDC `.well-known/openid-configuration` endpoint which is used to retrieve keys as JWKS. Search Guard will automatically refresh the JWKS document whenever an unknown key (identified by the `kid` claim) is encountered.

**jwt.signing.jwks_from_openid_configuration.tls:** TLS settings for the endpoint. See See [common TLS settings](#common-tls-settings) below.

**jwt.signing.jwks_from_openid_configuration.proxy:** If you need an HTTP proxy to connect to the endpoint, you can specify the proxy here as an HTTP URL.

## JWT headers and parameters

By default, Search Guard will look at the HTTP `Authorization` header with a `Bearer` scheme to extract the JWT. You can also configure other sources.

**jwt.header:** The HTTP header in which the token is transmitted. This is typically the `Authorization` header with the `Bearer` schema: `Authorization: Bearer <token>`. Default is `Authorization`.

**jwt.url_parameter:** If the token is not transmitted in the HTTP header, but as an URL parameter, define the name of this parameter here. 

## Common TLS settings

The `tls` settings mentioned above offer the following configuration options:

**tls.trusted_cas:** The root certificates to trust when connecting to the IdP. You can specify the certificates in PEM format inline or specify an absolute pathname using the syntax `#{file:/path/to/certificate.pem}`.

**tls.enabled_protocols:** The enabled TLS protocols. Defaults to `["TLSv1.2", "TLSv1.1"]`.

**tls.enabled_ciphers:** The enabled TLS cipher suites.

**tls.verify_hostnames:** Whether to verify the host names of the IdP’s TLS certificate or not. Default: true.

**tls.trust_all:** Disable all certificate checks. You should only use this for quick tests. *Never use this for production systems.*

**tls.start_tls:** Use StartTLS to initiate the TLS connection to the remote host.