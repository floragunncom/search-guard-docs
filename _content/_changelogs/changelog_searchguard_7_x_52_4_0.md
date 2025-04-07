---
title: Search Guard 7.x-52.4.0
permalink: changelog-searchguard-7x-52_4_0
layout: changelogs
description: Changelog for Search Guard 7.x-52.4.0
---
<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 52.4

**Release Date: 2021-10-14**

This release brings support for Elasticsearch 7.15.0. Also, it fixes a bug with the saved object migration in Kibana.

**If you are also using Kibana, it is essential that you also upgrade the Search Guard Kibana Plugin to 52.0.0. Otherwise, saved object migration in Kibana will not properly work.**

## Bug Fixes

### Kibana Saved Object Migraton

When updating Kibana from 7.11.x to 7.13.x, 7.14.x, there could be an error similar to the following during the Kibana startup process:

```
Error: Unable to complete saved object migrations for the [.kibana] index. Please check the health of your Elasticsearch cluster and try again.
Unexpected Elasticsearch ResponseError: statusCode: 400, method: PUT, url: /.kibana_7.14.1_001?wait_for_active_shards=all&timeout=60s 
error: [mapper_parsing_exception]: Failed to parse mapping [_doc]: unknown parameter [enabled] on mapper [params] of type [flattened]
```

This release of Search Guard fixes that problem; saved object migrations will no run again without an error.

The bugfix requires that also the Search Guard Kibana Plugin 52.0.0 is installed. 

Details:

- [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/381)
- [Merge Request Backend](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/125)
- [Merge Request Kibana Plugin](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/753) 
