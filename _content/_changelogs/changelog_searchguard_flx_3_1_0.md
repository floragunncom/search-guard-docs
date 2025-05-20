---
title: Search Guard FLX 3.1.0
permalink: changelog-searchguard-flx-3_1_0
layout: changelogs
description: Changelog for Search Guard FLX 3.1.0
---
<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 3.1.0

**Release Date: 2025-05-19**

## Bug fixes

### Validation of demo certs

Demo certificates are now loaded and validated according to the new Entitlements security feature introduced by Elasticsearch.

* [Issue: Port fix related to validation of demo certs from 9.0.0 to 8.18.0](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/475)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1161)

### Signals: Watch fix

Acknowledging the watch does not re-acknowledge actions which have already been acknowledged. 

* [Issue: Signals: acking whole watch also updates already acked actions in watch state](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/125)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1150)

### Kibana custom error page

Kibana custom error page has been fixed.

* [Issue: The custom error page seems to be broken](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/475)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1058)
