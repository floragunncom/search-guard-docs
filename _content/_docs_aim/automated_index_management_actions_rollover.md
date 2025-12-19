---
title: Rollover Action
html_title: Rollover Action
permalink: automated-index-management-actions-rollover
layout: docs
section: index_management
edition: community
description: How the rollover action works
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Rollover Action
{: .no_toc}

{% include toc.md %}

This creates a new write index for the alias specified in the `index.aim.alias_mapping` index setting and removes the alias from the current index.

For every index this action should be applied to the index settings must contain an alias_mapping `index.aim.alias_mapping` with the `rollover_alias` configured. Otherwise, the rollover attempt would fail.

## Index Settings Example

```json
{
  "index.aim.policy_name": "my-policy",
  "index.aim.alias_mapping": {
    "rollover_alias": "my-alias"
  }
}
```

## Action Example

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
