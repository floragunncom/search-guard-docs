---
title: Search Guard FLX 3.1.3
permalink: changelog-searchguard-flx-3_1_3
layout: changelogs
description: Changelog for Search Guard FLX 3.1.3
---
<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 3.1.3

**Release Date: 2025-11-03**

## Bug fixes

### Security Fixes
This release fixes the issue where the DLS rules were not applied correctly when Signals watch was executing. Revealing information in the alerts that the user does not have permissions for. The DLS is now applied correctly preventing any information leak.

Details will be made available on the [CVE Advisory Page](https://search-guard.com/cve-advisory/).

* [DLS Role Parsing Fails with AuthTokens Fix](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1312)
