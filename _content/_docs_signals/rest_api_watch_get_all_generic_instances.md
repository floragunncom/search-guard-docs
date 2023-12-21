---
title: Get Generic Watch Instances
html_title: Get Generic Watch Instances
permalink: elasticsearch-alerting-rest-api-watch-get-all-generic-instances
category: signals-rest
order: 10000
layout: docs
edition: community
description: Use the Alerting for Elasticsearch Get Generic Watch Instances API to retrieve existing watches instances by generic watch ID
---

<!--- Copyright 2023 floragunn GmbH -->

# Get All Generic Watch Instances API
{: .no_toc}

{% include toc.md %}

## Endpoint

```
GET /_signals/watch/{tenant}/{watch_id}/instances
```

Retrieves generic watch instances for generic watch identified by the `{watch_id}` path parameter.


## Path Parameters

**{tenant}:** The name of the tenant which contains the watch to be retrieved. `_main` refers to the default tenant. Users of the community edition can only use `_main` here.

**{watch_id}** The id of the generic watch to be retrieved. Required.

## Responses

### 200 OK

The generic watch instances exist and the user has sufficient privileges to access it.

The returned document contains generic watch instances defined for a given watch. Each watch instance is described by an object inside the `data` attribute. Therefore, the `data` attribute contains a map with a key which is equal to the generic watch instance id. The values corresponding to keys contain objects which define watch instance parameter values.

### 403 Forbidden

The user does not have the required privileges to access the endpoint for the selected tenant..

### 404 Not found

A generic watch with the given id does not exist for the selected tenant or generic watch has no instances.

## Permissions

To access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/get_all_instances` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL
* SGS\_SIGNALS\_WATCH\_MANAGE
* SGS\_SIGNALS\_WATCH\_READ

## Examples

```
GET /_signals/watch/_main/devices/instances
```

**Response**

```
200 OK
``` 

```json
{
  "status": 200,
  "data": {
    "device_257": {
      "device_id": 257,
      "time_range": "5s",
      "temperature_threshold": 5
    },
    "device_256": {
      "device_id": 256,
      "time_range": "3s",
      "temperature_threshold": 15
    },
    "device_258": {
      "device_id": 258,
      "time_range": "2s",
      "temperature_threshold": 10
  }
}
```
