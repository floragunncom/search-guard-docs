---
title: Search Guard 6.x-21
slug: changelog-6-x-21
category: changelogs
order: 900
layout: changelogs
description: Changelog for Search Guard 6.x-21
---

<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard 6.x-21.0

Release Date: 07.02.2018

[Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)

## Fixes 

### Search Guard

* Password dependent timing side channel in AuthCredentials
  * When checking if credentials are present in cache, use  MessageDigest.isEqual() instead of Arrays.equals() 
  * [https://github.com/floragunncom/search-guard/issues/439](https://github.com/floragunncom/search-guard/issues/439) 
* DLS: Inner hits/nested results not shown 
  * When a document contained nested objects they were not present in the search results under certain conditions
  * [https://groups.google.com/forum/#!searchin/search-guard/nested/search-guard/-9JTfDbJS4U/474EfzOUBAAJ](https://groups.google.com/forum/#!searchin/search-guard/nested/search-guard/-9JTfDbJS4U/474EfzOUBAAJ)
* Multi tenancy: Do not upgrade Kibana index in ES/KI >= 6.1.0
  * Due to changes in Kibana it is not necessary anymore to upgrade the tenant indices in the multi tenancy module
  * [https://github.com/floragunncom/search-guard/issues/444](https://github.com/floragunncom/search-guard/issues/444)
* Improved error messages if wrong certificate is used
  * [https://github.com/floragunncom/search-guard/issues/429](https://github.com/floragunncom/search-guard/issues/429)
* Audit Logging: request body on Transport layer cut off
  * In some cases the request body for events on the transport layer was cut off and contained too many escape signs
* sgadmin: add ability to prompt for passwords
  * Instead of providing passwords on the command line sgadmin can now prompt for them to avoid storing them in the bash historx 
* sgadmin: warn when cluster consists of nodes with different versions
  * When running a cluster where the nodes have different versions sgadmin now issues a warning
* sgadmin: warn when admin certificate is also a node certificate (fails if fast fail is given)

### Kibana

* Input fields on the login screen were marked errourness when page loads for the first time
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/55](https://github.com/floragunncom/search-guard-kibana-plugin/issues/55)
* Config GUI not usable if base path is set
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/57](https://github.com/floragunncom/search-guard-kibana-plugin/issues/57)
* Use HTTP Basic Authentication credentials if already present in request
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/58](https://github.com/floragunncom/search-guard-kibana-plugin/issues/58)
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/45](https://github.com/floragunncom/search-guard-kibana-plugin/issues/45)

## Features

* LDAP: Make connect timeout and response timeout configurable
  * add connect\_timeout and response\_timeout which maps to com.sun.jndi.ldap.connect.timeout and com.sun.jndi.ldap.read.timeout
* Make custom attributes available for the internal user database