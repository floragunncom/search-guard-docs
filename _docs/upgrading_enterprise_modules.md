---
title: Enterprise Modules
slug: upgrading-removing-enterprise-modules
category: installation
order: 500
layout: docs
description: How to handle Search Guard enterprise modules manually in case you  want to install newer versions or remove some functionality.
---
<!---
Copryight 2017 floragunn GmbH
-->
# Enterprise Modules

Search Guard ships with all enterise modules already installed. If you upgrade from one Search Guard versin to another, the latest version of all enterprise modules will be installed automatically.

## Upgrading Enterprise Modules manually

If you want to upgrade an enterprise module manually, download the respective module jar file from Maven. When downloading, **choose "jar  with dependencies"** and place it in the folder 

* `<ES installation directory>/plugins/search-guard-6`

After that, delete the older version of the module and restart your nodes for the changes to take effect.

#### Active Directory and LDAP Authentication/Authorisation:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-authbackend-ldap%22){:target="_blank"}

[https://github.com/floragunncom/search-guard-authbackend-ldap](https://github.com/floragunncom/search-guard-authbackend-ldap){:target="_blank"}

[Active Directory and LDAP documentation](ldap.md)

#### Kerberos/SPNEGO Authentication/Authorisation:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-auth-http-kerberos%22){:target="_blank"}

[https://github.com/floragunncom/search-guard-auth-http-kerberos](https://github.com/floragunncom/search-guard-auth-http-kerberos){:target="_blank"}

[Kerberos/SPNEGO documentation](kerberos.md)

#### JWT Authentication/Authorisation:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-auth-http-jwt%22){:target="_blank"}

[https://github.com/floragunncom/search-guard-authbackend-jwt](https://github.com/floragunncom/search-guard-authbackend-jwt){:target="_blank"}

[JSON Web token documentation](jwt.md)

#### Document- and field level security:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-module-dlsfls%22){:target="_blank"}

[https://github.com/floragunncom/search-guard-module-dlsfls](https://github.com/floragunncom/search-guard-module-dlsfls){:target="_blank"}

[Document and field level security documentation](dlsfls.md)

#### Audit logging:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-module-auditlog%22){:target="_blank"}

[https://github.com/floragunncom/search-guard-module-auditlog](https://github.com/floragunncom/search-guard-module-auditlog){:target="_blank"}

[Audit Logging documentation](auditlogging.md)

#### REST management API:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-rest-api%22){:target="_blank"}

[https://github.com/floragunncom/search-guard-rest-api](https://github.com/floragunncom/search-guard-rest-api){:target="_blank"}

[REST management API documentation](managementapi.md)

#### Kibana multi tenancy module:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-module-kibana-multitenancy%22){:target="_blank"}

[https://github.com/floragunncom/search-guard-module-kibana-multitenancy](https://github.com/floragunncom/search-guard-module-kibana-multitenancy){:target="_blank"}

[Kibana Multitenancy documentation](multitenancy.md)

## Removing Enterprise Modules

If you want to deploy only the features you actually plan to use, you can remove the Enterprise jar files for all other features from your Search Guard installation.

The jar files can be found in the folder

* `<ES installation directory>/plugins/search-guard-6`

The enterprise modules start with `dlic-search-guard*`, for example

```
dlic-search-guard-authbackend-ldap-6.0.0-7.jar 
```

To disable a module, remove the respective jar file from the `search-guard-6` directory and restart the node.