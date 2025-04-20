---
title: Search Guard 7.x-52.5.0
permalink: changelog-searchguard-7x-52_5_0
layout: changelogs
description: Changelog for Search Guard 7.x-52.5.0
---
<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 52.5

**Release Date: 2021-11-16**

This is a bugfix for a critical security issue in Search Guard versions 42 or later on Elasticsearch 7.7.0 or later. It only affects users who have hidden indices (`index.hidden: true`) on their cluster. These users are advised to update as soon as possible or to apply the mitigation explained below.

## Security Bug Fixes

### Unauthorized Access on Hidden Indices

A flaw was discovered in Search Guard where privilges were not properly evaluated for indices with the hidden flag set. This flaw could lead to authenticated users gaining access to data they are not authorized to view.

The flaw only affects indices with `index.hidden: true` in their settings. The flaw does not affect the internal Search Guard indices, as these are using a special protection. The flaw only allows read access; write access is not possible.

**Affected Versions:**

Search Guard versions 42.0.0 to 52.4.0 for Elasticsearch versions starting at 7.7.0.

**Solution:**

Update to Search Guard version 52.5.0.

**Mitigation:** 

Remove `index.hidden: true` from the settings of all indices. Note that this may affect queries using wildcards.

**Details:** 

- [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/45)
- [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/131)
