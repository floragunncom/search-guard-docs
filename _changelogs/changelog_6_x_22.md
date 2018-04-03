---
title: Search Guard 6.x-22
slug: changelog-6-x-22
category: changelogs
order: 700
layout: changelogs
description: Changelog for Search Guard 6.x-22
---

<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard 6.x-22.0

Release Date: 27.03.2018

[Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)

## Fixes 
* DLS causing dashboards to fail for users that use DLS
  * [https://github.com/floragunncom/search-guard/issues/457](https://github.com/floragunncom/search-guard/issues/457){:target="_blank"}
  * DLS performance regression
* Search-guard failed to parse admin DN 
  * [https://github.com/floragunncom/search-guard/issues/454](https://github.com/floragunncom/search-guard/issues/454){:target="_blank"}
* Set trial license to 60 days, not 61
  * (internally tracked) 

## Features

* Added OpenID and JWKS support 
  * [https://docs.search-guard.com/latest/openid-json-web-keys](https://docs.search-guard.com/latest/openid-json-web-keys){:target="_blank"}

# Kibana Plugin 6.x-11

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
  
  
# TLS Tool 1.2

## Fixes 
* Fix intermediate/root selection logic bug
  * [https://github.com/floragunncom/search-guard-tlstool/pull/1](https://github.com/floragunncom/search-guard-tlstool/pull/1){:target="_blank"}
  * Contributed by [Bas Smit](https://github.com/fbs){:target="_blank"} 