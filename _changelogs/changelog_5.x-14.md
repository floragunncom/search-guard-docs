---
title: Search Guard 5.x-14
slug: changelog-5-x-14
category: changelogs
order: 120
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v14

Release Date:  July 02, 2017

Note that with SG v14 our EOL policy takes effect. 

## Features
* Support for certificate revocation lists (CRL) (5.x only)
* BETA Support for Cross Cluster Search (>= 5.3.0)
* Backport to 2.4.5: [Snapshot/Restore for regular users](http://floragunncom.github.io/search-guard-docs/snapshots.html) (2.4.5 only)
* Accept red cluster flag in sgadmin (>= 2.4.5)
  * [sgadmin documentation](http://floragunncom.github.io/search-guard-docs/sgadmin.html)
* X-Pack Monitoring and Alerting support (>= 5.3.0)
  * [X-Pack Monitoring](../_docs/x_pack_monitoring.md)
* Support for PEM certificates in sgadmin (>= 2.4.5)
  * [https://github.com/floragunncom/search-guard/issues/346](https://github.com/floragunncom/search-guard/issues/346)
* noopenssl switch for sgadmin (>=2.4.5)
  * [sgadmin documentation](http://floragunncom.github.io/search-guard-docs/sgadmin.html)
* Improve sanity checks in sgadmin (>= 2.4.5)
  * [https://github.com/floragunncom/search-guard/issues/344](https://github.com/floragunncom/search-guard/issues/344)
* License notice output added (>= 2.4.5)

## Fixes 
* NPE when using POST for authinfo endpoint #335 (>= 2.4.5)
  * [https://github.com/floragunncom/search-guard/issues/335](https://github.com/floragunncom/search-guard/issues/335)
* Cache not flushed when updating single configuration files #334 (>= 2.4.5)
  * [https://github.com/floragunncom/search-guard/issues/334](https://github.com/floragunncom/search-guard/issues/334)
* Issue with deleting index with wildcards #332 (>= 2.4.5)
  * [https://github.com/floragunncom/search-guard/issues/332](https://github.com/floragunncom/search-guard/issues/332)
* Non final login failures are logged on ERROR level #329 (>= 2.4.5)
  * [https://github.com/floragunncom/search-guard/issues/329](https://github.com/floragunncom/search-guard/issues/329)
* Netty stacktrace displayed when accessing via HTTP instead of HTTPS
  * Issue was only present in SG >= 5.4.0
  * [https://github.com/floragunncom/search-guard-ssl/issues/65](https://github.com/floragunncom/search-guard-ssl/issues/65)