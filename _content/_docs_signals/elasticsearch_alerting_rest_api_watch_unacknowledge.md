---
title: Un-acknowledge Watch
html_title: Un-acknowledge Watch
permalink: elasticsearch-alerting-rest-api-watch-unacknowledge
layout: docs
edition: community
description: The Signals Alerting for Elasticsearch API provides an endpoint for un-acknowledging
  a watch to move it back to the initial state
---
<!--- Copyright 2022 floragunn GmbH -->

# Un-acknowledge Watch API
{: .no_toc}

{% include toc.md %}



## Endpoint

```
DELETE /_signals/watch/{tenant}/{watch_id}/_ack
```

```
DELETE /_signals/watch/{tenant}/{watch_id}/_ack/{action_id}
```

These endpoints can be used to withdraw acknowledgements done by the [Acknowledge Watch API](elasticsearch-alerting-rest-api-watch-acknowledge) or [Acknowledge And Get Watch](elasticsearch-alerting-rest-api-watch-acknowledge-and-get). The un-acknowledged actions will afterwards be in normal state and start executing again.

Please also see the extended version of the requests which returns additional information [Un-Acknowledge And Get Watch](elasticsearch-alerting-rest-api-watch-un-acknowledge-and-get).


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

This permission is included in the following [built-in action groups](elasticsearch-alerting-security-permissions):

* SGS\_SIGNALS\_WATCH\_ACKNOWLEDGE

## Examples


```
DELETE /_signals/watch/_main/bad_weather/_ack/email
```

**Response**

```
200 OK
``` 

