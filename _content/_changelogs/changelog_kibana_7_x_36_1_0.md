---
title: Kibana 7.x-36.1.0
slug: changelog-kibana-7.x-36_1_0
category: changelogs-kibana
order: 760
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 7.x-36.1.0
---

<!---
Copyright 2020 floragunn GmbH
-->

# Search Guard Kibana Plugin 7.x-36.1.0

**Release Date: 03.09.2019**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Security Fixes

* Issue a warning and refuse to start if `alwaysPresentCertificate` is set true **and** the Kibana server user is configured to use client TLS certificate authentication. In this scenario, a regular user can gain the privileges of the Kibana server user, 
  * [PR #268: ITT-1814 - Warn if DNFOF is false ](https://github.com/floragunncom/search-guard-kibana-plugin/pull/268){:target="_blank"}

## Fixes

* Fixed an issue with proxy cache authentication where the session was not cleared correctly after expiration
  * [PR #281: ITT-2389 - Clear session error](https://github.com/floragunncom/search-guard-kibana-plugin/pull/281){:target="_blank"}

* Issue a warning if "do not fail on forbidden" is set to false. Kibana requires this feature to run correctly
  * [PR #268: ITT-1814 - Warn if DNFOF is false ](https://github.com/floragunncom/search-guard-kibana-plugin/pull/268){:target="_blank"}

## Features

n/a
  