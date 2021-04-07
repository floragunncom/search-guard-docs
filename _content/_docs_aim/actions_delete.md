---
title: Delete Action
html_title: Delete Action
slug: automated-index-management-actions-delete
category: aim-actions
order: 5
layout: docs
edition: community
description: Using Automated Index Management Delete Action
---

<!--- Copyright 2020 floragunn GmbH -->

# Delete Action
{: .no_toc}

{% include toc.md %}

This action deletes the index permanently. Since this action deletes the index it has to be always the last action of a policy.

## Example

```JSON
{
    "delete":{}
}
```
