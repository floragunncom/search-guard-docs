---
title: Un-acknowledge Watch And Get
html_title: Un-acknowledge Watch And Get
permalink: elasticsearch-alerting-rest-api-watch-un-acknowledge-and-get
category: signals-rest
order: 700
layout: docs
edition: community
description: The Signals Alerting for Elasticsearch API provides an endpoint for un-acknowledging a watch to move it back to the initial state. The new watch state is also returned by the request.

---

<!--- Copyright 2023 floragunn GmbH -->

# Un-acknowledge And Get Watch API
{: .no_toc}

{% include toc.md %}



## Endpoint

```
DELETE /_signals/watch/{tenant}/{watch_id}/_ack_and_get
```

```
DELETE /_signals/watch/{tenant}/{watch_id}/_ack_and_get/{action_id}
```

These endpoints can be used to withdraw acknowledgements done by the [Acknowledge Watch API](rest_api_watch_acknowledge.md) or [Acknowledge And Get Watch](rest_api_watch_acknowledge_and_get.md). The un-acknowledged actions will afterwards be in normal state and start executing again.

The request's response contains in its body the list of all un-acknowledged action ids. Therefore, the REST operation can be treated as an extended version of the request [Un-Acknowledge Watch](rest_api_watch_unacknowledge.md).


## Path Parameters

**{tenant}:** The name of the tenant which contains the watch to be un-acknowledged. `_main` refers to the default tenant. Users of the community edition will can only use `_main` here.

**{watch_id}:** The id of the watch containing the action to be un-acknowledged. Required.

**{action_id}:** The id of the action to be un-acknowledged. Optional. If not specified, all actions of the watch will be un-acknowledged.

## Request Body

No request body is required for this endpoint.

## Responses

### 200 OK

A watch identified by the given id exists and was successfully un-acknowledged.

### 403 Forbidden

The user does not have the permission to un-acknowledge watches for the currently selected tenant. 

### 404 Not Found

A watch with the given id does not exist for the current tenant.

### 412 Precondition Failed

The specified action is not acknowledged. Thus, it cannot be un-acknowledged.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/ack` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_WATCH\_ACKNOWLEDGE

## Examples


```
DELETE /_signals/watch/_main/bad_weather/_ack_and_get/email
```

**Response**

```
200 OK
``` 
```json
{
  "status" : "OK",
  "unacked_action_ids" : [
    "email"
  ]
}
```

