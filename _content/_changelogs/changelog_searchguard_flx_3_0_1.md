---
title: Search Guard FLX 3.0.1
permalink: changelog-searchguard-flx-3_0_1
category: changelogs-searchguard
order: -1110
layout: changelogs
description: Changelog for Search Guard FLX 3.0.1
---

<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 3.0.1

**Release Date: 2024-12-10**

## Improvements

### Further improvements in dark mode

Additional improvements in Kibana UI Dark mode.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1024)

## Bug fixes

### SGCTL connection fixed

We have fixed the sgctl connection issues.

* [Issue: SGCTL 3.0.0 fails to connect to cluster](https://git.floragunn.com/search-guard/search-guard-custom-requests/-/issues/16)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-custom-requests/-/issues/16)
* [Merge Request](https://git.floragunn.com/search-guard/sgctl/-/merge_requests/224)

### Node restart after disabling of SearchGuard

Nodes are now successfully restarting when SearchGuard is disabled.

* [Issue: Node won't start after disabling SG](https://git.floragunn.com/search-guard/search-guard-custom-requests/-/issues/15)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-custom-requests/-/issues/15)
