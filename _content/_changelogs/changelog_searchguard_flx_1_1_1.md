---
title: Search Guard FLX 1.1.1
permalink: changelog-searchguard-flx-1_1_1
category: changelogs-searchguard
order: -1010
layout: changelogs
description: Changelog for Search Guard FLX 1.1.1
---

<!--- Copyright 2022 floragunn GmbH -->

# Search Guard FLX 1.1.1

**Release Date: 2023-02-20**

This is an important security fix release for Search Guard FLX. 

If you are using document level security (DLS), field level security (FLS) or field masking you are required to update.

It also bring a number of bug fixes.

## Security Fixes

### Fixed an issue with DLS, FLX and field masking leakage

Under certain conditions an authenticated but unauthorized user could access documents or fields or cleartext of masked fields which is not allowed to see.

This is only relevant if you have set `use_impl: flx` in sg_authz_dlsfls.yml

## Bug fixes

### Initialization of nodes does not work properly sometimes

When restarting nodes it could occasionally happen that a node could not be initialized or that initialization takes a long time.
When a node is not initialized any request to this node will result in "Search Guard not initialized (SG11)." 

* [Issue: Node initialization can stall under certain conditions](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/148)

### Issues with aliases pointing to configuration indices 

When aliases to configuration indices do exist they are not properly handled so far. This could result in errors when loading the initial configuration or running sgctl.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/325)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/328)

### Field masking did not work when running with very high number literals

Numbers in documents which are higher than 2³² can result in an exception being thrown when field masking is active.

* [Issue: The FLX field masking impl fails with int values outside of the 2³² range](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/154)

### JWT authentication not working with Kibana

JWT authentication is not working with Kibana despite configured in sg_authc.yml.

* [Issue: JWT auth does not work with Kibana if sg_authc.yml is in use](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/143)

### Issue with structured attributes for users

Using structured attributes of type `boolean` for users result in an exception being thrown. 

* [Issue: Structured attributes of user cannot contain java.lang.Boolean](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/135)

### sgctl could not delete legacy sg_config

Introduce a new REST API to enable sgctl to delete legacy configuration.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/312)
* [Issue: REST API for deleting instances of config types](https://git.floragunn.com/search-guard/sgctl/-/issues/6)

### Updated Apache CXF dependency to version 3.4.10

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/324)