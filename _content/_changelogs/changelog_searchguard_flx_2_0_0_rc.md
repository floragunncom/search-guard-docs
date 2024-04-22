---
title: Search Guard FLX 2.0.0 Release Candidate
permalink: changelog-searchguard-flx-2_0_0-rc
category: changelogs-searchguard
order: -1070
layout: changelogs
description: Changelog for Search Guard FLX 2.0.0 Release Candidate
---

<!--- Copyright 2024 floragunn GmbH -->

# Search Guard FLX 2.0.0 Release Candidate

**Release Date: 2024-05-15**

<span style="color:red">If you're upgrading to SG 2.0.0, please review [the upgrade guide](../_docs_installation/sg200_upgrade.md).</span>

## Multi tenancy
<span style="color:red">**Please make sure to read the documentation for [upgrading to Search Guard FLX 2.0.0](../_docs_installation/sg200_upgrade.md)**</span>

### BREAKING: The Kibana multi tenancy configuration has moved to the backend plugin

The multi tenancy configuration has been moved from the Kibana plugin to the Elasticsearch plugin, and will need to be removed from `kibana.yml`.
Instead, some of the settings are now available in `sg_frontend_multi_tenancy.yml'.
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


