---
title: Policy REST API
html_title: Policy REST API
slug: automated-index-management-rest-api-policy
category: aim-rest
order: 100
layout: docs
edition: community
description: Automated Index Management Policy REST API
---

# Policy APIs
{: .no_toc}

{% include toc.md %}

## PUT Policy

Uploads a new policy to the cluster. If the policy already exists we don't know yet what will happen.

### PUT Policy Endpoint

```
PUT /_aim/policy/{policy_name}
```

|Parameter|Description|
|---|---|
|`{policy_name}`|The name of the policy to put|

### PUT Policy Responses

|HTTP status code|Description|
|-|-|
|201 Created|The new policy was successfully put|
|400 Bad Request|The policy specified in the request body was not valid|
|403 Forbidden|The user does not have permission to put policies|
|415 Unsupported Media Type|The policy was not encoded as JSON document. Policies need to be sent using the media type application/json|

### PUT Policy Example

#### PUT Policy Example Request

```
PUT /_aim/policy/my_first_policy
```

```JSON
{
    "states":[
        {
            "name":"hot",
            "conditions":{},
            "actions":{}
        },
        {
            "name":"cold",
            "conditions":{
                "max_size":{
                    "max_size":"4gb"
                }
            },
            "actions":{
                "close":{}
            }
        },
        {
            "name":"delete",
            "conditions":{
                "max_age":{
                    "max_age":"30d"
                }
            },
            "actions":{
                "delete":{}
            }
        }
    ]
}
```

#### PUT Policy Example Response

```
201 Created
```

```
```

## GET Policy

### GET Policy Endpoint

```
GET /_aim/policy/{policy_name}
GET /_aim/policy/{policy_name}/{show_internal_states}
```

|Parameter|Type|Description|
|---|---|---|
|`{policy_name}`|string|The name of the policy to get|
|`{show_internal_states}`|boolean|(optional) Shows internal generated states|

### GET Policy Responses

|HTTP status code|Description|
|-|-|
|200 OK|The policy exists and the user has access to it|
|403 Forbidden|The user does not have permission to get policies|
|404 Not Found|No policy with the specified name was found|

### GET Policy Example

#### GET Policy Example Request

```
GET /_aim/policy/my_first_policy
```

#### GET Policy Example Response

```
200 OK
```

```JSON
{
    "states":[
        {
            "name":"hot",
            "conditions":{},
            "actions":{}
        },
        {
            "name":"cold",
            "conditions":{
                "max_size":{
                    "max_size":"4gb"
                }
            },
            "actions":{
                "close":{}
            }
        },
        {
            "name":"delete",
            "conditions":{
                "max_age":{
                    "max_age":"30d"
                }
            },
            "actions":{
                "delete":{}
            }
        }
    ]
}
```

## DELETE Policy

### DELETE Policy Endpoint

```
DELETE /_aim/policy/{policy_name}
```

|Parameter|Description|
|---|---|
|`{policy_name}`|The name of the policy to put|

### DELETE Policy Responses

|HTTP status code|Description|
|-|-|
|200 OK|The policy exists and the user has access to it|
|403 Forbidden|The user does not have permission to delete policies|
|404 Not Found|No policy with the specified name was found|
