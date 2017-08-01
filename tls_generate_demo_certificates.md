<!---
Copryight 2017 floragunn UG (haftungsbeschränkt)
-->

# Generating TLS demo certificates

Search Guard relies heavily on the use of TLS, both for the REST and the transport layer of Elasticsearch. While TLS on the REST layer is optional (but recommended), TLS on the transport layer is mandatory.

By using TLS:

* You can be sure that nobody is spying on the traffic.
* You can be sure that nobody tampered with the traffic.
* Only trusted nodes can join your cluster.

Search Guard also supports OpenSSL for improved performance and modern cipher suites.

The first step after installing Search Guard is to generate the necessary TLS certificates and to configure them on each node in the `elasticsearch.yml` configuration file.

Note that each change to this file requires a node restart.

If you have your own PKI infrastructure and are already familiar with TLS certificates, you can jump directly to [TLS certificates for production environments](tls_certificates_production.md).

If you just want to try out Search Guard, and deal with the TLS details later, we provide several options:

## Using the Search Guard demo installer

Search Guard ships with a demo installation script. The installation script will generate all required TLS certificates for running Search Guard.

To generate the certificates:

* ``cd`` into ``<Elasticsearch directory>/plugins/search-guard-5/tools``

* Execute ``./install_demo_configuration.sh``, ``chmod`` the script first if necessary.

This will generate the truststore and two keystore files. You can find them in the ``config`` directory of your Elasticsearch installation:

* ``truststore.jks``—the root CA and intermediate/signing CA.
* ``keystore.jks``—the node certificate. 
* ``kirk.jks``—the admin certificate required for running ``sgadmin``

The script will also add the TLS configuration to the `config/elasticsearch.yml` file automatically.

The node certificates are generated with the following SAN entries:

```
DNS Name: node-0.example.com
DNS Name: localhost 
IP Address: 127.0.0.1
```

Both key- and truststore have the password `changeit`.

## Using the TLS certificate generator service

If you want to use your own hostnames instead of `node-0.example.com`, you can use our TLS certificate generator web service: 

You need to provide your email address and organisation name, and can specify up to 10 hostnames. The certificates, key and truststore files are generated in the background. We will send you a download link once the certificates have been generated.

Your email is necessary to send you the download link, while the organisation name will become part of the generated root CA. Please use only letters, digits, hyphens and dots for the hostname.

The download will contain the node certificates, admin- and client certificates and the Root CA in JKS, P12 and PEM format. Please refer to the included `README.txt` for a detailed description of the generated artefacts and their respectice passwords. 

You can find the TLS generator service here:

[TLS certificate generator](https://floragunn.com/tls-certificate-generator/)


## Using the example PKI scripts

If you want to generate the certificates on your own machine, you can use the Search Guard example PKI scripts as a starting point. The scripts are shipped with Search Guard SSL and run on Linux or OS X.

You can use the scripts as-is, or you can edit the configuration files to tailor the certificates to your own needs. 

### Prerequisites

The scripts use OpenSSL and the Java `keytool` for generating all required artifacts.

In order to find out if you have OpenSSL installed, open a terminal and type

```
openssl version
```

Make sure it's version 1.0.1k or higher.

The `keytool` ships with the JDK itself and thus should be already available on your machine. Check it by calling

```
keytool
```
 
Which should print a list of available `keytool` commands. If this is not the case, check your JDK installation and make sure the `keytool` is on your `PATH`.

### Generating the certificates

First download the Search Guard SSL source code onto your machine. You can either clone the repository, or download it as zip file. The repository is located here:

[Search Guard SSL 5.x](https://github.com/floragunncom/search-guard-ssl/tree/5.5.0)

The script to execute is `./example.sh`, located in the folder `example-pki-scripts.` You might need to `chmod` the file before executing it. 

All required artifacts are now generated. If execution was successful, you'll find the generated files and folders inside the `example-pki-scripts` folder. If for any reason you need to re-execute the script, execute `./clean.sh` in the same directory first. This will remove all generated files automatically.

### Generated artifacts

The main artifacts are:

```
truststore.jks
```
The truststore containing the root CA and a signing CA used to sign all other certificates.

```
node-0-keystore.jks, node-0-keystore.jks, node-2-keystore.jks
```
Keystores containing node certificates. These certificates can be used on all Elasticsearch nodes.

```
kirk-keystore.jks
```
Keystore containing a client certificate. In the sample configuration files, this certificate is configured to be an admin certificate.

```
spock-keystore.jks
```
Keystore containing a regular, non-admin client certificate.

**The password for all generated stores is `changeit`.**

### Customizing the certificates

If you need to customize the certificates generated by the example PKI scripts, the following files are relevant:

```
example-pki-scripts/etc/root-ca.conf
example-pki-scripts/etc/signing-ca.conf
```

The example certificates are generated using a certificate chain. It consists of the Root CA, a signing CA and the actual certififcate. The two files stated above define the configuration of the Root CA and signing CA, especially the `Distinguished Name(DN)`. You can change the DN in the following section:

```
[ ca_dn ]
0.domainComponent       = "com"
1.domainComponent       = "example"
organizationName        = "Example Com Inc."
organizationalUnitName  = "Example Com Inc. Root CA"
commonName              = "Example Com Inc. Root CA"
```

In order to customize the DN of the generated node-, admin-, and client-certificates, modify the following files:

```
gen_node_cert.sh
  Generates a node certificate

gen_client_node_cert.sh
  Generates a client certificate. 
  Certificates generated by this script can also be used as admin certificate  
```

You can change the DN, the hostname and the IP of the generated certificate by modifying the following sections in the respective files:

```
-dname "CN=$NODE_NAME.example.com, OU=SSL, O=Test, L=Test, C=DE" \
-ext san=dns:$NODE_NAME.example.com,dns:localhost,ip:127.0.0.1,oid:1.2.3.4.5.5
```

*Note: For `gen_node_cert.sh`, make sure you keep the oid:1.2.3.4.5.5
 part! This OID value is used to identify node certificates in your cluster.*