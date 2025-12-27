---
title: Search Accounts
html_title: Search Accounts
permalink: elasticsearch-alerting-rest-api-account-search
layout: docs
section: alerting
edition: community
description: Use the Signals for Alerting Search Accounts REST API to search for email,
  PagerDuty, Slack and webhook accounts.
---
<!--- Copyright 2022 floragunn GmbH -->

# Search Accounts
{: .no_toc}

{% include toc.md %}


```
GET /_signals/account/_search
```

```
POST /_signals/account/_search
```

Searches for accounts. Search criteria and options can be specified in a manner similar to the ElasticSearch document search REST API.

Both the GET and the POST HTTP method can be used with the same effect.

## Query Parameters

**from:** Specifies an offset into the result list. Starting from this offset, the results will be returned. Optional.

**size:** Specifies the maximum number of accounts to be returned. Optional, defaults to 10. If scrolling is enabled, this specifies the maximum number of accounts to be returned in one scroll iteration. 

**scroll:** Configures the search to be scrollable. Optional. The value of this parameter must be a time duration value (like `1m` for one minute) during which the scroll will be available. If scrolling is enabled, the response will contain a `_scroll_id`. The value of this attribute must be passed to the standard ES REST endpoint `_search/scroll` to continue scrolling.



## Request Body

The request body specifies search options like the ElasticSearch document search REST API.

If no request body is specified, all accounts will be returned; limited to the amount specified to the `size` query parameter.

Important attributes of the request body are:

**query:** An ES document query.

**sort:** Specifies the attributes by which the result shall be sorted. 	


## Responses

### 200 OK

The search was successfully executed.

### 403 Forbidden

The user does not have the required to access the endpoint.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:account/search`.

This permission is included in the following [built-in action groups](elasticsearch-alerting-security-permissions):

* SGS\_SIGNALS\_ACCOUNT\_MANAGE
* SGS\_SIGNALS\_ACCOUNT\_READ

## Examples

### List all accounts

```
GET /_signals/account/_search?size=1000
```

**Response**

```
200 OK
```

```json
{
    "took": 3,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 2,
            "relation": "eq"
        },
        "max_score": 1,
        "hits": [
            {
                "_index": ".signals_accounts",
                "_type": "_doc",
                "_id": "default_slack",
                "_score": 1,
                "_source": {
                    "url": "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
                }
            },
            {
                "_index": ".signals_accounts",
                "_type": "_doc",
                "_id": "email/default",
                "_score": 1,
                "_source": {
                    "host": "mail.mycompany.example",
                    "port": 587,
                    "enable_tls": true,
                    "default_from": "signals@mycompany.example.com",
                    "default_bcc": [
                        "signals@mycompany.example.com"
                    ]
                }
            }
        ]
    }
}

