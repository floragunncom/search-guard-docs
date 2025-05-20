---
title: Quick Start
html_title: JSON web tokens Quick Start
permalink: json-web-tokens
layout: docs
edition: enterprise
description: How to configure JSON web tokens (JWT) to implement Single-Sign-On access
  to your Elasticsearch cluster.
resources:
- https://search-guard.com/jwt-secure-elasticsearch/|Using JSON web tokens to secure
  Elasticsearch (blog post)
- https://jwt.io/|jwt.io - useful tools for generating and validating JWT (website)
---
<!---
Copyright 2022 floragunn GmbH
-->

# JWT Authentication Quick Start
{: .no_toc}

{% include toc.md %}

Search Guard supports user authentication with [JSON Web Tokens](https://jwt.io/introduction) (JWT). 

This chapter describes the basic setup of JWT with Search Guard. This will work in many cases; some setups, however, require special configurations. Please refer to the section Advanced Configuration for this.

## Prerequisites

To use JWT based authentication, you need the keys which are used to sign the JWT. You can provide these in form of a [JSON Web Key or JSON Web Key Set](https://datatracker.ietf.org/doc/html/rfc7517) (JWK/JWKS) or in form of EC or RSA public keys or certificates in PEM format. You can also use an OIDC `.well-known/openid-configuration` URL to retrieve the signing keys. 

Additionally, you need to clarify from where to retrieve the roles of a user. These can be encoded in form of a claim inside of the JWT. However, there is no standardized format or claim name for this.

## Search Guard setup

A minimal `sg_authc.yml` file for JWT authentication using JWKS looks like this:

```yaml
auth_domains:
- type: jwt
  jwt.signing.jwks.keys:
  - kty: RSA
    use: sig
    alg: RS256
    n: "jicRTT-2H3U6jAoBeUKh8s..."
    e: "AQAB"
  user_mapping.roles.from_comma_separated_string: jwt.roles
```

The section below `jwt.signing.jwks.keys` is a JWKS document encoded into the YAML structure.

If you have a config variable containing a PEM file with an RSA certificate, you can use a configuration similar to the following:

```yaml
auth_domains:
- type: jwt
  jwt.signing.rsa.certificate: "#{var:jwt_rsa_cert}"
  jwt.signing.rsa.algorithm: RS256
  user_mapping.roles.from_comma_separated_string: jwt.roles
```

If you have a PEM with with an EC certificate, use this:

```yaml
auth_domains:
- type: jwt
  jwt.signing.ec.certificate: "#{var:jwt_ec_cert}"
  jwt.signing.ec.curve: "P-521"
  user_mapping.roles.from_comma_separated_string: jwt.roles
```

Note that you must specify a `curve` for EC, which is either `P-256`, `P-384` or `P-521`. 

For options on how to retrieve the keys from external endpoints, see [advanced configuration](json-web-tokens-advanced).

### Audience validation

JWT contain an "audience claim" which defines the system which is supposed to use the JWT. You can
configure Search Guard to validate the audience claim. For this, use the option `jwt.required_audience`. 

### Roles

The examples above assumed that the JWT contains an attribute called `roles` which is a simple, comma-separated string of role names. Thus, the `user_mapping.roles` configuration was set like this:

```
  user_mapping.roles.from_comma_separated_string: jwt.roles
```

If your JWT contain the roles in a different attribute, you can change the attribute path specification accordingly. 

It is also possible that your JWT contain the roles as an actual array of strings. Then, use this configuration:

```
  user_mapping.roles.from: jwt.roles
```

In some cases, JWT do not contain role information. In that case, you need a user information backend to retrieve role information.


## Activate the setup

After having applied the changes to `sg_authc.yml`, use `sgctl` to upload the file to Search Guard:

```
$ ./sgctl.sh update-config sg_authc.yml
```

That’s it. You can test the JWT setup with your favorite REST client. If you are using curl, you can try this command:

```
$ curl -H "Authorization: Bearer ${JWT}" "https://node.example.com:9200/_searchguard/authinfo"
```


## Where to go next

* Check the  [advanced configuration options for JWT](json-web-tokens-advanced)