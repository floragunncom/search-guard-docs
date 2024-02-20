---
title: Close Action
html_title: Close Action
permalink: automated-index-management-actions-close
category: aim-actions
order: 302
layout: docs
edition: community
description: How the close action works
---
<!--- Copyright 2023 floragunn GmbH -->

# Close Action
{: .no_toc}

{% include toc.md %}

This action closes the index. After this action, the index is blocked from read and write operations.
This action is useful in case the data needs to be preserved but not queried or extended.
Closing an index reduces overhead on the cluster.

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
          "type": "close"
        },
        ...
      ]
    },
    ...
  ]
}
```