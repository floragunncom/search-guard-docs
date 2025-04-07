---
title: Age Condition
html_title: Age Condition
permalink: automated-index-management-conditions-age
layout: docs
edition: community
description: How the age condition works
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Age Condition
{: .no_toc}

{% include toc.md %}

This condition checks the current age of the index and triggers the action execution when the index is older than the configured maximum.

## Parameters

| Parameter | Optional | Note                                           |
|-----------|----------|------------------------------------------------|
| `max_age` | false    | positive integer with unit ending (d, h, m, s) |

## Example

```json
{
  "steps": [
    ...
    {
      "name": "my_step",
      "conditions": [
        ...
        {
          "type": "age",
          "max_age": "30d"
        },
        ...
      ],
      "actions": [ ... ]
    },
    ...
  ]
}
```