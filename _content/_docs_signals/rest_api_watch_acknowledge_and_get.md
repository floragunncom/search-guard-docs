---
title: Acknowledge And Get
html_title: Acknowledge And Get
permalink: elasticsearch-alerting-rest-api-watch-acknowledge-and-get
category: signals-rest
order: 700
layout: docs
edition: community
description: The Signals Alerting for Elasticsearch API provides an endpoint for acknowledging a watch and suppress notifications until the anomaly disappears. New watch state is also returned by request.

---

<!--- Copyright 2023 floragunn GmbH -->

# Acknowledge And Get Watch API
{: .no_toc}

{% include toc.md %}



## Endpoint

```
PUT /_signals/watch/{tenant}/{watch_id}/_ack_and_get
```

```
PUT /_signals/watch/{tenant}/{watch_id}/_ack_and_get/{action_id}
```

```
PUT /_signals/watch/{tenant}/{watch_id}/instances/{instance_id}/_ack_and_get
```

```
PUT /_signals/watch/{tenant}/{watch_id}/instances/{instance_id}/_ack_and_get/{actionId}
```

These endpoints can be used to acknowledge actions performed by watches. By acknowledging actions, you can temporarily suppress further executions of these actions. 

When an action is acknowledged, its checks will be still executed on schedule. The actual action however won't be executed until the checks determined the action to be inapplicable during at least one scheduled run.  If the checks change their state again afterwards, the action will be normally executed again.

The user who acknowledged a watch or action is tracked and can be obtained using the watch state REST API.

It is possible to withdraw the acknowledgement using the `DELETE` verb on this endpoint. See [Un-acknowledge And Get Watch API](./rest_api_watch_unacknowledge_and_get.md) for details.

The request's response contains in its body the new state of the acknowledged actions. Therefore, the REST operation can be treated as an extended version of the request [Acknowledge Watch](rest_api_watch_acknowledge.md).

## Path Parameters

**{tenant}:** The name of the tenant which contains the watch to be acknowledged. `_main` refers to the default tenant. Users of the community edition can only use `_main` here.

**{watch_id}:** The id of the watch containing the action to be acknowledged. Required.

**{instance_id}** If `watch_id` points out into generic watch then it is necessary to provide `instance_id`. Actions of each generic watch instance can be acknowledged independently.

**{action_id}:** The id of the action to be acknowledged. Optional. If not specified, all actions of the watch will be acknowledged.

## Request Body

No request body is required for this endpoint.

## Responses

### 200 OK

A watch identified by the given id exists and was successfully acknowledged.

### 403 Forbidden

The user does not have the permission to acknowledge watches for the currently selected tenant. 

### 404 Not Found

A watch with the given id (or watch instance) does not exist for the current tenant.

### 412 Precondition Failed

The specified action was not executed during its last scheduled run. Thus, it cannot be acknowledged.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/ack_and_get` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_WATCH\_ACKNOWLEDGE

## Examples


```
PUT /_signals/watch/_main/bad_weather/_ack_and_get/email
```

**Response**

```
200 OK
``` 
```json
{
	"status": "OK",
	"acked": [
		{
			"action_id": "email",
			"by_user": "Oliver",
			"on": "2023-03-16T11:09:02.417291Z"
		}
	]
}
```

