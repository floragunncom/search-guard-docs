---
title: Get Destination
html_title: Get a destination with the REST API
slug: elasticsearch-alerting-rest-api-destination-get
category: signals-rest
order: 800
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Get Account API
{: .no_toc}

{% include toc.md %}


## Endpoint

```
GET /_signals/account/{account_id}
```

Retrieves the account configuration identified by the `{account_id}` path parameter. 


## Path Parameters

**{account_id}** The id of the account to be retrieved. Required.

## Responses

### 200 OK

The account exists and the user has sufficient privileges to access it. 

The return document is structured like an ElasticSearch GetDocument response with the configuration in the `_source` element. See example below.

### 403 Forbidden

The user does not have the required to access the endpoint.

### 404 Not found

An account with the given id does not exist. 

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:destination/get`.



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
