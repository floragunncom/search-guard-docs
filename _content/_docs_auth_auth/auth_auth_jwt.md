---
title: JSON web tokens
slug: json-web-tokens
category: authauth
order: 500
layout: docs
edition: enterprise
description: How to configure JSON web token (JWT) with Search Guard to implement Single-Sign-On access to your Elasticsearch cluster.
resources:
  - "https://search-guard.com/jwt-secure-elasticsearch/|Using JSON web tokens to secure Elasticsearch (blog post)"
  - "https://jwt.io/|jwt.io - useful tools for generating and validating JWT (website)"

---
<!---
Copyright 2020 floragunn GmbH
-->

# JSON web tokens
{: .no_toc}

{% include toc.md %}

## Token based authentication

JSON Web Tokens (JWT) are JSON-based access tokens that assert one or more claims. They are commonly used to implement Single-Sign-On solutions and fall in the category of token based authentication system:

* A user logs in to an authentication server by providing credentials, e.g. username and password.
* The authentication server validates the credentials.
* The authentication server creates an access token and signs it.
* The authentication server returns the token to the user.
* The user stores the access token.
* The user sends the access token along with every request to the service it wants to use.
* The service verifies the token and grants or denies access.

You can read more about token based authentication [in this blog post.](https://scotch.io/tutorials/the-ins-and-outs-of-token-based-authentication){:target="_blank"}.

## JSON web tokens

A JSON web token is self-contained in the sense that it carries all necessary information to verify a user within itself. The tokens are base64-encoded,  signed JSON objects. They are URL safe and can be passed around easily.

A JSON web token consists of three parts:

* Header
* Payload
* Signature

### Header

The header contains information about the used signing mechanism, for example:

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

In this case, the header states that the message was signed using HMAC-SHA256.

### Payload

The payload of a JSON web token contains the so-called [JWT Claims](http://self-issued.info/docs/draft-ietf-oauth-json-web-token.html#RegisteredClaimName){:target="_blank"}. A claim can be any piece of information about the user that the application that created the token has verified.

The specification defines a set of standard claims with reserved names ("registered claims"). These include, for example, the token issuer, the expiration date, or the creation date.

Public claims on the other hand can be created freely by the token issuer.  They can contain arbitrary information, such as the user name and the roles of the user.

Example:

```json
{
  "iss": "floragunn.com",
  "exp": 1300819380,
  "name": "John Doe",
  "roles": ["admin, "devops"]
}
```

### Signature

The issuer of the token calculates the signature of the token by applying a cryptographic hash function on the base-64 encoded header and payload. These three parts are then concatenated via a `.` dot. We now have a complete JSON web token:

```
encoded = base64UrlEncode(header) + "." + base64UrlEncode(payload)
signature = HMACSHA256(encoded, 'secretkey');
jwt = encoded + "." + base64UrlEncode(signature)
```

For example:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dnZWRJbkFzIjoiYWRtaW4iLCJpYXQiOjE0MjI3Nzk2Mzh9.gzSraSYS8EXBxLN_oWnFSRgCzcmJmMjLiuyu5CSpyHI
```

## Configuring JWT support in Search Guard

If JWT is the only authentication method you use, you should disable the [Search Guard User Cache](../_docs_configuration_changes/configuration_cache.md).
{: .note .js-note .note-warning}

In order to use JWT, set up an authentication domain and choose `jwt` as HTTP authentication type. Since the tokens already contain all required information to verify the request, `challenge` must be set to `false` and `authentication_backend` to `noop`.

Example:

```yaml
jwt_auth_domain:
  http_enabled: true
  order: 0
  http_authenticator:
    type: jwt
    challenge: false
    config:
      signing_key: "base64 encoded key"
      jwt_header: "Authorization"
      jwt_url_parameter: null
      <subject_key|subject_path>: null
      <roles_key|roles_path> : null
  authentication_backend:
I    type: noop
```

Configuration parameter:

| Name | Description |
|---|---|
| signing_key | The signing key to use when verifying the token. If you use a symmetric key algorithm, it is the base64 encoded shared secret. If you use an asymmetric algorithm it contains the public key. |
| jwt\_header | The HTTP header in which the token is transmitted. This is typically the `Authorization` header with the `Bearer` schema: `Authorization: Bearer <token>`. Default is `Authorization`.|
| jwt\_url\_parameter | If the token is not transmitted in the HTTP header, but as an URL parameter, define the name of this parameter here. |
| subject_key | The key in the JSON payload that stores the username. If not set, the [subject](https://tools.ietf.org/html/rfc7519#section-4.1.2){:target="_blank"} registered claim is used.|
| subject_path | A JSON path expression in the payload that stores the username, for example ```$["foo"]["user"]["name"]```  where `foo` is the claim name|
| roles_key | The key in the JSON payload that stores the user's roles. The value of this key must be a comma-separated list of roles. |
| roles_path | A JSON path expression to the payload that stores the user's roles, for example ```$["foo"]["user"]["roles"]``` where `foo` is the claim name |
{: .config-table}

It is recommend to use the bracket-notation in JSON path expressions in order to avoid ambiguity, for example a key could be called `user.id` and thus wouldn't be the same as `$["user"]["id"]`.

Since JSON web tokens are self-contained and the user is authenticated on HTTP level, no additional `authentication_backend` is needed, hence it can be set to `noop`.

## Symmetric key algorithms: HMAC 

*Hash-Based Message Authentication Codes* (HMACs) are a group of algorithms that provide a way of signing messages by means of a shared key. The key is shared between the authentication server and Search Guard. It must be configured as **base64-encoded** value of the `signing_key` configuration key:

```yaml
jwt_auth_domain:
  ...
    config:
      signing_key: "bmRSMW00c2pmNUk4Uk9sVVFmUnhjZEhXUk5Hc0V5MWgyV2p1RFE3Zk1wSTE="
      ...
```


Please refer to the documentation of your authentication server on how to obtain it.

While HMACs are simple to use they do not provide guarantees with regards to the creator of the JWT: Anyone who is in possession of the shared key can generate valid JWTs. In case the shared key is lost, all participating systems need to exchange it.

For security reasons, the shared key must be at least 32 characters
{: .note .js-note .note-warning}

## Asymmetric key algorithms: RSA and ECDSA 

RSA and ECDSA are asymmetric encryption and digital signature algorithms and use  a public/private key pair to sign and verify tokens. This means that they use a *private key* for signing the token, while Search Guard only needs to know the *public key* to verify it. 

Since you cannot issue new tokens with the public key and because you can make valid assumptions about the creator of the token, RSA and ECDSA are considered more secure than using HMAC.

In order to use RS256, you only need to configure the (non-base-64 encoded) public RSA key as `signing_key` in the JWT configuration like:

```yaml
jwt_auth_domain:
  ...
    config:
      signing_key: |-
        -----BEGIN PUBLIC KEY-----
        MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQK...
        -----END PUBLIC KEY-----
      ...
```

Search Guard will detect the used algorithm (RSA/ECDSA) automatically.

Please make sure that you keep the content of your public key on one line. Depending on the YAML parser, breaking it into newlines may lead to unwanted whitespaces in the key, rendering it unreadable.
{: .note .js-note .note-warning}


## Using JWT in HTTP requests: Bearer authentication

The most common way of transmitting a JWT in an HTTP request is to add it as HTTP header field with the Bearer authentication schema.

*Bearer authentication (also called token authentication) is an HTTP authentication scheme that involves security tokens called bearer tokens. The name “Bearer authentication” can be understood as “give access to the bearer of this token.”*

*The bearer token is a cryptic string, usually generated by the server in response to a login request. The client must send this token in the Authorization header when making requests to protected resources*
(Source: [https://swagger.io/docs/specification/authentication/bearer-authentication/](https://swagger.io/docs/specification/authentication/bearer-authentication/){:target="_blank"})

```
Authorization: Bearer <JWT>
```

The default name of the header is `Authorization`. If required by your authentication server or proxy, you can also use a different HTTP header name by  using the `jwt_header` configuration key.

As with HTTP Basic authentication, you should use HTTPS instead of HTTP when transmitting JWTs in HTTP requests.

## Using JWT in HTTP requests: URL parameter

While the most common way to transmit JWTs in HTTP requests is to use a header field, Search Guard also supports JWTs transmitted as GET parameter. To do so, configure the name of the GET parameter by using the following key:

```yaml
    config:
      signing_key: ...
      jwt_url_parameter: "parameter_name"
      subject_key: ...
      roles_key: ...
```

As with HTTP Basic authentication, you should use HTTPS instead of HTTP when transmitting JWTs in HTTP requests.

## Validated registered claims

The following registered claims are validated automatically:

* "iat" (Issued At) Claim
* "nbf" (Not Before) Claim
* "exp" (Expiration Time) Claim

## Supported formats and algorithms

Search Guard supports digitally signed compact JWTs with all standard algorithms:

```
HS256: HMAC using SHA-256
HS384: HMAC using SHA-384
HS512: HMAC using SHA-512
RS256: RSASSA-PKCS-v1_5 using SHA-256
RS384: RSASSA-PKCS-v1_5 using SHA-384
RS512: RSASSA-PKCS-v1_5 using SHA-512
PS256: RSASSA-PSS using SHA-256 and MGF1 with SHA-256
PS384: RSASSA-PSS using SHA-384 and MGF1 with SHA-384
PS512: RSASSA-PSS using SHA-512 and MGF1 with SHA-512
ES256: ECDSA using P-256 and SHA-256
ES384: ECDSA using P-384 and SHA-384
ES512: ECDSA using P-521 and SHA-512
```