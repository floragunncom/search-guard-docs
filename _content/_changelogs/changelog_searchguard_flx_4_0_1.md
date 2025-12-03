---
title: Search Guard FLX 4.0.1
permalink: changelog-searchguard-flx-4_0_1
layout: changelogs
description: Changelog for Search Guard FLX 4.0.1
---
<!--- Copyright 2024 floragunn GmbH -->
# Search Guard FLX 4.0.1

**Release Date: 2025-11-25**

## Bug fixes

### Security Fixes

In Search Guard FLX versions from 3.1.0 up to 4.0.0 with enterprise modules being disabled, there exists an issue which allows authenticated users to use specially crafted requests to read documents from data streams without having the respective privileges. As always, ensure that appropriate backup and rollback procedures are in place prior to performing the upgrade.

Details will be made available on the [CVE Advisory Page](https://search-guard.com/cve-advisory/).

* [Improve predicate for remote index recognition](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1363)