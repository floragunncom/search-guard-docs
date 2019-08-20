---
title: Search Watch API
html_title: Elasticsearch Alerting Search Watch API
slug: alerting-api-search-watch
category: signals
order: 250
layout: docs
edition: community
description: How to use the Signals Watch REST API endpoint to search for configured watches
---
<!--- Copyright 2019 floragunn GmbH-->

# Search Watch API
{: .no_toc}

{% include toc.md %}

## Endpoint

```
/_signals/watch/_search
```


## GET / POST

GET and POST are equivalent for this endpoint.

### Search for a watch

```
/_signals/watch/_search
```

```json
{
  "query" : {
    "term" : { "_id" : "testwatch-1" }
  }
}'
```

...  equivalent to body search ....