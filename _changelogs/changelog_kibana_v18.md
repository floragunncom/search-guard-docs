---
title: Kibana 6.x-18
slug: changelog-kibana-6.x-18
category: changelogs-kibana
order: 550
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-18
---

<!---
Copryight 2010 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-18

**Release Date: 02.02.2019**

[Upgrade Guide to 6.5.x](../_docs/upgrading-6_5_0.md)

## Security Fixes

n/a

## Fixes

* Support for Spaces alongside Search Guard multitenancy
  * Every Search Guard tenant has its own set of Spaces.
  * [PR #167](https://github.com/floragunncom/search-guard-kibana-plugin/pull/167){:target="_blank"}

## Features

* New proxycache auth type
  * It's now possible to use proxy authentication, but only transmit the headers once by storing them in a cookie.
  * [PR #157](https://github.com/floragunncom/search-guard-kibana-plugin/pull/157){:target="_blank"}