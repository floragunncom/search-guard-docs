---
title: Set Replica Count Action
html_title: Set Replica Count Action
slug: automated-index-management-actions-set-replica-count
category: aim-actions
order: 10
layout: docs
edition: community
description: Using Automated Index Management Set Replica Count Action
---

<!--- Copyright 2020 floragunn GmbH -->

# Set Replica Count Action
{: .no_toc}

{% include toc.md %}

Internally all indices are split up into shards. Usually there is a replica shard for each shard so in case of a node failure the shard might still be available. However having more shards also increases the index performance. With the replica count you can define how many shard replicas should exist for each shard of the index.

## Parameters

|Parameter|Type|Description|
|-|-|-|
|`replica_count`|Integer|Defines the replica count the index gets set to|

## Example

```JSON
{
    "set_replica_count":{
        "replica_count":3
    }
}
```
