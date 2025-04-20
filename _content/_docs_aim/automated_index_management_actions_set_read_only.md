---
title: Set Read Only Action
html_title: Set Read Only Action
permalink: automated-index-management-actions-set-read-only
layout: docs
edition: community
description: How the set read only action works
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Set Read Only Action
{: .no_toc}

{% include toc.md %}

Setting an index into read only mode.
This will block any write operations on the index.

## Example

```json
{
  "steps": [
    ...
    {
      "name": "inactive",
      "conditions": [ ... ],
      "actions": [
        ...
        {
          "type": "set_read_only"
        },
        ...
      ]
    },
    ...
  ]
}
```