---
title: Kibana 6.x-13
slug: changelog-kibana-6.x-13
category: changelogs-details
order: 900
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-13
---

<!---
Copryight 2010 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-13

**Release Date: 26.05.2018**

## Fixes

* Clicking on cancel on the role edit screen would sometimes submit the form
  * internally tracked 
* When selecting the private tenant objects are sometimes written to the global tenant
  * [https://github.com/floragunncom/search-guard-module-kibana-multitenancy/issues/13](https://github.com/floragunncom/search-guard-module-kibana-multitenancy/issues/13)
* Internal users could not be saved if they have attributes
  * internally tracked 
* Performance: Avoid unnecessary calls to the authinfo endpoint
  * internally tracked 
* Fixed "0 days left" license error message
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/95](https://github.com/floragunncom/search-guard-kibana-plugin/issues/95)  
  
