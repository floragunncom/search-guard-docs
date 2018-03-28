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

## Features

* Added OpenID and JWKS support 
  * [https://docs.search-guard.com/latest/openid-json-web-keys](https://docs.search-guard.com/latest/openid-json-web-keys){:target="_blank"}