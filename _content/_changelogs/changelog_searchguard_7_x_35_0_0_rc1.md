---
title: Search Guard 7.x-35.0.0-rc1
permalink: changelog-searchguard-7-x-35_0_0_rc1
layout: changelogs
description: Changelog for Search Guard 7.x-35.0.0-rc1
---
<!---
Copyright 2020 floragunn GmbH
-->

# Changelog for Search Guard 7.x-35.0.0-rc1

**Release Date: 30.04.2019**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7)

## Changes 

* This version is based on [6.7.x-25.0](https://docs.search-guard.com/6.x-25/changelog-searchguard-6-x-25_0) and contains all features from this version
* The code of the former [standalone SSL Plugin](https://github.com/floragunncom/search-guard-ssl) was merged into the [Search Guard codebase](https://github.com/floragunncom/search-guard). So for Search Guard 7 the `search-guard-ssl` github repository is no longer relevant. 

### BREAKING: Support for document types and tribe nodes removed

Elasticsearch 7 does no longer support [document types](https://www.elastic.co/guide/en/elasticsearch/reference/current/removal-of-types.html){:target="_blank"} and [tribe nodes](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/breaking-changes-7.0.html){:target="_blank"}. We removed those features now also from Search Guard.

### BREAKING: Deprecated endpoints from REST management API removed

The following endpoints were removed:

```
/_searchguard/api/actiongroup/
# Use /_searchguard/api/actiongroups/ instead

/_searchguard/api/configuration/{configname}
# Use /_searchguard/api/{configname}/ instead

/_searchguard/api/user/
# Use /_searchguard/api/internalusers/ instead
```

### BREAKING: New configuration format

With Search Guard 7 we introduce a new configuration format to fix a few longstanding issues and to remove the document type level security from it.

The new format is documented here:

* [Search Guard Configuration](authentication-authorization-configuration)
* [Internal users](internal-users-database)
* [Roles Mapping](mapping-users-roles)
* [Action Groups](action-groups)
* [Search Guard Roles](action-groups)
* [Kibana Tenants](kibana-multi-tenancy)

Notable changes and improvements at a glance:

* The new format does now allow dots (`.`) in index names and regular expressions
* Every file now has mandatory `_sg_meta` header
* Structure and wording is now more precise, aligned and extensible
* Additional config file for tenants (`sg_tenants.yml`)

If you do a migration from Elasticsearch/Search Guard 6.x please refer to the [upgrade instructions](sg-upgrade-6-7) to learn how to migrate the configuration to it's new format.

If you are using the REST API, you will likely need to change the payload processing of your calls slightly.

For the final release we will also provide a standalone tool to migrate the configuration offline (migrate.sh).

### BREAKING: Config format validation

Search Guard 6 and before the configuration syntax check were lenient. This can easily lead to misconfiguration. With Search Guard 7 there is now a strict config syntax validation which rejects invalid syntax as well as configuration parameters which do not exist. The REST API and sgadmin will automatically apply these checks. 

But in case you are upgrading from 6.x you have to do this one time manually. Please refer to the [upgrade instructions](sg-upgrade-6-7) in this case. If you miss this step your cluster can become uninitialized which will result in a downtime.

### BREAKING: Default changed for snapshot/restore handling

The default of `searchguard.enable_snapshot_restore_privilege` changed from `false` to `true` (in elasticsearch.yml). This will allow restore operations also for regular users without an admin certificate as long as the snapshot does not contain the global cluster state or the searchguard index. See [Enabling snapshot and restore for regular users](https://docs.search-guard.com/latest/snapshot-restore#enabling-snapshot-and-restore-for-regular-users) for more details.

### BREAKING: Default changed for permissions evaluation across different roles (multi-rolespan)

Before 7.x-35.0.0-rc1 the default was to grant permissions only, if a single role contained all grants necessary to allow a request.
Since 6.x-22.3 there is the `multi_rolespan_enabled` config option in sg_config.yml to override this behaviour. The default now changes from `multi_rolespan_enabled: false` to `multi_rolespan_enabled: true`. This means that a request will be permitted when the combination of all grants from all roles, the user is assigned to, are sufficient to allow access.

### BREAKING: Default changed for XFF (x-forwarded-for) support

The default changed from `xff.enabled: true` to `xff.enabled: false` (in sg_config.yml)

### New feature: Built-in configuration resources

Search Guard 7 ships with built-in roles and actiongroups. Those are static and unchangeable and will be maintained from release to release by us.
We strongly recommend to use them where ever possible and prefer them over your own roles and actiongroups. Albeit recommended their usage is not mandatory.

* [Built-in Roles](roles-permissions#built-in-roles)
* [Built-in Action Groups](action-groups#built-in-action-groups)

All built-in resource are uppercase and start with `SGS_`.

### New feature: Tenant endpoint for REST management API

For the new tenant file there is now also a corresponding tenant REST API endpoint `/_searchguard/api/tenants/`.
Please refer to the [documentation](rest-api-tenants) for any details.

### New feature: New options for sgadmin to support migration and backups

sgadmin now has this additional command line options:

* `-migrate <folder>` to automatically migrate configuration to the new format when upgrading from 6.x to 7.x., see [here for more details](sg-upgrade-6-7)
* `-vc <version>` to validate the configuration
* `-backup <folder>` to backup the configuration

### Known Issues
There is a known issue in this release with regards to Kibana Multi-Tenancy when upgrading from Elasticsearch 6. After upgrading the cluster the first attempt to start Kibana 7 may fail with an "index template missing exception" error message. In this case, the workaround is to stop Kibana and start it again. The second attempt to start Kibana 7 will then be successful.