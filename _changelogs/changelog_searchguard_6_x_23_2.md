---
title: Search Guard 6.x-23.2
slug: changelog-searchguard-6-x-23_2
category: changelogs-searchguard
order: 500
layout: changelogs
description: Changelog for Search Guard 6.x-23.2
---

<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard 6.x-23.2

Release Date: 20.11.2018

[Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)

## Fixes 

### Search Guard

* Maven would break the build if user- and group IDs are too long
* The license endpoint would falsely report a module version mismatch if some nodes have `http.enabled`set to false
  * In consequence, this leads to the Search Guard Kibana config GUI not being displayed 
  * [https://github.com/floragunncom/search-guard/commit/47e32aafd8f4494c8ca3a6742d1c82337c1fc966](https://github.com/floragunncom/search-guard/commit/47e32aafd8f4494c8ca3a6742d1c82337c1fc966){:target="_blank"}

### Field anonymization
* Update API disabled for all indices
  * If a role had field anonymization enabled, the Elasticsearch update API was falsely disabled for all indices
  * [https://github.com/floragunncom/search-guard/pull/582](https://github.com/floragunncom/search-guard/pull/582){:target="_blank"}

### SAML

* SAML fails when IdP URL has query parameters
  * [https://github.com/floragunncom/search-guard/issues/560](https://github.com/floragunncom/search-guard/issues/560){:target="_blank"}  
  * [https://github.com/floragunncom/search-guard-enterprise-modules/pull/11](https://github.com/floragunncom/search-guard-enterprise-modules/pull/11){:target="_blank"}
  
## Features

### Search Guard

* Java 11 compatibility
  * This version of Search Guard is compatible with Java 11 

* Experimental: TLSv1.3 compatibility
  * Added TLSv1.3 via Java 11 JCE
  * Support is experimental, do not use in production yet

* SSL only mode
  * Search Guard SSL is not released as a separate plugin anymore
  * This feature introduces an "SSL only" mode to Search Guard
  * This disables all features exept REST and transport TLS, restoring the behaviour of the Search Guard SSL plugin
  * [https://github.com/floragunncom/search-guard/pull/573](https://github.com/floragunncom/search-guard/pull/573){:target="_blank"}    

* Allow snapshot and restore for the Search Guard index
  * If enabled, regular users can snapshot and restore the Search Guard index 
  * [https://github.com/floragunncom/search-guard/pull/574](https://github.com/floragunncom/search-guard/pull/574){:target="_blank"}

* Allow user injection for OEM system integrators
 * When bundling Search Guard with other products, this allows to inject a user directly via the ThreadContext
 * [https://github.com/floragunncom/search-guard/pull/567](https://github.com/floragunncom/search-guard/pull/567){:target="_blank"}

### REST API

* REST API: Partial updates via PATCH
  * Makes it possible to update only parts of a resource via JSON patch
  * [https://github.com/floragunncom/search-guard-enterprise-modules/pull/10](https://github.com/floragunncom/search-guard-enterprise-modules/pull/10){:target="_blank"}  

* REST API: Bulk updates via PATCH
  * It is now possible to insert and update more than one resource at once
  * [https://github.com/floragunncom/search-guard-enterprise-modules/pull/12](https://github.com/floragunncom/search-guard-enterprise-modules/pull/12){:target="_blank"}  

* REST API: Hide resources completely
  * Resources can now be marked as "hidden"
  * Hidden resources are not viewable or changeable
  * This makes it possible to hide system users like kibanaserver or logstash from end user
  * [https://github.com/floragunncom/search-guard-enterprise-modules/pull/9](https://github.com/floragunncom/search-guard-enterprise-modules/pull/9){:target="_blank"}  

      