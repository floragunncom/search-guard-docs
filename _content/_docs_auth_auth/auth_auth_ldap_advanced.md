---
title: Advanced Configuration
html_title: Active Directory and LDAP Advanced Configuration
permalink: active-directory-ldap-advanced
category: ldap
order: 200
layout: docs
description: Use Search Guard's Active Directory and LDAP module to protect your OpenSearch/Elasticsearch cluster against unauthorized access.
---
<!---
Copyright 2020 floragunn GmbH
-->

# LDAP Advanced Configuration
{: .no_toc}

{% include toc.md %}


This chapter lists all advanced configuration options for LDAP. Most of them are only needed for specific setups.

## Connection Settings

The `ldap` authentication backend offers a number of options for controlling the connections to the LDAP server.

**ldap.idp.hosts:** An arbitrary number of hosts to connect to. The `ldap.idp.connection_strategy` option controls the behavior when which hosts will be connected to. 

**ldap.idp.connection_strategy:** Controls how hosts are connected to: `roundrobin`: cycles through all specified hosts (default). `failover`: Prefers the topmost entry in `hosts`. If a host is unavailable, the next one will be used. `fastest`: Tries to choose the fasted host from all specified hosts. `fewest`: Chooses the host with fewest connections. 

**ldap.idp.connection_pool.min_size:** Minimum size of LDAP connection pool. Default: 3.

**ldap.idp.connection_pool.max_size:** Maximum size of LDAP connection pool. Default: 10.


## TLS Settings

If you need special TLS settings to create connections from Search Guard to the IdP, you can configure them with the options listed below. For example, such configuration might become necessary if your IdP uses TLS certificates signed by non-public certificate authorities.

**ldap.idp.tls.trusted_cas:** The root certificates to trust when connecting to the IdP. You can specify the certificates in PEM format inline or specify an absolute pathname using the syntax `#{file:/path/to/certificate.pem}`.

**ldap.idp.tls.enabled_protocols:** The enabled TLS protocols. Defaults to `["TLSv1.2", "TLSv1.1"]`.

**ldap.idp.tls.enabled_ciphers:** The enabled TLS cipher suites.

**ldap.idp.tls.verify_hostnames:** Whether to verify the hostnames of the IdP’s TLS certificate or not. Default: true.

**ldap.idp.tls.trust_all:** Disable all certificate checks. You should only use this for quick tests. *Never use this for production systems.*

**ldap.idp.tls.start_tls:** Use StartTLS to initiate the TLS connection to the remote host.


### Example

```yaml
auth_domains:
- type: basic/ldap
  ldap.idp.hosts:
  - "ldaps://ldap.example.com"
  ldap.idp.tls.trusted_cas: |
      -----BEGIN CERTIFICATE-----
      MIIEZjCCA06gAwIBAgIGAWTBHiXPMA0GCSqGSIb3DQEBCwUAMHgxEzARBgoJkiaJ
      [...]
      1k4enV7iJWXE8009a6Z0Ouwm2Bg68Wj7TAQ=
      -----END CERTIFICATE-----
```

## TLS Client Authentication

If you need to use TLS client authentication to connect from Search Guard to the IdP, you can configure it using the following options:

**ldap.idp.tls.client_auth.certificate:** The client certificate. You can specify the certificate in PEM format inline or specify an absolute pathname using the syntax `#{file:/path/to/certificate.pem}`. You can also specify several certificates to specify a certificate chain.

**lpda.idp.tls.client_auth.private_key:** The private key that belongs to the client certificate. You can specify the key in PEM format inline or specify an absolute pathname using the syntax `#{file:/path/to/private-key.pem}`.

**ldap.idp.tls.client_auth.private_key_password:** If the private key is encrypted, you must specify the key password using this option.

## User Search Settings

The LDAP user search can be customized using the following settings:

**ldap.user_search.base_dn:** Root of the directory tree under which users shall be searched. Default: The root of the directory.

**ldap.user_search.filter.by_attribute:** Filters the subtree by the specify attribute which must match the user name which was extracted by the authentication frontend. Default: `sAMAccountName`

**ldap.user_search.filter.raw:** Alternatively to `ldap.user_search.filter.by_attribute`, you can specify a raw LDAP search filter. In the search filter, you can use the placeholder `${user.name}` to refer to the user name extracted by the authentication frontend. Example: `(uid=${user.name})`. 


