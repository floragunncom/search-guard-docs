---
title: Advanced Configuration
html_title: Active Directory and LDAP Advanced Configuration
permalink: active-directory-ldap-advanced
category: ldap
order: 200
layout: docs
description: Use Search Guard's Active Directory and LDAP module to protect your Elasticsearch cluster against unauthorized access.
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

**ldap.user_search.base_dn:** Root of the directory tree under which users shall be searched. Default: The empty dn.

**ldap.user_search.scope:** Defines the scope of the search. The default is `sub`, which specifies that the tree below `base_dn` is searched to any depth. `one` specifies that only directly subordinated entries shall be searched. 

**ldap.user_search.filter.by_attribute:** Filters the subtree by the specify attribute which must match the user name which was extracted by the authentication frontend. Default: `sAMAccountName`

**ldap.user_search.filter.raw:** Alternatively to `ldap.user_search.filter.by_attribute`, you can specify a raw LDAP search filter. In the search filter, you can use the placeholder `${user.name}` to refer to the user name extracted by the authentication frontend. Example: `(uid=${user.name})`. 

## Group Search Settings

The group search can be customized using the following settings:

**ldap.group_search.base_dn:** Root of the directory tree under which users shall be searched. 

**ldap.group_search.scope:** Defines the scope of the search. The default is `sub`, which specifies that the tree below `base_dn` is searched to any depth. `one` specifies that only directly subordinated entries shall be searched. 

**ldap.group_search.filter.by_attribute:** Filters the subtree by the specify attribute which must match the user name which was extracted by the authentication frontend. Default: `sAMAccountName`

**ldap.group_search.filter.raw:** Alternatively to `ldap.group_search.filter.by_attribute`, you can specify a raw LDAP search filter. In the search filter, you can use the following placeholders:

- `${dn}` refers to the distinguished name of the LDAP entry found by the user search phase. 
- `${user.name}` refers to the user name extracted by the authentication frontend. 
- A placeholder like `${ldap_user_entry.x}` can be used to refer to any attribute of the LDAP entry found by the user search phase. 

**ldap.group_search.role_name_attribute:** Defines the attribute that will be read from the found LDAP group entries to define the backend role names used by Search Guard. Default: `dn`. 

**ldap.group_search.recursive.enabled:** Set this to `true`, to also search for group memberships of the groups that have been already found during group search. Default: `false`

**ldap.group_search.recursive.enabled_for:** Set this to a regular expression pattern to allow recursion only for DNs which match the specified pattern.

**ldap.group_search.recursive.filter.by_attribute, ldap.group_search.recursive.filter.raw:** You can customize the search filter to be used for recursive group searches here. By default, the filter specified by `ldap.group_search.filter` is also used for recursive searches.

**ldap.group_search.recursive.max_depth:** Specifies the maximum recursion depth for group searches. Defaults to 30.

**ldap.group_search.cache.enabled:** By default, the results of group searches are cached. Set this to `false` to disable caching.

**ldap.group_search.cache.expire_after_write:** Defines that cached entries shall be removed from the cache at a certain time after they were written to the cache. Defaults to `2m`, which means two minutes. You can specify time units using the characters `s` (seconds), `m` (minutes), `h` (hours).

**ldap.group_search.cache.max_size:** Defines the maximum size of the cache. Defaults to 1000 entries.