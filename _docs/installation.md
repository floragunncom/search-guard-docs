---
title: Search Guard Installation
html_title: Installation
slug: search-guard-installation
category: installation
order: 100
layout: docs
description: Step by step instructions for setting up Search Guard on a new or existing Elastcsearch cluster. 
---
<!---
Copryight 2017 floragunn GmbH
-->

# Installation

This chapter describes the necessary steps to install and initialize Search Guard manually or by using tools like Puppet, Ansible or Chef. If you just want to try out Search Guard or set up a quick PoC, you can also follow the [Quickstart Guide.](quickstart.md). 

## Enterprise and Community Edition

Search Guard ships with all Enterprise features already installed and enabled. These features require a license if you want to run them in production. If you just want to use the free Community Edition of Search Guard, you can [disable the enterprise features manually.](license_community.md)

## General

The installation procedure is to:

1. Stop Elasticsearch
2. Install the Search Guard plugin
3. [Generate or obtain TLS certificates](tls_generate_demo_certificates.md)
3. Add at least the [TLS configuration](tls_configuration.md) to `elasticsearch.yml`
4. Restart Elasticsearch and check that the nodes come up
5. Configure authentication/authorization, users, roles and permissions by uploading the Search Guard configuration with [sgadmin](sgadmin.md)

While for an already configured Search Guard plugin you can also use the Kibana Search Guard configuration GUI, for vanilla systems you need to execute sgadmin at least once to initialize the Search Guard index.

## First time installation: Full cluster restart

A first time installation of Search Guard on a cluster always requires a full cluster restart. TLS encryption is mandatory on the transport layer of Elasticsearch, and thus all nodes must have Search Guard installed in order to be able to talk to each other.

Installing Search Guard for the first time via a rolling restart is possible in theory, but will lead to several strange effects so it is highly recommended to **perform a full cluster restart when installing Search Guard for the first time**.

## Ensure that your Java Virtual Machine is supported

* We support only OpenJDK 7/8 or Oracle JVM 7/8.
* There is **no** support for IBM VM or any other vendor than OpenJDK/Oracle JVM

## Installing Search Guard

Search Guard can be installed like any other Elasticsearch plugin by using the `elasticsearch-plugin` command. 

Change to the directory of your Elasticsearch installation and type:

```bash
bin/elasticsearch-plugin install -b com.floragunn:search-guard-6:<version>
```

For example:

```bash
bin/elasticsearch-plugin install -b com.floragunn:search-guard-6:{{site.searchguard.fullcurrentversion}}
```

**Replace the version number** in the examples above with the exact version number that matches your Elasticsearch installation. A plugin built for Elasticsearch {{site.elasticsearch.currentversion}} will not run on Elasticsearch {{site.elasticsearch.previousversion}} and vice versa.

An overview of all available Search Guard versions can be found on the [Search Guard Version Matrix](https://github.com/floragunncom/search-guard/wiki) page.

After the installation you see a folder called `search-guard-6` in the plugin directory of your Elasticsearch installation.

### Offline installation

If you are behind a firewall and need to perform an offline installation, follow these steps:

* Download the [Search Guard 6 version matching your Elasticsearch version](https://github.com/floragunncom/search-guard/wiki) from Maven Central:
  * [All versions of Search Guard 6](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22search-guard-6%22) 
  * Download the **zip file** of the Search Guard plugin
* Change to the directory of your Elasticsearch installation and type:

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-6-<version>.zip
```
### Additional permissions dialogue


You will see the following warning message when installating Search Guard. Confirm it by pressing 'y':

```bash
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@     WARNING: plugin requires additional permissions     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
* java.lang.RuntimePermission accessClassInPackage.sun.misc
* java.lang.RuntimePermission getClassLoader
* java.lang.RuntimePermission loadLibrary.*
* java.lang.reflect.ReflectPermission suppressAccessChecks
* java.security.SecurityPermission getProperty.ssl.KeyManagerFactory.algorithm
...
See http://docs.oracle.com/javase/8/docs/technotes/guides/security/permissions.html
for descriptions of what these permissions allow and the associated risks.
```

## Configuring Search Guard

Search Guard requires the following minumum pre-requisited to run:

* TLS certificates for securing transport- and (optional) REST-traffic
* TLS configuration settings in `elasticsearch.yml`
* Initialization of the Search Guard index

Search Guard ships with scripts to aid you with the initial setup, as described in the [Quickstart](quickstart.md) chapter.

Before moving your installation to production, please read the [moving Search Guard to production](configuration_production.md) chapter.

### Generating certificates

If you already have a PKI infrastructure in place, you usually obtain the required certificates by issuing certificate signing requests to your PKI.

If this is not the case, you can generate certificates by

* Using tools like OpenSSL and/or keytool
* Using our offline certificate generator tool (to be announced)
* Using our [online certificate generator service](https://floragunn.com/tls-certificate-generator/)
* Using our [example PKI scripts](https://github.com/floragunncom/search-guard-ssl/tree/master/example-pki-scripts) 
* Using our [demo installation script](quickstart.md)

The various ways to generate TLS certificates are described in the chapter [Generating demo TLS certificates](tls_generate_demo_certificates.md). For a typical installation you will want to generate

* One certificate for each node
* One admin certificate

It's possible to use the same certificate on each node, however this is less secure since you cannot use the hostname verification and DNS lookup feature of Search Guard to check the validity of the TLS certificates.

### Configuring TLS and admin certificates

The bare minimum Search Guard configuration consists of the TLS settings on transport layer and at least one admin certificate for initializing the Search Guard index. This is configured in elasticsearch.yml, all paths to certificates are relatice to the Elasticsearch `config` directory:

```yaml
searchguard.ssl.transport.pemcert_filepath: <path_to_node_certificate>
searchguard.ssl.transport.pemkey_filepath: <path_to_node_certificate_key>
searchguard.ssl.transport.pemkey_password: <key_password (optional)>
searchguard.ssl.transport.pemtrustedcas_filepath: <path_to_root_ca>
searchguard.ssl.transport.enforce_hostname_verification: <true | false>

searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test, C=de
```

The `searchguard.ssl.transport.pem*` keys define the paths to the node certificate, relative to the Elasticsearch `config` directory.

The `searchguard.authcz.admin_dn` entry configures the admin certificate that you can use with sgadmin or the REST management API. You need to state the full DN of the certificate, and you can configure more than one admin certificate.

If you want to use TLS also on the REST layer (HTTPS), add the following lines to `elasticsearch.yml`

```yaml
searchguard.ssl.http.enabled: true
searchguard.ssl.http.pemcert_filepath: <path_to_http_certificate>
searchguard.ssl.http.pemkey_filepath: <path_to_http_certificate_key>
searchguard.ssl.http.pemkey_password: <key_password (optional)>
searchguard.ssl.http.pemtrustedcas_filepath: <path_to_http_root_ca>
```

You can use the same certificates on the transport and on the REST layer. For production systems, we recommend to use individual certificates. 

### Enable the REST management API

In order to use the REST management API, configure the Search Guard roles that should have access to the API. The following entry grants full access to the API for the role `sg_all_access`:

```yaml
searchguard.restapi.roles_enabled: ["sg_all_access"]
```

If you want to further restrict access to certain API endpoints, please refer to the [REST management API documentation chapter](restapi_api_access.md).


## Initializing Search Guard

All settings regarding users, roles, permissions and authentication methods are stored in an Search Guard index on Elasticsearch. By default, this index is not populated automatically for security reason. Search Guard propagates a "Security First" mantra, so no default users or passwords are applied by default.

You intialize Search Guard by using the [sgadmin command line tool](sgadmin.md) with the admin certificate configured by the `searchguard.authcz.admin_dn` configuration key. This has to be performed at least once to tell Search Guard which [authentication and authorisation modules](configuration_auth.md) to use.

Once initialized, you can also use the Search Guard configuration GUI to edit roles and permissions.

## Search Guard Health Check

To check if Search Guard is installed, up and running, access the healthcheck endpoint like:

```
https://<hostname>:9200/_searchguard/health
```

It returns a JSON snippet like:

```
{
  message: null,
  mode: "strict",
  status: "UP"
}
```

## Testing the installation

**Using a browser**

* Open ``https://<hostname>:9200/_searchguard/authinfo``.
* Accept the self-signed demo TLS certificate.
* In the HTTP Basic Authentication dialogue, use ``admin`` as username and ``admin`` as password.
* This will print out information about the user ``admin`` in JSON format.

**Using curl**

* Execute ``curl --insecure -u admin:admin 'https://localhost:9200/_searchguard/authinfo?pretty'``
* This will print out information about the user ``admin`` in JSON format on the console.