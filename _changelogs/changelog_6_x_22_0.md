---
title: Search Guard 6.x-22.0
slug: changelog-searchguard-6-x-22_0
category: changelogs-details
order: 700
layout: changelogs
description: Changelog for Search Guard 6.x-22.0
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

  
  
# TLS Tool 1.2

## Fixes 
* Fix intermediate/root selection logic bug
  * [https://github.com/floragunncom/search-guard-tlstool/pull/1](https://github.com/floragunncom/search-guard-tlstool/pull/1){:target="_blank"}
  * Contributed by [Bas Smit](https://github.com/fbs){:target="_blank"} 