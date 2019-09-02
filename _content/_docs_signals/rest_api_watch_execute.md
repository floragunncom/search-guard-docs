---
title: Execute watch
html_title: Execute a watch with the REST API
slug: elasticsearch-alerting-rest-api-watch-execute
category: signals-rest
order: 600
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Execute watch API
{: .no_toc}

{% include toc.md %}



## Endpoint

```
POST /_signals/watch/_execute
```

```
POST /_signals/watch/{watch_id}/_execute
```

Immediately executes a watch and returns status information in the HTTP response. The watch can be specified in the request body. Alternatively, the watch to be executed can be specified by y the `{watch_id}` path parameter.



## Path Parameters

**{watch_id}** The id of the watch to be executed. Optional. If not specified, the watch needs to be specified in the request body.

## Request Body

The request body can contain a JSON document specifying further options for execution and the watch to be executed. 

The supported attributes of the JSON document are these:

**record_execution** If true, the result of the execution is stored in the watch log index just like it happens for a normal scheduled execution. Optional. Default: false
**watch** The watch to be executed as JSON document. Must be specified if no `{watch_id}` path parameter is given.

## Responses

### 200 OK

A watch identified by the given id existed before. The watch was successfully updated.

### 201 Created

A watch identified by the given id did not exist before. The watch was successfully created.

### 400 Bad Request

The request was malformed. 

If the watch specified in the request body was malformed, a JSON document containing detailed validation errors will be returned in the response body. See TODO for details.

### 404 Not found

The tenant specified by the `sg_tenant` request header does not exist.

### 403 Forbidden

The user does not have the permission to create watches for the currently selected tenant. 


### 415 Unsupported Media Type

The watch was not encoded as JSON document. Watches need to be sent using the media type application/json.


## Multi Tenancy

The watch REST API is tenant-aware. Each Signals tenant has its own separate set of watches. The HTTP request header `sg_tenant` can be used to specify the tenant to be used.  If the header is absent, the default tenant is used.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/put` for the currently selected tenant.


## Examples

### Basic 

```
POST /_signals/watch/bad_weather/_execute
```


**Response**

```
200 OK
```

```json
{
    "tenant": "main",
    "watch_id": "bad_weather",
    "status": {
        "code": "ACTION_TRIGGERED",
        "detail": "All actions have been executed"
    },
    "execution_start": "2019-09-02T08:51:05.519Z",
    "execution_end": "2019-09-02T08:51:05.650Z",
    "data": {
        "bad_weather_flights": {
            "_shards": {
                "total": 1,
                "failed": 0,
                "successful": 1,
                "skipped": 0
            },
            "hits": {
                "hits": [],
                "total": {
                    "value": 32,
                    "relation": "eq"
                },
                "max_score": null
            },
            "took": 3,
            "timed_out": false
        }
    },
    "actions": [
        {
            "name": "email",
            "status": {
                "code": "ACTION_TRIGGERED"
            },
            "execution_start": "2019-09-02T08:51:05.523Z",
            "execution_end": "2019-09-02T08:51:05.650Z"
        }
    ]
}
```

### Execution Error

```
POST /_signals/watch/bad_weather/_execute
```

**Response**

```
422 Unprocessable Entity
```

```json
{
    "tenant": "main",
    "watch_id": "bad_weather",
    "status": {
        "code": "EXECUTION_FAILED",
        "detail": "Error while executing SearchInput bad_weather_flights: no such index [kibana_sample_data_flights]"
    },
    "error": {
        "message": "[kibana_sample_data_flights] IndexNotFoundException[no such index [kibana_sample_data_flights]]",
        "detail": {
            "type": "index_not_found_exception",
            "reason": "no such index [kibana_sample_data_flights]",
            "resource.type": "index_or_alias",
            "resource.id": "kibana_sample_data_flights",
            "index_uuid": "_na_",
            "index": "kibana_sample_data_flights"
        }
    },
    "execution_start": "2019-09-02T08:19:28.009Z",
    "execution_end": "2019-09-02T08:19:28.010Z",
    "data": {},
    "actions": []
}
```

