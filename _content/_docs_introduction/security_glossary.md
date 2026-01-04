---
title: Security Glossary
html_title: Security Glossary
permalink: security-glossary
layout: docs
section: security
description: Technical glossary of key security terms and concepts in Search Guard
---

# Security Glossary

This glossary provides definitions of key technical terms and concepts used throughout the Search Guard Security documentation.

## A

**Action Group**
: A named collection of permissions that can be assigned to roles. Action groups simplify permission management by grouping related privileges together.

**Authentication**
: The process of verifying the identity of a user or system attempting to access Elasticsearch. Search Guard supports multiple authentication methods including LDAP, Active Directory, JWT, SAML, and others.

**Authentication Backend**
: A system that stores user credentials and validates authentication attempts. Examples include LDAP servers, Active Directory, or Search Guard's internal user database.

**Authentication Domain**
: A configuration block that defines how Search Guard should authenticate users, including the authentication type and backend configuration.

**Authorization**
: The process of determining what authenticated users are allowed to do. In Search Guard, this is controlled through roles and permissions.

**Audit Logging**
: The systematic recording of security-relevant events such as authentication attempts, authorization decisions, and data access patterns for compliance and security monitoring.

## B

**Backend Role**
: A role assigned to a user by an external authentication backend (such as LDAP or Active Directory) that can be mapped to Search Guard roles.

**Bulk Request**
: An Elasticsearch API request that performs multiple operations in a single call. Search Guard evaluates permissions for each operation individually.

## C

**Certificate**
: A digital document that establishes identity in TLS communications. Search Guard uses certificates for node authentication and optionally for client authentication.

**Certificate Authority (CA)**
: An entity that issues digital certificates. Search Guard requires all certificates to be signed by a trusted CA.

**Cluster Permission**
: A permission that applies to cluster-wide operations such as managing indices, monitoring cluster health, or updating cluster settings.

**Compliance Mode**
: An enhanced audit logging mode that captures additional information required for regulatory compliance, including read access tracking and field-level access logging.

**Configuration Index**
: The internal Search Guard index (`.searchguard`) that stores security configuration including users, roles, and permissions.

## D

**Distinguished Name (DN)**
: A unique identifier for an entry in an LDAP directory, used in certificate subject fields and LDAP authentication.

**Document-Level Security (DLS)**
: A feature that restricts which documents within an index a user can access based on query filters defined in their role.

**Dynamic Configuration**
: Security settings that can be changed at runtime without restarting Elasticsearch nodes, managed through the Search Guard configuration API or sgctl.

## E

**Elasticsearch Action**
: A specific operation performed on Elasticsearch, such as `indices:data/read/search` or `cluster:admin/settings/update`.

**Exclude Pattern**
: A pattern used in roles to explicitly deny access to certain indices, even if they match an include pattern.

## F

**Field-Level Security (FLS)**
: A feature that restricts which fields within documents a user can access, either by including specific fields or excluding sensitive ones.

**Filter**
: In DLS context, a query that determines which documents a user can access within an index.

## I

**Index Pattern**
: A pattern (supporting wildcards) that defines which indices a permission applies to, such as `logs-*` or `metrics-2024-*`.

**Index Permission**
: A permission that controls access to specific indices and the operations that can be performed on them.

**Internal User**
: A user account stored directly in Search Guard's internal user database rather than an external authentication system.

## J

**JWT (JSON Web Token)**
: A compact, URL-safe means of representing claims to be transferred between parties, commonly used for stateless authentication.

**JWK (JSON Web Key)**
: A JSON data structure that represents a cryptographic key, used in JWT signature verification.

## K

**Kibana Session**
: An authenticated session between a user and Kibana, managed by Search Guard's Kibana plugin.

**Keystore**
: A file that stores private keys and certificates, used in TLS configuration. Common formats include JKS and PKCS#12.

## L

**LDAP (Lightweight Directory Access Protocol)**
: A protocol for accessing and maintaining distributed directory information services, commonly used for centralized authentication.

**LDAP Bind**
: The process of authenticating to an LDAP server using a username and password.

## M

**Multi-Tenancy**
: The ability to segregate Kibana objects (dashboards, visualizations, etc.) by tenant, allowing different groups to have isolated Kibana workspaces.

## N

**Node Certificate**
: A certificate that identifies an Elasticsearch node and enables encrypted communication between cluster nodes.

**Node-to-Node Encryption**
: TLS encryption of traffic between Elasticsearch nodes in a cluster, also called transport layer encryption.

## O

**OpenID Connect (OIDC)**
: An identity layer on top of OAuth 2.0 that enables clients to verify user identity and obtain basic profile information.

## P

**Permission**
: A specific privilege to perform an action, such as reading from an index or creating a snapshot.

**PEM (Privacy Enhanced Mail)**
: A file format for storing and sending cryptographic keys and certificates, commonly used in TLS configuration.

**PKCS#12**
: A binary format for storing certificates and private keys, commonly with `.p12` or `.pfx` extensions.

**Principal**
: An authenticated identity (user or system) attempting to access Elasticsearch resources.

**Proxy Authentication**
: An authentication method where a trusted proxy server authenticates users and forwards the authenticated identity to Search Guard.

## R

**REST Management API**
: The HTTP API for managing Search Guard configuration, allowing creation and modification of users, roles, and other security settings.

**Role**
: A named collection of permissions that defines what actions a user or group can perform on which resources.

**Role Mapping**
: The configuration that associates users or backend roles with Search Guard roles.

**Root Certificate**
: A self-signed certificate at the top of a certificate chain that establishes trust for all certificates signed by it.

## S

**SAML (Security Assertion Markup Language)**
: An XML-based framework for exchanging authentication and authorization data between identity providers and service providers.

**sgctl**
: The command-line tool for managing Search Guard configuration, providing an alternative to the REST API.

**Signing Certificate**
: A certificate used to verify the authenticity of other certificates or signed data.

**SSL/TLS**
: Protocols for encrypting network communications. TLS (Transport Layer Security) is the modern successor to SSL (Secure Sockets Layer).

## T

**Tenant**
: An isolated workspace in Kibana that segregates dashboards, visualizations, and other saved objects.

**TLS Certificate**
: A digital certificate used to establish encrypted TLS connections.

**Transport Layer**
: The internal communication layer between Elasticsearch nodes, distinct from the HTTP/REST layer used by clients.

**Truststore**
: A file containing trusted certificates (typically root and intermediate CAs) used to verify the identity of connecting parties.

## U

**User**
: An authenticated identity with associated permissions, either stored internally in Search Guard or retrieved from an external authentication backend.

**User Attribute**
: Additional information about a user (such as email, department, or custom fields) that can be used in DLS queries or role mappings.

## W

**Wildcard**
: A pattern matching character (typically `*` or `?`) used in index patterns and other configuration to match multiple values.

## X

**X.509**
: An international standard format for public key certificates, used in TLS/SSL communications.
