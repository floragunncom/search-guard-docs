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
POST /_signals/watch/{tenant}/_execute
```

```
POST /_signals/watch/{tenant}/{watch_id}/_execute
```

Immediately executes a watch and returns status information in the HTTP response. The watch can be specified in the request body. Alternatively, the watch to be executed can be specified by y the `{watch_id}` path parameter.

## Path Parameters

**{tenant}** The name of the tenant in whose context the watch shall be executed in. `_main` refers to the default tenant. Users of the community edition will can only use `_main` here.

**{watch_id}** The id of the watch to be executed. Optional. If not specified, the watch needs to be specified in the request body.

## Request Body

The request body can contain a JSON document specifying further options for execution and the watch to be executed. 

The supported attributes of the JSON document are these:

**watch:** The watch to be executed as JSON document. Must be specified if no `{watch_id}` path parameter is given.

**record_execution:** If true, the result of the execution is stored in the watch log index just like it happens for a normal scheduled execution. Optional. Default: false

**input:** If specified, the runtime data will be initialized with the data specified here. This can be for example used to pass parameters to watches. For testing purposes, you can combine this with the attribute `"goto": "_actions"` and thus simulate the data produced by the checks this way. Optional, defaults to no input.

**goto:** With this attribute, you can skip one or more checks. If the value of this attribute is the name of a check, all checks before the specified check will be skipped and execution will start at the specified check. If the attribute contains `_actions`, all checks are skipped and only the actions are executed. Optional, defaults to starting from the beginning.

**skip_actions:** If true, only the checks are executed. The actions are not executed. Optional, defaults to false.

**simulate:** If true, the actions are only partially executed. All preparations for the action are executed, including executing nested checks and scripts, rendering mustache templates, etc. Only the final step for completing the action is not done; the type of the final step depends of course on the type of the action. For example, email actions render the email, but won't send it to the SMTP server. The resulting artifact or request can be viewed in the result returned by the action in the attribute `request`. 

## Responses

### 200 OK

The watch was successfully executed. 

The response body contains the watch log document:

**status:** The resulting status of the watch execution. The sub-attribute `status.code` contains of these codes:

* `NO_ACTION`: The watch was successfully executed, but no action was executed.
* `ACTION_TRIGGERED`: The watch was successfully executed and at least one action was triggered.

Details can be found in the attribute `status.message`. Also, the status of the single actions can be found in the attribute `actions`.

**data:** A copy of the watch runtime data. This represents the runtime data after the checks have completed and before the actions are run.

**actions:** The status of the single actions, identified by their name.  The sub-attribute `actions.status.code` contains of these codes:

* `NO_ACTION`: The action was not executed because its conditions did not evaluate to true.
* `ACTION_TRIGGERED`: The action was executed.
* `SIMULATED_ACTION_TRIGGERED`: The action would have been triggered, but was not actually triggered as requested by the attributes `simulate` or `skip_actions`.

### 422 Unprocessable Entity

An error occurred while executing the watch.

The response body contains the watch log document:

**status:** The resulting status of the watch execution. The sub-attribute `status.code` contains of these codes:

* `ACTION_FAILED`: The checks of the watch were successfully executed but at least one action failed.
* `EXECUTION_FAILED`: An error occured while the checks of a watch were executed.

Details can be found in the attribute `status.message`. Also, the status of the single actions can be found in the attribute `actions`.

**error:** Detailed information on the error that occurred.

**data:** A copy of the watch runtime data. This represents the runtime data after the checks have completed and before the actions are run.

**actions:** The status of the single actions, identified by their name.  The sub-attribute `actions.status.code` contains of these codes:

* `NO_ACTION`: The action was not executed because its conditions did not evaluate to true.
* `ACTION_TRIGGERED`: The action was executed.
* `ACTION_FAILED`: The execution of the action failed.
* `SIMULATED_ACTION_TRIGGERED`: The action would have been triggered, but was not actually triggered as requested by the attributes `simulate` or `skip_actions`.

### 400 Bad Request

The request was malformed. 

If the watch specified in the request body was malformed, a JSON document containing detailed validation errors will be returned in the response body. See TODO for details.

### 403 Forbidden

The user does not have the permission to execute watches for the currently selected tenant. 

### 404 Not found

A watch with the given id does not exist for the selected tenant. 

### 415 Unsupported Media Type

The watch was not encoded as JSON document. Watches need to be sent using the media type application/json.


## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/execute` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_WATCH\_EXECUTE

## Examples

### Basic 

```
POST /_signals/watch/_main/bad_weather/_execute
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
POST /_signals/watch/_main/bad_weather/_execute
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

