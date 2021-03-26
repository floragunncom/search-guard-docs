---
title: Kibana 7.x-50.1.0
slug: changelog-kibana-7.x-50_1_0
category: changelogs-kibana
order: -310
layout: changelogs
description: Changelog for Kibana 7.x-50.1.0	
---

<!--- Copyright 2021 floragunn GmbH -->


# Search Guard Kibana Plugin 50.1

**Release Date: 2021-03-26**

This is a bugfix release for the Search Guard Kibana plugin. It fixes two major issues of the Search Guard Kibana Plugin 50.0 which occurred only in specific setups. If you are using such setups with the Search Guard Kibana plugin 50.0, then upgrading is strongly recommended.

See below for details.

## Bugfix for setups where multitenancy is disabled

This fixes a bug that prevented Kibana pages from working properly if multi-tenancy in Search Guard is disabled and Kibana Spaces is enabled.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/351)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/695) 

## Bugfix for anonymous user authentication in Kibana

This fixes a bug that prevented Kibana pages from working properly for the anonymous user setup.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/349)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/694) 
