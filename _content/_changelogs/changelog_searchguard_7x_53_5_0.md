---
title: Search Guard 7.x-53.5.0
permalink: changelog-searchguard-7x-53_5_0
layout: changelogs
description: Changelog for Search Guard 7.x-53.5.0
---
<!--- Copyright 2022 floragunn GmbH -->

# Search Guard Suite 53.5

**Release Date: 2022-10-05**

This is a security fix release for an issue with datastreams.

Since data streams are an X-Pack feature in Elasticsearch 7.x, we did not officially support them.
Nevertheless we decided to release a fix for it but won't issue a CVE because datastreams was (and remains) an unsupported feature.

## Security Fixes

### An authenticated but unauthorized user could access all data stream events

An authenticated but unauthorized user could access all data stream events via the _search API.

This update fixes this issue. 

**Details:**

* [Search Guard Forum](https://forum.search-guard.com/t/search-guard-incompatible-with-data-streams/2347/14){:target="_blank"}

* [Commit](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/commit/c4df276cec95f81a82768a8fa098f35f80e1bcb5){:target="_blank"}