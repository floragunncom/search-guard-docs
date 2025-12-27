---
title: Search Guard FLX 1.4.1
permalink: changelog-searchguard-flx-1_4_1
layout: docs
section: security
description: Changelog for Search Guard FLX 1.4.1
---
<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 1.4.1

**Release Date: 2024-01-03**

This is a bug fix release of Search Guard FLX.

## Bug Fixes

### Create new LDAP connections in a privileged thread context

When the LDAP connection pool scales up, the code seems to be missing the necessary special privilege block. It failed with an AccessControlException.This is now fixed.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/256)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/553)

## Introduced config attributes retrieve_attributes for LDAP auth backend

This fix introduce two new config options: ldap.user_search.retrieve_attributes and ldap.group_search.retrieve_attributes. Both accept a list of strings that specify the attributes to be retrieved in the LDAP result set. Some LDAP directory might have a large number of attributes associated with single entries. In order to reduce network activity, it might make sense to allow to specify the attributes to select for queries.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/265)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/563)