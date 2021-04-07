---
title: Policy Instance REST API
html_title: Policy Instance REST API
slug: automated-index-management-rest-api-policy-instance
category: aim-rest
order: 200
layout: docs
edition: community
description: Automated Index Management Policy Instance REST API
---

# Policy Instance APIs
{: .no_toc}

{% include toc.md %}

These are the APIs for controlling policy instances. For each managed index there is a policy instance.

## GET Policy Instance Status

With this API you can access the state of indices.

### GET Policy Instance Status Endpoint

```
GET /_aim/status/{indices}
```

|Parameter|Description|
|---|---|
|`{indices}`|A list of indices separated by comma|

### GET Policy Instance Status Responses

|HTTP status code|Description|
|-|-|
|200 OK|The policy instance exists and the user has access to it|
|403 Forbidden|The user does not have permission to get policy instances|
|404 Not Found|No policy instance for the specified index was found|

## POST Policy Instance Execute

If you need to trigger an execution of a policy instance for some reason you can use the execute API. Instead of waiting for the next scheduled execution (per default every 5 minutes) the policy instance gets rescheduled and therefor executed immediately.

### POST Policy Instance Execute Endpoint

```
POST /_aim/execute/{indices}
```

|Parameter|Description|
|---|---|
|`{indices}`|A list of indices separated by comma|

### POST Policy Instance Execute Responses

|HTTP status code|Description|
|-|-|
|200 OK|The policy instance exists and the user has access to it|
|403 Forbidden|The user does not have permission to execute policy instances|
|404 Not Found|No policy instance for the specified index was found|
