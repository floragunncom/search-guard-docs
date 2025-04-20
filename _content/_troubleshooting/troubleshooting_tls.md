---
title: TLS troubleshooting
html_title: TLS help
permalink: troubleshooting-tls
layout: docs
description: Step-by-step instructions to troubleshoot Search Guard TLS and certificates
  issues
---
<!--- Copyright 2022 floragunn GmbH -->

# TLS troubleshooting

## Validate your elasticsearch.yml

The Elasticsearch configuration is in yaml format, and so is the Search Guard configuration. A quick way of checking the validity of any yml file is to use the Yaml Lint web service:

[http://www.yamllint.com/](http://www.yamllint.com/)

Just copy and paste the content of your yaml file there and check for any errors.

*Note: You can of course use [http://www.yamllint.com/](http://www.yamllint.com/) to also validate any other Search Guard configuration file.*

## Viewing the contents of PEM certificates

The content of PEM certificates can either be displayed by using OpenSSL or by the [diagnose function of the Search Guard TLS tool](../_docs_tls/tls_generate_tlstool.md#validating-certificates){:target="_blank"}.

OpenSSL:

```
openssl x509 -in node1.pem -text -noout
```

TLS diagnose tool:

```
./sgtlsdiag.sh -ca root-ca.pem -crt node1.pem
```

The [TLS diagnose tool](../_docs_tls/tls_generate_tlstool.md#validating-certificates){:target="_blank"} will also check the validity of the certificate chain.

## Viewing the contents of your Key- and Truststore

In order to view information about the certificates stored in your keystore or truststore, use the `keytool` command like:

```
keytool -list -v -keystore keystore.jks
``` 

The `keytool` will prompt for the password of the keystore and list all entries with detailed information. For example you can use this output to check for the correctness of the SAN and EKU settings.

If you rather like to work with a GUI, we recommend [KeyStore Explorer](http://keystore-explorer.org/):

> KeyStore Explorer is an open source GUI replacement for the Java command-line utilities keytool and jarsigner. KeyStore Explorer presents their functionality, and more, via an intuitive graphical user interface. 

You can use it to examine the contents of locally stored files, but you can also retrieve and inspect certificates from a server (or Elasticsearch cluster) directly.

## Checking the main attributes of a certificate

The main attributes of an entry in the keystore look like:

```
Alias name: node-0
Entry type: PrivateKeyEntry
Certificate chain length: 3
Certificate[1]:
Owner: CN=node-0.example.com, OU=SSL, O=Test, L=Test, C=DE
Issuer: CN=Example Com Inc. Signing CA, OU=Example Com Inc. Signing CA, O=Example Com Inc., DC=example, DC=com
```


| Name  | Description  |
|---|---|
| Alias name | The alias for this entry in the keystore |
| Entry type | Type of the entry, either `PrivateKeyEntry`, `SecretKeyEntry` or `trustedCertEntry` |
| Certificate chain length | Length of the certificate chain |
| Certificate[n] | Number of the certificate in the chain |
| Owner | DN of the owner of the certificate |
| Issue | DN of the issuer / signer of the certificate |
{: .config-table}

### Checking the configured alias

If you have multiple entries in the keystore and you are using aliases to refer to them, make sure that the configured alias in `elasticsearch.yml` matches the alias name in the keystore. 

In the example above example, you'd need to set:

```
searchguard.ssl.transport.keystore_alias: node-0
```

If there is only one entry in the keystore, you do not need to configure an alias.

### Checking the type of the certificate

The relevant certificate types for Search Guard are:

* PrivateKeyEntry
  * This type of entry holds a cryptographic PrivateKey, which is optionally stored in a protected format to prevent unauthorized access. It is also accompanied by a certificate chain for the corresponding public key.

* trustedCertEntry
  * This type of entry contains a single public key Certificate belonging to another party. It is called a trusted certificate because the keystore owner trusts that the public key in the certificate indeed belongs to the identity identified by the subject (owner) of the certificate.

(Source: [JavaDocs](https://docs.oracle.com/javase/7/docs/api/java/security/KeyStore.html))

For Client-, Admin- and Node certificates the type is `PrivateKeyEntry`. Root and intermediate certificates have type `TrustedCertificateEntry`.

### Checking the DN of the certificate

If you are unsure what the DN of your certificate looks like, check the `Owner` field of keytool output. In the example above the DN is:

```
Owner: CN=node-0.example.com, OU=SSL, O=Test, L=Test, C=DE
```

The corresponding configuration in elasticsearch.yml is:

```
searchguard.nodes_dn:
  - 'CN=node-0.example.com,OU=SSL,O=Test,L=Test,C=DE'
```


### Checking for special characters in DNs

Search Guard uses the [String Representation of Distinguished Names (RFC1779)](https://www.ietf.org/rfc/rfc1779.txt) when validating node certificates. 

If parts of your DN contain special characters, for example a comma, make sure it is escaped properly in your configuration, for example:

```
searchguard.nodes_dn:
  - 'CN=node-0.example.com,OU=SSL,O=My\, Test,L=Test,C=DE'
```

Omit whitespaces between the individual parts of the DN. Instead of:

```
searchguard.nodes_dn:
  - 'CN=node-0.example.com, OU=SSL,O=My\, Test, L=Test, C=DE'
```

use:

```
searchguard.nodes_dn:
  - 'CN=node-0.example.com,OU=SSL,O=My\, Test,L=Test,C=DE'
```

### Checking the IP Addresses of the certificate

Sometimes the IP address contained in your certificate is not the one communicating with the cluster.
This can happen if your node has multiple interfaces, or is running dual stack (IPv6 + IPv4).

When this happens, you would see the following in the node's elasticsearch log:

```
SSL Problem Received fatal alert: certificate_unknown javax.net.ssl.SSLException: Received fatal alert: certificate_unknown
```

And the following message in your cluster's master log when the new node tries to join the cluster:

```
Caused by: java.security.cert.CertificateException: No subject alternative names matching IP address 10.0.0.42 found
```

Check the IP address in the certificate:

```
IPAddress: 2001:db8:0:1:1.2.3.4
```

In this example, the node tries to join the cluster with the IPv4 `10.0.0.42`, but it's the IPv6 address `2001:db8:0:1:1.2.3.4` that is contained in the certificate.

### Validating the certificate chain

TLS certificates are organized in a certificate chain:

> A certificate chain is an ordered list of certificates, containing an SSL Certificate and Certificate Authority (CA) Certificates, that enable the receiver to verify that the sender and all CA's are trustworthy. The chain or path begins with the SSL certificate, and each certificate in the chain is signed by the entity identified by the next certificate in the chain.

(from: [Thawte](https://search.thawte.com/support/ssl-digital-certificates/index?page=content&actp=CROSSLINK&id=SO16297))

You can check with keytool that the certificate chain is correct by inspecting the owner and the issuer of each certificate. If you used the demo installation script that ships with Search Guard, the chain looks like:

Node certificate:

```
Owner: CN=node-0.example.com, OU=SSL, O=Test, L=Test, C=DE
Issuer: CN=Example Com Inc. Signing CA, OU=Example Com Inc. Signing CA, O=Example Com Inc., DC=example, DC=com
```

Intermediate / Signing certificate

```
Owner: CN=Example Com Inc. Signing CA, OU=Example Com Inc. Signing CA, O=Example Com Inc., DC=example, DC=com
Issuer: CN=Example Com Inc. Root CA, OU=Example Com Inc. Root CA, O=Example Com Inc., DC=example, DC=com
```

Root certificate:

```
Owner: CN=Example Com Inc. Root CA, OU=Example Com Inc. Root CA, O=Example Com Inc., DC=example, DC=com
Issuer: CN=Example Com Inc. Root CA, OU=Example Com Inc. Root CA, O=Example Com Inc., DC=example, DC=com
```

From the entries you can see that the node certificate was signed by the intermediate certificate. The intermediate certificate was signed by the root certificate. The root certificate was signed by itself, hence the name root or self signed certificate. If you're using separate key- and truststore files, your root CA can most likely be found in the truststore.

As a rule of thumb:

* The keystore contains the client or node certificate with its private key, and all intermediate certificates
* The truststore contains the root certificate

## Checking the SAN hostnames and IP addresses

The valid hostnames and IP addresses of a TLS certificates are stored as `SAN` entries. Check that the hostname and IP entries in the `SAN` section are correct, especially when you use hostname verification:

```
Certificate[1]:
Owner: CN=node-0.example.com, OU=SSL, O=Test, L=Test, C=DE
...
Extensions:
...
#5: ObjectId: 2.5.29.17 Criticality=false
SubjectAlternativeName [
  DNSName: node-0.example.com
  DNSName: localhost
  IPAddress: 127.0.0.1
  ...
]
```
## Node certificates: Checking the OID

If you are using OIDs to denote valid node certificates, check that the `SAN` extension for your node certificate contains the correct `OIDName`:

```
Certificate[1]:
Owner: CN=node-0.example.com, OU=SSL, O=Test, L=Test, C=DE
...
Extensions:
...
#5: ObjectId: 2.5.29.17 Criticality=false
SubjectAlternativeName [
  ...
  OIDName: 1.2.3.4.5.5
]
```

## Node certificates: Checking the EKU field

Node certificates need to have both `serverAuth` and `clientAuth` set in the extended key usage field:

```
#3: ObjectId: 2.5.29.37 Criticality=false
ExtendedKeyUsages [
  serverAuth
  clientAuth
]
```

## TLS versions

Search Guard disables `TLSv1` by default, because it is outdated, unsecure and vulnerable. If you need to use `TLSv1` and you know what you  are doing, you can re-enable it in `elasticsearch.yml` like:

```
searchguard.ssl.http.enabled_protocols:
  - "TLSv1"
  - "TLSv1.1"
  - "TLSv1.2"
```

## Supported ciphers

TLS relies on the server and client negotiating a common cipher suite. Depending on your system, the available ciphers will vary. They depend on the JDK or OpenSSL version you're using, and  whether or not the `JCE Unlimited Strength Jurisdiction Policy Files` are installed.

For legal reasons, the JDK does not include strong ciphers like AES256. In order to use strong ciphers you need to download and install the [Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html). If you don't have them installed, you will see an info message on startup like:

On startup, Search Guard will print out the available ciphers for the REST- and transport layer:

```
[INFO ][c.f.s.s.DefaultSearchGuardKeyStore] AES-256 not supported, max key length for AES is 128 bit. 
That is not an issue, it just limits possible encryption strength. 
To enable AES 256 install 'Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files'
```

Search Guard will still work and fall back to weaker cipher suites.

Search Guard will also print out all available cipher suites on startup:

```
[INFO ][c.f.s.s.DefaultSearchGuardKeyStore] sslTransportClientProvider:
JDK with ciphers [TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA256, 
TLS_DHE_DSS_WITH_AES_128_CBC_SHA256, ...]
```

## Encrypted PKCS#8 key does not work

When you experience a `File does not contain valid private key` or `data isn't an object ID` exception while using encrypted PKCS#8 keys (pem keys with a password)
you might have hit a [JDK bug](https://bugs.openjdk.java.net/browse/JDK-8076999) where "SunJCE support of password-based encryption scheme 2 params (PBES2) is not working". There is also an related [issue in the elastic GitHub repo](https://github.com/elastic/elasticsearch/issues/32021). The solution is to use the v1 encryption scheme. With openssl use the `-v1` flag in your command like `openssl pkcs8 -in key.pem -topk8 -out enckey.pem -v1 PBE-SHA1-3DES`. Please also refer to [Search Guard issue #524](https://github.com/floragunncom/search-guard/issues/524) and [OpenSSL pkcs8 documentation](https://www.openssl.org/docs/man1.0.2/man1/openssl-pkcs8.html) for more details.

## "Your keystore or PEM does not contain a key"

This error can have two reasons:

### Password not correct

If your key file is password protected, you need to specify the password in elasticsearch.yml like:

```
searchguard.ssl.transport.pemkey_password: ...
searchguard.ssl.http.pemkey_password: ...
```

Vice versa, if your key file is not password protected, be sure to omit those lines.

### Key is in PKCS#1 format

Search Guard supports private keys in PKCS#8 format. If your key is in PKCS#1 format, you will also see the "Your keystore or PEM does not contain a key" error message.

To check whether your key is in PKCS#1 format, open the key file with a text editor. The key is in PKCS#1 format if the file begins with:

```
-----BEGIN RSA PRIVATE KEY-----
```

Use OpenSSL to convert it to PKCS#8 format like:

```
openssl pkcs8 -topk8 -inform pem -in pkcs1-key.pem -outform pem -nocrypt -out pkcs8-key.pem
```

## Fixing curl

curl is not always curl when it comes to SSL/TLS. Sometimes it depends against which SSL/TLS implementation your curl version was compiled against. And there are a few including OpenSSL, GnuTLS and NSS. We made the experience that NSS and GnuTLS are very often problematic and so we assume (in our docs and scripts) your curl version is compiled against OpenSSL. You can check your curl version with

```
curl -V
```

This will print out something like:

```
curl 7.54.0 (x86_64-apple-darwin17.0) libcurl/7.54.0 OpenSSL/1.0.2g zlib/1.2.11 nghttp2/1.24.0
Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
Features: AsynchDNS IPv6 Largefile GSS-API Kerberos SPNEGO NTLM NTLM_WB SSL libz HTTP2 UnixSockets HTTPS-proxy
```

To make curl work best with Search Guard we recommend you use a curl binary with

* Version 7.50 or later
* Compiled against OpenSSL 1.0.2 or later
* Protocol needs to include `https`
* Features should include `GSS-API Kerberos SPNEGO NTLM` if you like to use Kerberos

If curl is compiled against NSS you may need to use explicitly a `./` for a relative or a `/` for an absolute paths like

```
curl --insecure --cert ./chain.pem --key ./kirk.key.pem "<API Endpoint>"
```

We already had a lot of issues, here are the most relevant ones:

* [Is it possible to configure elasticsearch/search guard to not make curl try to look for NSS certs?](https://groups.google.com/forum/#!topic/search-guard/LNSa6uf_g7Y)
* [Unable to Use REST API](https://groups.google.com/forum/#!topic/search-guard/lIDWvqebBBA)
* [enabling kerberos](https://groups.google.com/d/msg/search-guard/RiYnfg_sPgo/tFHzJu25AQAJ)

