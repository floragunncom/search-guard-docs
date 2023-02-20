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

### Updated Apache CXF dependency to version 3.4.10 to fix CVE-2022-46364

From the CVE:
```
A SSRF vulnerability in parsing the href attribute of XOP:Include in MTOM requests in versions of Apache CXF before 3.5.5 and 3.4.10 allows an attacker to perform SSRF style attacks on webservices that take at least one parameter of any type.
```

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/324)

This is only relevant if you use Kibana together with SAML or OIDC authentication in legacy mode.

## Bug fixes

### Node initialization can stall under certain conditions

* [Issue: Node initialization can stall under certain conditions](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/148)

### Replace hasIndex with hasIndexAbstraction to handle aliases correctly

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/325)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/328)

### The FLX field masking impl fails with int values outside of the 2³² range

* [Issue: The FLX field masking impl fails with int values outside of the 2³² range](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/154)

### JWT auth does not work with Kibana if sg_authc.yml is in use

* [Issue: JWT auth does not work with Kibana if sg_authc.yml is in use](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/143)

### Structured attributes of user cannot contain java.lang.Boolean

* [Issue: Structured attributes of user cannot contain java.lang.Boolean](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/135)

### REST API for deleting instances of config types

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/312)
* [Issue: REST API for deleting instances of config types](https://git.floragunn.com/search-guard/sgctl/-/issues/6)
