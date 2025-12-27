---
title: Kibana 7.x-52.1.0
permalink: changelog-kibana-7x-52_1_0
layout: docs
section: security
description: Changelog for Kibana 7.x-52.1.0
---
<!--- Copyright 2021 floragunn GmbH -->


# Search Guard Kibana Plugin 52.1

**Release Date: 2021-11-15**

## Bug Fixes

### Kibana Saved Object Migraton

When updating Kibana from 7.11.x to 7.13.x, 7.14.x, there could be an error similar to the following during the Kibana startup process:

```
Unable to fulfill migration for index .kibana_..., TypeError: Cannot read property 'getValueInBytes' of undefined
```

This bugfix release fixes that problem; saved object migrations will now run again without an error.

The bugfix requires that also the Search Guard Elasticsearch Plugin 52.4.0 is installed. 

Details:

- [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/382)
- [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/755) 
