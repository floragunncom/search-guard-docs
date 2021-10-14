---
title: Search Guard 7.x-45.1.0
permalink: changelog-searchguard-7x-45_1_0
category: changelogs-searchguard
order: 190
layout: changelogs
description: Changelog for Search Guard 7.x-45.1.0	
---

<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 10.09.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Bug Fixes



### Search Guard Core

* Incoming requests with an `X-Opaque-Id` header would fail. Fixed.
<p />

### Kibana Search Guard Integration

* Creating index patterns with Kibana 7.9.1 and Search Guard 45.0.0 was not possible. Fixed.
<p />

* Kibana could not access the .kibana-event-log-* indices. Fixed.
<p />


