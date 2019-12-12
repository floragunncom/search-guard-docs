---
title: Delete watch
html_title: Deleting a watch with the REST API
slug: elasticsearch-alerting-rest-api-watch-delete
category: signals-rest
order: 300
layout: docs
edition: community
description: 
---

<!--- Copyright 2019 floragunn GmbH -->


# Delete Watch API
{: .no_toc}

{% include toc.md %}


## Endpoint

```
DELETE /_signals/watch/{tenant}/{watch_id}
```

Deletes the watch identified by the `{watch_id}` path parameter. 


## Path Parameters

**{tenant}:** The name of the tenant which contains the watch to be deleted. `_main` refers to the default tenant. Users of the community edition will can only use `_main` here.

**{watch_id}:** The id of the watch to be deleted. Required.

## Responses

### 200 OK

The watch was successfully deleted.

### 403 Forbidden

The user does not have the permission to delete watches for the currently selected tenant. 

### 404 Not found

A watch with the given id does not exist for the current tenant.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/delete` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL 
* SGS\_SIGNALS\_WATCH\_MANAGE

## Examples

```
DELETE /_signals/watch/_main/bad_weather
```


**Response**

```
200 OK
```

```json
{
    "_id": "_main/bad_weather",
    "_version": 2,
    "result": "deleted"
}
```

