---
title: Search Guard 5.x-19.3
slug: changelog-5-x-19.3
category: changelogs
order: 70
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v19.3

Release Date: 04.02.2019

## Fixes

### REST API

* REST API: Silent failures when creating users with SG REST API
  * Needs REST API module [5.3-7](http://oss.sonatype.org/service/local/artifact/maven/content?c=jar-with-dependencies&r=releases&g=com.floragunn&a=dlic-search-guard-rest-api&v=5.3-7) or higher 
  * [Issue #628](https://github.com/floragunncom/search-guard/issues/628){:target="_blank"}