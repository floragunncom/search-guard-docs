---
title: Search Guard 6.x-24.3
slug: changelog-searchguard-6-x-24_3
category: changelogs-searchguard
order: 450
layout: changelogs
description: Changelog for Search Guard 6.x-24.3
---

<!---
Copryight 2017-2019 floragunn GmbH
-->

# Search Guard 6.x-24.3

**Release Date: 01.04.2019**

* [Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)
* [Upgrade Guide to 6.5.x](../_docs/upgrading-6_5_0.md)

## Security Fixes 

This release fixes two critical security issues with Cross Cluster Search (CCS).
Every release before 6.x-24.3 for ES 6 is vulnerable and you are strongly advised to upgrade immediately.
The fix will be made available for Elasticsearch 6.4 and higher. If you are running on 6.0.x/6.1.x/6.2.x or 6.3.x
you need to upgrade to at least 6.4.x. 

Your cluster is vulnerable if you have one or more remote clusters configured. If no remote cluster is configured
the cluster is not affected by this issue and there is no need to upgrade immediately.

Details will be made available on the [CVE Advisory Page](https://search-guard.com/cve-advisory/).

## Fixes 

### Search Guard

* CCS: Fix "Do not fail on permissions (DNFOF)" together with CCS
* Core: Reduce loglevel for JWT "No Bearer scheme found in header" warning to debug (ITT-1942)
* Core: Remove unnecessary logging from BackendRegistry
