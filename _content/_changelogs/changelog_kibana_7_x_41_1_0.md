---
title: Kibana 7.x-41.1.0
slug: changelog-kibana-7.x-41_1_0
category: changelogs-kibana
order: 510
layout: changelogs
description: Changelog for Kibana 7.x-41.1.0	
---

<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 01.06.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Bug Fixes

### Search Guard Kibana Plugin Core

* Fixed an issue where the Spaces selector gets stuck in loading state
  * This happens when a user selects a named tenant (i.e not the global tenant) and afterwards creates a new Space
<p />


### Kibana Authentication and Multi Tenancy

* Fix incorrect warning on tenant page
  * The page for selecting the active tenant would show a bogus warning if the user does not have administration privileges.
<p />