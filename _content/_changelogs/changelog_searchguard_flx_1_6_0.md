---
title: Search Guard FLX 1.6.0
permalink: changelog-searchguard-flx-1_6_0
category: changelogs-searchguard
order: -1070
layout: changelogs
description: Changelog for Search Guard FLX 1.6.0
---

<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 1.6.0

**Release Date: 2024-02-05**

This is a new minor release of Search Guard FLX.

It brings **[<span style="color:red">one breaking change</span>](#make-error-message-about-missing_permissions-less-verbose)**, 
some new features, some bug fixes, and updates a number of dependencies.

## New features

### Auth Token cache should be configurable

You can now configure the Auth Token cache.

* [Documentation](../_docs_auth_auth/auth_auth_sg_auth_token.md#auth-token-cache)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/13)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/617)

### Config Vars: Support for base 64 and bcrypt encoding

Pipe expressions can be used to transform values of configuration variables.

* [Documentation](../_docs_configuration_changes/configuration_environment_variables.md#using-pipe-expressions)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/57)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/618)

### Signals: Global configuration for proxy settings

It is now possible to manage proxies via an API and then reference them in watches.

* [Documentation](../_docs_signals/proxies.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/123)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/556)

### Signals: Operator view

Introduces a new separate operator view which gives an overview over the current status of the watches and focuses on current issues.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/124)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/352)
* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/467)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/874)

## Improvements

### Make error message about missing_permissions less verbose

<span style="color:red">**This is a breaking change**.</span>

So far, error responses related to security exceptions have always included the `missing_permissions` attribute. From now on it will be hidden by default.
If you want these details to be included, you must enable authorization debugging mode.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/251)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/616)


### Support for json_file variable resolver

Adds a new variable resolver `json_file` that reads JSON files and provides their structure.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/608)

### Misleading error message when using private tenant with Signals search API

Fixes a confusing error message that was returned when a user tried to use Signals with a private tenant.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/34)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/609)

### Added explicit ldap_search_operation metrics

Adds explicit metrics about LDAP search operations.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/562)

### Enforce absolute paths for login page branding images

Improves login page branding images validation so that only absolute paths are accepted.

* [Documentation](../_docs_kibana/kibana_customize_login.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/109)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/565)

### AuthTokenService generates signing key but does not use it

Auth tokens are signed with default signing key in case of no explicit configuration.

* [Documentation](../_docs_auth_auth/auth_auth_sg_auth_token.md#configuring-keys)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/79)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/535)

### Improve validation in case tenant does not exist

Improves validation of tenants pointed in role permissions.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/167)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/587)

## Bug fixes

### _analyze API fails to execute in SG FLX if no index is provided

Fixes handling of requests sent to the `_analyze` API when no index is specified.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/240)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/652)

### Cannot delete configuration by type using request DELETE /_searchguard/config/authc

Fixes an endpoint which handles removal of the `authc` configuration.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/156)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/612)

### Headers are not case-insensitive

Fixes improper handling of HTTP Headers.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/276)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/598)

### Remove truststore only when it's not used by any watch

Allows removal of truststore only when it’s not in use.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/264)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/568)

### sg_frontend_multi_tenancy.yml in the example config directory is using the wrong format

Corrects an example of the frontend multi tenancy configuration.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/261)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/558)

### Node startup fails if there are files larger than 2 GB in the elasticsearch/config directory or subdirectories

Fixes a `java.lang.OutOfMemoryError` error that could occur when loading demo certificates on startup.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/259)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/559)

## More

* See the complete changes in the [Gitlab Milestone](https://git.floragunn.com/groups/search-guard/-/milestones/15)
