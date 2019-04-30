---
title: Managing the Search Guard Index
html_title: Managing the Search Guard Index
slug: search-guard-index
category: configuration
order: 1100
layout: docs
edition: community
description: How to manage the primary and replica shards of the Search Guard configuration index.
---
<!---
Copyright 2019 floragunn GmbH
-->

# Managing the Search Guard index
{: .no_toc}

{% include toc.md %}

## Index name

If nothing else is specified, Search Guard uses `searchguard` as the name of the index where all configuration settings are stored.

You can configure the name of the Search Guard index. This is only necessary in special cases. If you have configured a Search Guard index name other than `searchguard`, you must configure this name via the `-i` switch.

## Replica shards

Search Guard manages the number of replica shards of the Search Guard index automatically. If the Search Guard index is created for the first time, the number of replica shards is set to the number of nodes - 1. If you add or remove nodes, the number of shards will be increased or decreased automatically. This means that a primary or replica shard of the Search Guard index is available on all nodes.

If you want to manage the number of replica shards yourself, you can disable the replica auto-expand feature by using the `-dra` switch of sgadmin. To set the number of replica shards, use sgadmin with the `-us` switch. To re-enable replica auto-expansion, use the `-era` switch. See also section "Index and replica settings" in the [sgadmin chapter](../_docs_configuration_changes/configuration_sgadmin.md).

Note that the `-us`, `-era` and `-dra` only apply if there is an existing Search Guard index.

## Disable auto expand replicas of the searchguard index

There are several situations where the auto-expand feature is not suitable including:

* When using a Hot/Warm Architecture
* Running multiple instances of Elasticsearch on the same host machine
* When `cluster.routing.allocation.same_shard.host` is set to `false`, see also [elastic/elasticsearch#29933](https://github.com/elastic/elasticsearch/issues/29933)
* The searchguard index stays constantly yellow

To solve this disable the auto-expand replicas feature of the searchguard index and set the number of replicas manually.
You can also keep the auto-expand replicas feature and set it to "0-n" where n is the number of datanodes-2.
