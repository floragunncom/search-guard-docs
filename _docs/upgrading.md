---
title: Upgrading Search Guard
slug: upgrading
category: installation
order: 400
layout: docs
description: How to upgrade Search Guard and Elasticsearch by rolling restarts or a full cluster restart. 
---
<!---
Copryight 2017 floragunn GmbH
-->

# Upgrading Search Guard
{: .no_toc}

{% include_relative _includes/toc.md %}

If you're looking for specific upgrade instructions from 5.x to 6.x, please follow the [steps described here](upgrading_5_6.md).
{: .note .js-note .note-warning}

The following instructions assume that Search Guard has been installed on your cluster previously and that the Search Guard configuration index already exists.

There are two types of upgrades to distinguish:

* Upgrading Search Guard for your current Elasticsearch version
  * for example, upgrading from {{site.searchguard.fullversion}} to {{site.searchguard.nextminorversion}}
* Upgrading Search Guard and Elasticsearch
  * for example, upgrading from {{site.searchguard.fullversion}} to {{site.searchguard.nextmajorversion}}

In the first case you only need to re-install Search Guard. This can be done with a rolling restart of your Elasticsearch nodes, without any downtime.

In the latter case, you need to first upgrade your Elasticsearch installation, and after that install the correct Search Guard version. If you need to perform a full cluster restart or not depends on the Elasticsearch version you are upgrading from and to. Please consult the official Elasticsearch documentation:

[https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html){:target="_blank"}

Before starting the upgrade, check if there are any breaking changes either in Elasticsearch or Search Guard:

[Elasticsearch Breaking Changes](https://www.elastic.co/guide/en/elasticsearch/reference/current/breaking-changes.html){:target="_blank"}

[Search Guard Change Log](https://github.com/floragunncom/search-guard/wiki/Changelog){:target="_blank"}

If you have a multicluster setup with tribe nodes, upgrade the tribe nodes after all other nodes.

## Check permission schema

The permission schema can change from Elasticsearch version to Elasticsearch version. If there are any known changes in the permission schema, they will be reflected in the `sg_roles.yml` and `sg_action_groups.yml` file that ships with Search Guard. Therefore always prefer using [action groups](configuration_action_groups.md)  instead of assigning single permissions to roles directly.

This applies for all Elasticsearch upgrades.

## Upgrading Search Guard Only

Upgrades from one version of Search Guard to another can be done with a rolling restart. If there are no breaking changes mentioned in the [Search Guard changelog](../_changelogs/changelog_searchguard.md), you don't need to adapt any configuration files. 

Given there are no breaking changes, you can directly upgrade to the latest Search Guard version and do not need to upgrade one version at a time. To do so:

* Stop your Elasticsearch node
* Remove the old version of Search Guard
  * `bin/elasticsearch-plugin remove search-guard-{{site.searchguard.esmajorversion}}`
* Install the new version of Search Guard
  * See the chapter [Installing Search Guard](installation.md)
 for instructions

After that, restart your node and check that Elasticsearch and Search Guard are starting without errors.

Then, repeat this process for all other nodes in the cluster.  

## Upgrading Elasticsearch and Search Guard

If you're looking for specific upgrade instructions from 5.x to 6.x, please follow the [steps described here](upgrading_5_6.md).
{: .note .js-note .note-warning}

First check with the official Elasticsearch documentation if your upgrade requires a full cluster restart, or if it can be performed via a rolling restart:

[Upgrading Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html){:target="_blank"}

### Minor Upgrades - Rolling restart

Follow the official Elasticsearch guideline for rolling upgrades for your Elasticsearch version:

[Rolling upgrades](https://www.elastic.co/guide/en/elasticsearch/reference/current/rolling-upgrades.html){:target="_blank"}

Depending on your configured authentication and authorisation modules, you need to provide additional credentials in the `curl` calls mentioned in the rolling upgrade guide.

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
9. If there are any changes in the permission schema, change the `sg_roles.yml` and/or `sg_action_groups.yml` and update the Search Guard configuration with `sgadmin` 
  
### Major Upgrades - Full cluster restart

Follow the official Elasticsearch guideline for full cluster restart upgrades for your Elasticsearch version:

[Full cluster restart upgrade](https://www.elastic.co/guide/en/elasticsearch/reference/current/restart-upgrade.html){:target="_blank"}

The same rules for the `curl` commands as above apply, you need to execute them by using an admin certificate or by providing credentials for a user that has full cluster management permissions.

### Back up the Search Guard configuration (Optional)

In case you do not have acces to your original Search Guard configuration files anymore, you can retrieve the current configuration of your running cluster by using `sgadmin` with the `-r` (`--retrieve`) switch:

```bash
./sgadmin.sh \ 
  -ks kirk.jks -kspass changeit \  
  -ts truststore.jks -tspass changeit \ 
  -icl -nhnv -r
``` 

This will retrieve and save all Search Guard configuration files to your working directory. You can later use these files to initialize Search Guard after the upgrade. 

For a major upgrade, the permission schema has very likely changed. so compare especially the `sg_roles.yml` and `sg_action_groups.yml` files with the versions that ship with the Search Guard plugin.