---
title: Upgrade to 2.0.0
html_title: Migrating from Elasticsearch and Kibana 8.7.x versions to 8.8.0
permalink: sg-200-upgrade
category: installation
order: 400
layout: docs
edition: community
description: How to upgrade Search Guard from versions 1.x.x to 2.x.x
---
<!---
Copyright 2024 floragunn GmbH
-->

# Upgrade from Search Guard FLX 1.x.x to 2.0.0

Search Guard 2.0.0 is not backwards compatible with previous versions. If you want to upgrade from version 1.x.x to 2.0.0, you will need to follow some additional steps. However, the upgrade process will differ for environments with and without the multitenancy feature enabled. It is strongly recommended that you read the entire page and clarify all doubts before starting the upgrade.

# How to check if multitenancy is enabled
To verify if multitenancy is enabled, please check the Kibana configuration file and the existence of indices dedicated to each tenant.
(For future information, please refer to the [documentation](../_docs_kibana/kibana_multitenancy.md)).

## Upgrading environments with disabled multitenancy 
The upgrade procedure for environments with disabled multitenancy is straightforward and cannot be applied when the multitenancy feature is enabled. Additional actions are mandatory in environments where the Kibana operates. Search Guard provides predefined roles for users who are authorized to access the Kibana interface, such as `SGS_KIBANA_USER`, `SGS_KIBANA_USER_NO_GLOBAL_TENANT`, `SGS_KIBANA_USER_NO_DEFAULT_TENANT`. Users with these roles cannot access the Kibana user interface when Search Guard is upgraded to version 2.0.0, and multitenancy is disabled. The system administrator should assign or map the `SGS_KIBANA_USER_NO_MT` role to users accessing the Kibana.

## Upgrading environments with enabled multitenancy


> **VERY IMPORTANT FOR DATA SAFETY**                                                    
> 
> Before starting Search Guard's upgrade from version 1.x.x to a newer version along with Search Guard 2.0.0, you need to back up your whole cluster. Furthermore, it is strongly advised that the upgrade procedure is tested first in a test environment containing a copy of the production cluster. If everything goes well, repeat the same procedure for the production cluster. The upgrade procedure can only be performed when an upgraded environment works with installed Search Guard 1.4.0 and Elasticsearch 8.7.1.
> 
> To perform an upgrade the system administrator should follow these steps:
>  1. Backup upgraded cluster
      * Execute a comprehensive cluster backup with installed Search Guard 1.x.x.
> 2. Upgrade Elasticsearch and Search Guard to version 8.7.1 and 1.4.0, respectively.
> 3. Stop Kibana
>    * Kibana must be shut down before and during the upgrade from Search Guard 1.x.x to 2.0.0
> 4. Upgrade Search Guard to version 2.0.0 and Elasticsearch to version required by the Search Guard
>    * Upgrade both Elasticsearch and Search Guard to the desired versions.
> 4. Perform frontend data migration
>    * Execute the necessary data migration procedures.
> 5. Upgrade Kibana
>    * Upgrade Kibana to the corresponding version.
>    * Install Kibana plugin
>    * From this point in time, the administrator can start Kibana.
> ### Troubleshooting
> 
> In case of any issues, if the cluster encounters problems, the administrator should consider reverting to the previously backed-up version.
> 
> ### Cluster Restoration
> 
> If needed, the administrator should restore the cluster to the version from which the upgrade was initiated. A full backup is necessary before the upgrade due to the impossibility of downgrading Elasticsearch. Additionally, the administrator should know that Search Guard may be partially backwards compatible between versions 1.x.x and 2.0.0.

### Multi Tenancy feature

Search Guard 2.0.0 contains a new multitenancy feature implementation. This implementation is not backwards compatible, and its behaviour might differ slightly from that used in Search Guard 1.x.x. Therefore, the system administrator is advised to familiarize themselves with the [limitations](../_docs_kibana/kibana_multitenancy.md#limitations-of-multi-tenancy-implementation-in-searchguard-2xx) related to the new implementation. Furthermore, the implementation of the new multitenancy feature does not support private tenants.

### Upgrading steps

1. Please download the new software versions from the following links:

- SG plugin for Elasticsearch 8.8.0:
[Download](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-elasticsearch-plugin/1.5.0-es-8.8.0/search-guard-flx-elasticsearch-plugin-1.5.0-es-8.8.0.zip)
- SG plugin for Kibana 8.8.0:
[Download](https://maven.search-guard.com/search-guard-flx-release/com/floragunn/search-guard-flx-kibana-plugin/1.5.0-es-8.8.0/search-guard-flx-kibana-plugin-1.5.0-es-8.8.0.zip)


2. Upgrade the Elasticsearch nodes to version 8.8.0

Following the successful upgrade of Elasticsearch to version 8.8.0 using the provided
SG snapshot, you are now ready to restart your Elasticsearch nodes in a standard manner.

3. In this instance, it is not necessary to initiate the data-migration process using the `sgctl` tool.


4. Upgrade Kibana to Version 8.8.0 with the New SG Plugin (`search-guard-flx-kibana-plugin-1.5.0-es-8.8.0`)

In this step, kindly proceed with the upgrade of Kibana to version 8.8.0, utilizing the provided SG plugin, specifically `search-guard-flx-kibana-plugin-1.5.0-es-8.8.0`.
Following the upgrade, restart Kibana in the usual manner. Subsequently, upon Kibana's successful restart, please collect the Kibana logs as well as the Elasticsearch logs. Ensure to maintain a copy or backup of these logs for reference.


5. Assign roles in Kibana

When MT is enabled, the system administrator should assign one of predefined roles to users accessing the Kibana:

* SGS_KIBANA_USER_NO_GLOBAL_TENANT

  Provides the minimum permissions for a kibana user in environment with enabled multi-tenancy, but without Global Tenant
* SGS_KIBANA_USER

  Provides the minimum permissions for a kibana user in environment with enabled multi-tenancy

> Each user needs to have at least one tenant configured, otherwise Search Guard
> does not know which tenant to use. If you disable the Global tenant,
> and the user does not have any other tenants configured, login will not be possible.
> 
> If a user has assigned direct access privileges to the Kibana-related indices, 
> then the user can bypass MT restriction.

6. Verification of SG-Tenants and Kibana Saved Objects (KSO) Migration

Upon completing the upgrade, log in to Kibana and thoroughly verify that all SG-Tenants, along with all Kibana Saved Objects within those Tenants, have been accurately and completely migrated.
After this verification process, kindly reach out to us again, providing details of your results.

---
Indices utilized by Kibana in version 8.8.0 or newer include: 
* .kibana 
* .kibana_analytics
* .kibana_ingest
* .kibana_security_solution
* .kibana_alerting_cases.

Official Kibana [documentation](https://www.elastic.co/guide/en/kibana/current/saved-object-migrations.html)