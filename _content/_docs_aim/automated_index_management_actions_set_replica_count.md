---
title: Set Replica Count Action
html_title: Set Replica Count Action
permalink: automated-index-management-actions-set-replica-count
layout: docs
section: index_management
edition: community
description: How the set replica count action works
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Set Replica Count Action
{: .no_toc}

{% include toc.md %}

This action sets the number of replicas that should exist for the index, it is defined by the `replica_count`.
By default, indices have a replica count of 1.
Having more replicas results in a higher availability of the index in case of node restarts.

## Parameters

| Parameter       | Optional | Note                 |
|-----------------|----------|----------------------|
| `replica_count` | false    | non negative integer |

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
          "type": "set_replica_count",
          "replica_count": 2
        },
        ...
      ]
    },
    ...
  ]
}
```
