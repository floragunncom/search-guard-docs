---
title: Search Guard 6.x-24.2
slug: changelog-searchguard-6-x-24_2
category: changelogs-searchguard
order: 450
layout: changelogs
description: Changelog for Search Guard 6.x-24.2
---

<!---
Copryight 2017-2019 floragunn GmbH
-->

# Search Guard 6.x-24.2

**Release Date: 19.03.2019**

* [Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)
* [Upgrade Guide to 6.5.x](../_docs/upgrading-6_5_0.md)

## Security Fixes 

n/a

## Fixes 

### Search Guard

* Core: "Fixed Authz cache does not work when authc is noop backend"
  * [PR #647](https://github.com/floragunncom/search-guard/pull/647){:target="_blank"}

* Core: Fix "ElasticSearch process extreme load when SG has lots of roles or role mappings"
  * [Issue #635](https://github.com/floragunncom/search-guard/issues/635){:target="_blank"}
  * [PR #654](https://github.com/floragunncom/search-guard/pull/654){:target="_blank"}
  * [PR #646](https://github.com/floragunncom/search-guard/pull/646){:target="_blank"}
  * [PR #34](https://github.com/floragunncom/search-guard-enterprise-modules/pull/34){:target="_blank"}

### SSL

* SSL: "TLSv1 not possible as TLS protocol for OpenSSL"
  * [Issue #650](https://github.com/floragunncom/search-guard/issues/650){:target="_blank"}
  * [PR #99](https://github.com/floragunncom/search-guard/pull/99){:target="_blank"}

* SSL: "Key password of a key stored in a keystore can now be set separately"
  * [PR #98](https://github.com/floragunncom/search-guard-ssl/pull/98){:target="_blank"}

### Auditlog

* Auditlog: "make sure when auditlog is turned off that impl methods are not called (perf wise)"
  * [PR #36](https://github.com/floragunncom/search-guard-enterprise-modules/pull/36){:target="_blank"}

### DLS/FLS

* DLS/FLS: "Attach DLS/FLS/MF headers only when enterprise modules are enabled"
  * [PR #652](https://github.com/floragunncom/search-guard/pull/652){:target="_blank"}

* DLS/FLS: "LeafReader.hasDeletions() should only return statically true when DLS is enabled"
  * [PR #38](https://github.com/floragunncom/search-guard-enterprise-modules/pull/38){:target="_blank"}

### sgadmin

* sgadmin: "sgadmin - no output on early ClassNotFoundException"
  * [Issue #639](https://github.com/floragunncom/search-guard/issues/639){:target="_blank"}
  * [PR #648](https://github.com/floragunncom/search-guard/pull/648){:target="_blank"}


### REST API

* REST API: "REST API doesn't accept prettified JSON containing tabs"
  * [Issue #634](https://github.com/floragunncom/search-guard/issues/634){:target="_blank"}
  * [PR #33](https://github.com/floragunncom/search-guard-enterprise-modules/pull/33){:target="_blank"}
