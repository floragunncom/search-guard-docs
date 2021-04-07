---
title: Close Action
html_title: Close Action
slug: automated-index-management-actions-close
category: aim-actions
order: 4
layout: docs
edition: community
description: Using Automated Index Management Close Action
---

<!--- Copyright 2020 floragunn GmbH -->

# Close Action
{: .no_toc}

{% include toc.md %}

The close action closes the index. Closing an index sets the index offline so it remains on disk but does not create any CPU load. Closed indices cannot be read from or write to. However if you want to access the index you can manually open the index again.

## Example

```JSON
{
    "close":{}
}
```
