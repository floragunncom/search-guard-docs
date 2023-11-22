---
title: Get one proxy
html_title: Get one proxy
permalink: elasticsearch-alerting-rest-api-proxy-get-one
category: signals-rest
order: 857
layout: docs
edition: community
description: Use to retrieve one proxy.
---

<!--- Copyright 2023 floragunn GmbH -->

# Get one proxy
{: .no_toc}

{% include toc.md %}


```
GET /_signals/proxies/{proxy-id}
```

Load information about the proxy with the given id. 


## Responses

### 200 OK

The proxy was found, information about proxy is present in response body.

### 403 Forbidden

The user does not have the required permissions to access the endpoint.

### 404 Not Found

The proxy with the requested id does not exist.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:proxies/findone`.

## Examples

### Get proxy with id `my-proxy`

```
GET /_signals/proxies/my-proxy
```

**Response**

```
200 OK
```

```json
{
  "status": 200,
  "data": {
    "id": "my-proxy",
    "name": "my test proxy",
    "uri": "http://127.0.0.1:9199"
  }
}
```
