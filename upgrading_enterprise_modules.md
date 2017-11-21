## Upgrading enterprise modules manually

Search Guard ships with all enterise modules already installed. If you upgrade from one Search Guard versin to another, the latest version of all enterprise modules will be installed automatically.

If you want to upgrade an enterprise module manually, download the respective module jar file from Maven. When downloading, **choose "jar  with dependencies"** and place it in the folder 

* `<ES installation directory>/plugins/search-guard-6`

After that, delete the older version of the module and restart your nodes for the changes to take effect.

#### Active Directory and LDAP Authentication/Authorisation:
[All versions on maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-authbackend-ldap%22)

[https://github.com/floragunncom/search-guard-authbackend-ldap](https://github.com/floragunncom/search-guard-authbackend-ldap)

[Active Directory and LDAP documentation](ldap.md)

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
