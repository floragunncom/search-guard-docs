# TLS troubleshooting

## Setting the log level to debug

For troubleshooting any problem with Search Guard, it is recommended to set the log level to at least `debug`.

Add the following lines in `config/log4j2.properties` and restart your node:

```
logger.searchguard.name = com.floragunn
logger.searchguard.level = debug
```

This will already print out a lot if helpful information in your log file. If this information is not sufficient, you can also set the log level to `trace`.

## Validate your elasticsearch.yml

The Elasticsearch configuration is in yaml format, and so is the Search Guard configuration. Yaml relies on correct indentation levels, and it is easy to overlook an incorrectly indented entry.

A quick way of checking the validity of any yml file is to use the Yaml Lint web service:

[http://www.yamllint.com/](http://www.yamllint.com/)

Just copy and paste the content of your yaml file there and check for any errors.

*Note: You can of course use [http://www.yamllint.com/](http://www.yamllint.com/) to also validate any other Search Guard configuration file.*

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