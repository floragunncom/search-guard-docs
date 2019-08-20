---
title: Execute Watch API
html_title: Elasticsearch Alerting Execute Watch API
slug: alerting-api-watch-execute
category: signals
order: 300
layout: docs
edition: community
description: How to use the Signals Watch Execute REST API endpoint to execute watches.

---
<!--- Copyright 2019 floragunn GmbH-->

# Execute Watch API
{: .no_toc}

{% include toc.md %}

## Endpoint

```
/_signals/watch/{watchid}/_execute
```
Where `watchid ` is the id of the watch to execute.

## POST

### Execute a single watch

```
POST /_signals/watch/{watchid}/_execute
```

Execute a watch, specified by `watchid`.