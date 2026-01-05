---
title: Get Account
html_title: Get Account
permalink: elasticsearch-alerting-rest-api-account-get
layout: docs
section: alerting
edition: community
description: Use the Signals for Alerting API to retrieve PagerDuty, Email, Slack
  and Webhook connectors by ID.
---
<!--- Copyright 2022 floragunn GmbH -->

# Get Account API
{: .no_toc}

{% include toc.md %}


## Endpoint

```
GET /_signals/account/{account_type}/{account_id}
```

Retrieves the account of type `{account_type}` identified by the `{account_id}` path parameter. 


## Path Parameters

**{account_type}** The type of the account to be retrieved. Required.

**{account_id}** The id of the account to be retrieved. Required.

## Responses

### 200 OK

The account exists and the user has sufficient privileges to access it. 

The return document is structured like an Elasticsearch GetDocument response with the configuration in the `_source` element. See example below.

### 403 Forbidden

The user does not have the required to access the endpoint.

### 404 Not found

An account with the given id does not exist. 

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:account/get`.

This permission is included in the following [built-in action groups](elasticsearch-alerting-security-permissions):

* SGS\_SIGNALS\_ACCOUNT\_MANAGE
* SGS\_SIGNALS\_ACCOUNT\_READ


## Examples

```
GET /_signals/account/default_email
```

**Response**

```
200 OK
``` 

```json
{
    "_id": "default_email",
    "found": true,
    "_version": 2,
    "_seq_no": 13,
    "_primary_term": 5,
    "_source": {
        "type": "email",
        "host": "localhost",
        "port": 2500
    }
}
```
