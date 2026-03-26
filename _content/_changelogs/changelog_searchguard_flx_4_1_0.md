---
title: Search Guard FLX 4.1.0
permalink: changelog-searchguard-flx-4_1_0
layout: docs
section: security
description: Changelog for Search Guard FLX 4.1.0
---
<!--- Copyright 2026 floragunn GmbH -->
# Search Guard FLX 4.1.0

**Release Date: 2026-03-25**

## New features

### Data stream failure store support

Search Guard now supports access control for [data stream failure stores](roles-permissions#accessing-the-data-stream-failure-store). A failure store holds documents that could not be indexed into the main data stream due to errors such as mapping conflicts or ingest pipeline failures.

A new privilege `SGS_FAILURE_STORE_ACCESS` must be explicitly granted in a role's `allowed_actions` to allow access to the failure store. Normal privileges such as `SGS_READ` or `SGS_CRUD` are not sufficient.

Note: DLS, FLS, and field masking are not supported for failure store documents and should not be combined with failure store access.

Note: This feature requires Elasticsearch 9.3.0 or newer.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/656)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1485)

### Signals: Signl4 action support

Signals now includes a dedicated Signl4 action, making it easier to route alerts to Signl4 from within the existing action configuration flow.

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/work_items/566)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1124)
* [Documentation](elasticsearch-alerting-actions-signl4)

## Improvements

### OIDC: dynamic frontend URL support

The OIDC authenticator now supports a `use_dynamic_frontend_url` configuration option. When enabled, the OIDC redirect URI is built from the frontend URL detected in the incoming request rather than the static `frontend_base_url` defined in `sg_authc.yml`. This allows OIDC authentication to work correctly when Kibana is accessible from multiple different hostnames or URLs.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/710)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1454)

### Signals: watches can now search remote cluster indices

Signals watches support cross-cluster search in their search inputs. Indices on remote clusters can be referenced using the standard `<remote_cluster>:<index>` syntax (e.g. `my_remote:my-index`). Access control is enforced on both the coordinating and the remote cluster.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/169)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1374)


### Audit log: HTTP headers included in Kibana login and logout events

`KIBANA_LOGIN` and `KIBANA_LOGOUT` audit log events now include HTTP request headers, consistent with other REST audit events. Sensitive headers are still excluded according to the configured `exclude_sensitive_headers` setting.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/724)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1481)

## Bug fixes

### Configuration variables not resolved at node startup

Configuration variables could remain unresolved if the variable service had not finished initializing when the configuration was first loaded. Search Guard now waits for the variable service to be ready before loading configuration, ensuring variables are correctly substituted from the start.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/288)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1354)

### Signals: URL-encoded tenant names in API paths now handled correctly

Signals API requests using URL-encoded tenant names (e.g. `admin%20tenant`) were not being decoded, causing tenant resolution to fail. These are now correctly decoded.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/717)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1451)

### Kibana login page: custom button styling now works

Custom styling configured via `login_page.button_style` in `sg_frontend_authc` now correctly appears on the Kibana login page, making login page branding behave as expected.

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/work_items/573)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1127)

### Dashboard share URLs now keep the correct tenant

When multitenancy was enabled, dashboard share URLs could be generated with an incorrect or missing tenant, causing links or embeds to open in the wrong tenant context. Share URLs now correctly preserve the active tenant.

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/work_items/561)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1109)

## More fixes

This update includes a number of further minor fixes. See [the Gitlab milestone](https://git.floragunn.com/groups/search-guard/-/milestones/27) for all details.