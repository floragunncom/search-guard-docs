---
title: Kibana 7.x-41.0.0
slug: changelog-kibana-7.x-41_0_0
category: changelogs-kibana
order: 700
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 7.x-41.0.0
---

<!---
Copyright 2020 floragunn GmbH
-->

# Search Guard Kibana Plugin 7.x-41.0.0

**Release Date: 11.05.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Security Fixes

n/a

## Fixes

* Timeout while trying to modify roles in Kibana App
  * This fixes a timeout issue on the Search Guard configuration screens if there is a huge number of role mappings

* Filter system indexes in the fetch mappings route
  * For FLS, system index mappings were not visible on the role configuration screen. 

* Search Guard session cookie: SameSite problem in the latest Chrome
  * The latest Chrome version woudl block the Search Guard session cookie if the SameSite policy was not set correctly.
  * See also [this issue](https://forum.search-guard.com/t/searchguard-cookie-samesite/1778) on the Search Guard forum
  * Thanks [HelderMarques91](https://forum.search-guard.com/u/HelderMarques91) for reporting
  
   
## Features

n/a

