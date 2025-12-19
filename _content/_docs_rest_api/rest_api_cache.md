---
title: Cache API
html_title: Cache API
permalink: rest-api-cache
layout: docs
section: security
edition: enterprise
description: How to use the cache REST API endpoint to flush the Search Guard cache.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Cache API
{: .no_toc}

{% include toc.md %}

Used to manage the Search Guard internal user, authentication and authorization cache.

## Endpoint

```
/_searchguard/api/cache
```

## DELETE

```
DELETE /_searchguard/api/cache
```

Flushes the Search Guard cache.

```json
{
  "status":"OK",
  "message":"Cache flushed successfully."
}
```
