---
title: Search Guard FLX 4.2.0
permalink: changelog-searchguard-flx-4_2_0
layout: docs
section: security
description: Changelog for Search Guard FLX 4.2.0
---
<!--- Copyright 2026 floragunn GmbH -->
# Search Guard FLX 4.2.0

**Release Date: 2026-09-18**

## Upgrade Notice

When you are upgrading from 9.4.x to 9.5.x, the suggest feature is insecure to use during the upgrade process in a mixed cluster when the cluster setting `search.batched_query_phase` is set to `true`.
In this case, set `search.batched_query_phase` to `false` before you start the upgrade and re-enable it after all nodes have been upgraded.

## Security Fixes

### Transforms can leak data under some circumstances

In Search Guard FLX versions before 4.2.0, the transform API can leak data under some circumstances.

Search Guard FLX 4.2.0 ensures proper transform action authorization and adds some further safeguards to prevent data leakage.

If you can't upgrade yet, we recommend removing the transform cluster privileges from all users.


Details will be made available on the [CVE Advisory Page](https://search-guard.com/cve-advisory/).


## New features

### New oidc_userinfo backend for JWT authentication domains

If the JWT does not contain all claims required for user mapping, Search Guard can now retrieve additional claims from the OIDC UserInfo endpoint.
The JWT is sent to the endpoint as a bearer access token, and the returned claims are available under `oidc_user_info`.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/728)
* [Documentation](json-web-tokens-advanced#retrieving-additional-claims-from-the-oidc-userinfo-endpoint)

### Support dynamic authentication methods by Kibana host name

If a Kibana instance is available under several host names, you can use `enable_by_host` to make authentication domains available only on particular hosts. 
This can be useful, for example, when a single Kibana instance serves several customers that use different identity providers.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/729)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1615)
* [Merge Request Kibana](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1228)
* [Documentation](kibana-multiple-authentication-methods)

### Support for lowercasing JWT claim values

Adds optional lowercase normalization to user mappings configured in sg_authc.yml.
The conversion settings are parsed within the corresponding mapping specifications and applied before the final user object is created.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/753)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1598)
* [Documentation](authentication-authorization-configuration-advanced-user-mapping)

### Signals: Add support for tenant-scoped accounts

Search Guard FLX 4.2.0 introduces tenant-scoped Signals accounts alongside existing tenant-independent accounts.
Tenant accounts are available only to watches in the same tenant, with tenant-independent accounts retained as a fallback.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/738)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1588)
* [Issue Kibana](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/623)
* [Merge Request Kibana](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1229)
* [Documentation](elasticsearch-alerting-accounts)

## Improvements

### Add desired_balance permissions to SGS_XP_MONITORING

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/789)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1600)

## Bug fixes

### Restore case-insensitive REST header lookup in user mapping attributes

This fixes a regression introduced in Search Guard FLX 4.1.2: the normalization of REST request headers
for user mapping attributes broke proxy authentication in Kibana.

* [Issue Kibana](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/619)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1620)

### Fixed sgctl hanging when only a single CPU core is assigned to the ES node

Fixes an sgctl deadlock on nodes with a single CPU core.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/756)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1599)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1608)

### Fixed FLS nested field behavior

An FLS nested field was not returned when another role had the same nested field in an FLS rule or excluded the parent field.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/744)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/750)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1585)

### Signals: Fixed watches not being shown in the operator view in the global tenant

Watches were not loaded in the operator view when multitenancy was enabled and the global tenant was selected.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/727)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/1509)

### Signals: Fixed watches created via Kibana not triggering alerts

Watches using the Graph watch type with severity enabled no longer get a default > 1000 threshold condition added on save, which could stop severity alerts from triggering. Re-save affected watches to restore alerting.

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/557)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1223)


### Signals: Fixed the email action GUI overriding the configured default sender

An account’s default_from mail address was overwritten by the UI’s default value 'signals@localhost'. Clearing that default value stored an action with an empty from address instead of falling back to the account default, which caused mail delivery to fail.

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/616)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/1219)

### Signals: Fixed navigation visibility

Fixed an issue where the Signals navigation entry was displayed even when Signals was not available to the current user.

### Various version updates of third-party libraries


