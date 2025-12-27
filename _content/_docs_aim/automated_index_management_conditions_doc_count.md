---
title: Doc Count Condition
html_title: Doc Count Condition
permalink: automated-index-management-conditions-doc-count
layout: docs
section: index_management
edition: community
description: How the doc count condition works
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Doc Count Condition
{: .no_toc}

{% include toc.md %}

The doc count condition requests the current number of documents in the index and triggers the action execution when the number of documents gets larger than the configured maximum.

## Parameters

| Parameter       | Optional | Note             |
|-----------------|----------|------------------|
| `max_doc_count` | false    | positive integer |

## Example

```json
{
  "steps": [
    ...
    {
      "name": "active",
      "conditions": [
        ...
        {
          "type": "doc_count",
          "max_doc_count": 1000000
        },
        ...
      ],
      "actions": [ ... ]
    },
    ...
  ]
}
```
