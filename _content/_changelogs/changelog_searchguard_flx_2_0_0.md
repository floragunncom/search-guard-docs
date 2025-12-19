---
title: Search Guard FLX 2.0.0
permalink: changelog-searchguard-flx-2_0_0
layout: docs
section: security
description: Changelog for Search Guard FLX 2.0.0
---
<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 2.0.0

**Release Date: 2024-05-15**

<span style="color:red">If you're upgrading to SG FLX 2.0.0, please review [the upgrade guide](sg-200-upgrade).
This version introduces backwards-incompatible changes.</span>
{: .note .js-note .note-warning}

## Multi-Tenancy
<span style="color:red">**Please make sure to read the documentation for [upgrading to Search Guard FLX 2.0.0](sg-200-upgrade)**</span>

### BREAKING: Multi-Tenancy has been reimplemented

Search Guard no longer maintains separate indices for each tenant. Instead, when multi-tenancy is enabled, it modifies saved objects
on the storage level. The IDs of saved objects are extended with the tenant ID, and a new attribute `sg_tenant` is added 
to each saved object, which contains the tenant ID. Search Guard modifies all saved objects except those belonging to the Global tenant.

### BREAKING: The Kibana Multi-Tenancy configuration has moved to the backend plugin

The Multi-Tenancy configuration has been moved from the Kibana plugin to the Elasticsearch plugin, and will need to be removed from `kibana.yml`.
Instead, some of the settings are now available in `sg_frontend_multi_tenancy.yml`.
Some settings have been removed, including support for the private tenant.
This applies to the settings prefixed `searchguard.multitenancy.`:


| Setting                   | Status          | Corresponding setting in sg_frontend_multi_tenancy.yml |
| ------------------------- |-----------------| ------------------------------------------------------ |
| enabled                   | moved           | enabled                                                |
| tenants.enable_global     | moved           | global_tenant_enabled                                  |
| tenants.enable_private    | removed         |                               |
| tenants.preferred         | moved           | preferred_tenants                                      |
| show_roles                | removed         |                                                        |
| enable_filter             | removed         |                                                        |
| saved_objects_migration.* | removed         |                                                        |
| debug                     | still available |


### BREAKING: Support for Private tenants have been removed

Private tenants are no longer supported. 

You can still use the Global tenant and define an arbitrary number of additional tenants in `sg_tenants.yml`.

### BREAKING: Permissions required to authorize users to access the Kibana user interface have been changed
If Multi-Tenancy is disabled, then the following roles `SGS_KIBANA_USER`, `SGS_KIBANA_USER_NO_GLOBAL_TENANT` and `SGS_KIBANA_USER_NO_DEFAULT_TENANT` are insufficient for a user to access the Kibana user interface. The role `SGS_KIBANA_USER_NO_MT` should be used instead. For more details, please see [Search Guard 2.0.0 Upgrade Guide](sg-200-upgrade).

## Bug Fixes

### Signals: Could not delete an alert from the execution history
Deleting an alert from the watch execution history returned an error.
* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/494)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/957)