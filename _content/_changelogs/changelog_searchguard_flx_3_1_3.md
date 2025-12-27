---
title: Search Guard FLX 3.1.3
permalink: changelog-searchguard-flx-3_1_3
layout: docs
section: security
description: Changelog for Search Guard FLX 3.1.3
---
<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 3.1.3

**Release Date: 2025-11-03**

## Bug fixes

### Security Fixes
This release resolves an issue where DLS rules were not correctly applied during Signals watch execution, which could result in alerts exposing information beyond a user’s permissions. DLS is now enforced properly, preventing any unauthorized data from being revealed.

Details will be made available on the [CVE Advisory Page](https://search-guard.com/cve-advisory/).

* [DLS Role Parsing Fails with AuthTokens Fix](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1312)
