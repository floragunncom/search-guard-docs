---
title: Create or Update Generic Watch Instance
html_title: Create or Update Generic Watch Instance
permalink: elasticsearch-alerting-rest-api-watch-create-or-update-generic-instance
category: signals-rest
order: 10000
layout: docs
edition: community
description: Use the Alerting for Elasticsearch Create or Update Generic Watch Instance API to create or update generic watch instance
---

<!--- Copyright 2023 floragunn GmbH -->

# Create or Update Generic Watch Instance API
{: .no_toc}

{% include toc.md %}

## Endpoint

```
PUT /_signals/watch/{tenant}/{watch_id}/instances/{instance_id}
```

Create or update instance for generic watch identified by `{watch_id}` path parameter. Path parameter `{instance_id}` specifies created watch instance id.


## Path Parameters

**{tenant}:** The parameter contains the tenant name which is or became an owner of the updated or the created watch instance respectively. `_main` refers to the default tenant. Users of the community edition can only use `_main` here.

**{watch_id}** The id of the generic watch. Required.

**{instance_id}** The id of the generic watch instance to be created or updated. Required.

## Request Body

The request body contains a JSON document which specifies created or updated generic watch instance parameters. It is necessary to provide value for each parameter defined in the generic watch.



## Responses

### 200 OK

The generic watch instances was updated and the user has sufficient privileges to perform the operation.

### 201 CREATED

The generic watch instances was updated and the user has sufficient privileges to perform the operation.

### 403 Forbidden

The user does not have the required permissions to access the endpoint for the selected tenant.

### 404 Not found

A generic watch with the given id does not exist for the selected tenant.

## Permissions

To access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/instances/upsert_one` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL
* SGS\_SIGNALS\_WATCH\_MANAGE

A generic watch instance is executed with the privileges of the user who created the generic watch but not an instance.

## Examples

```
PUT /_signals/watch/_main/devices/instances/device_257
```
```json
{
	"device_id":257,
	"time_range":"5s",
	"temperature_threshold":5
}
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

