---
title: Kibana 6.x-11
slug: changelog-kibana-6.x-11
category: changelogs-details
order: 900
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-11
---

<!---
Copryight 2010 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-11

**Release Date: 03.04.2018**

## Fixes 
* Disable password autocomplete on login form
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/82](https://github.com/floragunncom/search-guard-kibana-plugin/issues/82){:target="_blank"}
* Kibana error log "[index\_not\_found\_exception] no such index"
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/66](https://github.com/floragunncom/search-guard-kibana-plugin/issues/66){:target="_blank"}
* Session timeout leads to exception / dead links
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/53](https://github.com/floragunncom/search-guard-kibana-plugin/issues/53){:target="_blank"}
* After deleting an index from a role, auto-select the next existing
  * This fixes a minor GUI glitch when deleting the last index for a role
  * (internally tracked)
* LoginController: no this context when no tenants available 
  * If a user that tries to log in to Kibana has no available tenant, no error message was displayed 
  * (internally tracked)
* 6.2.x: Adapt to css changes 
  * Minor CSS fixes for the 6.2.x line  
  * (internally tracked)
* Search Guard configuration GUI enabled when is not
  * Made log statements more clear about the Config GUI being an enterprise feature 
  * [https://github.com/floragunncom/search-guard/issues/461](https://github.com/floragunncom/search-guard/issues/461){:target="_blank"}  

## Features

* Block system users from logging in to Kibana
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/81](https://github.com/floragunncom/search-guard-kibana-plugin/issues/81){:target="_blank"}  
* Support "View Dashboards Only mode"
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/48](https://github.com/floragunncom/search-guard-kibana-plugin/issues/48){:target="_blank"}
* Make it possible to select tenant by adding an HTTP header
  * This fix makes it possible to select the tenant when using the Kibana saved objects API 
