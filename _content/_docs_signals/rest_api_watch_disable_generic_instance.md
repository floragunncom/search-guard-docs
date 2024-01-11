---
title: Disable Generic Watch Instance
html_title: Disable Generic Watch Instance
permalink: elasticsearch-alerting-rest-api-watch-disable-generic-instance
category: signals-rest
order: 10000
layout: docs
edition: community
description: Use the Alerting for Elasticsearch Disable Generic Watch Instance API to stop execution generic watch instance.
---

<!--- Copyright 2023 floragunn GmbH -->

# Disable Generic Watch Instance API
{: .no_toc}

{% include toc.md %}

## Endpoint

```
DELETE /_signals/watch/{tenant}/{watch_id}/instances/{instance_id}/_active
```

Disable generic watch instance identified by the `{watch_id}` and `{instance_id}` path parameters. Disabled watches are not automatically executed.


## Path Parameters

**{tenant}:** The name of the tenant which contains the watch to be retrieved. `_main` refers to the default tenant. Users of the community edition can only use `_main` here.

**{watch_id}** The id of the generic watch. Required.

**{instance_id}** The id of the generic watch instance to be disabled. Required.

## Responses

### 200 OK

The generic watch instance was disabled and the user has sufficient privileges to perform the operation.


### 403 Forbidden

The user does not have the required privileges to access the endpoint for the selected tenant.

### 404 Not found

A generic watch with the given id does not exist for the selected tenant or generic watch has no instance with given instance id.

## Permissions

To access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/instances/disable` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL
* SGS\_SIGNALS\_WATCH\_MANAGE
* SGS\_SIGNALS\_WATCH\_ACTIVATE

## Examples

```
DELETE /_signals/watch/_main/devices/instances/device_257/_active
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
