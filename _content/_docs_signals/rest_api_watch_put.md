---
title: PUT watch
html_title: Creating a watch with the REST API
slug: elasticsearch-alerting-rest-api-watch-put
category: signals-rest
order: 200
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Put Watch API
{: .no_toc}

{% include toc.md %}


## Endpoint

```
PUT /_signals/watch/{watch_id}
```

Stores or updates a watch identified by the `{watch_id}` path parameter. By default, the watch will be active and scheduled for execution.


## Path Parameters

**{watch_id}** The id of the watch to be created or updated. Required.

## Request Body

The watch needs to be specified as JSON document in the request body. 

See TODO for details on the structure of watches.

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
PUT /_signals/watch/bad_weather
```
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

**Response**

```
201 Created
``` 

```json
{
    "_id": "bad_weather",
    "_version": 1,
    "result": "created"
}
```

### Invalid Watch

```
PUT /_signals/watch/really_bad_weather
```
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
      "subject": "Bad destination weather for {{data.bad_weather_flights.hits.total.value flights over last {{data.constants.window}}!",
      "text_body": "Time: {{_source.timestamp}}\n  Flight Number: {{_source.FlightNum}}\n  Origin: {{_source.OriginAirportID}}\n  Destination: {{_source.DestAirportID}}"
    }
  ]
}
```

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

