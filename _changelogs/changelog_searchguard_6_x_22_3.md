---
title: Search Guard 6.x-22.3
slug: changelog-searchguard-6-x-22_3
category: changelogs-searchguard
order: 700
layout: changelogs
description: Changelog for Search Guard 6.x-22.3
---

<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard 6.x-22.3

Release Date: 21.06.2018

[Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)

## Fixes 

### Search Guard

* Do not serialize inner LdapEntry in LDAPUser
  * Fixes performance problems with huge LDAP entries
* Fixed alias resolution when permitted alias is a pattern
  * [https://github.com/floragunncom/search-guard/commit/5a99fec08ba34368786753e998b19e052f5def79](https://github.com/floragunncom/search-guard/commit/5a99fec08ba34368786753e998b19e052f5def79){:target="_blank"} 
* Fixed permission issue when an alias is created together with an index but no permissions given to create an alias  
  * [https://github.com/floragunncom/search-guard/commit/090265b73c6877fbe2bf6113f0a0a1a99d885035](https://github.com/floragunncom/search-guard/commit/090265b73c6877fbe2bf6113f0a0a1a99d885035){:target="_blank"}  
* roleMapSettings.getAsList(".hosts") was incorrectly handled
  * [https://github.com/floragunncom/search-guard/issues/487](https://github.com/floragunncom/search-guard/issues/487)
* Demo installer doesn't check for "xpack.security.enabled" before adding to config
  * [https://github.com/floragunncom/search-guard/issues/499](https://github.com/floragunncom/search-guard/issues/499){:target="_blank"}
  * [https://github.com/floragunncom/search-guard/pull/504](https://github.com/floragunncom/search-guard/pull/504){:target="_blank"}
* Valid license gets replaced with Trial license with sgadmin
  * [https://github.com/floragunncom/search-guard/issues/490](https://github.com/floragunncom/search-guard/issues/490)  
* Fixed a NullPointerException when caller remote address is null

## Features

### Search Guard
* strengthen `plugin-security.policy` to allow native library to be loaded from netty-common codebase only
  * [https://github.com/floragunncom/search-guard/commit/280fba7ee947417a83087f560173d96be40f6758](https://github.com/floragunncom/search-guard/commit/280fba7ee947417a83087f560173d96be40f6758) 
* Update Guava to 25.1
* Added .kibana-6 to default configuration for a smoother upgrade from 5.x
* Replace "MONITOR" action group by "INDICES_MONITOR"
  * [https://github.com/floragunncom/search-guard/pull/479](https://github.com/floragunncom/search-guard/pull/479){:target="_blank"}
  * Contributed by [sylmarch](https://github.com/sylmarch){:target="_blank"} 
* Disable user cache automatically for JWT authentication 
  * [https://github.com/floragunncom/search-guard/pull/501](https://github.com/floragunncom/search-guard/pull/501){:target="_blank"}  
* Add verbose parameter to authinfo endpoint
* Add `searchguard.dynamic.multi_rolespan_enabled`
  * If set to true permissions on the same index that are defined in different roles are evaluated
  * Default is `false` (for backwards compatibility)

### DLS/FLS
* DLS/FLS performance improvements
  * [https://github.com/floragunncom/search-guard-module-dlsfls/pull/5](https://github.com/floragunncom/search-guard-module-dlsfls/pull/5){:target="_blank"} 
  * Contributed by [salyh](https://github.com/salyh){:target="_blank"}   

### sgadmin
* Allow disable of auto-expand and setting of replica count in single run
  * [https://github.com/floragunncom/search-guard/issues/500](https://github.com/floragunncom/search-guard/issues/500){:target="_blank"}
  * [https://github.com/floragunncom/search-guard/pull/503](https://github.com/floragunncom/search-guard/pull/503){:target="_blank"}

### Active Directory / LDAP
* Introduced LDAP custom attributes filtering and whitelisting
  * This makes it possible to select which LDAP attributes should be added to the Search Guard user
  * [https://github.com/floragunncom/search-guard-enterprise-modules/pull/3](https://github.com/floragunncom/search-guard-enterprise-modules/pull/3){:target="_blank"}   
* Support for non-DN LDAP roles as user attribute and multiple keys
  * Roles as direct user attributes had to be DNs. We now also allow non-DN role names
  * You can now define multiple attributes to fetch LDAP roles from
  * [https://github.com/floragunncom/search-guard-enterprise-modules/pull/2](https://github.com/floragunncom/search-guard-enterprise-modules/pull/2) 
* Updated ldaptive to 1.2.3 (official version)