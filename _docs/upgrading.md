---
title: Upgrading Search Guard
slug: upgrading-search-guard
category: installation
order: 400
layout: docs
description: How to upgrade Search Guard and Elasticsearch by rolling restarts or a full cluster restart. 
---
<!---
Copryight 2017 floragunn GmbH
-->
# Upgrading

There are two types of upgrades to distinguish:

* Upgrading Search Guard for your current Elasticsearch version
  * for example, upgrading from 5.3.1-11 to 5.3.1-12
* Upgrading Search Guard and Elasticsearch
  * for example, upgrading from 5.3.1-11 to 5.3.2-12 

In the first case you only need to re-install Search Guard and eventually some of the enterprise modules. This can be done with a rolling restart of your Elasticsearch nodes, without downtime.

In the latter case, you need to first upgrade your Elasticsearch installation, and after that install the correct Search Guard version, including the enterprise modules. If you need to perform a full cluster restart or not depends on the Elasticsearch version you are upgrading from and to. Please consult the official Elasticsearch documentation:

[https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html){:target="_blank"}


Before starting the upgrade, check if there are any breaking changes either in Elasticsearch or Search Guard:

[Elasticsearch Breaking Changes](https://www.elastic.co/guide/en/elasticsearch/reference/current/breaking-changes.html){:target="_blank"}

[Search Guard Change Log](https://github.com/floragunncom/search-guard/wiki/Changelog){:target="_blank"}

If you have a multicluster setup with tribe nodes, upgrade the tribe nodes after all other nodes.

# Check permission schema

The permission schema can change from Elasticsearch version to Elasticsearch version. For example, Elasticsearch has changed the way index- and delete-operations are handled from 5.3.0 onwards:

[Make index and delete operation execute as single bulk item](https://github.com/elastic/elasticsearch/pull/22812){:target="_blank"}

This means that if you upgrade from any version prior to 5.3.0, you need to give users with single index- and delete-permissions also permissions for bulk operations.

If there are any known changes in the permission schema, they will be reflected in the `sg_roles.yml` and `sg_action_groups.yml` file that ships with Search Guard. 

This applies for all Elasticsearch upgrades.

# Upgrading Search Guard Only

Upgrades from one version of Search Guard to another can be done with a rolling restart. If there are no breaking changes mentioned in the Search Guard changelog, you don't need to adapt any configuration files. 

Given there are no breaking changes between the versions, you can directly upgrade to the latest Search Guard version and do not need to upgrade one version at a time. To do so:

* Stop your Elasticsearch node
* Remove the old version of Search Guard
* For Search Guard 5
  * `bin/elasticsearch-plugin remove search-guard-5`
* For Search Guard 2
  * `bin/plugin remove search-guard-2`
  * `bin/plugin remove search-guard-ssl`
* Install the new version of Search Guard
  * See the chapter [Installing Search Guard](installation.md)
 for instructions

If you have any commercial modules installed, such as LDAP, Kerberos or Audit logging, you need to re-install those as well. Always use the latest available versions of the modules for your Elasticsearch versions.

Just download the module you want to install, and place it in the plugins/search-guard-5 or plugins/search-guard-2 folder. You can read more about it in the chapter [Installing Search Guard](installation.md) ("Installing enterprise modules").

After that, restart your node and check that Elasticsearch and Search Guard are starting without errors.

Then, repeat this process for all other nodes in the cluster.  

# Upgrading Elasticsearch and Search Guard

First, check with the official Elasticsearch documentation if your upgrade requires a full cluster restart, or if it can be performed via a rolling restart:

[Upgrading Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html){:target="_blank"}

Usually, a major upgrade, for example from ES 2.x to 5.x requires a full cluster restart, while a minor upgrade, for example fom ES 5.2.2 to ES 5.3.0 does not. 


## Minor Upgrades - Rolling restart

Follow the official Elasticsearch guideline for rolling upgrades for your Elasticsearch version:

[Rolling upgrades](https://www.elastic.co/guide/en/elasticsearch/reference/current/rolling-upgrades.html){:target="_blank"}

Depending on your configured authentication and authorisation modules, you need to provide additional credentials in the `curl` calls mentioned in the rolling upgrade guide.

*Note: "Disable shard allocation" and "Reenable shard allocation" are only necessary when upgrading a data node.
If you upgrade a dedicated master node (which is not a data node), a tribe node or client node you can omit these two steps.*

You can either use a user that has full cluster management permissions, or use an admin certificate, which has full access as well.

**Example: Using HTTP Basic authentication**

```
curl -Ss -u admin:admin --insecure -XPUT 'https://localhost:9200/_cluster/settings?pretty' \ 
  -H 'Content-Type: application/json' -d'
{
  "transient": {
    "cluster.routing.allocation.enable": "none"
  }
}
'
```

**Example: Using an admin certificate**

```
curl -Ss -XPUT 'https://localhost:9200/_cluster/settings?pretty' \
  -E "certificates/CN=kirk,OU=client,O=client,L=Test,C=DE.all.pem" \
  --cacert "certificates/chain-ca.pem" \
  -H 'Content-Type: application/json' -d'
{
  "transient": {
    "cluster.routing.allocation.enable": "none"
  }
}
'    
```    

### Steps

Steps from the [Rolling upgrades guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/rolling-upgrades.html){:target="_blank"}:

1. Disable shard allocation
2. Stop non-essential indexing and perform a synced flush (Optional)
3. Stop and upgrade a single node
4. Upgrade any plugins: Upgrade the Search Guard plugin and the enterprise modules (if any) as outlined above
5. Start the upgraded node
6. Reenable shard allocation
7. Wait for the node to recover
8. Repeat for all nodes
9. If there are any changes in the permission schema, change the `sg_roles.yml` and/or `sg_action_groups.yml` and update the Search Guard configuration with `sgadmin` 
  
## Major Upgrades - Full cluster restart

Follow the official Elasticsearch guideline for full cluster restart upgrades for your Elasticsearch version:

[Full cluster restart upgrade](https://www.elastic.co/guide/en/elasticsearch/reference/current/restart-upgrade.html){:target="_blank"}

The same rules for the `curl` commands as above apply, you need to execute them by using an admin certificate or by providing credentials for a user that has full cluster management permissions.

### Back up the Search Guard configuration (Optional)

In case you do not have acces to your original Search Guard configuration files anymore, you can retrieve the current configuration of your running cluster by using `sgadmin` with the `-r` (`--retrieve`) switch:

```
./sgadmin.sh \ 
  -ks kirk.jks -kspass changeit \  
  -ts truststore.jks -tspass changeit \ 
  -icl -nhnv -r
``` 

This will retrieve and save all Search Guard configuration files to your working directory. You can later use these files to initialize Search Guard after the upgrade. 

For a major upgrade, the permission schema has very likely changed. so compare especially the `sg_roles.yml` and `sg_action_groups.yml` files with the versions that ship with the Search Guard plugin.

### Upgrading from Search Guard 2.x to Search Guard 5.x

The structure of the Search Guard index is not compatible between version 2.x and 5.x. This means that after you upgrade and restart your the cluster, you need to re-execute sgadmin again. 

**Caveat: The offical upgrade documentation of Elasticsearch recommends to disable shard allocation. It is crucial that you re-enable shard allocation again before initializing Search Guard via sgadmin! We provide a special flag in sgadmin to do so, even if Search Guard is not fully intialized.**

Follow the steps mentioned in the [Full cluster restart upgrade guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/restart-upgrade.html){:target="_blank"}

### Steps

1. Disable shard allocation
2. Perform a synced flush
3. Shutdown and upgrade all nodes
4. Upgrade any plugins: Upgrade the Search Guard plugin and the enterprise modules (if any) as outlined above
5. Start the cluster
6. Wait for yellow: At this point you will see error messages from Search Guard, stating that the index (from the 2.x version) is not readable by the installed Search Guard version (5.x). This is expected.
7. Reenable allocation: Since Search Guard is not initialized yet, due to the non-compatible indices, **you need to reenable shard allocation by using `sgadmin`, not `curl`! See below.**
8. Monitor progress with the `_cat/health` and `_cat/recovery` APIs  
8. Execute `sgadmin` as usual to initialize the Search Guard index.

### Using sgadmin to reenable shard allocation

To reenable shard allocation with sgadmin, use the -esa (--enable-shard-allocation) switch, for example:

```
./sgadmin.sh \ 
  -ks kirk.jks -kspass changeit \  
  -ts truststore.jks -tspass changeit \ 
  -icl -nhnv -esa
```

The output of this command should read:

```
Search Guard Admin v5
Will connect to myhost:9300 ... done
Persistent and transient shard allocation enabled
```

### Alternative: Use "persistent = new_primaries" strategy

An alternative way of upgrading is to change the `cluster.routing.allocation.enable` setting in step 1 from `none` no `new_primaries`. This differs from the official upgrade guide of Elasticsearch, but makes it possible to avoid having to reenable shard allocation with `sgadmin`. You can use the curl to reenable shard allocation as mentioned in the [Full cluster restart upgrade guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/restart-upgrade.html){:target="_blank"}.

#### Steps

1. Disable shard allocation, but **use `new_primaries` instead of `none`.**
2. Perform a synced flush
3. Shutdown and upgrade all nodes
4. Upgrade any plugins: Upgrade the Search Guard plugin and the enterprise modules (if any) as outlined above
5. Start the cluster
6. Wait for yellow: At this point you will see error messages from Search Guard, stating that the index (from the 2.x version) is not readable by the installed Search Guard version (5.x). This is expected.
7. Run sgadmin.sh to update the SG configuration, test access to the cluster
8. Reenable shard allocation
9. Monitor progress with the `_cat/health` and `_cat/recovery` APIs  
