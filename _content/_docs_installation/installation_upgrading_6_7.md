---
title: Upgrading from 6.x to 7.x
slug: upgrading-6-7
category: installation
order: 850
layout: docs
description: Step-by-step upgrade instructions from Search Guard 6.x to Search Guard 7.x. 
---
<!---
Copyright 2019 floragunn GmbH
-->

# Upgrading from 6.x to 7.x
{: .no_toc}

{% include toc.md %}

Upgrading Search Guard from 6.7.x to 7.x.x can be done while you upgrade Elasticsearch from 6.7.x to 7.x.x . You can do this by performing a full cluster restart, or by doing a rolling restart: 

Search Guard supports running a mixed cluster of 6.7.x and 7.x nodes and is thus compatible with the Elasticsearch upgrade path.

If you have not already done so, make yourself familiar with Elastic's own upgrade instruction for the Elastic stack:

* [Upgrading the Elastic Stack](https://www.elastic.co/guide/en/elastic-stack/7.0/upgrading-elastic-stack.html){:target="_blank"}
* [Upgrade Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/7.0/setup-upgrade.html){:target="_blank"}
* [Upgrade Assistant](https://www.elastic.co/guide/en/kibana/6.7/upgrade-assistant.html){:target="_blank"}
* [Rolling Upgrades](https://www.elastic.co/guide/en/elasticsearch/reference/7.0/rolling-upgrades.html){:target="_blank"}

## Review breaking changes

* [Breaking Changes in Elasticsearch 7](https://www.elastic.co/guide/en/elasticsearch/reference/current/breaking-changes-7.0.html)
* [Breaking Changes in Search Guard 7](../_changelogs/changelog_searchguard_7_x_35_0_0.md)

## Prerequisites

In order to to perform a rolling restart and upgrade from 6.x to 7.x, you need to run at least:

* Elasticsearch 6.7.x (Elasticsearch requirement)
* Search Guard 6.7.x-25.0 (Search Guard requirement)

If you run older versions of Elasticsearch and/or Search Guard, please upgrade first.

## Pause processes that use the REST management API or sgadmin

If you have jobs or processes running which use the Search Guard REST management API you may want to pause them until the cluster is fully migrated.
During migration the REST management API will not work properly and should not be used. The same is true for sgadmin.

## Check your Search Guard configuration

If you miss this step your cluster can become uninitialized which will result in a downtime.
{: .note .js-note .note-warning}

Download standalone [sgadmin 7](../_docs_versions/versions_versionmatrix.md) and unpack it in a folder called sgadmin7. It is recommended to do this on the machine from where you typically run `sgadmin`. Then run 

* `./sgadmin7/tools/sgadmin.sh -backup "./sgadmin7" <other parameters like -ks -cert etc>`

If the command completes successfully the run

* `./sgadmin7/tools/sgadmin.sh -vc 6 "./sgadmin7"`

If the output looks like

```
./sgadmin7/sg_action_groups.yml OK
./sgadmin7/sg_internal_users.yml OK
./sgadmin7/sg_roles.yml OK
./sgadmin7/sg_roles_mapping.yml OK
./sgadmin7/sg_config.yml OK
```

then your configuration is valid and you can proceed. 

If there are errors you need to fix them before you start the upgrade.

Fix the errors, check them with `sgadmin.sh -vc 6` command from above and if no further errors are reported upload them into the cluster:

* `./sgadmin7/tools/sgadmin.sh -cd "./sgadmin7" <other parameters like -ks -cert etc>`

## Upgrading Search Guard

After upgrading a node from ES 6.x to 7.x, simply [install](installation.md) the [correct version of Search Guard](../_docs_versions/versions_versionmatrix.md) on this node. 

Search Guard 7 is able to read the Search Guard configuration index created with Search Guard 6.x. You do not need to change any settings during the upgrade process. 

After all nodes have been upgraded to 7.x, it is mandatory to migrate the Search Guard configuration to the new format.
{: .note .js-note .note-warning}

### Migrate Search Guard configuration

Run `sgadmin` with the `-migrate` switch:

```bash
mkdir my_migrate_dir
./sgadmin.sh -migrate my_migrate_dir <other parameters like -ks -cert etc> 
``` 

This will retrieve and save all your original Search Guard configuration files to the my_migrate_dir/ directory. It will then migrate the files to the new configuration format and automatically upload them into your cluster.

As long as this migrate step is not completed you can not use the REST management API.

## Demo roles and action groups

If you use any of the Search Guard demo roles and/or actions groups in production, you should migrate them to the new built-in static [roles](#migrating-to-the-new-built-in-roles) and static [action groups](#migrating-to-the-new-built-in-action-groups).

## Upgrading Kibana

Kibana should be upgraded after the Elasticsearch / Search Guard upgrade is completed. Just [install](../_docs_versions/versions_versionmatrix.md) the correct version of the Search Guard plugin to Kibana. There are no configuration changes in `kibana.yml`.

## Running in mixed mode: Limitations

Elasticsearch and Search Guard support running your cluster in mixed mode, means with 6.7.x and 7.x nodes. This makes it possible to upgrade via rolling restart.

Running a cluster in mixed mode should only be done while upgrading from 6 to 7. It's not supposed to be a permanent situation and you should aim to minimize the duration where a mixed cluster exists.

While running in mixed mode, the following limitations apply:

### Omit Search Guard configuration changes

Search Guard 7 uses a new format for the Search Guard configuration index, and is also able to read and configuration indices created with Search Guard 6. 

While running in mixed mode, do not perform changes to the Search Guard configuration index.
{: .note .js-note .note-warning}

This applies to sgadmin and the REST management API. Configuration changes are possible again after all nodes have been upgraded.

### Monitoring

While running in mixed mode, X-Pack monitoring might return incorrect values or throw Exceptions which you can safely ignore.

## Migrating to the new built-in roles

Search Guard 6 shipped with a couple of demo users, roles and action groups. In Search Guard 7, some of them are now built-in and cannot be changed. This was done so whenever the permission schema changes with a new Elasticsearch version, the built-in roles are also updated in the corresponding Search Guard version. This ensures a smooth and automatic upgrade path.

We encourage you to switch from the demo roles to the new built-in roles. Usually it is sufficient to adapt the `sg_roles_mapping` configuration.

| Static Role name (SG 7) | Demo role name (SG 6) |
|---|---|
| SGS\_ALL\_ACCESS | sg\_all\_access |
| SGS\_READALL | sg\_readall|
| SGS\_READALL\_AND\_MONITOR | sg\_readall\_and\_monitor |
| SGS\_KIBANA\_SERVER | sg\_kibana\_server |
| SGS\_KIBANA\_USER | sg\_kibana\_user|
| SGS\_LOGSTASH | sg\_logstash |
| SGS\_MANAGE\_SNAPSHOTS | sg\_manage\_snapshots |
| SGS\_OWN\_INDEX | sg\_own\_index |
| SGS\_XP\_MONITORING | sg\_xp\_monitoring |
| SGS\_XP\_ALERTING | sg\_xp\_alerting|
| SGS\_XP\_MACHINE\_LEARNING | sg\_xp\_machine\_learning |
{: .config-table}

## Migrating to the new built-in action groups

### General

| Static action group name (SG 7) | Demo action group name (SG 6) |
|---|---|
| SGS_UNLIMITED | UNLIMITED|
{: .config-table}

### Index-level action groups

| Static action group name (SG 7) | Demo action group name (SG 6) |
|---|---|
| SGS\_INDICES\_ALL | INDICES\_ALL | 
| SGS_READ | READ | 
| SGS_SEARCH | SEARCH |
| SGS_DELETE | DELETE |
| SGS_WRITE | WRITE |
| SGS_CRUD | CRUD |
| SGS_GET | GET |
| SGS_SUGGEST | SUGGEST |
| SGS_CREATE_INDEX | CREATE_INDEX | 
| SGS_MANAGE_ALIASES | MANAGE_ALIASES | 
| SGS_INDICES_MONITOR | INDICES_MONITOR |
| SGS_MANAGE | MANAGE | 
| SGS_INDICES_MANAGE_ILM | INDICES_MANAGE_ILM | 
{: .config-table}

### Cluster-level action groups

| Static action group name (SG 7) | Demo action group name (SG 6) |
|---|---|
| SGS_CLUSTER_ALL | CLUSTER_ALL |
| SGS_CLUSTER_MONITOR | CLUSTER_MONITOR |
| SGS_CLUSTER\_COMPOSITE\_OPS\_RO | CLUSTER\_COMPOSITE\_OPS\_RO |
| SGS_CLUSTER\_COMPOSITE\_OPS | CLUSTER\_COMPOSITE\_OPS |
| SGS_MANAGE_SNAPSHOTS | MANAGE_SNAPSHOTS  |
| SGS_CLUSTER_MANAGE_ILM | CLUSTER_MANAGE_ILM |
| SGS_CLUSTER_READ_ILM | CLUSTER_READ_ILM |
| SGS_CLUSTER_MANAGE_INDEX_TEMPLATES | CLUSTER_MANAGE_INDEX_TEMPLATES |
| SGS_CLUSTER_MANAGE_PIPELINES | CLUSTER_MANAGE_PIPELINES |
{: .config-table}
