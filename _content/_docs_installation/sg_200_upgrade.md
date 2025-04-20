---
title: Upgrade Search Guard FLX to 2.0.0
html_title: Upgrade to Search Guard FLX to 2.0.0
permalink: sg-200-upgrade
layout: docs
edition: community
description: How to upgrade Search Guard from versions 1.x.x to 2.x.x
---
<!---
Copyright 2024 floragunn GmbH
-->

# Upgrade from Search Guard FLX 1.x.x to 2.0.0

Search Guard 2.0.0 is not backwards compatible with previous versions. If you want to upgrade from version 1.x.x to 2.0.0, you will need to follow some additional steps. However, the upgrade process will differ for environments with and without the Multi-Tenancy feature enabled. It is strongly recommended that you read the entire page and clarify all doubts before starting the upgrade.

## How to check if Multi-Tenancy is enabled
To verify if Multi-Tenancy is enabled, please check the Kibana configuration file and the existence of indices dedicated to each tenant.
(For future information, please refer to the [documentation](../_docs_kibana/kibana_multitenancy.md)).

## Upgrading environments with disabled Multi-Tenancy 
The upgrade procedure for environments with disabled Multi-Tenancy is straightforward, but if you are using Kibana, it may be necessary to change the Kibana users' roles. Search Guard provides predefined roles for users who are authorized to access the Kibana interface, such as `SGS_KIBANA_USER`, `SGS_KIBANA_USER_NO_GLOBAL_TENANT`, `SGS_KIBANA_USER_NO_DEFAULT_TENANT`. However, if Multi-Tenancy is not enabled, users with these roles cannot access the Kibana user interface when Search Guard is upgraded to version 2.0.0. Instead, the system administrator should assign or map the `SGS_KIBANA_USER_NO_MT` role to users accessing Kibana.

## Upgrading environments with enabled Multi-Tenancy


> **VERY IMPORTANT FOR DATA SAFETY**                                                    
> 
> Before starting Search Guard's upgrade from version 1.x.x to a newer version along with Search Guard 2.0.0, you need to back up your whole cluster. Furthermore, it is strongly advised that the upgrade procedure is tested first in a test environment containing a copy of the production cluster. If everything goes well, repeat the same procedure for the production cluster. The upgrade procedure can only be performed when an upgraded environment works with installed Search Guard 1.4.0 or 1.6.0 for Elasticsearch 8.7.x.
> ### Troubleshooting
> In case of any issues, if the cluster encounters problems, the administrator should consider reverting to the previously backed-up version.
> ### Cluster Restoration
> If needed, the administrator should restore the cluster to the version from which the upgrade was initiated. A full backup is necessary before the upgrade due to the impossibility of downgrading Elasticsearch.

### Multi-Tenancy feature

Search Guard 2.0.0 contains a new Multi-Tenancy feature implementation. This implementation is not backwards compatible, and its behaviour might differ slightly from that used in Search Guard 1.x.x. Therefore, the system administrator is advised to familiarize themselves with the [limitations](../_docs_kibana/kibana_multitenancy.md#limitations-of-multi-tenancy-implementation-in-for-flx-v200-and-higher) related to the new implementation. Furthermore, the implementation of the new Multi-Tenancy feature does not support private tenants.

### Upgrading steps
The upgrade procedure should first be carried out in the test environment, which is a copy of the production cluster. Once this test is accomplished successfully, you can upgrade the production environment.

1. Backup.\
   Preparing a backup is crucial due to Elasticsearch's inability to downgrade the cluster node. Therefore, if the upgrade procedure is not accomplished, you will need backups to restore the cluster to its previous version. Please use the following [documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) to create the cluster backup. Additionally, the system administrator should follow [Search Guard backup and restore guidance](search-guard-index-maintenance#backup-and-restore) to perform the backup of the Search Guard configuration. It is also worth testing if the created backups can be restored.

Moreover, support for users' private tenants has been removed, and the data associated with private tenants is not migrated to FLX 2.0.0. If data stored within the scope of private tenants is needed, the system administrator should prepare and test the procedure of exporting and importing such data via [Kibana Saved objects APIs](https://www.elastic.co/guide/en/kibana/current/saved-objects-api.html). However, due to the removal of private tenants, the data that belongs to users' private tenants in SG FLX 1.x.x must be assigned to the not-private tenant in SG 2.0.0.

2. Upgrade Search Guard to version 1.4.0 or 1.6.0 and Elasticseare to version 8.7.1\
The current step is associated with the usual Search Guard upgrade procedure conveyed by the following [documentation](./installation_upgrading.md).
3. Adjust Multi-Tenancy configuration.\
   Multi-Tenancy configuration in Search Guard versions before 2.0.0 was present in the `kibana.yml` file, e.g.
    ```yml
    searchguard.multitenancy.enabled: true
    searchguard.multitenancy.show_roles: true
    searchguard.multitenancy.enable_filter: true
    searchguard.multitenancy.tenants.enable_global: true
    searchguard.multitenancy.tenants.enable_private: true
    ```
    Search Guard 2.0.0 does not use the `kibana.yml` file to store the Multi-Tenancy configuration. Instead, the configuration file `sg_frontend_multi_tenancy.yml` is used. Therefore, proper configuration needs to be transferred to the `sg_frontend_multi_tenancy.yml` and **removed from the `kibana.yml` file**. The file's `sg_frontend_multi_tenancy.yml` syntax is covered in the [Multi-Tenancy configuration](../_docs_kibana/kibana_multitenancy.md#multi-tenancy-configuration) section. You will need the updated file version `sg_frontend_multi_tenancy.yml` later if the default configuration introduced in the Search Guard 2.0.0 is inappropriate for you. Example configuration which can be placed in the file `sg_frontend_multi_tenancy.yml`
    ```yml
    enabled: true
    server_user: kibanaserver
    global_tenant_enabled : true
    ```
4. Stop Kibana\
The Kibana should not work during further steps related to the upgrade.
5. Download new versions of the software.\
   You need a new version of the Search Guard plugins for Elasticsearch and Kibana, the `sgctl` tool, and the proper versions of Elasticsearch and Kibana. Search Guard 2.0.0 for Elasticsearch in versions 8.8.x, 8.9.x, 8.10.x, 8.11.x or 8.12.x is required to perform upgrade. Please use the [following page](search-guard-versions) to download the Search Guard plugin for Elasticsearch and Kibana, as well as `sgctl`.
6. Upgrade Search Guard and the Elasticsearch\
   Before performing the current step, you must review the Elasticsearch documentation for the proper version and check which additional steps and measures are required to upgrade Elasticsearch. Then, you can upgrade Elasticsearch and Search Guard on your cluster node. The upgrade procedure is described in the [Search Guard upgrade guide](upgrading#upgrading-elasticsearch-and-search-guard).
7. Migrate frontend data\
   The data structures used by the Multi-Tenancy implementation in SearchGuard 1.x.x and 2.0.0 are distinct. Therefore, running a data migration process is necessary to move Kibana Saved Objects (entities like data views and dashboards stored by Kibana in Elasticsearch). To conduct the data migration process, you need an up-to-date version of the `sgctl` tool. To carry out the data migration process, execute the command `sgctl special start-mt-data-migration-from-8.7`. The command execution should be above a few minutes, depending on the number of tenants defined in your environment and the volume of data stored in the Kibana indices. You can check the status of the data migration process using the command `sgctl special get-mt-data-migration-state-from-8.7`. The administrator must successfully execute data migration before proceeding with further upgrade steps. It is important to note that the system administrator should not run the data migration process in parallel, and the Kibana should be shut down during this process. Please note that Multi-Tenancy is disabled by default in the Search Guard 2.0.0 or newer. The command used for data migration will enable the Multi-Tenancy if needed.
8. Upgrade Kibana\
   In this step, please proceed with upgrading Kibana to a version corresponding to Elasticsearch and install the Search Guard Kibana plugin in the appropriate version. The Kibana upgrade should be carried out in accordance with the Kibana documentation.
9. Restore Multi-Tenancy configuration\
   If the default Multi-Tenancy configuration is inappropriate for you, you can introduce customization by using `sg_frontend_multi_tenancy.yml`, a Multi-Tenancy configuration file. Available configuration options are described in the [Multi-Tenancy configuration](kibana-multi-tenancy#elasticsearch-configuration) section. You can apply a new configuration using the following command `sgctl.sh update-config sg_frontend_multi_tenancy.yml`
10. Read-only access to tenants\
    When you grant read-only access to some tenants for some users, these users may encounter an error popup when they start accessing the tenant without the write privilege. In such a case, please evaluate whether using the Kibana telemetry is appropriate for your company. If you decide to turn off telemetry, you can do so by adding the configuration below to the `kibana.yml` file.
    ```yml
    telemetry:
      enabled: false
      optIn: false
      allowChangingOptInStatus: false
    ```
11. Verify Kibana users' role assignment\
    The role names intended for use in a Multi-Tenancy-enabled environment have not been modified between the 1.x.x and 2.0.0 versions of Search Guard. However, the role definitions were changed. Therefore, if you are using custom roles that allow users to access Kibana, you should upgrade your role definitions. Each user needs access to at least one tenant. Otherwise, the user lacking any tenant access cannot log into Kibana. This is especially important in the context of private tenant removal or when you deprive users of global tenant access. The privilege of accessing the global tenant can be revoked by disabling the global tenant in the Multi-Tenancy configuration file (`sg_frontend_multi_tenancy.yml`) or when you do not assign to your users a role, which grants access to the global tenant. The build-in role `SGS_KIBANA_USER` allows the global tenant access, whereas the role `SGS_KIBANA_USER_NO_GLOBAL_TENANT` does not.
12. Start Kibana\
    When the new Kibana version is started, the Kibana carries out data migration of its saved objects.
13. Upgrade verification\
    The upgrade procedure is almost complete. Please verify if your environment behaves correctly and all required features are available, check if other plugins work correctly, and integrate with external systems. You should also confirm that all required Kibana Saved Objects have been migrated correctly and that the Kibana user interface contains all required tenants, spaces, dashboards, etc. The test should be executed with users' accounts with various permission levels to access tenants.

***

Please take into consideration that Kibana in version 8.8.0 or newer uses some additional indices. You may need to adjust your backup strategy accordingly. Some indices used by the Kibana are listed below
* `.kibana` 
* `.kibana_analytics`
* `.kibana_ingest`
* `.kibana_security_solution`
* `.kibana_alerting_cases`

Official Kibana [documentation](https://www.elastic.co/guide/en/kibana/current/saved-object-migrations.html)