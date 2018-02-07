---
title: Connection Settings
html_title: Active Directory Connection Settings
slug: active-directory-ldap-connection
category: ldap
order: 100
layout: docs
description: Use Search Guard's Active Directory and LDAP module to protect your Elasticsearch cluster against unauthorized access.
---
<!---
Copryight 2017 floragunn GmbH
-->

# Active Directory and LDAP

## Activating the module

LDAP and Active Directory can be used both in the `authc` and `authz` section of the configuration. 

The `authc` section is used for configuring authentication, which means to check if the user has entered the correct credentials. The `authz` is used for authorisation, which defines how the role(s) for an authenticated user are retrieved and mapped.

In most cases, you want to configure both authentication and authorization, however, it is also possible to use authentication only and map the users retrieved from LDAP directly to Search Guard roles. 

To enable LDAP authentication and authorization, add the following lines to sg_config.yml

**Authentication:**

```yaml
authc:
  ldap:
    enabled: true
    order: 1
    http_authenticator:
      type: basic
      challenge: false
    authentication_backend:
      type: ldap
      config:
        ...
```

**Authorization:**

```yaml
authz:
  ldap:
    enabled: true
  authorization_backend:
    type: ldap
    config:
      ...
```

## Connection settings

The connection settings are identical for authentication and authorisation and are added to the `config` section of the respective domains.  

### Connection timeout

Configure the connection timeout and response timeout for all LDAP connections.

```yaml
config:
  connect_timeout: 2000
  response_timeout: 2000
```

| Name | Description |
|---|---|
| connect_timeout | The connection timeout in milliseconds, -1 means indefinite. Default: 5s |
| response_timeout | The response timeout in milliseconds, -1 means indefinite. Default: 5s |


### Hostname and Port

Configure the hostname and port of your Active Directory server(s) like:

```yaml
config:
  hosts:
    - primary.ldap.example.com:389
    - secondary.ldap.example.com:389
```
  
You can configure more than one servers here. If Search Guard cannot connect to the first server, the second one is tried and so on.   

| Name | Description |
|---|---|
| hosts | Host and port of your LDAP server(s). Hostnames and IPs are allowed, and you can define multiple LDAP servers. |

### Bind DN and password

Configure the bind dn and password Search Guard uses when issuing queries to your Active Directory / LDAP server like:

```yaml
config:
  bind_dn: cn=admin,dc=example,dc=com
  password: password
```

These are basically the credential you are using to authenticate against your server. If your server supports anonymous authentication both `bind_dn` and `password` can be set to `null`. 


| Name | Description |
|---|---|
| bind_dn | The DN to use when connecting to LDAP. If anonymous auth is allowed, can be set to null |
| password | The password to use when connecting to LDAP. If anonymous auth is allowed, can be set to null |

### TLS settings

Use the following parameters to configure TLS for connecting to your server:

```yaml
config:
  enable_ssl: <true|false>
  enable_start_tls: <true|false>
  enable_ssl_client_auth: <true|false>
  verify_hostnames: <true|false>
```

| Name | Description |
|---|---|
| enable_ssl | Whether to use LDAP over SSL (LDAPS) or not |
| enable\_start\_tls | Whether to use STARTTLS or not. Cannot be used in combination with LDAPS. |
| enable\_ssl\_client\_auth | Whether to send the client certificate to the LDAP server or not.  |
| verify\_hostnames | Whether to verify the hostnames of the server's TLS certificate or not  |

### Certificate validation

By default Search Guard validates the TLS certificate of the LDAP server(s) against the Root CA configured in elasticsearch.yml, either as PEM certificate or a truststore:

```
searchguard.ssl.transport.pemtrustedcas_filepath: ...
searchguard.ssl.http.truststore_filepath: ...
```

If your server uses a certificate signed by a different CA, import this CA to your truststore or add it to your trusted CA file on each node. 

You can also use a separate root CA in PEM format by setting **one of** the following configuration options:

```yaml
config:
  pemtrustedcas_filepath: /path/to/trusted_cas.pem
```

or

```yaml
config:
  pemtrustedcas_content: |-
    MIID/jCCAuagAwIBAgIBATANBgkqhkiG9w0BAQUFADCBjzETMBEGCgmSJomT8ixk
    ARkWA2NvbTEXMBUGCgmSJomT8ixkARkWB2V4YW1wbGUxGTAXBgNVBAoMEEV4YW1w
    bGUgQ29tIEluYy4xITAfBgNVBAsMGEV4YW1wbGUgQ29tIEluYy4gUm9vdCBDQTEh
    ...
```


| Name | Description |
|---|---|
| pemtrustedcas\_filepath | Absolute path to the PEM file containing the root CA(s) of your Active Directory / LDAP server |
| pemtrustedcas\_content | The root CA content of your Active Directory / LDAP server. Cannot be used when `pemtrustedcas\_filepath` is set. |

### Client authentication

If you use TLS client authentication, Search Guard sends the PEM certificate of the node, as configured in `elasticsearch.yml`.

by setting **one of** the following configuration options::

```yaml
config:
  pemkey_filepath: /path/to/private.key.pem
  pemkey_password: private_key_password
  pemcert_filepath: /path/to/certificate.pem
```

or

```yaml
config:
  pemkey_content: |-
    MIID2jCCAsKgAwIBAgIBBTANBgkqhkiG9w0BAQUFADCBlTETMBEGCgmSJomT8ixk
    ARkWA2NvbTEXMBUGCgmSJomT8ixkARkWB2V4YW1wbGUxGTAXBgNVBAoMEEV4YW1w
    bGUgQ29tIEluYy4xJDAiBgNVBAsMG0V4YW1wbGUgQ29tIEluYy4gU2lnbmluZyBD
    ...
  pemkey_password: private_key_password
  pemcert_content: |-
    MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCHRZwzwGlP2FvL
    oEzNeDu2XnOF+ram7rWPT6fxI+JJr3SDz1mSzixTeHq82P5A7RLdMULfQFMfQPfr
    WXgB4qfisuDSt+CPocZRfUqqhGlMG2l8LgJMr58tn0AHvauvNTeiGlyXy0ShxHbD
    ...
```

| Name | Description |
|---|---|
| pemkey\_filepath | Absolute path to the file containing the private key of your certificate. |
| pemkey\_content | The content of the private key of your certificate. Cannot be used when `pemkey\_filepath` is set. |
| pemkey\_password | The password of your private key, if any. |
| pemcert_filepath | Absolute path to the the client certificate. |
| pemcert_content | The content of the client certificate. Cannot be used when `pemcert_filepath` is set. |

### Enabled ciphers and protocols

You can limit the allowed ciphers and TLS protocols for the LDAP connection. For example, you can only allow strong ciphers and limit the TLS versions to the most recent ones.

```yaml
ldap:
  enabled: true
  ...
  authentication_backend:
    type: ldap
    config:
      enabled_ssl_ciphers:
        - "TLS_DHE_RSA_WITH_AES_256_CBC_SHA"
        - "TLS_DHE_DSS_WITH_AES_128_CBC_SHA256"
      enabled_ssl_protocols:
        - "TLSv1.1"
        - "TLSv1.2"
```

| Name | Description |
|---|---|
| enabled\_ssl\_ciphers | Array, enabled TLS ciphers. Only Java format is supported. |
| enabled\_ssl\_protocols | Array, enabled TLS protocols. Only Java format is supported. |


**Note: By default Search Guard disables `TLSv1` because it is unsecure. If you need to use `TLSv1` and you know what you  are doing, you can re-enable it like:**

```yaml
enabled_ssl_protocols:
  - "TLSv1"
  - "TLSv1.1"
  - "TLSv1.2"
```