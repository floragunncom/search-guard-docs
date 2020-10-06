---
title: Kibana 7.x-46.0.0
slug: changelog-kibana-7.x-46_0_0
category: changelogs-kibana
order: 100
layout: changelogs
description: Changelog for Kibana 7.x-46.0.0	
---

<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 06.10.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Bug Fixes


### Kibana Authentication and Multi Tenancy

* Fixed read only mode for React based apps.
<p />
* When being redirected to the login page after a session timeout, the base path would not always be used correctly. Fixed.
<p />


### Search Guard Kibana Plugin Core

* No longer caches tenant data in the browser cookie, as this led to unexpected behavior when working with tenants, e.g., inability to select tenants added via API, inability to store a large amount of tenants' data due to the cookie size limit.
<p />


