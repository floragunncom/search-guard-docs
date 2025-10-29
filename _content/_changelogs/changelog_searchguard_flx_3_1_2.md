---
title: Search Guard FLX 3.1.2
permalink: changelog-searchguard-flx-3_1_2
layout: changelogs
description: Changelog for Search Guard FLX 3.1.2
---
<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 3.1.2

**Release Date: 2025-08-12**

## Bug fixes

### Security Fixes

This release fixed two security issues that could allow unauthorized data access under field level security (FLS) and field masking. In FLX 3.1.1 and earlier, FLS exclusions on object-valued fields removed the object from _source but did not restrict queries against its member fields. The field masking (FM) was fixed on the IP field types. The user is no longer able to search by the field that has FM applied. Versions FLX 3.1.1 and earlier are still vulnerable and you are strongly advised to upgrade.

Regarding the issue relating to objects, if you cannot upgrade immediately and FLS exclusion rules are used for object valued attributes (like ~object), add an additional exclusion rule for the members of the object (like ~object.*).
If you effected by the field masking issue and you cannot upgrade immediately, you can avoid the problem by using field level security (FLS) protection on fields of the affected types instead of field masking.

* [FLS/FM security fix related to objects and IPs](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1250)