---
title: Managing the Search Guard index
html_title: Search Guard index
slug: search-guard-index
category: configuration
order: 1100
layout: docs
edition: community
description: How to manage the primary and replica shards of the Search Guard configuration index.
---
<!---
Copryight 2017 floragunn GmbH
-->

# Managing the Search Guard index

## Index name

If nothing else is specified, Search Guard uses `searchguard` as the name of the index where all configuration settings are stored.

You can configure the name of the Search Guard index. This is only necessary in special cases. If you have configured a Search Guard index name other than `searchguard`, you must configure this name via the `-i` switch.

## Replica shards

Search Guard manages the number of replica shards of the Search Guard index automatically. If the Search Guard index is created for the first time, the number of replica shards is set to the number of nodes - 1. If you add or remove nodes, the number of shards will be increased or decreased automatically. This means that a primary or replica shard of the Search Guard index is available on all nodes.

If you want to manage the number of replica shards yourself, you can disable the replica auto-expand feature by using the `-dra` switch of sgadmin. To set the number of replica shards, use sgadmin with the `-us` switch. To re-enable replica auto-expansion, use the `-dra` switch. See also section "Index and replica settings" in the [sgadmin chapter](sgadmin.md).

Note that the `-us`, `-era` and `-dra` only apply if there is an existing Search Guard index.
