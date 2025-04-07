---
title: Search Guard FLX 1.4.0
permalink: changelog-searchguard-flx-1_4_0
layout: changelogs
description: Changelog for Search Guard FLX 1.4.0
---
<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 1.4.0

**Release Date: 2023-11-29**

This is a security release of Search Guard FLX. The security issue applies to Multi-Tenancy only. 
If you have not enabled that Multi-Tenancy, you are not affected.

**We ask all users that leverage the Multi-Tenancy features of Search Guard to update to Search Guard FLX 1.4.0 or above.** 

If you are still using Search Guard Classic, please upgrade to Search [Guard Classic 53.8](changelog-searchguard-7x-53_8_0) or above, which contain
a fix for the security issue as well.

## Security Fixes

### Multi-Tenancy: Users with read/only tenants can do destructive operations such as deleting the .kibana index

A user with only READ access to a tenant cannot perform any updates to the corresponding tenant index, but can still issue destructive operations like DELETE. 
This release fixes the issue.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/570)

## Helm Charts

When running Search Guard FLX 1.2.0 or 1.3.0 for Elasticsearch 8.7.x on Kubernetes with the Search Guard Helm Charts,
the custer sometimes does not initialize properly on first start because sgctl blocks indefinitely. This release fixes the issue
by adjusting the ThreadPool.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/255)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/547)