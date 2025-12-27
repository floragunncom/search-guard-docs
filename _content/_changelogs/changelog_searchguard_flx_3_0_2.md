---
title: Search Guard FLX 3.0.2
permalink: changelog-searchguard-flx-3_0_2
layout: docs
section: security
description: Changelog for Search Guard FLX 3.0.2
---
<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 3.0.2

**Release Date: 2024-12-05**

## Improvements

### SGS_KIBANA_SERVER now has access to .kibana-reporting data stream

Data stream .kibana-reporting* is now a part of the SGS_KIBANA_SERVER role.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1054)

## Bug fixes

### Multi-tenancy in data migration 

Data migration in multi tenant environment is fixed.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1055)
