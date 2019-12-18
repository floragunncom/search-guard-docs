---
title: Put watch
html_title: Creating a watch with the REST API
slug: elasticsearch-alerting-rest-api-watch-put
category: signals-rest
order: 200
layout: docs
edition: beta
description:
---

<!--- Copyright 2019 floragunn GmbH -->

# Put Watch API
{: .no_toc}

{% include toc.md %}


## Endpoint

```
PUT /_signals/watch/{tenant}/{watch_id}
```

Stores or updates a watch identified by the `{watch_id}` path parameter. By default, the watch will be active and scheduled for execution.

**Important** When a watch is created or updated, a snapshot of the privileges of the user performing the operation will be stored with the watch. When the stored watch is executed, it will have exactly these privileges. If a user modifies a watch created by another user, the user must ensure that they still have enough privileges to allow successful execution of the watch. See also the chapter on the [security execution context](security_execution_context.md).

## Path Parameters

**{tenant}:** The name of the tenant in which the watch shall be stored. `_main` refers to the default tenant. Users of the community edition will can only use `_main` here.

**{watch_id}** The id of the watch to be created or updated. Required.

## Request Body

The watch needs to be specified as JSON document in the request body.

## Responses

### 200 OK

A watch identified by the given id existed before. The watch was successfully updated.

### 201 Created

A watch identified by the given id did not exist before. The watch was successfully created.

### 400 Bad Request

The request was malformed.

If the watch specified in the request body was malformed, a JSON document containing detailed validation errors will be returned in the response body. See TODO for details.


### 403 Forbidden

The user does not have the permission to create watches for the currently selected tenant.


### 415 Unsupported Media Type

The watch was not encoded as JSON document. Watches need to be sent using the media type application/json.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/put` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL
* SGS\_SIGNALS\_WATCH\_MANAGE

## Examples

### Basic

```
PUT /_signals/watch/_main/bad_weather
```
<!-- {% raw %} -->
```json
{
  "trigger": {
    "schedule": {
      "cron": "0 */1 * * * ?"
    }
  },
  "checks": [
    {
      "type": "search",
      "name": "bad_weather_flights",
      "target": "bad_weather_flights",
      "request": {
        "indices": [
          "kibana_sample_data_flights"
        ],
        "body": {
          "query": {
            "bool": {
              "must": [
                {
                  "query_string": {
                    "default_field": "DestWeather",
                    "query": "*hunder* OR *ightning*"
                  }
                },
                {
                  "range": {
                    "timestamp": {
                      "gte": "now-4h",
                      "lte": "now"
                    }
                  }
                }
              ]
            }
          }
        }
      }
    },
    {
      "type": "condition.script",
      "source": "data.bad_weather_flights.hits.hits.length > 10"
    }
  ],
  "actions": [
            {
                "type": "email",
                "name": "email",
                "throttle_period": "1h",
                "account": "default_mail",
                "to": [
                    "notify@example.com"
                ],
                "subject": "Bad destination weather for {{data.bad_weather_flights.hits.total.value}} flights over last {{data.constants.window}}!",
                "text_body": "Time: {{_source.timestamp}}\n  Flight Number: {{_source.FlightNum}}\n  Origin: {{_source.OriginAirportID}}\n  Destination: {{_source.DestAirportID}}"
            }
        ]
}
```
<!-- {% endraw %} -->

**Response**

```
201 Created
```

```json
{
    "_id": "_main/bad_weather",
    "_version": 1,
    "result": "created"
}
```

### Invalid Watch

```
PUT /_signals/watch/_main/really_bad_weather
```

<!-- {% raw %} -->
```json
{
  "trigger": {
    "schedule": {
      "cron": "after lunch :-?"
    }
  },
  "checks": [
    {
      "type": "sörch",
      "request": {
        "indices": [
          "kibana_sample_data_flights"
        ]
      }
    },
    {
      "type": "condition.script",
      "source": "data.bad_weather_flights.hits.hits.length > "
    }
  ],
  "actions": [
    {
      "type": "email",
      "account": "test",
      "throttle_period": "1h",
      "to": "notify@example.com",
      "subject": "Bad destination weather for {{data.bad_weather_flights.hits.total.value}} flights over last {{data.constants.window}}!",
      "text_body": "Time: {{_source.timestamp}}\n  Flight Number: {{_source.FlightNum}}\n  Origin: {{_source.OriginAirportID}}\n  Destination: {{_source.DestAirportID}}"
    }
  ]
}
```
<!-- {% endraw %} -->

**Response**

```
400 Bad Request
```

```json
{
    "status": 400,
    "error": "Watch is invalid: 5 errors; see detail.",
    "detail": {
        "checks[].source": [
            {
                "error": "unexpected end of script.",
                "context": "... ights.hits.hits.length > \n                             ^---- HERE"
            }
        ],
        "actions[].account": [
            {
                "error": "Account does not exist: test"
            }
        ],
        "triggers.schedule.cron": [
            {
                "error": "Invalid cron expression: Illegal characters for this position: 'AFT'",
                "value": "after lunch :-?",
                "expected": "Quartz Cron Expression: <Seconds: 0-59|*> <Minutes: 0-59|*> <Hours: 0-23|*> <Day-of-Month: 1-31|?|*> <Month: JAN-DEC|*> <Day-of-Week: SUN-SAT|?|*> <Year: 1970-2199|*>?. Numeric ranges: 1-2; Several distinct values: 1,2; Increments: 0/15"
            }
        ],
        "actions[].name": [
            {
                "error": "Required attribute is missing"
            }
        ],
        "checks[].type": [
            {
                "error": "Invalid value",
                "value": "sörch",
                "expected": "search|static|http|condition.script|calc|transform"
            }
        ]
    }
}
```
