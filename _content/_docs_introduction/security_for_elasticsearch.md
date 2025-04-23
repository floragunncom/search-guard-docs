---
title: Overview
html_title: Security for Elasticsearch Overview
permalink: security-for-elasticsearch
layout: docs
description: Search Guard is an Enterprise Security Suite for Elasticsearch that encrypts
 and protects your data in the entire Elastic Stack, including Kibana, Logstash and
 Beats.
resources:
 - https://search-guard.com/security-for-elasticsearch/|Elasticsearch security overview
  (website)
 - search-guard-presentations#quickstart|Search Guard Quickstart and First Steps (presentation)
 - search-guard-presentations#architecture-request-flow|Architecture and Request Flow
  (presentation)
 - search-guard-presentations#configuration-basics|Configuration Basics (presentation)
---
<!--- Copyright floragunn GmbH -->

# Security for Elasticsearch
{: .no_toc}

{% include toc.md %}

## Security Overview

Search Guard is a comprehensive Enterprise Security and Alerting suite for Elasticsearch. It provides robust protection for your data through multiple security layers, including:

* TLS encryption for secure data transmission
* Role-Based Access Control (RBAC) for precise management of index access
* Document and Field-level security controls for granular data protection
* Comprehensive Audit Logging for compliance and security monitoring
* Alerting capabilities for proactive threat detection

With Search Guard, you can secure, monitor, and control access to all data stored in your Elasticsearch ecosystem, including connected components like Kibana, Logstash, and Beats.

Search Guard is available in three distinct editions:

* **Community Edition** - Open source and free of charge (Apache 2 licensed)
* **Enterprise Edition** - Advanced features with additional capabilities (requires license)
* **Compliance Edition** - Enhanced security features for regulatory compliance with PCI, GDPR, HIPAA, or SOX (requires license)

The latest version of the software is branded as Search Guard FLX.

## TLS Encryption

Search Guard implements comprehensive encryption across your entire cluster, protecting both REST and Transport layer communications. This multi-layer encryption ensures:

* Complete protection against data interception
* Prevention of data tampering or modification
* Secure cluster membership limited to trusted nodes only

The system supports state-of-the-art cryptographic standards, including:

* Modern cipher suites with Elliptic Curve Cryptography (ECC)
* Configurable TLS protocol versions to match your security requirements
* Hostname validation and DNS lookups for certificate verification
* Certificate hot-reloading for zero-downtime updates
* Certificate revocation through both CRL and OCSP mechanisms for immediate security response

## Authentication and Authorization

Search Guard integrates with industry-standard authentication and authorization systems, providing flexible security options:

* **Directory Services**: [LDAP and Active Directory](../_docs_auth_auth/auth_auth_ldap.md) for enterprise user management
* **Token-Based**: [JSON Web Token (JWT)](../_docs_auth_auth/auth_auth_jwt.md) for modern application architectures
* **Certificate-Based**: [TLS client certificates](../_docs_auth_auth/auth_auth_clientcert.md) for strong cryptographic identity verification
* **Infrastructure**: [Proxy authentication](../_docs_auth_auth/auth_auth_proxy_overview.md) for gateway and reverse proxy scenarios
* **Enterprise Authentication**: [Kerberos](../_docs_auth_auth/auth_auth_kerberos.md) for integrated Windows authentication
* **Single Sign-On**: [OpenID Connect](../_docs_kibana/kibana_authentication_openid.md) and [SAML](../_docs_kibana/kibana_authentication_saml.md) for seamless authentication experiences

For environments without external authentication requirements, Search Guard provides a built-in user management system:

* [Search Guard Internal user database](../_docs_auth_auth/internalusers.md) with complete user lifecycle management

## Security Controls

Search Guard enhances Elasticsearch with powerful Role-Based Access Control (RBAC) capabilities. These controls define and limit what operations users can perform on specific indices within your cluster. Key features include:

* Dynamic role management without service disruption or cluster restarts
* Pre-defined action groups (`READ`, `WRITE`, `DELETE`) for simplified permission management
* Fine-grained control through combination of action groups and individual permissions
* Flexible index pattern matching with support for:
 * Wildcards and regular expressions
 * Date/math expressions for time-based data
 * Variable substitution for dynamic role definitions

This approach allows for precise security definitions, such as allowing a user to read data from an index while preventing them from creating index aliases.

## Document and Field-Level Security

Beyond index-level permissions, Search Guard offers granular control over data access at the document and field levels. This allows you to:

* Restrict access to specific documents within an index based on security attributes
* Control which fields a user can view, hiding sensitive information
* Apply field-level anonymization for privacy protection while preserving data utility

A key advantage of Search Guard is its ability to apply these security controls to existing data. This means you can implement security measures on already indexed content without reingestion or restructuring.

## Audit Logging

Search Guard provides comprehensive visibility into your cluster's security posture through detailed audit logging. The system tracks and records:

* Security-related events, including:
 * Failed authentication attempts
 * Privilege violations
 * Header spoofing attempts
 * TLS certificate issues
* Query execution details for accountability
* Document access tracking for sensitive information
* Write operations with detailed JSON patch format change records

These audit capabilities are essential for maintaining compliance with regulatory frameworks like GDPR, PCI, SOX, and HIPAA by providing the necessary evidence of security controls and data access patterns.

## Alerting - Monitoring for Your Data

The integrated [Alerting module](elasticsearch-alerting-getting-started) enhances your security posture through proactive monitoring. This feature:

* Continuously scans cluster data to identify anomalies or security incidents
* Sends notifications through multiple channels:
 * Email for standard communications
 * PagerDuty for urgent operational alerts
 * Slack for team collaboration
 * JIRA for issue tracking and workflow integration
 * Custom Webhook support for integration with other systems

The Signals Alerting module includes a sophisticated escalation framework that routes notifications to different channels based on incident severity. The system also provides resolution notifications when anomalies are no longer detected, confirming a return to normal operations.