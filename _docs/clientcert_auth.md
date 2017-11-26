---
title: Client certificate authentication
html_title: TLS authentication
slug: client-certificate-authentication
category: authauth
order: 700
layout: docs
description: How to use client side TLS certificates to protect Elasticsearch against unauthorized access.
---
<!---
Copryight 2017 floragunn GmbH
-->

# Client certificate based authentication

Search Guard can use a client TLS certificate in the HTTP request to authenticate users and assign roles and permissions.

## Configuration

In order for Search Guard to pick up client certificate on the REST layer, you need to set the `clientauth_mode` in `elasticsearch.yml` to either `OPTIONAL` or `REQUIRE`:

```yaml
searchguard.ssl.http.clientauth_mode: OPTIONAL
```

The configuration for the client certificate authenticator is very minimal:

```yaml
clientcert_auth_domain:
  enabled: false
  order: 1
  http_authenticator:
    type: clientcert
    config:
      username_attribute: cn
    challenge: false
  authentication_backend:
    type: noop
```

| Name | Description |
|---|---|
| username_attribute | String, the part of the certificate's DN that is used as username. If not specified, the complete DN is used.|

## Mapping DNs to roles

To map a certificate based user to a role, just use the username as specified by `username_attribute` in `sg_roles_mapping.yml`, for example:

```yaml
sg_role_starfleet:
  users:
    - 'cn=ldaprole,ou=groups,dc=example,dc=com'
  backendroles:
    - ...
  hosts:
    - ...
```