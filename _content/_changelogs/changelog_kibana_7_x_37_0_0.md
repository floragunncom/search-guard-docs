---
title: Kibana 7.x-37.0.0
slug: changelog-kibana-7.x-37_0_0
category: changelogs-kibana
order: 750
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 7.x-37.0.0
---

<!---
Copyright 2020 floragunn GmbH
-->

# Search Guard Kibana Plugin 7.x-37.0.0

**Release Date: 11.12.2019**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Security Fixes

n/a

## Features

* Configurable cookie names [#PR 306](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/merge_requests/306){:target="_blank"}
* Redirect after tenant switch should take base path into account [#PR 361](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/merge_requests/361){:target="_blank"}
* Add option for allowed_usernames - whitelist users [#PR 362](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/merge_requests/362){:target="_blank"}
* Remove invalid cookies after a 401 Unauthorized for basic auth [#PR 357](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/merge_requests/357){:target="_blank"}
* Consolidate check for null in array values

* Local error message for internal users
* Redirect after tenant switch should take base path into account
* Handle an index with undefined mappings correctly while converting mappings into fields
