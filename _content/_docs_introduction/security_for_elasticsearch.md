---
title: Overview
html_title: Security for Elasticsearch Overview
permalink: security-for-elasticsearch
layout: docs
section: security
description: Search Guard is an Enterprise Security Suite for Elasticsearch that encrypts
  and protects your data in the entire Elastic Stack, including Kibana, Logstash and
  Beats.
resources:
- https://search-guard.com/security-for-elasticsearch/|Elasticsearch security overview
  (website)
- https://search-guard.com/presentations/|Search Guard Quickstart and First Steps (presentation)
- https://search-guard.com/presentations/|Architecture and Request Flow
  (presentation)
- https://search-guard.com/presentations/|Configuration Basics (presentation)
---
<!---
Copyright 2022 floragunn GmbH
-->

# Security for Elasticsearch
{: .no_toc}

{% include toc.md %}

## Security Overview 

Search Guard is an Enterprise Security and Alerting suite for Elasticsearch. It provides TLS encryption, Role Based
Access Control (RBAC) to Elasticsearch indices, Document- and Field-level security controls and Audit Logging and Alerting capabilities.

Search Guard provides all the tools you need to encrypt, secure and monitor access to data stored in Elasticsearch, including Kibana, Logstash and Beats.

Search Guard comes in three editions:

* Free Community Edition (Apache 2 licensed, open source and free of charge)
* Enterprise Edition (requires license)
* Compliance Edition for covering regulations like PCI, GDPR, HIPAA or SOX (requires license)

The most recent versions of Search Guard are called Search Guard FLX. 

## TLS Encryption 

Search Guard encrypts all data flows in your cluster, both on REST and on Transport layer. This ensures that:

* No one can sniff any data
* No one can tamper with your data
* Only trusted nodes can join your cluster

Search Guard supports all modern cipher suites including Elliptic Curve Cryptography (ECC) and let's you choose the allowed TLS versions.

Search Guard provides hostname validation and DNS lookups to ensure the validity and integrity of your certificates. Certificates can be
 changed by hot-reloading them on a running cluster without any downtimes. Search Guard supports both CRL and OCSP for revoking compromised certificates.

## Authentication and authorization
  
Search Guard supports all major industry standards for authentication and authorization like:
  
* [LDAP and Active Directory](active-directory-ldap)
* [JSON Web token](json-web-tokens)
* [TLS client certificates](client-certificate-auth)
* [Proxy authentication](proxy-authentication)
* [Kerberos](kerberos-spnego)
* [OpenID Connect](kibana-authentication-openid)
* [SAML](kibana-authentication-saml)
  
If you do not want or need any external authentication tool you can also use the built-in user database:
   
* [Search Guard Internal user database](internal-users-database)
 
## Security Controls
 
Search Guard adds Role-Based Access Control (RBAC) to your cluster and indices. Search Guard roles define and
control what actions a user is allowed to perform on any given index. Roles can be defined and assigned to users on-the-fly 
without the need for any node or cluster restart.
 
You can use pre-defined action groups like READ, WRITE or DELETE to define access permissions. You can also mix action groups
with *single permissions* to implement very fine-grained access controls if required. For example, grant a user the right to read data
in an index, but deny the permission to create an index alias.
 
Index names are dynamic and support wildcards, regular expressions, date/math expressions and variable substitution for dynamic role definitions.
 
## Document- and Field-level access to your data

Search Guard also controls access to documents and fields in your indices. You can use Search Guard roles to define:

* To what documents in an index a user has access to
* What fields a user can access and what other fields should be removed
* What fields should be anonymized
  
This can be defined at runtime. You do not need to decide upfront at ingest time but can apply all security controls to already existing indices and data.   
  
## Audit Logging
  
Search Guard tracks and monitors all data flows inside your cluster and can produce audit trails on
several levels. This includes

* Security related events like failed login attempts, missing privileges, spoofed headers or invalid TLS certificates
* Successfully executed queries
* Read-access to documents
* Write-access to documents including the changes in JSON patch format

The Audit Logging capabilities of Search Guard especially help to keep your Elasticsearch cluster compliant with regulations like GDPR, PCI, SOX or HIPAA.

## Alerting - Anomaly detection for your data

Search Guard comes with an [Alerting module](elasticsearch-alerting-getting-started) that periodically scans the data in your cluster for anomalies and send out
notifications on various channels like Email, PagerDuty, Slack, Jira or any endpoint that provides a Webhook.

The Signals Alerting module provides a fully fledged escalation model so you can choose to send notifications on different channels based on
the severity of the incident. Search Guard will also notify you once an anomaly is not detected anymore and everything is back to normal.

