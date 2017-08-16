<!---
Copryight 2017 floragunn GmbH
-->

# Installation

## General

The basic installation procedure is to:

1. Stop Elasticsearch
2. Install Search Guard
3. Execute the demo configuration script
5. Restart Elasticsearch.
6. Initialise the Search Guard index by running sgadmin

## Ensure that you Java Virtual Machine is supported

* We support only OpenJDK 7/8 or Oracle JVM 7/8.
* There is **no** support for IBM VM or any other vendor than OpenJDK/Oracle JVM

## Installing Search Guard

Search Guard can be installed like any other Elasticsearch plugin. **Replace the version number** in the following examples with the exact version number that matches your Elasticsearch installation. A plugin built for ES 5.4.3 will not run on ES 5.5.0 and vice versa.

Change to the directory of your Elasticsearch installation and type:

```
bin/elasticsearch-plugin install -b com.floragunn:search-guard-5:<version>
```
For example:

```
bin/elasticsearch-plugin install -b com.floragunn:search-guard-5:5.5.0-14
```

Run `bin/elasticsearch-plugin` as the user that owns all of the Elasticsearch files.

In order to find the most recent Search Guard version for your Elasticsearch installation, please refer to our [version matrix](https://github.com/floragunncom/search-guard/wiki). 

After the installation you see a folder called "search-guard-5" in the plugin directory of your Elasticsearch installation.

**If you're running Elasticsearch 2.x:**

For Search Guard 2, you need to install Search Guard SSL first and after that Search Guard. Change to the directory of your Elasticsearch installation and type:

```
bin/plugin install -b com.floragunn/search-guard-ssl/2.4.5.21
bin/plugin install -b com.floragunn/search-guard-2/2.4.5.14
```

After the installation you should see a folder called "search-guard-2" in the plugin directory of your Elasticsearch installation.

### Offline installation

If you are behind a firewall and need to perform an offline installation, follow these steps:

* Download the [Search Guard 5 version matching your Elasticsearch version](https://github.com/floragunncom/search-guard/wiki) from Maven Central:
  * [All versions of Search Guard 5](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22search-guard-5%22) 
  * Download the **zip file** of the Search Guard plugin
* Change to the directory of your Elasticsearch installation and type:

```
bin/elasticsearch-plugin install -b file:///path/to/search-guard-5-<version>.zip
```
**If you're running Elasticsearch 2.x:**

* Download the Search Guard SSL and Search Guard plugins [version matching your Elasticsearch version](https://github.com/floragunncom/search-guard/wiki) from Maven Central:
  * [All versions of Search Guard 2 SSL](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22search-guard-ssl%22) 
  * [All versions of Search Guard 2](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22search-guard-2%22) 

  * Download the **zip files** of Search Guard plugins
* Change to the directory of your Elasticsearch installation and type:

```
bin/plugin install -b file:///location/of/search-guard-ssl-<version>.zip
bin/plugin install -b file:///location/of/search-guard-2-<version>.zip
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

If you want to use any of the enterprise modules, simply download the respective module jar file from Maven. Whend downloading, **choose "jar  with dependencies"** and place it in the folder 

* `<ES installation directory>/plugins/search-guard-5`

or

* `<ES installation directory>/plugins/search-guard-2`


After that, restart your nodes for the changes to take effect.

#### LDAP- and Active Directory Authentication/Authorisation:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-authbackend-ldap%22)

[https://github.com/floragunncom/search-guard-authbackend-ldap](https://github.com/floragunncom/search-guard-authbackend-ldap)

[LDAP and Active Directory documentation](ldap.md)

#### Kerberos/SPNEGO Authentication/Authorisation:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-auth-http-kerberos%22)

[https://github.com/floragunncom/search-guard-auth-http-kerberos](https://github.com/floragunncom/search-guard-auth-http-kerberos)

[Kerberos/SPNEGO documentation](kerberos.md)

#### JWT Authentication/Authorisation:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-auth-http-jwt%22)

[https://github.com/floragunncom/search-guard-authbackend-jwt](https://github.com/floragunncom/search-guard-authbackend-jwt)

[JSON Web token documentation](jwt.md)

#### Document- and field level security:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-module-dlsfls%22)

[https://github.com/floragunncom/search-guard-module-dlsfls](https://github.com/floragunncom/search-guard-module-dlsfls)

[Document and field level security documentation](dlsfls.md)

#### Audit logging:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-module-auditlog%22)

[https://github.com/floragunncom/search-guard-module-auditlog](https://github.com/floragunncom/search-guard-module-auditlog)

[Audit Logging documentation](auditlogging.md)

#### REST management API:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-rest-api%22)

[https://github.com/floragunncom/search-guard-rest-api](https://github.com/floragunncom/search-guard-rest-api)

[REST management API documentation](managementapi.md)

#### Kibana multi tenancy module:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-module-kibana-multitenancy%22)

[https://github.com/floragunncom/search-guard-module-kibana-multitenancy](https://github.com/floragunncom/search-guard-module-kibana-multitenancy)

[Kibana Multitenancy documentation](multitenancy.md)

Most of these modules require additional configuration settings. Please see the respective sections of this document for further information.
