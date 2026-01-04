---
title: Index Count Condition
html_title: Index Count Condition
permalink: automated-index-management-conditions-index-count
layout: docs
section: index_management
edition: community
description: How the index count condition works
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Index Count Condition
{: .no_toc}

{% include toc.md %}

This condition counts the number of indices assigned to a configured alias. If the number exceeds the configured maximum, this condition triggers if the current index is the oldest.

To determine which alias to check this condition requires an alias key configured in the `index.aim.alias_mapping` part of the index settings.

## Index Settings Example

```json
{
  "index.aim.policy_name": "my-policy",
  "index.aim.alias_mapping": {
    "my-size-condition-key": "my-alias"
  }
}
```

## Condition Example

```json
{
  "steps": [
    ...
    {
      "name": "active",
      "conditions": [
        ...
        {
          "type": "index_count",
          "alias_key": "my-size-condition-key",
          "max_index_count": 10
        },
        ...
      ],
      "actions": [ ... ]
    },
    ...
  ]
}
```
