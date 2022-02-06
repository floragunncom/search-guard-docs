---
title: Advanced Configuration
html_title: JWT Advanced Configuration
permalink: json-web-tokens-advanced
category: jwt
order: 200
layout: docs
edition: enterprise
description: How to configure JSON web tokens (JWT) to implement Single-Sign-On access to your OpenSearch/Elasticsearch cluster.
resources:
  - "https://search-guard.com/jwt-secure-elasticsearch/|Using JSON web tokens to secure OpenSearch/Elasticsearch (blog post)"
  - "https://jwt.io/|jwt.io - useful tools for generating and validating JWT (website)"

---
<!---
Copyright 2020 floragunn GmbH
-->

# JWT Authentication Advanced Configuration
{: .no_toc}

{% include toc.md %}

This chapter lists all advanced configuration options for OIDC. Most of them are only needed for specific setups.

## JWK Sources

You can configure the sources of signing keys using the following options:

**jwt.signing.jwks_endpoint.url:** An endpoint which serves JWKS documents. Search Guard will automatically refresh the document whenever an unknown key (identified by the `kid` claim) is encountered.

**jwt.signing.jwks_endpoint.tls:** TLS settings for the endpoint. See TODO.

**jwt.signing.jwks_endpoint.proxy:** If you need an HTTP proxy to connect to the endpoint, you can specify the proxy here as an HTTP URL.

**jwt.signing.jwks_from_openid_configuration.url:** An OIDC `.well-known/openid-configuration` endpoint which is used to retrieve keys as JWKS. Search Guard will automatically refresh the JWKS document whenever an unknown key (identified by the `kid` claim) is encountered.

**jwt.signing.jwks_from_openid_configuration.tls:** TLS settings for the endpoint. See TODO.

**jwt.signing.jwks_from_openid_configuration.proxy:** If you need an HTTP proxy to connect to the endpoint, you can specify the proxy here as an HTTP URL.

## JWT Headers and Parameters

By default, Search Guard will look at the HTTP `Authorization` header with a `Bearer` scheme to extract the JWT. You can also configure other sources.

**jwt.header:** The HTTP header in which the token is transmitted. This is typically the `Authorization` header with the `Bearer` schema: `Authorization: Bearer <token>`. Default is `Authorization`.

**jwt.url_parameter:** If the token is not transmitted in the HTTP header, but as an URL parameter, define the name of this parameter here. 

