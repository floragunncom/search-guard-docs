---
title: GET watch
html_title: Getting a watch with the REST API
slug: elasticsearch-alerting-rest-api-watch-get
category: signals-rest
order: 100
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Get Watch API
{: .no_toc}

{% include toc.md %}

## Endpoint

```
GET /_signals/watch/{watch_id}
```

Retrieves the configuration of a watch identified by the `{watch_id}` path parameter. 


## Path Parameters

**{watch_id}** The id of the watch to be retrieved.

## Responses

### 200 OK

The watch exists and the user has sufficient privileges to access it. 

The return document is structured like an ElasticSearch GetDocument response with the watch configuration in the `_source` element. See example below.

### 404 Not found

A watch with the given Id does not exist for the current tenant.




## Multi Tenancy

The watch REST API is tenant-aware. Each Signals tenant has its own separate set of watches. The HTTP request header `sg_tenant` can be used to specify the tenant to be used. 

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/get` for the currently selected tenant.


## Examples

```
GET /_signals/watch/bad_weather
```

```json
{
    "_id": "bad_weather",
    "_tenant": "main",
    "found": true,
    "_version": 6,
    "_seq_no": 6,
    "_primary_term": 5,
    "_source": {
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
        "active": true,
        "_meta": {
            "last_edit": {
                "user": "admin",
                "date": "2019-09-02T06:33:30.919Z"
            }
        },
        "trigger": {
            "schedule": {
                "timezone": "Europe/Berlin",
                "cron": [
                    "0 */1 * * * ?"
                ]
            }
        },
        "log_runtime_data": false,
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
}
```