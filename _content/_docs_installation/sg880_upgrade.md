# Upgrade from 8.7.x to 8.8.0

## Note

For users who already used Multi Tenancy feature (called MT)

> **VERY IMPORTANT FOR DATA SAFETY**                                                    
> 
> Before starting migration You need to do a backup of your whole cluster.
> 
> If an upgrade is being performed from version 8.7.x to a newer version
> along with SG 2.0, the user should follow these steps:
> 
> 1. Backup Cluster in Version 8.7.x
>    * Execute a comprehensive backup of the cluster in version 8.7.x.
> 2. Upgrade Elasticsearch (ES) and Search Guard (SG)
>    * Upgrade both Elasticsearch and Search Guard to the desired versions.
> 3. Perform Data Migration
>    * Execute the necessary data migration procedures.
> 4. Upgrade Kibana
>    * Upgrade Kibana to the corresponding version.
> 
> ### Troubleshooting
> 
> In case of any issues, if the cluster encounters problems, 
> the user should consider reverting to the previously backed-up version.
> 
> ### Cluster Restoration
> 
> If needed, the user should restore the cluster to the version from which the upgrade was initiated.
> It is essential to note that due to the impossibility of downgrading Elasticsearch, 
> a full backup is necessary before the upgrade. Additionally, users should be aware 
> that Search Guard may not be fully backward compatible between versions 1 and 2.
> This entire procedure is applicable only if the user is utilizing multi-tenancy.

## Multi Tenancy feature

A Kibana tenant serves as a designated container for the storage of saved objects.
It is possible to associate a tenant with one or more 
Search Guard roles, granting the assigned roles either read-write or read-only 
privileges to the tenant and its associated saved objects. When working within Kibana,
users have the option to choose the tenant they wish to interact with. Search Guard 
ensures that the saved objects are appropriately located within the selected tenant.

The Global tenant is designed for shared use among all users, serving as the default 
tenant when no alternative tenant is specified. Objects created prior
to the installation of the multi-tenancy module are lost, thus there is a need of
secured backup. Furthermore, it is imperative to ensure that the user is granted
access to the global tenant. By default, the Global tenant is not accessible. 
This demarcates a distinction between the newer and older implementations of 
Multi-Tenancy (MT).

In contrast, the Private tenant is exclusively accessible to the currently 
logged-in user and is not shared with others.


## Limitations
* cannot use id in query (due to id scoping)
* painless scripts receive ID with tenant scope
* error messages contain ID with tenant scope
* legacy MT configuration should be not used with single index MT implementation
* cannot switch off multi-tenancy
* system administrator should consider if above limitations are acceptable for environment

## Upgrading steps

1. Please be advised that it is mandatory to deactivate Kibana.

2. Please execute the following script by entering the provided command:

```bash
./sgctl-1.5.0.sh special get-mt-data-migration-state-8.7-to-8.8
```

After executing the script, kindly copy and paste the entire output message. 
Please share the output details in your next reply.

3. Log in to Kibana and verify that all Security-Tenants (SG-Tenants), along 
with all Kibana Saved Objects (KSO) within those Tenants, have been successfully migrated.

> Should you encounter any discrepancies or issues, kindly refrain from proceeding
> to the next step. Instead, we kindly request that you contact us promptly. 
> Please provide detailed information regarding any missing elements or instances 
> of incorrect placement within the Tenant. Your cooperation is greatly appreciated.

4. Please download the new software versions from the following links:

- SG plugin for Elasticsearch 8.8.0:
[Download](https://maven.search-guard.com//search-guard-flx-snapshot/com/floragunn/search-guard-flx-elasticsearch-plugin/sg-flx-1.5.0-es-8.8.0-SNAPSHOT/search-guard-flx-elasticsearch-plugin-sg-flx-1.5.0-es-8.8.0-20240103.143104-1.zip)
- SG plugin for Kibana 8.8.0:
[Download](https://maven.search-guard.com/search-guard-flx-release/com/floragunn/search-guard-flx-kibana-plugin/1.5.0-es-8.8.0/search-guard-flx-kibana-plugin-1.5.0-es-8.8.0.zip)


5. Upgrade the Elasticsearch nodes to version 8.8.0

Following the successful upgrade of Elasticsearch to version 8.8.0 using the provided
SG snapshot, you are now ready to restart your Elasticsearch nodes in a standard manner.

6. In this instance, it is not necessary to initiate the data-migration process using the `sgctl` tool.


7. Upgrade Kibana to Version 8.8.0 with the New SG Plugin (`search-guard-flx-kibana-plugin-1.5.0-es-8.8.0`)

In this step, kindly proceed with the upgrade of Kibana to version 8.8.0, utilizing the provided SG plugin, specifically `search-guard-flx-kibana-plugin-1.5.0-es-8.8.0`.
Following the upgrade, restart Kibana in the usual manner. Subsequently, upon Kibana's successful restart, please collect the Kibana logs as well as the Elasticsearch logs. Ensure to maintain a copy or backup of these logs for reference.


8. Assign roles in Kibana

When MT is enabled, the Kibana user needs a role `SGS_KIBANA_MT_USER`  instead of `SGS_KIBANA_USER`. 

Users possessing the `SGS_KIBANA_USER` role are granted the privilege to 
bypass multi-tenancy checks. It is noteworthy to highlight that, in contrast, 
the `SGS_KIBANA_MT_USER` role does not confer access to the global tenant. 
This distinction underscores the importance of recognizing the nuanced capabilities 
associated with each role, particularly in relation to multi-tenancy considerations.

> Each user needs to have at least one tenant configured, otherwise Search Guard
> does not know which tenant to use. If you disable both the Global and Private tenant,
> and the user does not have any other tenants configured, login will not be possible.
> 
> If a user has assigned direct access privileges to the Kibana-related indices, 
> then the user can bypass MT restriction.

9. Verification of SG-Tenants and Kibana Saved Objects (KSO) Migration

Upon completing the upgrade, log in to Kibana and thoroughly verify that all SG-Tenants, along with all Kibana Saved Objects within those Tenants, have been accurately and completely migrated.
After this verification process, kindly reach out to us again, providing details of your results.

---
Indices utilized by Kibana in version 8.8.0 or newer include: 
* .kibana 
* .kibana_analytics
* .kibana_ingest
* .kibana_security_solution
* .kibana_alerting_cases.

Official Kibana [documentation](https://www.elastic.co/guide/en/kibana/current/index.html)