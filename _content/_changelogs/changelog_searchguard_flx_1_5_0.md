---
title: Search Guard FLX 1.5.0
permalink: changelog-searchguard-flx-1_5_0
category: changelogs-searchguard
order: -1060
layout: changelogs
description: Changelog for Search Guard FLX 1.5.0
---

<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 1.5.0

**Release Date: 2024-01-15**

## Multi Tenancy

**Due to technical constraints, Multi Tenancy is not available in this version of Search Guard. We are working on this issue and will reintroduce
Multi Tenancy in the next release of Search Guard.**

## LDAP

### Allow selection of attributes to be returned for ldap queries

Some LDAP directory might have a large number of attributes associated with single entries. 
In order to reduce network activity, this change makes it possible to specify the attributes to select for queries.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/265)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/563)

### LDAP connection pool fails with java.security.AccessControlException

When the LDAP connection pool scales up, the code seems to be missing the necessary special privilege block.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/256)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/553)
