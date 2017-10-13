# Configuring TLS

TLS is configured in the `config/elasticsearch.yml` file of your ES installation. There are two main configuration sections, one for the transport layer, and one for the REST layer. For the REST layer, TLS is optional, while you cannot switch it off for the transport layer. You can add the configuration at any place of the `elasticsearch.yml` file, the order does not matter.

## Using Keystore and Truststore files

The following settings configure the location and password of your keystore and truststore files. You can use different keystore and truststore files for the REST and the transport layer if required.

*Note: It's common practice to put the certificates and trusted Root CAs in separate keystore and a truststore files. As an alternative, you can also store all certificates in one file, and refer to the relevant certificate by using an alias.* 

### Transport layer TLS

| Name | Description |
|---|---|
| searchguard.ssl.transport.keystore\_type | The type of the keystore file, JKS or PKCS12 (Optional, default: JKS) |
| searchguard.ssl.transport.keystore\_filepath | Path to the keystore file, **relative to the `config/` directory** (mandatory) |
| searchguard.ssl.transport.keystore\_alias: my\_alias | Alias name (optional, default: first alias which could be found) |
| searchguard.ssl.transport.keystore_password | Keystore password (default: changeit) |
| searchguard.ssl.transport.truststore_type | The type of the truststore file, JKS or PKCS12 (default: JKS) |
| searchguard.ssl.transport.truststore_filepath | Path to the truststore file, **relative to the `config/` directory** (mandatory) |
| searchguard.ssl.transport.truststore\_alias | Alias name (optional, default: all certificates) |
| searchguard.ssl.transport.truststore_password | Truststore password (default: changeit) |

### REST layer TLS

| Name | Description |
|---|---|
| searchguard.ssl.http.enabled | Whether to enable TLS on the REST layer or not. If enabled, only HTTPS is allowed. (Optional, default: false) |
| searchguard.ssl.http.keystore\_type | The type of the keystore file, JKS or PKCS12 (Optional, default: JKS) |
| searchguard.ssl.http.keystore\_filepath | Path to the keystore file, **relative to the `config/` directory** (mandatory) |
| searchguard.ssl.http.keystore\_alias | Alias name (optional, default: first alias which could be found) |
| searchguard.ssl.http.keystore_password | Keystore password (default: changeit) |
| searchguard.ssl.http.truststore_type | The type of the truststore file, JKS or PKCS12 (default: JKS) |
| searchguard.ssl.http.truststore_filepath | Path to the truststore file, **relative to the `config/` directory** (mandatory) |
| searchguard.ssl.http.truststore\_alias | Alias name (optional, default: all certificates) |
| searchguard.ssl.http.truststore_password | Truststore password (default: changeit) |

## Using X.509 PEM certificates and PKCS #8 keys

As an alternative to using keystore and trustore files, you can also use X.509 PEM certificates and PKCS #8 keys. This, for example, makes it easy to configure and use Let's Encrypt certificates. Instead of using the keystore and truststore configuration keys described above, use the following keys to configure PEM certificates:

### Transport layer TLS

| Name | Description |
|---|---|
| searchguard.ssl.transport.pemkey_filepath | Path to the certificates key file (PKCS #8), **relative to the `config/` directory** (mandatory) |
| searchguard.ssl.transport.pemkey_password |  Key password. Omit this setting if the key has no password. (optional)|
| searchguard.ssl.transport.pemcert_filepath | X.509 node certificate chain in PEM format, **relative to the `config/` directory** (mandatory) |
| searchguard.ssl.transport.pemtrustedcas_filepath | Trusted certificates in PEM format, **relative to the `config/` directory** (mandatory)|

### REST layer TLS

| Name | Description |
|---|---|
| searchguard.ssl.http.pemkey_filepath | Path to the certificates key file (PKCS #8), **relative to the `config/` directory** (mandatory) |
| searchguard.ssl.http.pemkey_password |  Key password. Omit this setting if the key has no password. (optional)|
| searchguard.ssl.http.pemcert_filepath | X.509 node certificate chain in PEM format, **relative to the `config/` directory** (mandatory) |
| searchguard.ssl.http.pemtrustedcas_filepath | Trusted certificates in PEM format, **relative to the `config/` directory** (mandatory)|

## Configuring Node certificates

Search Guard needs to identify inter-cluster requests, i.e. requests between the nodes in the cluster reliably. While there are several possibilites, the simplest way of configuring node certificates is to list the DNs of these certificates in `elasticsearch.yml`. Search Guard supports wildcards and regular expressions:

```
searchguard.nodes_dn:
  - 'CN=node.other.com,OU=SSL,O=Test,L=Test,C=DE'
  - 'CN=*.example.com,OU=SSL,O=Test,L=Test,C=DE'
  - 'CN=elk-devcluster*'
  - '/CN=.*regex/'
```

See [TLS for production environments](tls_certificates_production.md) for more details and options regarding node certificates.

## Configuring Admin certificates

Admin certificates are regular client certificates that have elevated rights to perform administrative tasks. You need an admin certificate to change the Search Guard configuration via the [sgadmin](sgadmin.md) command line tool, or to use the [REST management API](managementapi.md). Admin certificates are configured in `elasticsearch.yml` by simply stating their DN(s).

```
searchguard.authcz.admin_dn:
  - CN=admin,OU=SSL,O=Test,L=Test,C=DE
```

For security reasons, you cannot use wildcards or regular expressions here.


## Using OpenSSL

Search Guard supports OpenSSL. We recommend to use OpenSSL in production for enhanced performance and a wider range of more modern cipher suites. In order to use OpenSSL, you need to install OpenSSL, the Apache Portable Runtime and a Netty version with OpenSSL support matching your platform on all nodes. This is described in the [OpenSSL](tls_openssl.md) chapter.

If OpenSSL is enabled, but for one reason or another the installation does not work, Search Guard will fall back to the Java JCE as security engine.

| Name | Description |
|---|---|
| searchguard.ssl.transport.enable\_openssl\_if\_available | Enable OpenSSL on the transport layer if avaliable. (Optional, default: true) |
| searchguard.ssl.http.enable\_openssl\_if\_available | Enable OpenSSL on the REST layer if available. (Optional, default: true) |

See the [OpenSSL](tls_openssl.md) chapter for more information on how to install all required components.

## Advanced: Hostname verification and DNS lookup

In addition to verifying the TLS certificates against the Root CA and/or intermediate CA(s) in the truststore, Search Guard can apply additional checks on the transport layer to further secure your cluster.

With **hostname verification** enabled, Search Guard verifies that the hostname of the communication partner matches the hostname in the certificate. For example, if the hostname of your node is node-0.example.com then the hostname in the TLS certificate has to be set to node-0.example.com as well. Otherwise, an error is thrown.

In addition, when **resolve hostnames** is enabled, Search Guard resolves the (verified) hostname against your DNS. If the hostname does not resolve, an error is thrown.

While these settings require a dedicated certificate for each node, and also correct DNS entries, we recommend to enable it for advanced security.

| Name | Description |
|---|---|
| searchguard.ssl.transport.enforce\_hostname\_verification | Whether or not to verify hostnames on the transport layer. (Optional, default: true) |
| searchguard.ssl.transport.resolve\_hostname | Whether or not to resolve hostnames against DNS on the transport layer. (Optional, default: true) |

## Advanced: Client authentication

With TLS client authentication enabled, REST clients can send a TLS certificate in the HTTP request to provide identity information to Search Guard. There are two main usage scenarios for TLS client authentication:

* Providing an admin certificate when using the REST management API.
* Configuring roles and permissions based on a client certificate.

TLS client authentication has three modes:

* `NONE`: Search Guard does not accept TLS client certificates. If one is sent, it is discarded.
* `OPTIONAL`: Search Guard accepts TLS client certificates if they are sent, but does not enforce them.
* `REQUIRE`: Search Guard only accepts REST requests when a valid client TLS certificate is sent.

For the REST management API, the client authentication modes has to be OPTIONAL at least.

You can configure the client authentication mode by using the following key:

| Name | Description |
|---|---|
| searchguard.ssl.http.clientauth_mode | The TLS client authentication mode to use. Can be one of `NONE`, `OPTIONAL` or `REQUIRE`. (Optional, default: OPTIONAL) |

## Expert: Enabled ciphers and protocols

You can limit the allowed ciphers and TLS protocols for the REST layer. For example, you can only allow strong ciphers and limit the TLS versions to the most recent ones.

If this is not set, the ciphers and TLS versions are negotiated between the browser and Search Guard automatically, which in some cases can lead to a weaker cipher suite being used. You can configure the ciphers and protocols by using the following keys:

| Name | Description |
|---|---|
| searchguard.ssl.http.enabled_ciphers | Array, enabled SSL cipher suites for http protocol. Only Java format is supported. |
| searchguard.ssl.http.enabled_protocols | Array, enabled SSL protocols for http protocol. Only Java format is supported. |

Example:

```
searchguard.ssl.http.enabled_ciphers:
  - "TLS_DHE_RSA_WITH_AES_256_CBC_SHA"
  - "TLS_DHE_DSS_WITH_AES_128_CBC_SHA256"
searchguard.ssl.http.enabled_protocols:
  - "TLSv1.1"
  - "TLSv1.2"
```

**Note: By default Search Guard disables `TLSv1` because it is unsecure. If you need to use `TLSv1` and you know what you  are doing, you can re-enable it like:**

```
searchguard.ssl.http.enabled_protocols:
  - "TLSv1"
  - "TLSv1.1"
  - "TLSv1.2"
```

## Expert: Disable client initiated renegotiation for Java 8

Set `-Djdk.tls.rejectClientInitiatedRenegotiation=true` to disable secure client initiated renegotiation (which is enabled by default). This can be set via `ES_JAVA_OPTS` in config/jvm.options. See also [#362](https://github.com/floragunncom/search-guard/issues/362) for more details.

## Configuration example

For an up-to-date, complete configuration example with all features, please refer to the configuration template in the Search Guard SSL repository:

[Search Guard SSL configuration template](https://github.com/floragunncom/search-guard-ssl/blob/master/searchguard-ssl-config-template.yml)
