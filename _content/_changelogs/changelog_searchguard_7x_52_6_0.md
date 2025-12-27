---
title: Search Guard 7.x-52.6.0
permalink: changelog-searchguard-7x-52_6_0
layout: docs
section: security
description: Changelog for Search Guard 7.x-52.6.0
---
<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 52.6

**Release Date: 2022-01-10**

This is a bugfix release for a critical security issue for users which use filter-level DLS with msearch queries. Filter-level DLS was introduced in Search Guard 52.0; in the default configuration, it is only active when you are using term-lookup queries as DSL queries in the `sg_roles.yml` file. Alternatively, it can be enabled using the configuration option `searchguard.dls.mode: filter_level`. 

If you are using filter-level DLS, we are strongly recommending to apply this update soon.

## Security Bug Fixes

### Unauthorized Access on Indices Protected By Fiter-Level DLS using `msearch`

A flaw was discovered in Search Guard where `msearch` actions on indices protected by filter-level DLS could return all documents of the index instead of just the documents filtered by the DLS query. This flaw can occur non-deterministically. In most cases the result would be correct. In sporadic cases, however, the flaw might return an unfiltered query result.

Users who can customize the `msearch` request flags, however, have the ability to trigger the flaw in a deterministic manner.

**Affected Versions:**

Search Guard versions 52.0.0 to 52.5.0.

**Solution:**

Update to Search Guard version 52.6.0.

**Mitigation:** 

Do not grant `msearch` privileges on indices protected by filter-level DLS.

**Details:** 

- [Documentation for DLS](https://docs.search-guard.com/latest/document-level-security)
- [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/150)
