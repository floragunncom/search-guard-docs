---
title: Kibana 7.x-36.0.0
slug: changelog-kibana-7.x-36_0_0
category: changelogs-kibana
order: 770
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 7.x-36.0.0
---

<!---
Copyright 2020 floragunn GmbH
-->

# Search Guard Kibana Plugin 7.x-36.0.0

**Release Date: 23.07.2019**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Security Fixes

n/a

## Fixes

* Fixed an issue with index migrations when the internal Kibana server user is not configured to use HTTP Basic Authentication
  * [PR #260: Call tenantinfo with InternalUser](https://github.com/floragunncom/search-guard-kibana-plugin/pull/260){:target="_blank"}

* Fixed an issue where multi tenancy would not work correctly when user impersonation was used
  * [PR #260: Handle user impersonation settings](https://github.com/floragunncom/search-guard-kibana-plugin/pull/227){:target="_blank"}


## Features

* Introduced a new Search Guard Configuration UI based on React and eui
  