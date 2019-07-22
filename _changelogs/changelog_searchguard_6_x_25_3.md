---
title: Search Guard 6.x-25.3
slug: changelog-searchguard-6-x-25_3
category: changelogs-searchguard
order: 200
layout: changelogs
description: Changelog for Search Guard 6.x-25.3
---

<!---
Copryight 2019 floragunn GmbH
-->

# Search Guard 6.x-25.3

**Release Date: 19.07.2019**

25.2 was skipped

* [Upgrade Guide from 5.x to 6.x](upgrading-5-6)
* [Upgrade Guide to 6.5.x](upgrading-560)

## Security Fixes 

n/a
  
## Fixes 

* [BREAKING] Fix wrong content-type in HTTP responses for REST API [#638](https://github.com/floragunncom/search-guard/issues/638){:target="_blank"} ([#52](https://github.com/floragunncom/search-guard-enterprise-modules/pull/52){:target="_blank"})

* Fixed build pipeline to circumvent wrong plugin version info [#700](https://github.com/floragunncom/search-guard/issues/700){:target="_blank"}

* Fix default permissions to allow Index Lifecycle Management (ILM) for logstash user and beats [#694](https://github.com/floragunncom/search-guard/issues/694){:target="_blank"} ([#713](https://github.com/floragunncom/search-guard/pull/713){:target="_blank"})
  * Also added new default action groups CLUSTER_MANAGE_ILM, CLUSTER_READ_ILM, INDICES_MANAGE_ILM, CLUSTER_MANAGE_INDEX_TEMPLATES and CLUSTER_MANAGE_PIPELINES
<br/><br/>
* Fixed when tenants not handled correctly when using impersonation [#714](https://github.com/floragunncom/search-guard/pull/714){:target="_blank"}

* Fix JSON unescaping bug which caused issues when JWK KID's contained forward slashes [#49](https://github.com/floragunncom/search-guard-enterprise-modules/pull/49){:target="_blank"}

* Better tolerate SAML IdP problems upon startup [#48](https://github.com/floragunncom/search-guard-enterprise-modules/pull/48){:target="_blank"}

* Dependency updates
  * Update Bouncycastle to 1.62
  * Update Jackson databind dependency to 2.9.9
  * Update Kafka client dependency to 2.0.1 (alongside with spring-kafka-test)
  * Upgrade CXF to 3.2.9
<br/><br/>
* Fix index resolution for `*,-index` like patterns [#712](https://github.com/floragunncom/search-guard/pull/712){:target="_blank"}

* Added `searchguard.filter_sgindex_from_all_requests` option in elasticsearch.yml to filter out the searchguard index from all-index requests
  * When set to `true` Search Guard will under the hood filter out the searchguard index from requests targeting `all` indices like `*` or `_all` 
  * Default is `false` to make this change to a breaking change (will be `true` by default in future releases)
<br/><br/>
* [REGRESSION] Respect also non-dn usernames when skipping users for LDAP authorization in `ldap2` backend

* Fix access control exception with `ldap2` backend 