<!---
Copryight 2016 floragunn UG (haftungsbeschränkt)
-->

# Installation

Since Search Guard build on Search Guard SSL, you need to install both plugins. The order in which you install them is not relevant. Due to how the Elasticsearch plugin mechanism works, you have to install the Search Guard version matching your Elasticsearch Version. For example, a plugin built for ES 2.3.3 will not run on ES 2.3.4 and vice versa.

## Versioning

In order to find the correct Search Guard and Search Guard SSL version for your Elasticsearch installation, please refer to our [version matrix](https://github.com/floragunncom/search-guard/wiki) in the github repository. This matrix will be kept up-to-date with each release.

## Installing the plugins
Search Guard itself can be installed like any other Elasticsearch plugin. 

Change to the directory of your Elasticsearch installation and type:

```
bin/plugin install -b com.floragunn/search-guard-ssl/2.3.4.16
bin/plugin install -b com.floragunn/search-guard-2/2.4.0.6
```
Of course, replace the version number with the version suitable for your Elasticsearch installation.

After that you should see a folder called "search-guard-2" in the plugin directory of your Elasticsearch installation.

Make sure to install the plugins with the same user you run Elasticsearch. For example, if you installed Elasticsearch using the official debian packages, it is executed with user `elasticsearch`. 

## Configure the admin certificate

Nearly all configuration settings for Search Guard are kept in Elasticsearch itself and can be changed at runtime by using the ```sgadmin``` command line tool. The only static configuration is the definition of the admin TLS certificate(s). This certificate is required by [```sgadmin```](sgadmin.md). sgadmin is a command line tool to change the Search Guard configuration at runtime. To use a TLS certificate as admin certificate with sgadmin, you must configure the DN of it in elasticsearch.yml:

```
searchguard.authcz.admin_dn:
  - cn=admin,ou=Test,ou=ou,dc=company,dc=com
```

You can configure one or more of those admin certificates.

## Installing enterprise modules

If you want to use any of the enterprise modules, download the respective jar file and place it in the folder `<ES installation directory>/plugins/search-guard-2`.

Each module lives in its own github repository. You can either download the repository and build the jar files yourself via a simple ```mvn install``` command. Or you can choose to download the jar file(s) directly from Maven.

#### LDAP- and Active Directory Authentication/Authorisation:
[https://github.com/floragunncom/search-guard-authbackend-ldap](https://github.com/floragunncom/search-guard-authbackend-ldap) 
[https://mvnrepository.com/artifact/com.floragunn/dlic-search-guard-authbackend-ldap](https://mvnrepository.com/artifact/com.floragunn/dlic-search-guard-authbackend-ldap) 


#### Kerberos Authentication/Authorisation:
 [https://github.com/floragunncom/search-guard-auth-http-kerberos](https://github.com/floragunncom/search-guard-auth-http-kerberos) 
 [https://mvnrepository.com/artifact/com.floragunn/dlic-search-guard-auth-http-kerberos](https://mvnrepository.com/artifact/com.floragunn/dlic-search-guard-auth-http-kerberos) 
 
#### JWT Authentication/Authorisation:
 [https://github.com/floragunncom/search-guard-authbackend-jwt](https://github.com/floragunncom/search-guard-authbackend-jwt)
 [https://mvnrepository.com/artifact/com.floragunn/dlic-search-guard-auth-http-jwt](https://mvnrepository.com/artifact/com.floragunn/dlic-search-guard-auth-http-jwt)
 
#### Document- and field level security:
[https://github.com/floragunncom/search-guard-module-dlsfls](https://github.com/floragunncom/search-guard-module-dlsfls) 
[https://mvnrepository.com/artifact/com.floragunn/dlic-search-guard-module-dlsfls](https://mvnrepository.com/artifact/com.floragunn/dlic-search-guard-module-dlsfls) 

#### Audit logging:
 [https://github.com/floragunncom/search-guard-module-auditlog](https://github.com/floragunncom/search-guard-module-auditlog) 
[https://mvnrepository.com/artifact/com.floragunn/dlic-search-guard-module-auditlog](https://mvnrepository.com/artifact/com.floragunn/dlic-search-guard-module-auditlog) 

Most of these modules require additional configuration settings. Please see the respective sections of this document for further information.


## Known Issues

### License plugin and audit logging

At the moment, the [audit log module breaks](https://github.com/floragunncom/search-guard-module-auditlog/issues/4) if you have the Elasticsearch license plugin installed. 

### Compatibility with other plugins

If you have other plugins like kopf installed, please check the compatibility with Search Guard. 

As a rule of thumb, if a plugin is compatible with Shield, it is also compatible with Search Guard. In detail:

If the plugin talks to Elasticsearch on the REST layer, and you have REST TLS enabled, the plugin must also support TLS. 

If the plugin talks to Elasticsearch on the transport layer, you need to be able to add the Search Guard SSL plugin and its configuration settings to the transport client. You can read more about using transport clients with a Search Guard secured cluster [in this blog post](https://floragunn.com/searchguard-elasicsearch-transport-clients/).

Incompatible plugins and products include:

* [Graylog](https://www.graylog.org/)
* [JDBC Importer](https://github.com/jprante/elasticsearch-jdbc)

We will work on making them compatible, however, this depends on the authors of these products accepting our pull requests.