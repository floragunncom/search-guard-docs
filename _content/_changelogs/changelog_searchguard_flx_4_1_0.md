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

A new privilege `SGS_FAILURE_STORE_ACCESS` must be explicitly granted in a role's `allowed_actions` allow access to the failure store. Normal privileges such as `SGS_READ` or `SGS_CRUD` are not sufficient.

The privilege can be granted via the following role definition sections:

- `data_stream_permissions` \- when the index_pattern specifies a pattern matching a data stream
- `alias_permissions` \- an alias that includes a data stream with an enabled failure store


Note: DLS, FLS, and field masking are not supported for failure store documents and should not be combined with failure store access.

Note: This feature requires Elasticsearch 9.3.0 or newer.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1485)
* [Documentation](roles-permissions#accessing-the-data-stream-failure-store)

### Signals: Signl4 action support

Signals can now send alerts to <a href="https://www.signl4.com/" target="_blank" rel="noopener">Signl4</a> using a dedicated action type.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1124)
* [Documentation](elasticsearch-alerting-actions-signl4)

## Improvements

### OIDC: dynamic frontend URL support

The OIDC authenticator now supports a `use_dynamic_frontend_url` configuration option. When enabled, the OIDC redirect URI is built from the frontend URL detected in the incoming request rather than the static `frontend_base_url` defined in `sg_authc.yml`. This allows OIDC authentication to work correctly when Kibana is accessible from multiple different hostnames or URLs.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/710)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1454)
* [Documentation](kibana-authentication-openid-advanced-config#dynamic-frontend-url)

### Audit log: HTTP headers included in Kibana login and logout events

`KIBANA_LOGIN` and `KIBANA_LOGOUT` audit log events now include HTTP request headers, consistent with other REST audit events. Sensitive headers are still excluded according to the configured `exclude_sensitive_headers` setting.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/724)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1481)

## Bug fixes

### Signals: Tenant names with spaces now work correctly in API paths

Signals API requests for tenants with spaces in their names (e.g. `admin tenant`) were failing due to incorrect handling of the tenant name in the URL. This has been fixed.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/717)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1451)

### Kibana login page: custom button styling now works

`login_page.button_style` in `sg_frontend_authc` now correctly applies styles to the Kibana login button.

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/work_items/573)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1127)
* [Documentation](kibana-login-customizing#customizing-the-login-page)

### Dashboard share URLs now keep the correct tenant

URLs and embeds copied from share dialogs now correctly include the target tenant.

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/work_items/561)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1109)

### Fixed issue with Kibana and proxy authentication
Under certain conditions, Kibana would fail with client side errors when proxy authentication was used. This has been fixed.

### Configuration variables not resolved at node startup

Fixed an issue with configuration variable loading on cluster startup.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/288)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1354)

## Security Fixes

### Search Guard audit logs can contain under certain conditions user credentials

In Search Guard FLX versions from 1.0.0 up to 4.0.1, the audit logging feature might log user credentials from users logging into Kibana.

If you cannot upgrade right away, you can mitigate the issue by, disable request-body logging, either globally `searchguard.audit.log_request_body: false` or specifically `searchguard.audit.ignore_request_bodies: ["*/_searchguard/auth/session*"]`, more details here: https://docs.search-guard.com/latest/audit-logging-compliance#logging-the-request-body and here: https://docs.search-guard.com/latest/audit-logging-compliance#excluding-request-bodies

Details will be made available on the [CVE Advisory Page](https://search-guard.com/cve-advisory/)

### Some management operations on data streams are not properly restricted when user does not have the necessary privileges

In Search Guard FLX versions from 3.0.0 up to 4.0.1, there exists an issue which allows users without the necessary privileges to execute some management operations against data streams.

If you cannot upgrade right away, you can mitigate the issue by adding `indices:admin/data_stream/modify` to property `searchguard.admin_only_indices` in the `elasticsearch.yml`.

Details will be made available on the [CVE Advisory Page](https://search-guard.com/cve-advisory/)

### Open redirect vulnerability in Search Guard Kibana Plugin via manipulated requests

In Search Guard FLX up to version 4.0.1, it is possible to use specially crafted requests to redirect the user to an untrusted URL.

Details will be made available on the [CVE Advisory Page](https://search-guard.com/cve-advisory/)
