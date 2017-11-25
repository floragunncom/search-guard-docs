---
title: Search Guard 5.x-9
slug: changelog-5-x-9
category: changelogs
order: 170
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v9

Release Date: December 12, 2016

* Add support for Elasticsearch 5.1.1
* Fix [DLS not picked up when getting documents by ID #1](https://github.com/floragunncom/search-guard-module-dlsfls/issues/1)
* Fix [sgadmin timeout when updating a role with duplicated permissions #238](https://github.com/floragunncom/search-guard/issues/238)
 * by introducing a -ff (--fail-fast) flag which is not set by default
* Fix [Missing permissions when running JWT #1](https://github.com/floragunncom/search-guard-authbackend-jwt/issues/1)
* Fix composite handling (composite actions were not detected correctly)
* Fix [permissions resolution for certain index/type combinations](https://github.com/floragunncom/search-guard/wiki/SecurityIssues) (by Lucas Bremgartner) 
* Fix [Redundant condition #248](https://github.com/floragunncom/search-guard/issues/248)
* Make error messages more verbose and give recommendations what the user can try to fix it