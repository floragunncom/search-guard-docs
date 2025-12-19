---
title: Create or replace a proxy
html_title: Create or replace proxy
permalink: elasticsearch-alerting-rest-api-proxy-create-or-replace
layout: docs
section: alerting
edition: community
description: The request used to create or replace a proxy
---
<!--- Copyright 2023 floragunn GmbH -->

# Create or replace proxy
{: .no_toc}

{% include toc.md %}


```
PUT /_signals/proxies/{proxy-id}
```

Create a new proxy if no proxy with the provided id exists. If a proxy with the provided id exists, the existing
proxy is replaced.

## Responses

### 200 OK

Proxy added or replaced, information about proxy is present in response body.

### 400 Bad Request

The request was malformed.

If the proxy specified in the request body was malformed, a JSON document containing detailed validation errors will be returned in the response body. 

### 403 Forbidden

The user does not have the required permissions to access the endpoint.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:proxies/createorreplace`.

## Examples

### Create a new proxy with id `my-proxy`

```
PUT /_signals/proxies/my-proxy
```
```json
{
  "name": "my test proxy",
  "uri": "http://127.0.0.1:9199"
}
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
