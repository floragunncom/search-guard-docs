---
title: Delete watch
html_title: Deleting a watch with the REST API
slug: elasticsearch-alerting-rest-api-watch-delete
category: signals-rest
order: 300
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->


# Delete Watch API
{: .no_toc}

{% include toc.md %}


## Endpoint

```
DELETE /_signals/watch/{watch_id}
```

Deletes the watch identified by the `{watch_id}` path parameter. 


## Path Parameters

**{watch_id}** The id of the watch to be deleted. Required.

## Responses

### 200 OK

The watch was successfully deleted.

### 403 Forbidden

The user does not have the permission to delete watches for the currently selected tenant. 

### 404 Not found

A watch with the given id does not exist for the current tenant.

The status 404 is also returned if the tenant specified by the `sg_tenant` request header does not exist.


## Multi Tenancy

The watch REST API is tenant-aware. Each Signals tenant has its own separate set of watches. The HTTP request header `sg_tenant` can be used to specify the tenant to be used.  If the header is absent, the default tenant is used.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/delete` for the currently selected tenant.


## Examples

```
DELETE /_signals/watch/bad_weather
```


**Response**

```
200 OK
```

```json
{
    "_id": "bad_weather",
    "_version": 2,
    "result": "deleted"
}
```

