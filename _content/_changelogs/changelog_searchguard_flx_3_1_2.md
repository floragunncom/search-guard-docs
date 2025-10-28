---
title: Search Guard FLX 3.1.2
permalink: changelog-searchguard-flx-3_1_2
layout: changelogs
description: Changelog for Search Guard FLX 3.1.2
---
<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 3.1.2

**Release Date: 2025-08-12**

## Bug fixes

### Security Fixes

This release fixed two security issues that could allow unauthorized data access under Field Level Security (FLS) and field masking. In FLX 3.1.1 and earlier, FLS exclusions on object-valued fields removed the object from _source but did not restrict queries against its member fields. Versions FLX 3.1.1 and earlier are still vulnerable and you are strongly advised to upgrade.

* [FLS/FM security fix related to objects, IPs, and geo_points](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1250)