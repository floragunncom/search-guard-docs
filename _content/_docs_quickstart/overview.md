---
title: Overview
html_title: Security for Elasticsearch Overview
slug: security-for-elasticsearch
category: quickstart
order: 10
layout: docs
description: Search Guard is an Enterprise Security Suite for Elasticsearch that encrypts and protects your data in the entire Elastic Stack, including Kibana, Logstash and Beats.
resources:
  - "https://search-guard.com/security-for-elasticsearch/|Elasticsearch security overview (website)"
  - "search-guard-presentations#quickstart|Search Guard Quickstart and First Steps (presentation)"
  - "search-guard-presentations#architecture-request-flow|Architecture and Request Flow (presentation)"
  - "search-guard-presentations#configuration-basics|Configuration Basics (presentation)"

---

<!---
Copyright 2020 floragunn GmbH
-->

# Security for Elasticsearch
{: .no_toc}

{% include toc.md %}

## Security Overview 

Search Guard is an Enterprise Security and Alerting suite for Elasticsearch and the entire Elastic Stack. It provides TLS encryption, Role Based
Access Control (RBAC) to Elasticsearch indices, Document- and Field-level security controls and Audit Logging and Alerting capabilities.

Search Guard provides all the tools you need to encrypt, secure and monitor access to data stored in Elasticsearch, including Kibana, Logstash and Beats.

Search Guard comes in three flavours:

* Free Community Edition
* Enterprise Edition
* Compliance Edition for covering regulations like PCI, GDPR, HIPAA or SOX

## TLS enryption for Elasticsearch

Search Guard encrypts all data flows in your Elasticsearch cluster, both on REST and on Transport layer. This ensures that:

* No one can sniff any data
* No once can tamper with your data
* Only trusted nodes can join your Elasticsearch cluster

Search Guard supports all modern cipher suites including Elliptic Curve Cryptography (ECC) and let's you choose the allowed TLS versions.

Search Guard provides hostname validation and DNS lookups to ensure the validity and integrity of your certificates. Certificates can be
 changed by hot-reloading them on a running cluster without any downtimes. Search Guard supports both CRL and OCSP for revoking compromised certificates.

## Elasticsearch authentication and authorization
  
Search Guard supports all major industry standards for authentication and authorization like:
  
* [LDAP and Active Directory](../_docs_auth_auth/auth_auth_ldap.md)
* [JSON Web token](../_docs_auth_auth/auth_auth_jwt.md)
* [TLS client certificates](../_docs_auth_auth/auth_auth_clientcert.md)
* [Proxy authentication](../_docs_auth_auth/auth_auth_proxy2.md)
* [Kerberos](../_docs_auth_auth/auth_auth_kerberos.md)
* [OpenID Connect](../_docs_auth_auth/auth_auth_openid.md)
* [SAML](../_docs_auth_auth/auth_auth_saml.md)
  
If you do not want or need any external authentication tool you can also use the built-in user database:
   
* [Search Guard Internal user database](../_docs_roles_permissions/configuration_internalusers.md)
 
## Elasticsearch security controls
 
Search Guard adds Role-Based Access Control (RBAC) to your Elasticsearch cluster and indices. Search Guard roles define and
control what actions a user is allowed to perform on any given Elasticsearch index. Roles can be defined and assigned to users on-the-fly 
without the need for any node or cluster restart.
 
You can use pre-defined action groups like READ, WRITE or DELETE to define access permissions. You can also mix action groups
with *single permissions* to implement very fine-grained access controls if required. For example, grant a user the right to read data
in an Elasticsearch index, but deny the permission to create an index alias.
 
Index names are dynamic and support wildcards, regular expressions, date/math expressions and variable substitution for dynamic role definitions.
 
## Document- and Field-level access to Elasticsearch data

Search Guard also controls access to documents and fields in your Elasticsearch indices. You can use Search Guard roles to define:

* To what documents in an index a user has access to
* What fields a user can access and what other fields should be removed
* What fields should be anonymized
  
This can be defined at runtime. You do not need to decide upfront at ingest time but can apply all security controls to already existing indices and data.   
  
## Audit Logging
  
Search Guard tracks and monitors all data flows inside your Elasticsearch cluster and can produce audit trails on
several levels. This includes

* Security related events like failed login attempts, missing privileges, spoofed headers or invalid TLS certificates
* Successfully executed queries
* Read-access to documents
* Write-access to documents including the changes in JSON patch format

The Audit Logging capabilities of Search Guard especially help to keep your Elasticsearch cluster compliant with regualations like GDPR, PCI, SOX or HIPAA.

## Alerting - Anomaly detection for your Elasticsearch data

Search Guard comes with an [Alerting module](elasticsearch-alerting-getting-started) that periodically scans the data in your Elasticsearch cluster for anomalies and send out
notifications on various channels like Email, PagerDuty, Slack, JIRA or any endpoint that provides a Webhook.

The Elasticsearch Alerting module provides a fully fledged escalation model so you can choose to send notifications on different channels based on
the severity of the incident. Search Guard will also notify you once an anomaly is not detected anymore and everything is back to normal.

