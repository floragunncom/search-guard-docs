---
title: Get watch
html_title: Getting a watch with the REST API
slug: elasticsearch-alerting-rest-api-watch-get
category: signals-rest
order: 750
layout: docs
edition: community
description: 
---

<!--- Copyright 2020 floragunn GmbH -->

# Get Watch State API
{: .no_toc}

{% include toc.md %}

## Endpoint

```
GET /_signals/watch/{tenant}/{watch_id}/_state
```

Retrieves state information about the watch. 


## Path Parameters

**{tenant}:** The name of the tenant which contains the watch to be considered. `_main` refers to the default tenant. Users of the community edition can only use `_main` here.

**{watch_id}** The id of the watch state to be retrieved. Required.

## Responses

### 200 OK

The watch exists and the user has sufficient privileges to access it. 

The response body will contain a JSON document listing various watch state attributes. It may look like this:

```
{
  "actions": {
    "my_action": {
      "last_triggered": "2019-12-05T14:21:50.025735Z",
      "last_triage": "2019-12-05T14:21:50.025735Z",
      "last_triage_result": true,
      "last_execution": "2019-12-05T14:21:50.025735Z",
      "last_error": "2019-12-03T11:17:50.129348Z",
      "last_status": {
        "code": "ACTION_TRIGGERED"
      },
      "acked": {
        "on": "2019-12-05T14:23:21.373254Z",
        "by": "test_user",
      },
      "execution_count": 20
    }
  },
  "last_execution": {
    "data": {
      "my_data": {
        "hits": {
          "hits": [
            {
              "_type": "_doc",
              "_source": {
                "a": "b"
              },
              "_id": "1",
              "_index": "my_index",
              "_score": 1
            }
          ],
          "total": {
            "value": 1,
            "relation": "eq"
          },
          "max_score": 1
        }
      }
    },
    "severity": {
      "level": "error",
      "level_numeric": 3,
      "mapping_element": {
        "threshold": 1,
        "level": "error"
      },
      "value": 1
    },
    "trigger": {
      "scheduled_time": "2019-12-05T14:21:50Z",
      "triggered_time": "2019-12-05T14:21:50.006Z",
    },
    "execution_time": "2019-12-05T14:21:50.009277Z"
  },
  "last_status": {
    "code": "ACTION_TRIGGERED"
  },
  "node": "my_node"
}
```

The attributes have the following meaning:

**actions.{name}.last_triggered:** The last time the action was triggered. Triggering refers here to the event that starts the process checking whether an action might be executable.

**actions.{name}.last_triage:** The last time the action was triggered and its applicability has been checked. An action might have been triggered but not triaged in case it is throttled. In case an action has been acknowledged before, an action will be triaged but not executed. 

**actions.{name}.last_triage_result:** This is true if all the checks configured for an action ran and found that the conditions that should lead to the action are present. 

**actions.{name}.last_execution:** The last time the action was executed. This might be different to `actions.{name}.last_triage` in case an action is acknowledged or in case execution fails.

**actions.{name}.last_error:** The last time action execution was aborted due to an error.

**actions.{name}.last_status:** The status of the last execution. The same status can be also found in the watch log. The status code can be:
* `ACTION_TRIGGERED`: The action was successfully executed.
* `NO_ACTION`: The checks determined that the action does not need to be executed.
* `ACTION_FAILED`: An error occured during execution of the action.
* `ACTION_THROTTLED`: The action was not executed because it is throttled
* `ACKED`: The action was not exectued because it was acked before

**actions.{name}.acked:** If the action was acknowledged, the time and the name of the user acknowledging the action are listed here.

**last_execution.data:** The runtime data gathered by the checks during the last execution.
**last_execution.severity:** If a severity mapping is configured for the watch, this lists the found severity level during the last execution.

**last_execution.trigger.scheduled_time:** The time the watch was scheduled for execution.
**last_execution.trigger.triggered_time:** The time the watch was actually triggered.
**last_execution.execution_time:** The time the watch reached execution stage.
**last_status:** The status of the last execution summarized for the whole watch. The same status can be also found in the watch log. 
**node:** The name of the node which is right now responsible for exeucting the watch.



### 403 Forbidden

The user does not have the required to access the endpoint for the selected tenant.

### 404 Not found

A watch with the given id does not exist for the selected tenant. 

## Permissions

To access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch:state/get` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL 
* SGS\_SIGNALS\_WATCH\_MANAGE
* SGS\_SIGNALS\_WATCH\_READ

