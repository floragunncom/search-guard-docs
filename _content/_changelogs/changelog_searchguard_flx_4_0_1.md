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

This version addresses a security issue present in Search Guard FLX 4.0.0 and earlier. When the DLS/FLS module is disabled, queries using selector syntax against data streams may incorrectly return documents that should not be accessible. Before upgrading to Search Guard FLX 4.0.1, system administrators should carefully review their use of selector-based queries and data streams, and validate access control behavior in a non-production environment. As always, ensure that appropriate backup and rollback procedures are in place prior to performing the upgrade.

Details will be made available on the [CVE Advisory Page](https://search-guard.com/cve-advisory/).

* [Improve predicate for remote index recognition](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1362)