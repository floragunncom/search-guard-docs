---
title: Search Guard FLX 4.1.2
permalink: changelog-searchguard-flx-4_1_2
layout: docs
section: security
description: Changelog for Search Guard FLX 4.1.2
---
<!--- Copyright 2026 floragunn GmbH -->
# Search Guard FLX 4.1.2

**Release Date: 2026-06-25**

## Bug fixes


### Authentication failures when request headers are mapped into user attributes in a multi-node cluster

In clusters where authentication domains mapped HTTP request headers into user attributes (e.g. `attrs.from: $.request.headers[...]`), the resulting user context could not be serialized for transport between nodes, causing requests in multi-node deployments to fail with a `NotSerializableException`. Single-node setups were not affected. This has been fixed.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1534)

