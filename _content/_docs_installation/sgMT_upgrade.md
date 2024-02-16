# Upgrade from 8.7.x to 8.8.0

## Note

For users who already used Multi Tenancy feature (called MT)

> **VERY IMPORTANT FOR DATA SAFETY**                                                    
> 
> Before starting migration You need to do a backup of your whole cluster 
> 
> Please review the provided information about backups and restores
> in [documentation](../docs_configuration_changes/configuration_advanced.md#backup-and-restore)


## Multi Tenancy feature

A Kibana tenant serves as a designated container for the storage of saved objects, 
referred to as a "space." It is possible to associate a tenant with one or more 
Search Guard roles, granting the assigned roles either read-write or read-only 
privileges to the tenant and its associated saved objects. When working within Kibana,
users have the option to choose the tenant they wish to interact with. Search Guard 
ensures that the saved objects are appropriately located within the selected tenant.

Every Kibana user is inherently granted access to two pre-configured tenants:
Global and Private.

The Global tenant is designed for shared use among all users, serving as the default 
tenant when no alternative tenant is specified. Objects created prior
to the installation of the multi-tenancy module are housed within this tenant.

In contrast, the Private tenant is exclusively accessible to the currently 
logged-in user and is not shared with others.


## Limitations
* cannot use id in query (due to id scoping)
* painless scripts receive ID with tenant scope
* error messages contain ID with tenant scope
* legacy MT configuration should be not used with single index MT implementation
* cannot switch off multi-tenancy

## Upgrading steps

1. Please be advised that it is mandatory to deactivate Kibana.

2. Please execute the following script by entering the provided command:

```bash
./sgctl-1.5.0.sh special get-mt-data-migration-state-8.7-to-8.8
```

After executing the script, kindly copy and paste the entire output message. Please share the output details in your next reply.

3. Log in to Kibana and verify that all Security-Tenants (SG-Tenants), along 
with all Kibana Saved Objects (KSO) within those Tenants, have been successfully migrated.

> Should you encounter any discrepancies or issues, kindly refrain from proceeding
> to the next step. Instead, we kindly request that you contact us promptly. 
> Please provide detailed information regarding any missing elements or instances 
> of incorrect placement within the Tenant. Your cooperation is greatly appreciated.

4. Please download the new software versions from the following links:

- SG plugin for Elasticsearch 8.9.2:
[Download](https://maven.search-guard.com//search-guard-flx-snapshot/com/floragunn/search-guard-flx-elasticsearch-plugin/femt-pre-release-8.9.x-SNAPSHOT/search-guard-flx-elasticsearch-plugin-femt-pre-release-8.9.x-20240207.140845-5.zip)
- SG plugin for Kibana 8.9.2:
[Download](https://maven.search-guard.com/search-guard-flx-release/com/floragunn/search-guard-flx-kibana-plugin/1.5.0-es-8.9.2/search-guard-flx-kibana-plugin-1.5.0-es-8.9.2.zip)


5. Upgrade the Elasticsearch nodes to version 8.9.2

Following the successful upgrade of Elasticsearch to version 8.9.2 using the provided
SG snapshot, you are now ready to restart your Elasticsearch nodes in a standard manner.

6. In this instance, it is not necessary to initiate the data-migration process using the `sgctl` tool.


7. Upgrade Kibana to Version 8.9.2 with the New SG Plugin (`search-guard-flx-kibana-plugin-1.5.0-es-8.9.2`)

In this step, kindly proceed with the upgrade of Kibana to version 8.9.2, utilizing the provided SG plugin, specifically `search-guard-flx-kibana-plugin-1.5.0-es-8.9.2`.
Following the upgrade, restart Kibana in the usual manner. Subsequently, upon Kibana's successful restart, please collect the Kibana logs as well as the Elasticsearch logs. Ensure to maintain a copy or backup of these logs for reference.

8. Verification of SG-Tenants and Kibana Saved Objects (KSO) Migration

Upon completing the upgrade, log in to Kibana and thoroughly verify that all SG-Tenants, along with all Kibana Saved Objects within those Tenants, have been accurately and completely migrated.
After this verification process, kindly reach out to us again, providing details of your results.