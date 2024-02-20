---
title: Force Merge Action
html_title: Force Merge Action
permalink: automated-index-management-actions-force-merge
category: aim-actions
order: 304
layout: docs
edition: community
description: How the force merge action works
---
<!--- Copyright 2023 floragunn GmbH -->

# Force Merge Action
{: .no_toc}

{% include toc.md %}

The force merge action forces the reduction of segments for each shard.
This potentially frees up space by removing deleted documents.

The `segments` parameter specifies the number of segments each shard should be merged to.

Since force merges can be costly, this action is implemented asynchronously, meaning a separate internal step is automatically added to the policy to check if the force merge has finished.
Until the force merge is finished successfully, the index remains in the internal `awaiting_force_merge` step.
No other steps, actions or conditions are run during this phase.

Asynchronous actions are always required to be the last action in a step.

## Parameters

| Parameter  | Optional | Note             |
|------------|----------|------------------|
| `segments` | false    | positive integer |

## Example

```json
{
  "steps": [
    ...
    {
      "name": "attempt_merge",
      "conditions": [ ... ],
      "actions": [
        ...
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