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
Copyright 2017 floragunn GmbH
-->

# Installation

## General

The basic installation procedure is to:

1. Stop Elasticsearch
2. Install Search Guard
3. Execute the demo configuration script
5. Restart Elasticsearch.
6. Initialise the Search Guard index by running sgadmin

## Ensure that your Java Virtual Machine is supported

* We support only OpenJDK 7/8 or Oracle JVM 7/8.
* There is **no** support for IBM VM or any other vendor than OpenJDK/Oracle JVM

## Installing Search Guard

Search Guard can be installed like any other Elasticsearch plugin by using the `elasticsearch-plugin` command. 

* Download the [Search Guard version](installation_versionmatrix.md) matching your Elasticsearch version
* Change to the directory of your Elasticsearch installation and type:

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-5-5.6.16-19.4.zip
```
## Additional permissions dialogue


Since ES 2.2, you will see the following warning message when installating Search Guard and/or Search Guard SSL. Confirm it by pressing 'y':

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@     WARNING: plugin requires additional permissions     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
* java.lang.RuntimePermission accessClassInPackage.sun.misc
* java.lang.RuntimePermission getClassLoader
* java.lang.RuntimePermission loadLibrary.*
* java.lang.reflect.ReflectPermission suppressAccessChecks
* java.security.SecurityPermission getProperty.ssl.KeyManagerFactory.algorithm
See http://docs.oracle.com/javase/8/docs/technotes/guides/security/permissions.html
for descriptions of what these permissions allow and the associated risks.
```

## Quickstart: Configuring and Initializing Search Guard

Search Guard requires the following minumum pre-requisited to run:

* TLS certificates for securing transport- and REST-traffic
* TLS configuration settings in `elasticsearch.yml`
* Initialization of the Search Guard index

Search Guard ships with scripts to aid you with the initial setup. Before moving your installation to production, please read the [moving Search Guard to production](configuration_production.md) chapter.

### Configuring Search Guard

* Stop Elasticsearch 

* ``cd`` into ``<Elasticsearch directory>/plugins/search-guard-5/tools``

* Execute ``./install_demo_configuration.sh``, ``chmod`` the script first if necessary.

This will generate the truststore and two keystore files. You can find them in the ``config`` directory of your Elasticsearch installation:

* ``truststore.jks``—the root CA and intermediate/signing CA.
* ``keystore.jks``—the node certificate. 
* ``kirk.jks``—the admin certificate required for running ``sgadmin``

The config directory should now look like:

```
elasticsearch-5.5.0
│
└─── config
    │   elasticsearch.yml
    │   log4j2.properties
    │   keystore.jks
    │   kirk.jks
    │   truststore.jks
    ├─── scripts
    │    │   ...
    │ ...
 
```

The script will also add the TLS configuration to the `config/elasticsearch.yml` file automatically.

### Initializing Search Guard

In order to upload the demo configuration with users, roles and permissions:

* Start Elasticsearch

* ``cd`` into ``<Elasticsearch directory>/plugins/search-guard-5/tools``

* Execute ``./sgadmin_demo.sh``, ``chmod`` the script if necessary first

This will execute ``sgadmin`` and populate the Search Guard configuration index with the files contained in the ``plugins/search-guard-<version>/sgconfig`` directory. If you want to play around with different configuration settings, you can change the files in the ``sgconfig`` directory directly. After that, just execute ``./sgadmin_demo.sh`` again for the changes to take effect.

### Testing the installation

**Using curl**

* Execute ``curl --insecure -u admin:admin 'https://localhost:9200/_searchguard/authinfo?pretty'``
* This will print out information about the user ``admin`` in JSON format on the console.

**Using a browser**

* Open ``https://<hostname>:9200/_searchguard/authinfo``.
* Accept the self-signed demo TLS certificate.
* In the HTTP Basic Authentication dialogue, use ``admin`` as username and ``admin`` as password.
* This will print out information about the user ``admin`` in JSON format.

 
## Installing enterprise modules

If you want to use any of the enterprise modules, simply download the respective module jar file and place it in the folder 

`<ES installation directory>/plugins/search-guard-5`

After that, restart your nodes for the changes to take effect.

#### LDAP- and Active Directory Authentication/Authorisation:
[LDAP module v5.6-13 for Elasticsearch 5.6.x](https://releases.floragunn.com/dlic-search-guard-authbackend-ldap/5.6-13/dlic-search-guard-authbackend-ldap-5.6-13-jar-with-dependencies.jar){:target="_blank"}

[LDAP and Active Directory documentation](ldap.md)

#### Kerberos/SPNEGO Authentication/Authorisation:
[Kerberos/SPNEGO module v5.0-4 for Elasticsearch 5.6.x](https://releases.floragunn.com/dlic-search-guard-auth-http-kerberos/5.0-4/dlic-search-guard-auth-http-kerberos-5.0-4-jar-with-dependencies.jar){:target="_blank"}

[Kerberos/SPNEGO documentation](kerberos.md)

#### JWT Authentication/Authorisation:
[JWT module v5.0-7 for Elasticsearch 5.6.x](https://releases.floragunn.com/dlic-search-guard-auth-http-jwt/5.0-7/dlic-search-guard-auth-http-jwt-5.0-7-jar-with-dependencies.jar){:target="_blank"}

[JSON Web token documentation](jwt.md)

#### Document- and field level security:
[Document- and field level module v5.6-11 for Elasticsearch 5.6.x](https://releases.floragunn.com/dlic-search-guard-module-dlsfls/5.6-11/dlic-search-guard-module-dlsfls-5.6-11-jar-with-dependencies.jar){:target="_blank"}

[Document and field level security documentation](dlsfls.md)

#### Audit logging:
[Audit log module v5.3-7 for Elasticsearch 5.6.x](https://releases.floragunn.com/dlic-search-guard-module-auditlog/5.3-7/dlic-search-guard-module-auditlog-5.3-7-jar-with-dependencies.jar){:target="_blank"}

[Audit Logging documentation](auditlogging.md)

#### REST management API:
[REST management module v5.3-7 for Elasticsearch 5.6.x](https://releases.floragunn.com/dlic-search-guard-rest-api/5.3-7/dlic-search-guard-rest-api-5.3-7-jar-with-dependencies.jar){:target="_blank"}

[REST management API documentation](managementapi.md)

#### Kibana multi tenancy module:
[Multi tenancy management module v5.4-5 for Elasticsearch 5.6.x](https://releases.floragunn.com/dlic-search-guard-module-kibana-multitenancy/5.4-5/dlic-search-guard-module-kibana-multitenancy-5.4-5-jar-with-dependencies.jar){:target="_blank"}

[Kibana Multitenancy documentation](kibana_multitenancy.md)

Most of these modules require additional configuration settings. Please see the respective sections of this document for further information.
