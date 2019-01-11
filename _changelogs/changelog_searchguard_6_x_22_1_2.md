---
title: Search Guard 6.x-22.2
slug: changelog-6-x-22_2
category: changelogs-searchguard
order: 700
layout: changelogs
description: Changelog for Search Guard 6.2.x-22.1 and 6.1.x-22.2
---

<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard 6.2.x-22.1 / Search Guard 6.1.x-22.2

Release Date: 27.04.2018

## Features

* Search Guard demo certificates rollover
  * [https://groups.google.com/forum/#!topic/search-guard/VJQqzxQXYFE](https://github.com/floragunncom/search-guard/issues/457https://groups.google.com/forum/#!topic/search-guard/VJQqzxQXYFE){:target="_blank"}

## Fixes

* Fixed permissions in Search Guard demo roles
  * [Insufficient permissions for Kibana Short Urls ](https://github.com/floragunncom/search-guard/issues/451)
* Fixed an issue where the Webhook Audit Log fails due to insufficient plugin permissions
  * (internally tracked)
* Fixed an issue where the JWKS/OpenID module fails when the JWT does not contain a `keyid`
  * (internally tracked)
* Fixed in issue in the Audit Log module where `audit_request_origin` is not logged for SSL Exceptions on Transport layer
  * (internally tracked)