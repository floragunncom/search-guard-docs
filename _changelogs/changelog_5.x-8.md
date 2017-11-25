---
title: Search Guard 5.x-8
slug: changelog-5-x-8
category: changelogs
order: 180
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v8

Release Date: November 10, 2016

* Add support for Elasticsearch 5
* Add .bat files for Windows operating system
* Add standalone version of sgadmin
* fixed a bug with tribe nodes where node where counted wrong
* Fix [sgadmin.sh --update_settings together with --configdir #228](https://github.com/floragunncom/search-guard/issues/228) 
* Fix DLS/FLS index association issue
* Handle composite requests in that way, that permission violations will be reported on subrequest level
* Fix initialization issue with auditlog module when ES license plugin is installed