---
title: Force Merge Action
html_title: Force Merge Action
slug: automated-index-management-actions-force-merge
category: aim-actions
order: 6
layout: docs
edition: community
description: Using Automated Index Management Force Merge Action
---

<!--- Copyright 2020 floragunn GmbH -->

# Force Merge Action
{: .no_toc}

{% include toc.md %}

The Force Merge action reduces the number of Lucene segments of the index. Especially on older indices a lot of segments might be created. By reducing the number of segments a better search performance for the index is achieved.

> **Note:** This action is async.

## Parameters

|Parameter|Type|Description|
|-|-|-|
|`segments`|Integer|Defines the number of segments the index should be reduced to|

## Example

```JSON
{
    "force_merge":{
        "segments":2
    }
}
```
