---
title: Set Priority Action
html_title: Set Priority Action
slug: automated-index-management-actions-set-priority
category: aim-actions
order: 8
layout: docs
edition: community
description: Using Automated Index Management Set Priority Action
---

<!--- Copyright 2020 floragunn GmbH -->

# Set Priority Action
{: .no_toc}

{% include toc.md %}

To determine which indices should be recovered first during a node restart you can adjust the index priority throughout the states by using the set priority action. A higher priority means the index gets favoured over other indices with a lower priority after a restart.

## Parameters

|Parameter|Type|Description|
|-|-|-|
|`priority`|Integer|Defines the priority the index gets set to|

## Example

```JSON
{
    "set_priority":{
        "priority":50
    }
}
```
