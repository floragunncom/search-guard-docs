---
title: Configuring TLS
permalink: configuring-tls
layout: docs
edition: community
description: Search Guard TLS configuration settings for the REST and the transport
  layer. Extended security options for hostname verification and DNS lookups.
resources:
- troubleshooting-tls|Troubleshooting TLS problems (docs)
- https://search-guard.com/elasticsearch-searchguard-tls-introduction/|An introduction
  to TLS (blog post)
- https://search-guard.com/elasticsearch-tls-certificates/|An introduction to TLS
  certificates (blog post)
---
<!---
Copyright 2022 floragunn GmbH
-->
# Configuring TLS
{: .no_toc}

{% include toc.md %}

TLS is configured in the `config/elasticsearch.yml` file of your Elasticsearch installation. There are two main configuration sections, one for the transport layer, and one for the REST layer. For the REST layer, TLS is optional, while it is mandatory for the transport layer. You can add the configuration at any place of the `elasticsearch.yml` file, the order does not matter.

You can find an example configuration template with all options on [GitLab](https://git.floragunn.com/search-guard/search-guard-ssl/blob/master/searchguard-ssl-config-template.yml){:target="_blank"}
{: .note .js-note}

## Using X.509 PEM certificates and PKCS #8 keys

Use the following keys to configure the location of your PEM certificates and private keys:

### Transport layer TLS

| Name | Description |
|---|---|
| searchguard.ssl.transport.pemkey_filepath | Path to the certificates key file (PKCS #8), which must be under the config/ directory, specified using a relative path (mandatory) |
| searchguard.ssl.transport.pemkey_password |  Key password. Omit this setting if the key has no password. (optional)|
| searchguard.ssl.transport.pemcert_filepath | Path to the X.509 node certificate chain (PEM format), which must be under the config/ directory, specified using a relative path (mandatory) |
| searchguard.ssl.transport.pemtrustedcas_filepath | Path to the root CA(s) (PEM format), which must be under the config/ directory, specified using a relative path (mandatory)|
{: .config-table}

### REST layer TLS

| Name | Description |
|---|---|
| searchguard.ssl.http.pemkey_filepath | Path to the certificates key file (PKCS #8), which must be under the config/ directory, specified using a relative path (mandatory)  |
| searchguard.ssl.http.pemkey_password |  Key password. Omit this setting if the key has no password. (optional)|
| searchguard.ssl.http.pemcert_filepath | Path to the X.509 node certificate chain (PEM format), which must be under the config/ directory, specified using a relative path (mandatory) |
| searchguard.ssl.http.pemtrustedcas_filepath | Path to the root CA(s) (PEM format), which must be under the config/ directory, specified using a relative path (mandatory) |
{: .config-table}

## Using Keystore and Truststore files
As an alternative to certificates and private keys in PEM format, you can also use keystore and truststore files in JKS or PKCS12/PFX format. The following settings configure the location and password of your keystore and truststore files. You can use different keystore and truststore files for the REST and the transport layer if required.

### Transport layer TLS

| Name | Description |
|---|---|
| searchguard.ssl.transport.keystore\_type | The type of the keystore file, JKS or PKCS12/PFX (Optional, default: JKS) |
| searchguard.ssl.transport.keystore\_filepath | Path to the keystore file, which must be under the config/ directory, specified using a relative path (mandatory) |
| searchguard.ssl.transport.keystore\_alias: my\_alias | Alias name (optional, default: first alias which could be found) |
| searchguard.ssl.transport.keystore_password | Keystore password (default: changeit) |
| searchguard.ssl.transport.keystore_keypassword | (since v24.2) Key password (default: value of searchguard.ssl.transport.keystore_password) |
| searchguard.ssl.transport.truststore_type | The type of the truststore file, JKS or PKCS12/PFX (default: JKS) |
| searchguard.ssl.transport.truststore_filepath | Path to the truststore file, which must be under the config/ directory, specified using a relative path (mandatory) |
| searchguard.ssl.transport.truststore\_alias | Alias name (optional, default: all certificates) |
| searchguard.ssl.transport.truststore_password | Truststore password (default: changeit) |
{: .config-table}

### REST layer TLS

| Name | Description                                                                                                              |
|---|--------------------------------------------------------------------------------------------------------------------------|
| searchguard.ssl.http.enabled | Whether to enable TLS on the REST layer or not. If enabled, only HTTPS is allowed. (Optional, default: true since 4.0.0) |
| searchguard.ssl.http.keystore\_type | The type of the keystore file, JKS or PKCS12/PFX (Optional, default: JKS)                                                |
| searchguard.ssl.http.keystore\_filepath | Path to the keystore file, which must be under the config/ directory, specified using a relative path (mandatory)        |
| searchguard.ssl.http.keystore\_alias | Alias name (optional, default: first alias which could be found)                                                         |
| searchguard.ssl.http.keystore_password | Keystore password (default: changeit)                                                                                    |
| searchguard.ssl.http.keystore_keypassword | (since v24.2) Key password (default: value of searchguard.ssl.http.keystore_password)                                    |
| searchguard.ssl.http.truststore_type | The type of the truststore file, JKS or PKCS12/PFX (default: JKS)                                                        |
| searchguard.ssl.http.truststore_filepath | Path to the truststore file, which must be under the config/ directory, specified using a relative path (mandatory)      |
| searchguard.ssl.http.truststore\_alias | Alias name (optional, default: all certificates)                                                                         |
| searchguard.ssl.http.truststore_password | Truststore password (default: changeit)                                                                                  |
{: .config-table}

## Configuring Node certificates

Search Guard needs to identify inter-cluster requests, i.e. requests between the nodes in the cluster reliably. The simplest way of configuring node certificates is to list the DNs of these certificates in `elasticsearch.yml`. Search Guard supports wildcards and regular expressions:

```yaml
searchguard.nodes_dn:
  - 'CN=node.other.com,OU=SSL,O=Test,L=Test,C=DE'
  - 'CN=*.example.com,OU=SSL,O=Test,L=Test,C=DE'
  - 'CN=elk-devcluster*'
  - '/CN=.*regex/'
```

If your node certificates have an OID identifier in the SAN section, you can omit this configuration completely. See [TLS for production environments](tls-in-production) for more details regarding this option.

## Configuring Admin certificates

Admin certificates are regular client certificates that have elevated rights to perform administrative tasks. You need an admin certificate to change the Search Guard configuration via the [sgctl](sgctl-configuration-changes) command line tool, or to use the [REST management API](rest-api-access-control). Admin certificates are configured in `elasticsearch.yml` by simply stating their DN(s).

```yaml
searchguard.authcz.admin_dn:
  - CN=admin,OU=SSL,O=Test,L=Test,C=DE
```

For security reasons, you cannot use wildcards or regular expressions here.

## Advanced: Hostname verification and DNS lookup

In addition to verifying the TLS certificates against the Root CA and/or intermediate CA(s), Search Guard can apply additional checks on the transport layer to further secure your cluster.

With **hostname verification** enabled, Search Guard verifies that the hostname of the communication partner matches the hostname in the certificate. For example, if the hostname of your node is `node-0.example.com` then the hostname in the TLS certificate has to be set to `node-0.example.com` as well. Otherwise, an error is thrown. The hostname is taken from the `subject` or the `SAN` entries of your certificate.

In addition, when **resolve hostnames** is enabled, Search Guard resolves the (verified) hostname against your DNS. If the hostname does not resolve, an error is thrown.

| Name | Description |
|---|---|
| searchguard.ssl.transport.enforce\_hostname\_verification | Whether or not to verify hostnames on the transport layer. (Optional, default: true) |
| searchguard.ssl.transport.resolve\_hostname | Whether or not to resolve hostnames against DNS on the transport layer. (Optional, default: true, only works if hostname verification is enabled.) |
{: .config-table}

## Advanced: Client authentication

With TLS client authentication enabled, REST clients can send a TLS certificate with the HTTP request to provide identity information to Search Guard. There are three main usage scenarios for TLS client authentication:

* Providing an admin certificate when using the REST management API.
* Configuring roles and permissions based on a client certificate.
* Providing identity information for tools like Kibana, logstash or Beats

TLS client authentication has three modes:

* `NONE`: Search Guard does not accept TLS client certificates. If one is sent, it is discarded.
* `OPTIONAL`: Search Guard accepts TLS client certificates if they are sent, but does not enforce them.
* `REQUIRE`: Search Guard only accepts REST requests when a valid client TLS certificate is sent.

For the REST management API, the client authentication modes has to be OPTIONAL at least.

You can configure the client authentication mode by using the following key:

| Name | Description |
|---|---|
| searchguard.ssl.http.clientauth_mode | The TLS client authentication mode to use. Can be one of `NONE`, `OPTIONAL` or `REQUIRE`. (Optional, default: OPTIONAL) |
{: .config-table}

## Expert: Enabled ciphers and protocols

You can limit the allowed ciphers and TLS protocols for the REST layer. For example, you can only allow strong ciphers and limit the TLS versions to the most recent ones.

If this is not set, the ciphers and TLS versions are negotiated between the browser and Search Guard automatically, which in some cases can lead to a weaker cipher suite being used. You can configure the ciphers and protocols by using the following keys:

| Name | Description |
|---|---|
| searchguard.ssl.http.enabled_ciphers | Array, enabled TLS cipher suites for the REST layer. Only Java format is supported. |
| searchguard.ssl.http.enabled_protocols | Array, enabled TLS protocols for the REST layer. Only Java format is supported. |
| searchguard.ssl.transport.enabled_ciphers | Array, enabled TLS cipher suites for the transport layer. Only Java format is supported. |
| searchguard.ssl.transport.enabled_protocols | Array, enabled TLS protocols for the transport layer. Only Java format is supported. |
{: .config-table}

Example:

```yaml
searchguard.ssl.http.enabled_ciphers:
  - "TLS_DHE_RSA_WITH_AES_256_CBC_SHA"
  - "TLS_DHE_DSS_WITH_AES_128_CBC_SHA256"
searchguard.ssl.http.enabled_protocols:
  - "TLSv1.1"
  - "TLSv1.2"
```

By default Search Guard disables `TLSv1` because it is unsecure. 
{: .note .js-note .note-warning}

If you need to use `TLSv1` and you know what you  are doing, you can re-enable it like:**

```yaml
searchguard.ssl.http.enabled_protocols:
  - "TLSv1"
  - "TLSv1.1"
  - "TLSv1.2"
```

## Expert: Disable client initiated renegotiation for Java 8

Set `-Djdk.tls.rejectClientInitiatedRenegotiation=true` to disable secure client initiated renegotiation (which is enabled by default). This can be set via `ES_JAVA_OPTS` in config/jvm.options.

## Configuration example

For an up-to-date, complete configuration example with all features, please refer to the configuration template in the Search Guard SSL repository:

[Search Guard SSL configuration template](https://git.floragunn.com/search-guard/search-guard-ssl/blob/master/searchguard-ssl-config-template.yml){:target="_blank"}