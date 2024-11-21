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

**Release Date: 2024-11-13**

## New Feature

### Data streams and aliases

You can now use data steams and aliases instead of directly specifying indices. 

* [Documentation](../_docs_roles_permissions/configuration_roles_permissions.md#alias-and-data-stream-level-permissions)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/879)
* [Issue: First class support for privileges on aliases and data streams](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/273)

Permissions can also be configured using Kibana UI.

* [Issue: Extend roles ui for data streams and aliases](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/493)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/993)


## Improvements

### New DLS configuration option

DLS can now be configured with additional option of `force_min_doc_count_to_1`, in order to work around cases where `min_doc_count` is `0`, see following example:

```
dls:
  force_min_doc_count_to_1: false | true # Default is false
```

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/827)

### New audit log dashboard templates

You can now install default audit log dashboard template available at:

`Searchguard` -> `Configuration` -> `System Status` -> `Templates`

* [Issue: Add templates like the audit log templates to the website](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/499)

### signals.watch_log.mapping_total_fields_limit configuration option added to signals

Property `mapping.total_fields.limit` is added to signals configuration options with default value of `2000`. This can be configured using `signals.watch_log.mapping_total_fields_limit`.
Setting this value to `-1` will store the content of the `data` field in the log index but it will not be searchable.

* [Issue: Signals: index template for signals logs](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/366)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/967)

### signals.worker_threads.pool.max_size

The maximum default signals threads per tenant is now `5`. This can be configured using `signals.worker_threads.pool.max_size`.

* [Issue: Signals: increase default thread pool size](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/365)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/968)

### BREAKING: exclude_index_permission removed

`exclude_index_permission` has been removed. Further details can be found at [support removed for exclude_index_permissions](../_docs_roles_permissions/configuration_roles_permissions.md#support-removed-for-exclude_index_permissions)

* [Issue: Remove exclude_index_permissions](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/359)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/928)

### BREAKING: changes to auth-token in mix cluster not supported

When upgrading cluster to FLX 3.0. Any changes to auth-tokens are not supported and will potentially not work correctly. Ensure any changes like adding, updating or deleting auth-token are performed on the cluster either before or after the migration to FLX 3.0.

### BREAKING: legacy implementation of DLSFLS removed

In order to avoid data leaks, the DLS/FLS implementation must be switched before performing the upgrade to SG FLX 3.0

To migrate safely follow the below procedure:

  1. Edit sg_authz_dlsfls.yml and set `use_impl: flx`
  2. If settings related to field masking were previously listed in `elasticsearch.yml`, these need to be moved to `sg_authz_dlsfls.yml`:
  - `searchguard.compliance.mask_prefix` must be moved to `field_anonymization.prefix`
  - If blake2b hashes shall remain consistent before and after the update:
    - `searchguard.compliance.salt` must be moved to `field_anonymization.personalization`.
    - If `dynamic.field_anonymization_salt2` in `sg_config.yml` is not set then `field_anonymization.salt` must be set to `null`, otherwise `field_anonymization.salt` must be set to relevant value.
  - If consistency of blake2b hashes is not necessary before and after the update, `searchguard.compliance.salt` can be moved to `field_anonymization.salt`.

If `use_impl: flx` is not configured before upgrading, DLS/FLS/FM can become inoperable in mixed clusters and can potentially expose information to unauthorized users.
{: .note .js-note .note-warning}

### Kibana dark mode 

Kibana dark mode is now fully functional.

* [Issue: Improve support for dark mode](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/496)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1005)

### Improved authentication errors

Improved authentication error message if user doesn't have tenant assigned or roles mapped.

* [Issue: Improve authentication error message when a user doesn't have any tenants or roles](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/480)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1005)

## Bug fixes

### Bug in field anonymization in DLS/FLS and MessageDiggest fixed

MessageDiggest is no longer shared between threads. The field anonymization in DLS/FLS was affected.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/988)

### Stabilized scheduling for schedulers with overload

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1013)

### Fixed OIDC response processing

`expires_in` is no longer required in OIDC response

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/993)

### Fixed permission needed for indices:data/read/close_point_in_time

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1027)

### Read-only user and bulk updates

Read-only user can now view bulk updates when dashboards are open

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/825)

### Signals: Error detail fixed

Signal Error Details button in Kibana now displays the correct error message

* [Issue: Signals: Error detail seems to be broken](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/487)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1012)

### Redirection to login page after token expired

MT no longer redirects to the login page if the session token is expired

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1011)