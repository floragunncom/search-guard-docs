---
title: Search Guard 5.x-15
slug: changelog-5-x-15
category: changelogs
order: 110
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v15

Release Date: August 08, 2017

## Critical Security Fix

* DLS/FLS leaking information when multitenancy module is installed and "do not fail on forbidden" is activated

If multitenancy module is installed and the "do not fail on forbidden" feature is activated in sg_config like:

```
searchguard:
  dynamic:
    kibana:
      do_not_fail_on_forbidden: true
```

The DLS/FLS module can leak information if the user does not have permissions for all indices in a query or get action.

This affects all versions of Search Guard up to and including v14 with Elasticsearch 5.0.2 or higher, and includes the REST and the transport layer. 
Please upgrade to Search Guard v15 immediately. 
Search Guard 15 is a drop-in replacement for v14, no changes in any configuration is required.

## Features (only available for ES 5.4.3 and higher)
* Search Guard can now be disabled in `elasticsearch.yml` by setting:
  * `searchguard.disabled: true`
  * Caution: This will disable all security features and also exposes the internal Search Guard index
* Make user cache timeout configurable, incl. disabling it completely
  * The internal user cache ttl can be set in `elasticsearch.yml` now
  * `searchguard.cache.ttl_minutes: <integer, ttl in minutes>`
  * Setting this value to `0` disables the cache completely
* Documented TLS Client-Initiated Renegotiation
  * [https://github.com/floragunncom/search-guard/issues/368](https://github.com/floragunncom/search-guard/issues/368)
* Support for multiple filtered index aliases 
  * [https://github.com/floragunncom/search-guard/issues/190](https://github.com/floragunncom/search-guard/issues/190)
  * The behavior can now be configured in `sg_config.yml` via the `filtered_alias_mode`
  * Allowed values: `warn` (default), `nowarn`, `disallow`
* Support for email address in certificates
  * The DN of node and admin certificates can now contain the (deprecated) emailAddress field
  * This is for backward compatibility, email addresses should usually be stored in the SAN entry
* Sanity checks for DLS/FLS settings
  * An error is now logged if invalid DLS/FLS settings are detected 


## Fixes
* Improve error message on key- and truststore location enhancement
  * Ported from Search Guard SSL to Search Guard
  * [https://github.com/floragunncom/search-guard/issues/339](https://github.com/floragunncom/search-guard/issues/339)  
* SSL client plugin requires "path.plugin" when it should not   
  * [https://github.com/floragunncom/search-guard/issues/369](https://github.com/floragunncom/search-guard/issues/369)
* Support relative and absolute locations for PEM certificates in sgadmin
* Improved error messages in case of faulty node certificate settings
  * So far, in almost all cases a "Bad Headers" exception was logged 
* Search Guard not initialized Elasticsearch 5.5.0 - no permissions for indices:admin/exists
  * [https://github.com/floragunncom/search-guard/issues/366](https://github.com/floragunncom/search-guard/issues/366)
  * Add explanatory message in sgadmin output