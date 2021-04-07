---
title: Snapshot Action
html_title: Snapshot Action
slug: automated-index-management-actions-snapshot
category: aim-actions
order: 11
layout: docs
edition: community
description: Using Automated Index Management Snapshot Action
---

<!--- Copyright 2020 floragunn GmbH -->

# Snapshot Action
{: .no_toc}

{% include toc.md %}

The snapshot action creates a snapshot of the index.

> **Note:** This action is async.

## Parameters

|Parameter|Type|Description|
|-|-|-|
|`my_snapshot`|string|Defines the name of the snapshot to create|
|`repository_name`|string|Defines the repository to save the snapshot to|

## Example

```JSON
{
    "snapshot":{
        "snapshot_name":"my_snapshot",
        "repository_name":"my_repo"
    }
}
```
