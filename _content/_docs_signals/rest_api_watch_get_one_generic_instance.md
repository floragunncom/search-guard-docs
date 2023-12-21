---
title: Get One Generic Watch Instance
html_title: Get One Generic Watch Instance
permalink: elasticsearch-alerting-rest-api-watch-get-one-generic-instance
category: signals-rest
order: 10000
layout: docs
edition: community
description: Use the Alerting for Elasticsearch Get Generic Watch One Instance API to retrieve existing watches instances by generic watch id and instance id
---

<!--- Copyright 2023 floragunn GmbH -->

# Get One Generic Watch Instance API
{: .no_toc}

{% include toc.md %}

## Endpoint

```
GET /_signals/watch/{tenant}/{watch_id}/instances/{instance_id}
```

Retrieves generic watch instances for generic watch identified by the `{watch_id}` path parameter and instance identified by `{instance_id}` path parameter.


## Path Parameters

**{tenant}:** The name of the tenant which contains the watch to be retrieved. `_main` refers to the default tenant. Users of the community edition can only use `_main` here.

**{watch_id}** The id of the generic watch to be retrieved. Required.

**{instance_id}** The id of the generic watch instance to be retrieved. Required.

## Responses

### 200 OK

The generic watch instances exist and the user has sufficient privileges to access it.

The returned document contains all parameters defined for the generic watch instance inside the `data` attribute

### 403 Forbidden

The user does not have the required privileges to access the endpoint for the selected tenant..

### 404 Not found

A generic watch with the given id does not exist for the selected tenant or generic watch has no instance with given instance id.

## Permissions

To access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/instances/get_one` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL
* SGS\_SIGNALS\_WATCH\_MANAGE
* SGS\_SIGNALS\_WATCH\_READ

## Examples

```
GET /_signals/watch/_main/devices/instances/device_257
```

**Response**

```
200 OK
``` 

```json
{
  "status": 200,
  "data": {
    "device_id": 257,
    "time_range": "5s",
    "temperature_threshold": 5
  }
}
```
