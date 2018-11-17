---
title: Cache API
html_title: Search Guard cache REST API endpoints
slug: rest-api-cache
category: restapi
order: 500
layout: docs
edition: enterprise
description: How to use the cache REST API endpoint to flush the Search Guard cache.
---
<!---
Copryight 2017 floragunn GmbH
-->

# Cache API

Used to manage the Search Guard internal user, authentication and authorization cache.

## Endpoint

```
/_searchguard/api/cache
```

## Delete

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
