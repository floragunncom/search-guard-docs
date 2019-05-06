---
title: Search Guard 6.x-24.1
slug: changelog-searchguard-6-x-24_1
category: changelogs-searchguard
order: 450
layout: changelogs
description: Changelog for Search Guard 6.x-24.1
---

<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard 6.x-24.1

**Release Date: 02.02.2019**

* [Upgrade Guide from 5.x to 6.x](upgrading-5-6)
* [Upgrade Guide to 6.5.x](upgrading-560)

## Security Fixes 

n/a

## Fixes 

### Search Guard

* Core: Fixed NPE for sslonly mode
  * [Issue #616](https://github.com/floragunncom/search-guard/issues/616){:target="_blank"}
  * [PR #618](https://github.com/floragunncom/search-guard/pull/618){:target="_blank"}

* Core: Remove COMPLIANCE module from modules info
  * [PR #624](https://github.com/floragunncom/search-guard/pull/624){:target="_blank"}

* Core: Atomic update of backendregistry
  * [PR #625](https://github.com/floragunncom/search-guard/pull/625){:target="_blank"}

* Core: Do not delete config cache when only single config file is uploaded
  * [PR #631](https://github.com/floragunncom/search-guard/pull/631){:target="_blank"}
  * [PR #631](https://github.com/floragunncom/search-guard/pull/631){:target="_blank"}

* Core: License trial date does not respect the locale
  * [Issue #615](https://github.com/floragunncom/search-guard/issues/615){:target="_blank"}
  * [PR #617](https://github.com/floragunncom/search-guard/pull/617){:target="_blank"}

* Core: Removed deprecated permissions
  * [PR #602](https://github.com/floragunncom/search-guard/pull/602){:target="_blank"}
  

### sgadmin

* sgadmin: sgadmin.sh does now work when invoked from a symlink
  * [Issue #604](https://github.com/floragunncom/search-guard/issues/604){:target="_blank"}
  * [PR #621](https://github.com/floragunncom/search-guard/pull/621){:target="_blank"}

### Field anonymization

* Field anonymization: Masked fields not evaluated correctly
  * [PR #31](https://github.com/floragunncom/search-guard-enterprise-modules/pull/31){:target="_blank"}

### Kerberos

* Kerberos: Support KRB5 MECH and multiple acceptors
  * [PR #27](https://github.com/floragunncom/search-guard-enterprise-modules/pull/27){:target="_blank"}

### LDAP

* LDAP: Fix rolename resolution (get attributes from LDAP entry instead of DN)
  * [PR #25](https://github.com/floragunncom/search-guard-enterprise-modules/pull/25){:target="_blank"}
* LDAP: Fix forward slash handling
  * [PR #26](https://github.com/floragunncom/search-guard-enterprise-modules/pull/26){:target="_blank"}
* LDAP: Renamed LDAPv2 implementation (beta)

### REST API
* REST API: Silent failures when creating users with SG REST API
  * [Issue #628](https://github.com/floragunncom/search-guard/issues/628){:target="_blank"}
  * [PR #630](https://github.com/floragunncom/search-guard/pull/630){:target="_blank"}
  * [PR #32](https://github.com/floragunncom/search-guard-enterprise-modules/pull/24){:target="_blank"}
* REST API: Fix ?pretty
  * [PR #24](https://github.com/floragunncom/search-guard-enterprise-modules/pull/24){:target="_blank"}

## Features

* Core: Ability to pass down to the index resolver the indices options from the original IndicesRequest
  * EXPERTS functionality (enable only if you know what you are doing)
  * Needs to be turned on with `searchguard.dynamic.respect_request_indices_options: true`
  * [PR #608](https://github.com/floragunncom/search-guard/pull/608){:target="_blank"}
  * [5a81450](https://github.com/floragunncom/search-guard/commit/5a814508fd137ec6295c0bd23d4b37a59545400e){:target="_blank"}
