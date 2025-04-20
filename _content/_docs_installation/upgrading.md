---
title: Updating Search Guard
permalink: upgrading
layout: docs
description: How to upgrade Search Guard and Elasticsearch by rolling restarts or
  a full cluster restart.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Updating Search Guard
{: .no_toc}

{% include toc.md %}

<span style="color:red">If you're upgrading to SG FLX 2.0.0, please review [the upgrade guide](../_docs_installation/sg200_upgrade.md).
This version introduces backwards-incompatible changes.</span>
{: .note .js-note .note-warning}

If you're looking for specific upgrade instructions from SG 53, please follow the [steps described here](../_docs_installation/sg53_migration.md).
{: .note .js-note .note-warning}

The following instructions assume that Search Guard has been installed on your cluster previously and that the Search Guard configuration index already exists.

There are two types of upgrades to distinguish:

* Upgrading Search Guard for your current Elasticsearch version
* Upgrading Search Guard and Elasticsearch

In the first case you only need to re-install Search Guard. This can be done with a rolling restart of your Elasticsearch nodes, without any downtime.

In the latter case, you need to first upgrade your Elasticsearch installation, and after that install the correct Search Guard version. If you need to perform a full cluster restart or not depends on the Elasticsearch version you are upgrading from and to. Please consult the official Elasticsearch documentation:

[https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html){:target="_blank"}

Before starting the upgrade, check if there are any breaking changes either in Elasticsearch or Search Guard:

[Elasticsearch Breaking Changes](https://www.elastic.co/guide/en/elasticsearch/reference/current/breaking-changes.html){:target="_blank"}

[Search Guard Change Log](../_changelogs/changelog_searchguard_overview.md){:target="_blank"}


## Check permission schema

The permission schema can change from Elasticsearch version to Elasticsearch version. If there are any known changes in the permission schema, they will be reflected in the `sg_roles.yml` and `sg_action_groups.yml` file that ships with Search Guard. Therefore always prefer using [action groups](../_docs_roles_permissions/configuration_action_groups.md)  instead of assigning single permissions to roles directly.

This applies for all Elasticsearch upgrades.

## Upgrading Search Guard Only

Upgrades from one version of Search Guard to another can be done with a rolling restart. If there are no breaking changes mentioned in the [Search Guard changelog](../_changelogs/changelog_searchguard.md), you don't need to adapt any configuration files. 

Given there are no breaking changes, you can directly upgrade to the latest Search Guard version and do not need to upgrade one version at a time. To do so:

* Stop your Elasticsearch node
* Remove the old version of Search Guard
  * `bin/elasticsearch-plugin remove search-guard-flx`
* Install the new version of Search Guard
  * See the chapter [Installing Search Guard](../_docs_installation/installation.md)
 for instructions

After that, restart your node and check that Elasticsearch and Search Guard are starting without errors.

Then, repeat this process for all other nodes in the cluster.  

## Upgrading Elasticsearch and Search Guard

First check with the official Elasticsearch documentation if your upgrade requires a full cluster restart, or if it can be performed via a rolling restart:

[Upgrading Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html){:target="_blank"}

### Minor Upgrades - Rolling restart

Follow the official Elasticsearch guideline for rolling upgrades for your Elasticsearch version:

[Rolling upgrades](https://www.elastic.co/guide/en/elasticsearch/reference/current/rolling-upgrades.html){:target="_blank"}

Depending on your configured authentication modules, you need to provide additional credentials in the `curl` calls mentioned in the rolling upgrade guide.

You can either use a user that has full cluster management permissions, or use an admin certificate, which has full access as well.

**Example: Using HTTP Basic authentication**

```bash
curl -Ss -u admin:admin --insecure -XPUT 'https://localhost:9200/_cluster/settings?pretty' \ 
  -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "none"
  }
}
'
```

**Example: Using an admin certificate**

```bash
curl -Ss -XPUT 'https://localhost:9200/_cluster/settings?pretty' \
  -E "certificates/CN=kirk,OU=client,O=client,L=Test,C=DE.all.pem" \
  --cacert "certificates/chain-ca.pem" \
  -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "none"
  }
}
'    
```

#### Steps

Steps from the [Rolling upgrades guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/rolling-upgrades.html){:target="_blank"}:

1. Disable shard allocation
2. Stop non-essential indexing and perform a synced flush (Optional)
3. Stop and upgrade a single node
4. Upgrade any plugins: Upgrade the Search Guard plugin
5. Start the upgraded node
6. Reenable shard allocation
7. Wait for the node to recover
8. Repeat for all nodes
9. If there are any changes in the permission schema, change the `sg_roles.yml` and/or `sg_action_groups.yml` and update the Search Guard configuration with `sgctl` 
  
### Major Upgrades - Full cluster restart

Follow the official Elasticsearch guideline for full cluster restart upgrades for your Elasticsearch version:

[Full cluster restart upgrade](https://www.elastic.co/guide/en/elasticsearch/reference/current/restart-upgrade.html){:target="_blank"}

The same rules for the `curl` commands as above apply, you need to execute them by using an admin certificate or by providing credentials for a user that has full cluster management permissions.

# Upgrade SearchGuard FLX 1.x.x to 2.x.x/Elasticsearch and Kibana to 8.8.0

Upgrading Elasticsearch and Kibana to 8.8.0 implies also upgrading Search Guard FLX plugin
to at least version 2.0.0

For upgrading Elasticsearch and Kibana from version 8.7.x to 8.8.0 please refer to
[upgrade manual](sg-200-upgrade)

