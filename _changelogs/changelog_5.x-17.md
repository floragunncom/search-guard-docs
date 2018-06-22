---
title: Search Guard 5.x-17
slug: changelog-5-x-17
category: changelogs
order: 100
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v17

Release Date: December 19, 2017

## Fixes
* Fix “Unable to Install Demo Configuration on Elasticsearch Docker Image”
  * [https://github.com/floragunncom/search-guard/issues/385](https://github.com/floragunncom/search-guard/issues/385){:target="_blank"}
* Fix demo installer when X-Pack is installed
* Fix demo installer to work with various Linux distributions and Elastic official docker containers
* Fix “Hiding class loading exceptions”
  * [https://github.com/floragunncom/search-guard/issues/391](https://github.com/floragunncom/search-guard/issues/391){:target="_blank"}
* Fix principal extractor usage 
  * [https://github.com/floragunncom/search-guard/issues/383](https://github.com/floragunncom/search-guard/issues/383){:target="_blank"}
* Fix NullPointer in sgadmin diagnose trace
* Fix Cross Cluster Search local index handling (SG-681)
* Cross Cluster Search now also works with Kerberos authentication
* Fix “Not all auth domains are evaluated for TransportRequests” (SG-951)
* If the first authentication domain on transport level failed to authenticate, the following ones were not executed sometimes
* It is no longer necessary to add the DN of the TLS certificate used for Transport clients to the internal user database
* Added `indices:data/read/scroll*` cluster permission for Kibana user roles
* Changed `?kibana` permissions from `READ` to `INDICES_ALL` for X-Pack user roles

## Enhancements
* Make scroll requests more secure
  * If the user in the original request and following requests differ, a security exception is raised
* Additional permissions for inner bulk request (BREAKING)
  * For inner bulk request, it’s no longer sufficient to grant the `indices:data/write/bulk[s]` permission on index level
  * In addition, the user needs to have `indices:data/write/index`, `indices:data/write/delete` and/or `indices:data/write/update permissions` on index level explicitely


## Features
* Allow client certificate authentication module to pick up roles from DN
  * [https://github.com/floragunncom/search-guard/pull/420](https://github.com/floragunncom/search-guard/pull/420){:target="_blank"} (by [Mikael Knutsson](https://github.com/mikn){:target="_blank"})
  * [https://github.com/floragunncom/search-guard/pull/423](https://github.com/floragunncom/search-guard/pull/423){:target="_blank"}