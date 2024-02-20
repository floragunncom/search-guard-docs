---
title: Rollover Action
html_title: Rollover Action
permalink: automated-index-management-actions-rollover
category: aim-actions
order: 305
layout: docs
edition: community
description: How the rollover action works
---
<!--- Copyright 2023 floragunn GmbH -->

# Rollover Action
{: .no_toc}

{% include toc.md %}

This creates a new write index for the alias specified in the `index.aim.rollover_alias` index setting and removes the alias from the current index.

For every index this action should be applied to the index setting `index.aim.rollover_alias` must be configured. Otherwise, the rollover attempt would fail.

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
          "type": "rollover"
        },
        ...
      ]
    },
    ...
  ]
}
```