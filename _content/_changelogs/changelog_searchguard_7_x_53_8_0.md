---
title: Search Guard 7.x-53.8.0
permalink: changelog-searchguard-7x-53_8_0
layout: changelogs
description: Changelog for Search Guard 7.x-53.8.0
---
<!--- Copyright 2024 floragunn GmbH -->

# Search Guard Suite 53.8

**Release Date: 2023-11-29**

This is a security release of Search Guard that applies to Multi-Tenancy only. If you have not enabled that Multi-Tenancy, you are not affected.

We ask all users that leverage the Multi-Tenancy features of Search Guard to update to Search Guard 53.8 or above.

If you are using Search Guard FLX, please upgrade to [Search Guard FLX 1.4.1](changelog-searchguard-flx-1_4_1).

## Security Fixes

### Multi-Tenancy: Users with read/only tenants can do destructive operations such as deleting the .kibana index

A user with only READ access to a tenant cannot perform any updates to the corresponding tenant index, but can still issue destructive operations like DELETE.
This release fixes the issue.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/571)
