---
title: Kibana 6.x-19.1
slug: changelog-kibana-6.x-19.1
category: changelogs-kibana
order: 200
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-19.1
---

<!---
Copryight 2019 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-19.1

**Release Date: 14.05.2020**

* [Upgrade Guide from 5.x to 6.x](upgrading-5-6)
* [Upgrade Guide to 6.5.x](upgrading-560)

## Fixes

* Fix an issue with `SameSite` cookie settings and the latest Chrome versions. This fix makes it possible again to run Kibana in an iFrame

* Fix an issue where sometimes newly created tenants were not visible due to a caching bug
