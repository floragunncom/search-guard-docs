---
title: Search Watch States
html_title: Search Watch State
slug: elasticsearch-alerting-rest-api-watch-state-search
category: signals-rest
order: 760
layout: docs
edition: community
description: Use the Alerting for Elasticsearch Search API to search for watch state documents
---

<!--- Copyright 2020 floragunn GmbH -->

# Search Watch State API
{: .no_toc}

{% include toc.md %}


## Endpoint

```
GET /_signals/watch/{tenant}/_search/_state
```

```
POST /_signals/watch/{tenant}/_search/_state
```

Searches for watch state documents. Search criteria and options can be specified in a manner similar to the Elasticsearch document search REST API.

Both the GET and the POST HTTP method can be used with the same effect.

## Path Parameters

**{tenant}:** The name of the tenant which contains the watch states to be searched. `_main` refers to the default tenant. Users of the community edition will can only use `_main` here.

## Query Parameters

**from:** Specifies an offset into the result list. Starting from this offset, the results will be returned. Optional.

**size:** Specifies the maximum number of watches to be returned. Optional, defaults to 10. If scrolling is enabled, this specifies the maximum number of watches to be returned in one scroll iteration. 

**scroll:** Configures the search to be scrollable. Optional. The value of this parameter must be a time duration value (like `1m` for one minute) during which the scroll will be available. If scrolling is enabled, the response will contain a `_scroll_id`. The value of this attribute must be passed to the standard ES REST endpoint `_search/scroll` to continue scrolling.



## Request Body

The request body specifies search options like the ElasticSearch document search REST API. Refer to [Get Watch State API](rest_api_watch_state.md) for an overview over the searchable attributes.

If no request body is specified, the states for all watches of the currently selected tenant will be returned; limited to the amount specified to the `size` query parameter.

Important attributes of the request body are:

**query:** An ES document query.

**sort:** Specifies the attributes by which the result shall be sorted. 	


## Responses

### 200 OK

The search was successfully executed. The response body contains the found watch states in the same format as an ES REST API search response.

**Important:** The search results contain the watch ids in the format `{tenant}/{watch_id}`, i.e., they are always prefixed by the tenant name. If you use this id with another REST API, be sure not to include the tenant name another time. 

### 403 Forbidden

The user does not have the required to access the endpoint for the selected tenant.


## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch:state/search` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL 
* SGS\_SIGNALS\_WATCH\_MANAGE
* SGS\_SIGNALS\_WATCH\_READ

## Examples

### List all watch states

```
GET /_signals/watch/_main/_search?size=1000
```

**Response**

```
200 OK
```



### Search for all watches that failed during the last execution

```
POST /_signals/watch/_main/_search?size=1000
```

```
{
    "query": {
        "bool": {
            "should": [
                {
                    "term": {
                        "last_status.code.keyword": "EXECUTION_FAILED"
                    }
                },
                {
                    "term": {
                        "last_status.code.keyword": "ACTION_FAILED"
                    }
                }
            ]
        }
    }
}
```

**Response**

```
200 OK
```

```json
{
    "took": 17,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 1,
            "relation": "eq"
        },
        "max_score": 1.3862944,
        "hits": [
            {
                "_index": ".signals_watches_state",
                "_type": "_doc",
                "_id": "_main/test",
                "_score": 1.3862944,
                "_source": {
                    "_tenant": "_main",
                    "actions": {
                        "my_action": {
                            "last_triggered": "2019-12-05T14:21:50.025735Z",
                            "last_triage": "2019-12-05T14:21:50.025735Z",
                            "last_triage_result": true,
                            "last_execution": null,
                            "last_error": "2019-12-05T14:21:50.032264Z",
                            "last_status": {
                                "code": "ACTION_FAILED"
                            },
                            "execution_count": 0
                        }
                    },
                    "last_execution": {
                        "data": {
                            "testsearch": {
                                "_shards": {
                                    "total": 1,
                                    "failed": 0,
                                    "successful": 1,
                                    "skipped": 0
                                },
                                "hits": {
                                    "hits": [
                                        {
                                            "_type": "_doc",
                                            "_source": {
                                                "a": "a"
                                            },
                                            "_id": "1",
                                            "_index": "testsource",
                                            "_score": 1.0
                                        }
                                    ],
                                    "total": {
                                        "value": 1,
                                        "relation": "eq"
                                    },
                                    "max_score": 1.0
                                },
                                "took": 2,
                                "timed_out": false
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
                            "triggered_time": "2019-12-05T14:21:50.006Z",
                            "scheduled_time": "2019-12-05T14:21:50Z"
                        },
                        "execution_time": "2019-12-05T14:21:50.009277Z"
                    },
                    "last_status": {
                        "code": "ACTION_FAILED",
                        "detail": "All actions failed"
                    },
                    "node": "my_node"
                }
            }
        ]
    }
}
```
