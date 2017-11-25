---
title: Search Guard 5.x-12
slug: changelog-5-x-12
category: changelogs
order: 140
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v12

Release Date: April 12, 2017

* First version with supports multitenancy for Kibana (ES 5.x only)
  * (needs [Search Guard Kibana Multitenancy Module](https://github.com/floragunncom/search-guard-module-kibana-multitenancy/wiki) and [Search Guard Kibana Plugin](https://github.com/floragunncom/search-guard-kibana-plugin) installed)
* Add Kibana Info REST endpoint (ES 5.x only)
* Add Demo installer (ES 5.x only)
* [Snapshot restore now usable for regular users PR 257 (5.x only)](https://github.com/floragunncom/search-guard/pull/257) by Lucas Bremgartner @breml
* SSL X509/PEM certificate support for transport and rest layer SSL (2.x/5.x)
  * Not yet available for LDAPS and Auditlog HTTPS connections
* Thread context handling fixed (5.x only)
* Honor JAVA_HOME in sgadmin.sh and hash.sh (2.x/5.x)
* Revise security policy to include additional netty permissions (5.x only)
* Do not load DLS/FLS wrapper for clients (5.x only)
* Revise default configuration, add multitenancy config (5.x only)