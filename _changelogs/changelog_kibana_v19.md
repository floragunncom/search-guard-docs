---
title: Kibana 6.x-19
slug: changelog-kibana-6.x-19
category: changelogs-kibana
order: 250
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-19
---

<!---
Copryight 2019 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-19

**Release Date: 11.12.2019**

* [Upgrade Guide from 5.x to 6.x](upgrading-5-6)
* [Upgrade Guide to 6.5.x](upgrading-560)

## Security Fixes

* Avoid Cacheable SSL Page [#PR 301](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/merge_requests/301){:target="_blank"}
* Avoid Internal IP Disclosure Pattern [#PR 299](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/merge_requests/299){:target="_blank"}

## Fixes

* Configurable cookie names [#PR 306](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/merge_requests/306){:target="_blank"}
* Redirect after tenant switch should take base path into account [#PR 361](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/merge_requests/361){:target="_blank"}
* Add option for allowed_usernames - whitelist users [#PR 362](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/merge_requests/362){:target="_blank"}
* Remove invalid cookies after a 401 Unauthorized for basic auth [#PR 357](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/merge_requests/357){:target="_blank"}
* Consolidate check for null in array values
* Local error message for internal users
* Redirect after tenant switch should take base path into account