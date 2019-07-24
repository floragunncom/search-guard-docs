---
title: Search Guard 7.x-36.0.0
slug: changelog-searchguard-7.x-36_0_0
category: changelogs-searchguard
order: 850
layout: changelogs
description: Changelog for Search Guard 7.x-36.0.0
---

<!--- Copyright 2019 floragunn GmbH -->

# Search Guard 7.x-36.0.0

**Release Date: 23.07.2019**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Security Fixes 

n/a

## Features

* Introduce search\_guard\_roles for internal users
  * This makes it possible to assign Search Guard roles directly to internal users without the need for using the role mapping
  * [Intern users database](internal-users-database){:target="_blank"}

* Added `searchguard.filter_sgindex_from_all_requests` option in elasticsearch.yml to filter out the searchguard index from all-index requests
  * When set to `true` Search Guard will under the hood filter out the searchguard index from requests targeting `all` indices like `*` or `_all` 
  * Default is `false` to make this change to a breaking change (will be `true` by default in future releases)

* Added ChaCha20 support for TLS 1.2
  * This requires Oracle JDK >= 12 or OpenSSL 1.1.1

* Make it possible to disable built-in roles
  * Search Guard 7 introduced new static built-in resources like roles and action groups. For backwards-compatibility with Search Guard 6, the static resources can be disabled in elasticsearch.yml by setting:
  * `searchguard.unsupported.load_static_resources: false`

* Make `GLOBAL` a static built-in tenant
  * In order to unify the Kibana GLOBAL tenant with the named tenants, we have introduced a static built-in `SGS_GLOBAL_TENANT`. 
  
## Fixes 

* [BREAKING] Fix wrong content-type in HTTP responses for REST API 
  * [GitHub #638: Wrong content-type in HTTP responses](https://github.com/floragunncom/search-guard/issues/638){:target="_blank"} 
  * [PR #52: Backport of "Always return a JSON response for REST Api with correct conent-type header"](https://github.com/floragunncom/search-guard-enterprise-modules/pull/52){:target="_blank"}

* [BREAKING] Use "backend_roles" instead of "roles" for the authinfo  endpoint
  * In the JSON returned by the authinfo endpoint, "roles" have been renamed to "backend_roles" to make it clear that the listed roles are not Search Guard roles.  

* [BREAKING] Renamed the `sgconfig` REST API endpoint to `sg_config`
  * This is to streamline the Search Guard naming conventions
  * The `sgconfig` still works, but is deprecated and will be removed in Search Guard 8

* Fixed build pipeline to circumvent wrong plugin version info 
  * [GitHub #700: searchguard 6.8.0-25.1 version issue ](https://github.com/floragunncom/search-guard/issues/700){:target="_blank"}

* Fix default permissions to allow Index Lifecycle Management (ILM) for logstash user and beats 
  * [GitHub #694: Beats With ILM Enabled Failed To check For Alias: 403](https://github.com/floragunncom/search-guard/issues/694){:target="_blank"} 
  * ([PR #713: Cleanup and redefine logstash and ILM roles and action groups](https://github.com/floragunncom/search-guard/pull/713){:target="_blank"})
  * Also added [new default action groups](action-groups){:target="_blank"} 
     * SGS_CLUSTER\_MANAGE\_ILM
     * SGS_CLUSTER\_READ\_ILM
     * SGS_INDICES\_MANAGE\_ILM
     * SGS_CLUSTER\_MANAGE\_INDEX\_TEMPLATES
     * SGS_CLUSTER\_MANAGE\_PIPELINES

* Fixed when tenants not handled correctly when using impersonation 
  * [PR #714: Fixed when tenants not handled correctly when using impersonation](https://github.com/floragunncom/search-guard/pull/714){:target="_blank"}

* Fix JSON unescaping bug which caused issues when JWK KID's contained forward slashes 
  * [PR #49: Upgrade CXF due to JSON unescaping bug](https://github.com/floragunncom/search-guard-enterprise-modules/pull/49){:target="_blank"}

* Better tolerate SAML IdP problems upon startup 
*   [PR #48: Better tolerate IdP problems upon startup](https://github.com/floragunncom/search-guard-enterprise-modules/pull/48){:target="_blank"}

* Dependency updates
  * Update Bouncycastle to 1.62
  * Update Jackson databind dependency to 2.9.9
  * Update Kafka client dependency to 2.0.1 (alongside with spring-kafka-test)
  * Upgrade CXF to 3.2.9
<br/><br/>

* Fix index resolution for `*,-index` like patterns 
  * [PR #712: Fix index resolution for "*,-index" patterns](https://github.com/floragunncom/search-guard/pull/712){:target="_blank"}

* [REGRESSION] Respect also non-dn usernames when skipping users for LDAP authorization in `ldap2` backend

* Fix access control exception with `ldap2` backend 



