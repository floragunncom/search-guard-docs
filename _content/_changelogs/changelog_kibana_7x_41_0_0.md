---
title: Kibana 7.x-41.0.0
permalink: changelog-kibana-7x-41_0_0
layout: docs
section: security
description: Changelog for the Search Guard Kibana Plugin 7.x-41.0.0
---
<!---
Copyright 2020 floragunn GmbH
-->

# Search Guard Kibana Plugin 7.x-41.0.0

**Release Date: 05.05.2020**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7){:target="_blank"}

## Features

* Port Multi-Tenancy page to React
  * Tracking number: SGD-397

## Fixes

* authInfo cache in storage cookie is not refreshed when adding/deleting tenants
  * In some cases newly created tenants were not immediately visible
  * Tracking number: SGD-386
<br /><br />

* Timeout while trying to modify roles in Kibana App
  * This fixes a timeout issue on the Search Guard configuration screens if there is a huge number of role mappings
  * Tracking number: SGD-383
<br /><br />

* Filter system indexes in the fetch mappings route
  * For FLS, system index mappings were not visible on the role configuration screen. 
  * Tracking number: SGD-341
<br /><br />

* Search Guard session cookie: SameSite problem in the latest Chrome
  * The latest Chrome version woudl block the Search Guard session cookie if the SameSite policy was not set correctly.
  * See also [this issue](https://forum.search-guard.com/t/searchguard-cookie-samesite/1778){:target="_blank"} on the Search Guard forum
  * Thanks [HelderMarques91](https://forum.search-guard.com/u/HelderMarques91){:target="_blank"} for reporting
  * Tracking number: SGD-19
  
## Security Fixes

n/a
   