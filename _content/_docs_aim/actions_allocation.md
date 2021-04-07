---
title: Allocation Action
html_title: Allocation Action
slug: automated-index-management-actions-allocation
category: aim-actions
order: 3
layout: docs
edition: community
description: Using Automated Index Management Allocation Action
---

<!--- Copyright 2020 floragunn GmbH -->

# Allocation Action
{: .no_toc}

{% include toc.md %}

The allocation action sets an index setting to determine on which nodes the index should be hosted.

## Parameters

|Parameter|Type|Description|
|-|-|-|
|`require`|Object|Attributes the node requires in order to allocate the index to it|
|`include`|Object|Attributes of which at least one should be met by the node in order to allocate the index to it|
|`exclude`|Object|Attributes the node can not have in order to allocate the index to it|

## Example

```JSON
{
    "allocation":{
        "require":{
            "box_type":"cold"
        },
        "include":{},
        "exclude":{}
    }
}
```
