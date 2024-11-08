---
title: Search Guard FLX 3.0.0
permalink: changelog-searchguard-flx-3_0_0
category: changelogs-searchguard
order: -1090
layout: changelogs
description: Changelog for Search Guard FLX 3.0.0
---

<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 3.0.0

**Release Date: 2024-05-15 <to be updated>**

## Data streams and aliases

You can now use data steams and aliases instead of directly specifying indices. 

* [Documentation](../_docs_roles_permissions/configure_roles_permissions.md#alias-and-data-stream-level-permissions)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/879)
* [Issue: First class support for privileges on aliases and data streams](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/273)

Permissions can also be configured using Kibana UI.

* [Issue: Extend roles ui for data streams and aliases](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/493)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/993)

## New DLS configuration option

DLS can now be configured with additional option of `force_min_doc_count_to_1`, in order to work around cases where `min_doc_count` is `0`, see following example:

```
dls:
  force_min_doc_count_to_1: false | true # Default is false
```

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/827)

## New audit log dashboard templates

You can now install default audit log dashboard template available at:

`Searchguard` -> `Configuration` -> `System Status` -> `Templates`

## Signals properties

### Breaking change: `signals.watch_log.mapping_total_fields_limit` configuration option added to signals

Property `mapping.total_fields.limit` is added to signals configuration options with default value of `2000`. This can be configured using `signals.watch_log.mapping_total_fields_limit`. If you were previously querying runtime data in signals (which should only have been used for debugging), this will not be possible going forward and therefore this is marked as **Breaking change**.

* [Issue: Signals: index template for signals logs](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/366)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/967)

### `signals.worker_threads.pool.max_size`

The maximum default signals threads per tenant is now `5`. This can be configured using `signals.worker_threads.pool.max_size`.

* [Issue: Signals: increase default thread pool size](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/365)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/968)

## BREAKING: `exclude_index_permission` removed

`exclude_index_permission` has been removed. Further details can be found here(TODO)

* [Issue: Remove exclude_index_permissions](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/359)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/928)

## BREAKING: changes to auth-token in mix cluster not supported

When upgrading cluster to FLX 3.0. Any changes to auth-tokens are not supported and will potentially not work correctly. Ensure any changes like adding, updating or deleting auth-token are performed on the cluster either before or after the migration to FLX 3.0.

## Improvements

### Kibana dark mode 

Kibana dark mode is now fully functional.

* [Issue: Improve support for dark mode](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/496)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1005)

### Improved authentication errors

Improved authentication error message if user doesn't have tenant assigned or roles mapped.

* [Issue: Improve authentication error message when a user doesn't have any tenants or roles](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/480)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1005)

## Bug fixes

Bug in field anonimization in DLS/FLS fixed

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/988)

## Read-only user and bulk updates

Read-only user can now view bulk updates when dashboards are open

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/825)

## Signals: Error detail fixed

Signal Error Details button in Kibana now displays the correct error message

* [Issue: Signals: Error detail seems to be broken](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/487)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1012)

## Redirection to login page after token expired

MT no longer redirects to the login page if the session token

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1011)