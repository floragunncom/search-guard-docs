---
title: Kibana 6.x-15
slug: changelog-kibana-6.x-15
category: changelogs-kibana
order: 650
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-15
---

<!---
Copryight 2010 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-15

**Release Date: 25.09.2018**

## Features
* Add field anonymization to config GUI
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/134](https://github.com/floragunncom/search-guard-kibana-plugin/pull/134){:target="_blank"} 
* Add user attributes to GUI
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/135](https://github.com/floragunncom/search-guard-kibana-plugin/pull/135){:target="_blank"} 
* Block users from logging in when they do not have at least one SG role
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/133](https://github.com/floragunncom/search-guard-kibana-plugin/pull/133){:target="_blank"}  
 
## Fixes

* Roles: Index not preselected anymore on roles tab
  *  [https://github.com/floragunncom/search-guard-kibana-plugin/pull/131](https://github.com/floragunncom/search-guard-kibana-plugin/pull/131){:target="_blank"}
* Auto-complete input fields for index and document types would not accept non pre-selected values
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/132](https://github.com/floragunncom/search-guard-kibana-plugin/pull/132)   
* Typo fin build.sh fixed
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/122](https://github.com/floragunncom/search-guard-kibana-plugin/issues/122){:target="_blank"}
* Regression: Session timeout handling
  * [https://github.com/floragunncom/search-guard/issues/553](https://github.com/floragunncom/search-guard/issues/553){:target="_blank"}
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/130](https://github.com/floragunncom/search-guard-kibana-plugin/pull/130){:target="_blank"}