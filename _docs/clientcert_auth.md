---
title: Client certificate authentication
html_title: TLS authentication
slug: client-certificate-auth
category: authauth
order: 700
layout: docs
edition: community
description: How to use client side TLS certificates to protect Elasticsearch against unauthorized access.
---
<!---
Copyright 2017 floragunn GmbH
-->

# Client certificate based authentication
{: .no_toc}

{% include_relative _includes/toc.md %}

Search Guard can use a client TLS certificate in the HTTP request to authenticate users and assign roles and permissions.

## Configuration

In order for Search Guard to pick up client certificate on the REST layer, you need to set the `clientauth_mode` in `elasticsearch.yml` to either `OPTIONAL` or `REQUIRE`:

```yaml
searchguard.ssl.http.clientauth_mode: OPTIONAL
```

The configuration for the client certificate authenticator is very minimal:

```yaml
clientcert_auth_domain:
  enabled: true
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

To map a certificate based user to a role, just use the username as specified by `username_attribute` (`cn` in `clientcert_auth_domain`) in `sg_roles_mapping.yml`, for example:

You issued a certificate for the user `kirk` for which the subject of the certificate is (`openssl x509 -in kirk.crt.pem -text -noout`):

```
Subject: C=DE, L=Test, O=client, OU=client, CN=kirk
```

You would then map the role like so:

```yaml
sg_role_starfleet:
  users:
    - kirk
  backendroles:
    - ...
  hosts:
    - ...
```