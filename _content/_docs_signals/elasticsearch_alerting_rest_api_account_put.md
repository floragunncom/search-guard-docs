---
title: Put Account
html_title: Put Account
permalink: elasticsearch-alerting-rest-api-account-put
layout: docs
edition: community
description: Use the Signals for Alerting API to create PagerDuty, Email, Slack and
  Webhook connectors.
---
<!--- Copyright 2022 floragunn GmbH -->

# Put Account API
{: .no_toc}

{% include toc.md %}



## Endpoint

```
PUT /_signals/account/{account_type}/{account_id}
```

Stores or updates an account of type `{account_type}`identified by the `{account_id}` path parameter. 

## Path Parameters

**{account_type}** The type of the account to be stored. Required.

**{account_id}** The id of the account to be stored. Required.

## Request Body

The account needs to be specified as JSON document in the request body. 

See the chapter [accounts](accounts.md) for details on the structure of accounts.

## Responses

### 200 OK

An account identified by the given id existed before. The account was successfully updated.

### 201 Created

An account identified by the given id did not exist before. The account was successfully created.

### 400 Bad Request

The request was malformed. 

If the account specified in the request body was malformed, a JSON document containing detailed validation errors will be returned in the response body. See TODO for details.


### 403 Forbidden

The user does not have the permission to create accounts. 


### 415 Unsupported Media Type

The account was not encoded as JSON document. Accounts need to be sent using the media type application/json.


## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:account/put`.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ACCOUNT\_MANAGE

## Examples

### E-Mail 

```
PUT /_signals/account/email/default
```
```json
{
    "host": "mail.mycompany.example",
    "port": 587,
    "enable_tls": true,
    "default_from": "signals@mycompany.example.com",
    "default_bcc": "signals@mycompany.example.com"
}
```

**Response**

```
201 Created
```


### Slack

```
PUT /_signals/account/slack/default
```
```json
{
    "url": "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
}
```


**Response**

```
201 Created
```

### Invalid data

```
PUT /_signals/account/email/test
```
```json
{
    "port": 587,
    "enable_tls": true,
    "default_from": "signals@mycompany.example.com",
    "default_bcc": "@"
}
```

**Response**

```
400 Bad Request
```

```json
{
    "status": 400,
    "error": "2 errors; see detail.",
    "detail": {
        "host": [
            {
                "error": "Required attribute is missing"
            }
        ],
        "default_bcc": [
            {
                "error": "Invalid value",
                "value": "@",
                "expected": "E-mail address"
            }
        ]
    }
}
```

