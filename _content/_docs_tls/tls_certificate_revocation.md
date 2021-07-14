---
title: Certificate revocation
slug: elasticsearch-certificate-revocation
category: tls
order: 350
layout: docs
edition: community
description: How to use certificate revocation lists to revoce TLS certificates used in your Elasticsearch cluster.
resources:
  - troubleshooting-tls|Troubleshooting TLS problems (docs)  
  - https://search-guard.com/elasticsearch-searchguard-tls-introduction/|An introduction to TLS (blog post)
  - https://search-guard.com/elasticsearch-tls-certificates/|An introduction to TLS certificates (blog post)

---
<!---
Copyright 2020 floragunn GmbH
-->
# Certificate revocation
{: .no_toc}

{% include toc.md %}


A Certificate Revocation List (CRL) is 

"a list of digital certificates that have been revoked by the issuing Certificate Authority (CA) before their scheduled expiration date and should no longer be trusted. CRLs are a type of blacklist and are used by various endpoints, including Web browsers, to verify whether a certificate is valid and trustworthy."
([https://searchsecurity.techtarget.com/definition/Certificate-Revocation-List](https://searchsecurity.techtarget.com/definition/Certificate-Revocation-List))

You can use a CRL to either permanently or temporarily revoke certificates:

**Revoked**: A certificate is permanently revoked and should no longer be trusted. This status is irreversible and used, for example, if a certificate was issued by mistake, or a private key has been compromised.

**Hold**: A certificate is temporarily revoked and should not be trusted at the moment. This status is reversible and used, for example, if a user thinks a private key has been compromised, but it turns out this is not the case.


## CRL and OCSP

There are two approaches to validating a certificate against a list of revoked certificates: Certificate Revocation Lists (CRL) and OCSP (Online Certificate Status Protocol). 

Search Guards supports both CRL and OCSP. However, OCSP has largely replaced CRL.

### Certificate Revocation Lists

Each CA is required to keep track of revoked certificates. After the CA has revoked a Certificate, it adds the serial number of the certificate to their certificate revocation list. The URL to the CRL is contained in each certificate in the CRL Distribution Points field. The problem with this approach is that the CRL tends to become very large over time.

### Online Certificate Status Protocol

Instead of downloading a potentially large CRL file periodically, one can also query the CA's *OCSP server* to validate a certificate. The certificates serial number is transmitted to the OSCP server, and validation is based on the server's response. As with CRLs, the OCSP endpoint is part of each certificate *Extensions* section.

## CRL Configuration

To enable CRL support, add the following to `elasticsearch.yml`:

```
searchguard.ssl.http.crl.validate: true
```

If CRL validation is enabled, Search Guard can use:

* A local CRL file accessible on each node
* A remote CRL file, as configured in the *Distribution Points* field of the certificate
* An OSCP server file, as configured in the *Authority Information Access* field of the certificate
  * This requires additional configuration, see below

### Configuration options

| Name | Description |
|---|---|
| searchguard.ssl.http.crl.validate | Enable CRL validation. Default: false |
| searchguard.ssl.http.crl.file_path |  Absolute path to a local CRL file. The file must be present on all nodes and is reloaded automatically if it changes. Optional, usually CRL endpoints in the certificate are preferred.|
| searchguard.ssl.http.crl.check\_only\_end\_entities | If set to true, only end entities (leaf certificates) are validated. Default: true|
{: .config-table}


## OCSP Configuration

Due to limitations in the Elasticsearch security model, enabling OCSP requires changes to the `jdk/conf/security` file in your ES installation directory on every node.

To enable OCSP, add the following line to this file:

```
ocsp.enable=true
```  

You can use the following configuration options in `elasticsearch.yml` to control whether CRL, OCSP or both are being used:

| Name | Description |
|---|---|
| searchguard.ssl.http.crl.prefer\_crlfile\_over\_ocsp | If set to true, the CRL certificate entry is preferred over the OCSP entry if the certificate contains both. Default: false |
| searchguard.ssl.http.crl.disable_crldp | Disable CRL endpoints in certificates. Default: false|
{: .config-table}