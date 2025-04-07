---
title: Actions Overview
html_title: Actions Overview
permalink: automated-index-management-actions-overview
layout: docs
edition: community
description: How actions work in AIM
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Actions Overview
{: .no_toc}

{% include toc.md %}

## Basics

Actions can be used to change the state or behavior of an index. Steps may contain no actions, one action, or multiple actions.
If there are multiple actions defined in one step the actions get executed in the defined order.

Actions get executed when the step is triggered and at least one condition is met.
If the step does not contain conditions, the actions get executed when the step is entered.

Every action has a `type` field that defines the action type. Some actions have additional configuration variables.

## Available Actions

Supported actions are:
- [allocation](actions_allocation.md): Changes the allocation settings for the index.
- [close](actions_close.md): Closes the index.
- [delete](actions_delete.md): Deletes the index permanently.
- [force_merge](actions_force_merge.md): Force merges the index shards.
- [rollover](actions_rollover.md): Rolls the index over.
- [set_priority](actions_set_priority.md): Sets the priority of the index.
- [set_read_only](actions_set_read_only.md): Changes the index to read only mode.
- [set_replica_count](actions_set_replica_count.md): Sets the number of replicas the index should have.
- [snapshot](actions_snapshot.md): Takes a snapshot of the entire index.

## Example

```json
{
  "steps": [
    ...
    {
      "name": "my-rollover-step",
      "conditions": [],
      "actions": [
        {
          "type": "rollover"
        },
        {
          "type": "set_read_only"
        },
        {
          "type": "force_merge",
          "segments": 1
        }
      ]
    },
    ...
  ]
}
```

In the example above, the index would be rolled over when `my-rollover-step` is entered.
After the index is rolled over successfully, it would be set the read only mode and force merge into one segment.
