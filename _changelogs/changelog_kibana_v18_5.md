---
title: Kibana 6.x-18.5
slug: changelog-kibana-6.x-18.5
category: changelogs-kibana
order: 300
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-18.5
---

<!---
Copyright 2019 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-18.5

**Release Date: 18.07.2019**

* [Upgrade Guide from 5.x to 6.x](upgrading-5-6)
* [Upgrade Guide to 6.5.x](upgrading-560)

## Security Fixes

n/a

## Fixes

* Fixed an issue with index migrations when the internal Kibana server user is not configured to use HTTP Basic Authentication
  * [PR #260: Call tenantinfo with InternalUser](https://github.com/floragunncom/search-guard-kibana-plugin/pull/260){:target="_blank"}

* Fixed an issue where multi tenancy would not work correctly when user impersonation was used
  * [PR #260: Handle user impersonation settings](https://github.com/floragunncom/search-guard-kibana-plugin/pull/227){:target="_blank"}


## Features

n/a
  