---
title: Snapshot Action
html_title: Snapshot Action
permalink: automated-index-management-actions-snapshot
layout: docs
section: index_management
edition: community
description: How the snapshot action works
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Snapshot Action
{: .no_toc}

{% include toc.md %}

This action takes a snapshot of the index that can be restored in case the index gets corrupted or deleted unintentionally.
The action requires a `repository` in which the snapshot gets stored.
The snapshot name is based on the index name and date of creation following the pattern `<index_name>_<date>`.
If the optional parameter `name_prefix` is configured the pattern would be `<name_prefix>_<index_name>_<date>`.

Since snapshots can take some time to finish, this action is implemented asynchronously.
This means a separate internal step is automatically added to the policy to check if the snapshot has finished.
Until the snapshot is finished successfully the index remains in the internal `awaiting_snapshot` step.
No other steps, actions or conditions run during this phase.

Asynchronous actions are always required to be the last action in a step.

## Parameters

| Parameter     | Optional | Note                                      |
|---------------|----------|-------------------------------------------|
| `repository`  | false    | repository where the snapshot gets stored |
| `name_prefix` | true     | prefix of the snapshot name               |

## Example

```json
{
  "steps": [
    ...
    {
      "name": "backup",
      "conditions": [ ... ],
      "actions": [
        ...
        {
          "type": "snapshot",
          "repository": "my_repo",
          "name_prefix": "my_snapshot"
        }
      ]
    }
    ...
  ]
}
```
