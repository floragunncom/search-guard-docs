---
title: Search Guard 6.x-24.0
slug: changelog-searchguard-6-x-24_0
category: changelogs-searchguard
order: 450
layout: changelogs
description: Changelog for Search Guard 6.x-24.0
---

<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard 6.x-24.0

**Release Date: 20.12.2018**

* [Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)
* [Upgrade Guide to 6.5.x](../_docs/upgrading-6_5_0.md)

## Security Fixes 

### Field anonymization

* Field anonymization: Added support for string arrays
 * Until now string content within arrays where not masked/anonymized
 * [4af8dde](https://github.com/floragunncom/search-guard-enterprise-modules/commit/4af8dde7ad3a4ae3f2da38c0d2586d54b5e2973f){:target="_blank"}  

### DLS/FLS

* DLS/FLS: Fix field capabilities API and get mapping when FLS is activated
  * Until now the field caps and the mapping API has leaked field names (not values) for fields which are not allowed for the user because FLS was activated
  * [PR #17](https://github.com/floragunncom/search-guard-enterprise-modules/pull/17 ){:target="_blank"}
  

## Fixes 

### Search Guard

* Impersonation: Only one authentication domain used for impersonated user lookup
  * Only the domain which authenticated the user in the first place was considered for impersonation
  * [PR #597](https://github.com/floragunncom/search-guard/pull/597){:target="_blank"}
* Core: username_atttibute is now also supported for Transport authentication
  * [Issue #547](https://github.com/floragunncom/search-guard/issues/547){:target="_blank"} 
  * [PR #594](https://github.com/floragunncom/search-guard/pull/594){:target="_blank"}
* Core: Log more infos if authentication has finally failed
  * Include the remote address in the log message
  * [PR #595](https://github.com/floragunncom/search-guard/pull/595){:target="_blank"}

### sgadmin

* sgadmin: sgadmin does now print out stracktrace in case of an error
  * Stacktrace is now printed out to stdout instead of stderr
  * [PR #598](https://github.com/floragunncom/search-guard/pull/598){:target="_blank"}
  
### LDAP

* LDAP: Fix LDAP hostname verification
  * Hostname verfification can now be properly turned off
  * [PR #21](https://github.com/floragunncom/search-guard-enterprise-modules/pull/21){:target="_blank"}
* LDAP: Skipping users for authz not working as expected
  * LDAP authenticated users were not skipped properly
  * [PR #16](https://github.com/floragunncom/search-guard-enterprise-modules/pull/16){:target="_blank"}

### SAML
* SAML: IdP initiated SSO throws an error in Kibana (requires Kibana Plugin v17 or newer)
  * The acsEndpoint to the authtoken call used by SAML was added
  * [PR #23](https://github.com/floragunncom/search-guard-enterprise-modules/pull/23){:target="_blank"}

### REST API
* REST API should support the username attribute 
  * The username attribute supports usernames containing dots
  * [PR #20](https://github.com/floragunncom/search-guard-enterprise-modules/pull/20){:target="_blank"}

## Features

### Audit logging

* Audit logging: index does now have an additional @timestamp field
  * [Issue #609](https://github.com/floragunncom/search-guard/issues/609){:target="_blank"} 
  * [PR #22](https://github.com/floragunncom/search-guard-enterprise-modules/pull/22){:target="_blank"}
* Audit logging: Implemented retry for all auditlog sinks
  * Non-persistent retry capabilities for sinks which can occasionally fail
  * [PR #19](https://github.com/floragunncom/search-guard-enterprise-modules/pull/19){:target="_blank"}

### Field anonymization
* Field anonymization: Custom field anonymization
  * More fine grained control which parts of a field value should be anonymized
  * Alternative hashing algorithms can now be configured
  * [4af8dde](https://github.com/floragunncom/search-guard-enterprise-modules/commit/4af8dde7ad3a4ae3f2da38c0d2586d54b5e2973f){:target="_blank"} 

### DLS/FLS

* DLS/FLS: Add support for `${user.roles}` property for DLS
  * `${user.roles}` will expand to a comma delimited list of the backend roles of the current user
  * [74f292c](https://github.com/floragunncom/search-guard-enterprise-modules/commit/74f292c9c15fb8af91841d5815c80968cb0e19f9){:target="_blank"} 

### REST API

* REST API: Password rules for REST API
  * It's now possible to configure a regex to define miniumum requirements for passwords
  * [PR #14](https://github.com/floragunncom/search-guard-enterprise-modules/pull/14){:target="_blank"}
* REST API: Validate masked fields when regex or custom hashing algo used
  * [0bf3c18](https://github.com/floragunncom/search-guard-enterprise-modules/commit/0bf3c1849b2afca8f9a7950b20174b2d79f6487d){:target="_blank"} 

### LDAP

* LDAP: Connection pooling load balancing
  * New LDAP implementation which supports connection pooling and better load balancing when more than one LDAP server is configured (BETA)
  * [PR #18](https://github.com/floragunncom/search-guard-enterprise-modules/pull/18){:target="_blank"}
* LDAP: Make it possible to query more than one user- and rolebase
  * [PR #18](https://github.com/floragunncom/search-guard-enterprise-modules/pull/18){:target="_blank"}