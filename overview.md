<!---
Copryight 2016 floragunn GmbH
-->

# Overview

Search Guard is a security plugin for Elasticsearch. It offers authentication and authorization against backend systems like LDAP or Kerberos, and adds audit logging and document-/field-level-security to Elasticsearch.

All **basic** security features are free, while you need to obtain a **license** if you want to use our **enterprise features** in a commercial project.

The basic features include:

* Node-to-node encryption through SSL/TLS
* Secure REST layer through HTTPS (SSL/TLS)
* Flexible REST layer access control (User/Role based; on aliases, indices and types)		
* Flexible transport layer access control (User/Role based; on aliases, indices and types)		
* HTTP basic authentication		
* HTTP proxy authentication		
* HTTP SSL/CLIENT-CERT authentication	
* X-Forwarded-For (XFF) support		
* Internal authentication/authorization	
* Anonymous login/unauthenticated access
* User Impersonation
* Tribe node support		

The enterprise features include:

* HTTP SPNEGO/Kerberos authentication	
* LDAP/Active Directory authentication/authorisation
* Document level security (DLS): Retrieve only documents matching criteria
* Field level security (FLS): Filter out fields from a search response
* JSON web token support
* Audit logging
* REST management API
* Kibana multitenancy support		

Search Guard supports **OpenSSL** and works with **Kibana**, **logstash** and **beats**. The complete source code (including the code for the enterprise features) is available, so you can inspect it and perform security audits if necessary.

## Disclaimer

Search Guard is an independent implementation of a security access layer for Elasticsearch, and is completely independent from Elasticsearch own security offerings.

Elasticsearch, Kibana, Logstash, and Beats are trademarks of Elasticsearch BV, registered in the U.S. and in other countries.

floragunn GmbH is not affiliated with Elasticsearch BV.

## License model

Search Guard, including all enterprise features, can be used **free of charge for personal, non-commercial projects**.

Search Guard is also free for **academic purposes**, but you have to grant us the permission to name your institute as reference on our website. For more information, please download our [academic and scientific licensing overview PDF](https://floragunn.com/wp-content/uploads/2016/11/Academic-Licensing.pdf).

In order to use the enterprise features for commercial projects, you need to obtain a license. For more information on enterprise licensing, see the [Search Guard enterprise licensing page on our website](https://floragunn.com/searchguard/searchguard-license-support/), or download our [licensing overview PDF](https://floragunn.com/wp-content/uploads/2016/11/Search-Guard-Licensing.pdf).

In contrast to competitor products, our licenses are issued per **production cluster**, regardless of its size. In other words, whether your cluster contains only a single node, or hundreds of nodes, you just need one license with a fixed price. Scale your cluster, not your cost!

All your development, staging and QA-systems are also covered, there are no additional costs involved.