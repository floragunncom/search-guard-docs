---
title: Search Guard FLX 4.1.3
permalink: changelog-searchguard-flx-4_1_3
layout: docs
section: security
description: Changelog for Search Guard FLX 4.1.3
---
<!--- Copyright 2026 floragunn GmbH -->
# Search Guard FLX 4.1.3

**Release Date: 2026-11-12**

This release is available for Elasticsearch and Kibana 9.4.3 and 9.4.4.

## Bug fixes


### Kibana response times could increase with uptime

This fixes a regression introduced in Search Guard FLX 4.1.0 for Elasticsearch 9.3.x and 9.4.x: the Kibana plugin registered an internal request listener more often than necessary, so Kibana response times could gradually increase the longer a Kibana instance was running. Search Guard FLX 4.2.0 and later are not affected.

* [Issue Kibana](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/632)
* [Merge Request Kibana](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1250)

