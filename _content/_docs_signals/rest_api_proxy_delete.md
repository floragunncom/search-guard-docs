---
title: Delete proxy
html_title: Delete proxy
permalink: elasticsearch-alerting-rest-api-proxy-delete
category: signals-rest
order: 858
layout: docs
edition: community
description: Use to delete proxy by id
---

<!--- Copyright 2023 floragunn GmbH -->

# Delete proxy
{: .no_toc}

{% include toc.md %}


```
DELETE /_signals/proxies/{proxy-id}
```

Delete the proxy with the provided id. 


## Responses

### 200 OK

The proxy was found and deleted.

### 403 Forbidden

The user does not have the required permissions to access the endpoint.

### 404 Not Found

The proxy with the requested id does not exist.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:proxies/delete`.

## Examples

### Delete proxy with the id `my-proxy`

```
DELETE /_signals/proxies/my-proxy
```

**Response**

```
200 OK
```

```json
{
  "status": 200
}
```

