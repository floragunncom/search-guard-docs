---
title: Size Condition
html_title: Size Condition
permalink: automated-index-management-conditions-size
category: aim-conditions
order: 203
layout: docs
edition: community
description: How the size condition works
---
<!--- Copyright 2023 floragunn GmbH -->

# Size Condition
{: .no_toc}

{% include toc.md %}

This condition checks the current size of the index and triggers the action execution when the index size is larger than the configured maximum.

## Parameters

| Parameter | Optional | Note                                              |
|-----------|----------|---------------------------------------------------|
| `max_size`  | false    | positive integer with unit ending (b, kb, mb, gb) |

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
          "type": "size",
          "max_size": "50gb"
        },
        ...
      ],
      "actions": [ ... ]
    },
    ...
  ]
}
```
