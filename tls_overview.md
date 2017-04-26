<!---
Copryight 2017 floragunn UG (haftungsbeschränkt)
-->

# Prerequisites: TLS

Search Guard relies heavily on the use of TLS, both for the REST and the transport layer of Elasticsearch. While TLS on the REST layer is optional (but recommended), TLS on the transport layer is mandatory. **TLS on transport layer** means using TLS on the Elasticsearch transport layer, which uses a special wire protocol for inter-node communication.**TLS on REST layer** means using TLS (HTTPS) for communicating with Elasticsearch via its REST API.

By using TLS: 

* You can be sure that nobody is spying on the traffic.
* You can be sure that nobody tampered with the traffic.
* Only trusted nodes can join your cluster.

Search Guard also supports OpenSSL for improved performance and modern cipher suites.

The first step after installing Search Guard is to generate the necessary TLS certificates and to configure them on each node in the `elasticsearch.yml` configuration file.

Note that each change to this file requires a node restart.

If you have your own PKI infrastructure and are already familiar with TLS certificates, you can jump directly to [Node certificates](tls_node_certificates.md).

## Supported formats

Search Guard supports certificates in the following formats:

* Keystores and truststores in JKS or PKCS12 format  
* X509 / PEM 

The **keystore** holds private keys and the associated certificates. It is used to **provide credentials** to the communication partner.  **Clarification of communication partner:** In a typical web (HTTPS) scenario, a server would send its certificate from its keystore to the client, which validates it against the Root (and possibly intermediate) certificates in its truststore. In our case, Elasticsearch nodes act as clients (send requests to other nodes) and servers (serving requests from other nodes) at the same time. When they act as clients, they need to authenticate against the server (nodes) as well. In that case, they need to send their certificate from their keystore as well. So TLS authentication is mutual in our case. That’s why we use the loose term **communication partner**.


When they act as clients, they need to authenticate against the server 

The **truststore** contains all trusted certificates, which are typically root CAs and intermediate/signing certificates. It is used to **verify credentials** from a communication partner. 

In a typical scenario, the certificate(s) contained in the keystore have been signed by the root CA or the intermediate/signing CA contained in the truststore.

## Types of certificates

Search Guard distinguishes between the following types of certificates

* Client certificates
* Admin certificates
* Node certificates

**Client certificates** are regular TLS certificates without any special requirements. They are used to identify Elasticsearch clients on the REST and transport layer. They can be used for HTTP client certificate authentication or when using a Java Transport Client to talk to an Search Guard secured cluster. All permission checks apply.

**Admin certificates** are **client certificates** that have elevated rights to perform administrative tasks. You need an admin certificate to change the Search Guard configuration via the [sgadmin](sgadmin.md) command line tool, or to use the [REST management API](managementapi.md). Admin certificates are configured in `elasticsearch.yml` by simply stating their DN(s). You can use any valid client certificate as an admin certificate.  And you can configure multiple admin certificates as well. Not all permission checks are applied for admin certificates, and the certificates especially grant the permission to modify the [Search Guard configuration index](sgindex.md).

**Node certificates** are used to identify and secure traffic between Elasticsearch nodes on the transport level (inter-node traffic). For this kind of traffic, no permission checks are applied, i.e. every request is allowed. Therefore, these certificates must meet some special requirements. If you plan to generate certificates using your own PKI infrastructure, please refer to the chapter [Node certificates](tls_node_certificates.md) for details.

## Generating certificates

If you already have a PKI infrastructure in place, you can jump right to the chapter [Node certificates](tls_node_certificates.md) to learn about the requirements for node certificates, and [TLS configuration](tls_configuration.md) to learn about the configuration options.

If you just want to try out Search Guard, and deal with the TLS details later, we provide several options:

### Search Guard Bundle

The Search Guard Bundle is an Elasticsearch package that comes pre-installed and pre-configured with the latest Search Guard version, all required TLS certificates and all enterprise modules. All features are fully functional, and you can test for as along as you like with no trial license required. Just download, unzip and run.  This is the easiest way to test all of our features. We provide bundles for the 2.x and 5.x series, you can find the latest version [here](https://github.com/floragunncom/search-guard/wiki/Search-Guard-Bundle).


### Demo certificate installation script

Since v12, Search Guard ships with a demo certificate installation script. This script can be used on any **vanilla** Elasticsearch installation. It will generate the keystore and truststore and add the necessary configuration entries to the `elasticsearch.yml` configuration file. Please note that the script only works on an unchanged `elasticsearch.yml` file. 

After installing Search Guard, you will find the script here:

```
<ES dir>/plugins/search-guard-5/tools/install_demo_configuration.sh
```

After executing the script (you might have to run `chmod` first), all artefacts and configuration entries are generated, and you should be able to start your cluster without problems.

Note that the ES nodes must be stopped before executing the script, since the changes take effect only after a node restart.

### Using the TLS generator service

We have set up a web-based service to generate all required artefacts for you. You need to provide your email address and organisation name, and can specify up to 10 hostnames. The certificates, key and truststore files are generated in the background.  Secure Guard will send you a download link once everything is ready.

Your email is necessary to send you the download link, while the organisation name will become part of the generated root CA. Please use only letters, digits, hyphens and dots for the hostname.

You can find the TLS generator service here:

[TLS certificate generator](https://floragunn.com/tls-certificate-generator/)

### Using the example PKI scripts

If you use Linux or OS X, you can use the example scripts that ship with Search Guard SSL. 

#### Prerequisites

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

#### Generating the certificates

In order to obtain and run the scripts, you need to download the Search Guard SSL source code onto your machine. You can either clone the repository, or download it as zip file. The repository is located here:

[Search Guard SSL 5.x](https://github.com/floragunncom/search-guard-ssl/tree/5.3.0)

[Search Guard SSL 2.x](https://github.com/floragunncom/search-guard-ssl/tree/es-2.4.4)

The script to execute is `./example.sh`, located in the folder `example-pki-scripts.` You might need to `chmod` the file before executing it. 

All required artifacts are now generated. If execution was successful, you'll find the generated files and folders inside the `example-pki-scripts` folder. If for any reason you need to re-execute the script, execute `./clean.sh` in the same directory first. This will remove all generated files automatically.

#### Generated artifacts

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
