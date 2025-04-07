---
title: Set Priority Action
html_title: Set Priority Action
permalink: automated-index-management-actions-set-priority
layout: docs
edition: community
description: How the set priority action works
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Set Priority Action
{: .no_toc}

{% include toc.md %}

Sets the priority setting of the index to the specified value.
Indices with a higher priority will be recovered first after a node restart.

## Parameters

| Parameter  | Optional | Note             |
|------------|----------|------------------|
| `priority` | false    | positive integer |

## Example

```json
{
  "steps": [
    ...
    {
      "name": "active",
      "conditions": [ ... ],
      "actions": [
        ...
        {
          "type": "set_priority",
          "priority": 50
        },
        ...
      ]
    },
    ...
  ]
}
```