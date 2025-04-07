---
title: Search Guard FLX 1.1.1
permalink: changelog-searchguard-flx-1_1_1
layout: changelogs
description: Changelog for Search Guard FLX 1.1.1
---
<!--- Copyright 2022 floragunn GmbH -->

# Search Guard FLX 1.1.1

**Release Date: 2023-02-20**

This is an important security fix release for Search Guard FLX. 

If you are using using document level security (DLS), field level security (FLS) or field masking and your sg_authz_dlsfls.yml contains use_impl: flx, you are required to update.

This release also bring a number of further bug fixes.

## Security bug fixes

### Fixed an issue with DLS, FLX and field masking leakage

Under certain conditions an authenticated but unauthorized user could access documents or fields or cleartext of masked fields which they are not allowed to see.

This was only the case if you have set `use_impl: flx` in `sg_authz_dlsfls.yml`.

## Bug fixes

### Initialization of nodes does not work properly sometimes

When restarting nodes it could occasionally happen that a node could not be initialized or that initialization takes a long time.
When a node is not initialized any request to this node will result in "Search Guard not initialized (SG11)." This is not fixed.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/148)

### Issues with aliases pointing to configuration indices 

When aliases to configuration indices do exist they were not properly handled so far. This could result in errors when loading the initial configuration or running sgctl. This release now handles aliases correctly.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/325)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/328)

### Field masking did not work when running with very high number literals

Numbers in documents which are higher than 2³¹ could result in an exception being thrown when field masking is active. This is now fixed.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/154)

### JWT param authentication not working with Kibana

JWT param authentication was not working with Kibana despite beging configured in `sg_authc.yml`.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/143)

### Issue with structured attributes for users

Using structured attributes of type `boolean` for users would result in an exception being thrown. This is now fixed.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/135)

## Other

### Updated Apache CXF dependency to version 3.4.10

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/324)
