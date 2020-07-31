---
title: Search Guard 7.x-36.0.0
slug: changelog-searchguard-7.x-36_0_0
category: changelogs-searchguard
order: 850
layout: changelogs
description: Changelog for Search Guard 7.x-36.0.0
---

<!--- Copyright 2020 floragunn GmbH -->

# Changelog for Search Guard 7.x-36.0.0

**Release Date: 23.07.2019**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Security Fixes 

n/a

## Features

* Introduce search\_guard\_roles for internal users ([PR #706](https://github.com/floragunncom/search-guard/pull/706){:target="_blank"})
  * This makes it possible to assign Search Guard roles directly to internal users without the need for using the role mapping
  * [Internal users database](internal-users-database){:target="_blank"}

* Added `searchguard.filter_sgindex_from_all_requests` option in elasticsearch.yml to filter out the searchguard index from all-index requests
  * When set to `true` Search Guard will under the hood filter out the searchguard index from requests targeting `all` indices like `*` or `_all` 
  * Default is `false` to make this change to a breaking change (will be `true` by default in future releases)

* Added ChaCha20 support for TLS 1.2 ([Commit 2e99232](https://github.com/floragunncom/search-guard/commit/2e99232e5ff45d5537c37c709636956a1ec4d7a8){:target="_blank"})
  * This requires Oracle JDK >= 12 or OpenSSL 1.1.1

* Make it possible to disable built-in roles ([PR #708](https://github.com/floragunncom/search-guard/pull/708){:target="_blank"})
  * Search Guard 7 introduced new static built-in resources like roles and action groups. For backwards-compatibility with Search Guard 6, the static resources can be disabled in elasticsearch.yml by setting:
  * `searchguard.unsupported.load_static_resources: false`
  
## Fixes

* [BREAKING] Use "backend_roles" instead of "roles" for the authinfo  endpoint([PR #707](https://github.com/floragunncom/search-guard/pull/707){:target="_blank"})
  * In the JSON returned by the authinfo endpoint, "roles" have been renamed to "backend_roles" to make it clear that the listed roles are not Search Guard roles.

* Fixed build pipeline to circumvent wrong plugin version info 
  * [GitHub #700: searchguard 6.8.0-25.1 version issue](https://github.com/floragunncom/search-guard/issues/700){:target="_blank"}

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

* Added cluster:admin/xpack/monitoring* permission to SGS_LOGSTASH. This was missing and caused logstash monitoring not working in Kibana. [PR #709: Better tolerate IdP problems upon startup](https://github.com/floragunncom/search-guard/pull/709){:target="_blank"}

* Fix built-in roles to work with xp monitoring when multi cluster monitoring is supported

* Validate all config files before uploading them via sgadmin and make sure yaml parser does not tolerate duplicate keys

* Include error details in "details" field in case the submitted payload is unparseable, renamed internal method



