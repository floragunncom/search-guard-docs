---
title: Create or Update Many Generic Watch Instances
html_title: Create or Update Many Generic Watch Instances
permalink: elasticsearch-alerting-rest-api-watch-create-or-update-many-generic-instances
category: signals-rest
order: 10000
layout: docs
edition: community
description: Use the Alerting for Elasticsearch Create or Update Many Generic Watch Instances API to create or update many generic watch instances
---

<!--- Copyright 2023 floragunn GmbH -->

# Create or Update Many Generic Watch Instances API
{: .no_toc}

{% include toc.md %}

## Endpoint

```
PUT /_signals/watch/{tenant}/{watch_id}/instances/
```

Create or update instances for generic watch identified by `{watch_id}` path parameter.


## Path Parameters

**{tenant}:** The parameter contains the tenant name which is or became an owner of the updated or the created watch instances respectively. `_main` refers to the default tenant. Users of the community edition can only use `_main` here.

**{watch_id}** The id of the generic watch. Required.


## Request Body

The request body contains a JSON document which specifies created or updated generic watch instance ids and parameters. It is necessary to provide value for each parameter defined in the generic watch. The body contains a JSON map with keys which contain instance id whereas values in the map define instance parameter values


## Responses

### 200 OK

The generic watch instances was updated and the user has sufficient privileges to perform the operation.

### 201 CREATED

At least one generic watch instance was updated and the user has sufficient privileges to perform the operation.

### 403 Forbidden

The user does not have the required permissions to access the endpoint for the selected tenant.

### 404 Not found

A generic watch with the given id does not exist for the selected tenant.

## Permissions

To access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/instances/upsert_many` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL
* SGS\_SIGNALS\_WATCH\_MANAGE

A generic watch instance is executed with the privileges of the user who created the generic watch but not an instance.

## Examples

```
PUT /_signals/watch/_main/devices/instances
```
```json
{
  "instance_id_one": {
    "param_name_1": "param-value-1",
    "param_name_2": 1
  },
  "instance_id_two": {
    "param_name_1": "param-value-2",
    "param_name_2": 2
  },
  "instance_id_three": {
    "param_name_1": "param-value-3",
    "param_name_2": 3
  }
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
