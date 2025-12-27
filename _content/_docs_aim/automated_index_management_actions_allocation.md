---
title: Allocation Action
html_title: Allocation Action
permalink: automated-index-management-actions-allocation
layout: docs
section: index_management
edition: community
description: How the allocation action works
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Allocation Action
{: .no_toc}

{% include toc.md %}

This action configures nodes allowed to host the index.
There are three optional configuration options to set allowed nodes.
At least one of the configuration options has to be set.

## Parameters

| Parameter | Optional | Note                                                                         |
|-----------|----------|------------------------------------------------------------------------------|
| `exclude` | true     | Allow index only on nodes that have none of the specified attributes         |
| `include` | true     | Allow index only on nodes that have at least one of the specified attributes |
| `require` | true     | Allow index only on nodes that have all of the specified attributes          |

## Example

```json
{
  "steps": [
    ...
    {
      "name": "my-step",
      "conditions": [ ... ],
      "actions": [
        ...
        {
          "type": "allocation",
          "require": {
            "box_type": "my-custom-box-type"
          }
        },
        ...
      ]
    },
    ...
  ]
}
```
