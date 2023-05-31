---
title: Delete trust store
html_title: Delete trust store
permalink: elasticsearch-alerting-rest-api-trust-store-delete
category: signals-rest
order: 854
layout: docs
edition: community
description: Use to delete trust store by id
---

<!--- Copyright 2023 floragunn GmbH -->

# Delete trust store
{: .no_toc}

{% include toc.md %}


```
DELETE /_signals/truststores/{trust-store-id}
```

Delete the trust store with provided id. 


## Responses

### 200 OK

The trust store was found and deleted

### 403 Forbidden

The user does not have the required permissions to access the endpoint.

### 404 Not Found

The trust store with the requested id does not exist.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:truststores/delete`.

## Examples

### Delete truststore with the id `ca-trust-anchor`

```
DELETE /_signals/truststores/ca-trust-anchor
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

