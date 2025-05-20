---
title: Client certificate authentication
html_title: TLS authentication
permalink: client-certificate-auth
layout: docs
edition: community
description: How to use client side TLS certificates to protect Elasticsearch against
  unauthorized access.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Client certificate based authentication
{: .no_toc}

{% include toc.md %}

Search Guard can use a client TLS certificate in the HTTP request to authenticate users and assign roles and permissions.

## Search Guard setup

In order for Search Guard to pick up client certificate on the REST layer, you need to set the `clientauth_mode` in `elasticsearch.yml` to either `OPTIONAL` or `REQUIRE`:

```yaml
searchguard.ssl.http.clientauth_mode: OPTIONAL
```

The configuration for the client certificate authenticator is very minimal:

```yaml
auth_domains:
- type: clientcert
```

In this configuration, users logged in by client cert show up in Search Guard with the full distinguished name ("dn") of the certificate subject. 

If you want to use just a RDN of the certificate subject, you can access it in `user_mapping` using the attribute `clientcert.subject`:

```yaml
auth_domains:
- type: clientcert
  user_mapping.user_name.from: clientcert.subject.cn
```


In this configuration, the cn ("common name") component of the certificate subject is used as the user name in Search Guard. 


### Roles

Certificates carry no role information. In order to define authorization information for users authenticated by client certificates, you have several options:

- Assign roles to concrete users in `sg_role_mapping.yml`.
- Use a user information backend to retrieve roles.
- If the client is capable and trustworthy to define the roles by itself, you can use the same mechanism as described for [proxy authentication](proxy-authentication).

#### Using `sg_role_mapping.yml`

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
  backend_roles:
    - ...
  hosts:
    - ...
```


## Activate the setup

After having applied the changes to `sg_authc.yml`, use `sgctl` to upload the file to Search Guard:

```
$ ./sgctl.sh update-config sg_authc.yml
```

That’s it. Use your favorite REST client capable of client certificate authentication to test logging in. If you are using curl, you can use a command similar to the following:

```
$ curl --cert client.crt.pem --key client.key.pem "https://cluster.example.com:9200/_searchguard/authinfo"
```

