---
title: Get all proxies
html_title: Get all proxies
permalink: elasticsearch-alerting-rest-api-proxy-get-all
layout: docs
edition: community
description: Use to retrieve information about proxies.
---
<!--- Copyright 2023 floragunn GmbH -->

# Get all proxies
{: .no_toc}

{% include toc.md %}


```
GET /_signals/proxies/
```

Load information about all proxies.


## Responses

### 200 OK

List which contains all defined proxies in the system.

### 403 Forbidden

The user does not have the required permissions to access the endpoint.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:proxies/findall`.

## Examples

### Get all proxies

```
GET /_signals/proxies/
```

**Response**

```
200 OK
```

```json
{
  "status": 200,
  "data": [
    {
      "id": "my-proxy",
      "name": "my test proxy",
      "uri": "http://127.0.0.1:9199"
    }
  ]
}
```

