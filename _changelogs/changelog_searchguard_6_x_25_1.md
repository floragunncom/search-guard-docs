---
title: Search Guard 6.x-25.1
slug: changelog-searchguard-6-x-25_1
category: changelogs-searchguard
order: 450
layout: changelogs
description: Changelog for Search Guard 6.x-25.1
---

<!---
Copryight 2019 floragunn GmbH
-->

# Search Guard 6.x-25.1

**Release Date: 08.05.2019**

* [Upgrade Guide from 5.x to 6.x](upgrading-5-6)
* [Upgrade Guide to 6.5.x](upgrading-560)

## Security Fixes 

n/a
  
## Fixes 

### Search Guard

* Make initialization more robust [#691](https://github.com/floragunncom/search-guard/issues/691){:target="_blank"}
  * There are rare situations where Search Guard was not initialized properly during a full cluster restart. This should now be fixed.

* Change logstash demo role to include cluster pipeline put+get permissions so that logstash and beats can manage their pipeline
[#692](https://github.com/floragunncom/search-guard/pull/692)

## Features

* Expert feature for OEM integrators: Add PUT and PATCH method for sgconfig endpoint [#46](https://github.com/floragunncom/search-guard-enterprise-modules/pull/46){:target="_blank"}
  * Needs to be enabled by setting `searchguard.unsupported.restapi.allow_sgconfig_modification: true` in elasticsearch.yml

