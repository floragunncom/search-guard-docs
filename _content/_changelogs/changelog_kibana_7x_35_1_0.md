---
title: Kibana 7.x-35.1.0
permalink: changelog-kibana-7x-35_1_0
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 7.x-35.1.0
---
<!---
Copyright 2020 floragunn GmbH
-->

# Search Guard Kibana Plugin 7.x-35.1.0

**Release Date: 29.05.2019**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Security Fixes

n/a

## Fixes

* Handle session timeouts on ajax requests that aren't created by Angular's $http service
  * [PR #214](https://github.com/floragunncom/search-guard-kibana-plugin/pull/214){:target="_blank"}

* Support special characters in tenant names
  * This PR allows for special characters in tenant names, such as $something&_test#
  * [PR #207](https://github.com/floragunncom/search-guard-kibana-plugin/pull/207){:target="_blank"}

* Take non default space into account in nextUrl 
  * This PR makes sure that the space prefix is available in the nextUrl when redirecting an unauthenticated request.
  * [PR #208](https://github.com/floragunncom/search-guard-kibana-plugin/pull/208){:target="_blank"}


## Features

* Add proxy headers
  * This PR makes it possible to forcefully add X-Forwarded-For headers to calls from KI to ES
  * [PR #205](https://github.com/floragunncom/search-guard-kibana-plugin/pull/205){:target="_blank"}

  
* Make logout url configurable
  * This PR adds a configurable logout URL for auth types that do not specify their own (Basic Auth, JWT)
  * [PR #206](https://github.com/floragunncom/search-guard-kibana-plugin/pull/206){:target="_blank"}  