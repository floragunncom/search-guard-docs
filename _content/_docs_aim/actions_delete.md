---
title: Delete Action
html_title: Delete Action
permalink: automated-index-management-actions-delete
category: aim-actions
order: 303
layout: docs
edition: community
description: How the delete action works
---
<!--- Copyright 2023 floragunn GmbH -->

# Delete Action
{: .no_toc}

{% include toc.md %}

The delete action deletes the index permanently. This action has to be the last action in a policy.

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
          "type": "delete"
        }
      ]
    }
  ]
}
```