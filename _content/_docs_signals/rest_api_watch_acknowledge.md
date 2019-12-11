---
title: Acknowledge watch
html_title: Acknowledge a watch with the REST API
slug: elasticsearch-alerting-rest-api-watch-acknowledge
category: signals-rest
order: 700
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Acknowledge Watch API
{: .no_toc}

{% include toc.md %}



## Endpoint

```
PUT /_signals/watch/{tenant_id}/{watch_id}/_ack
```

```
PUT /_signals/watch/{tenant_id}/{watch_id}/_ack/{action_id}
```

These endpoints can be used to acknowledge actions performed by watches. By acknowledging actions, you can temporarily suppress further executions of these actions. 

When an action is acknowledged, its checks will be still executed on schedule. The actual action however won't be executed until the checks determined the action to be inapplicable during at least one scheduled run.  If the checks change their state again afterwards, the action will be normally executed again.


## Path Parameters

**{tenant_id}** The Signals tenant to be used. Specify `_main` to select the default tenant. If multi tenancy is disabled, `_main` is the only possible value.

**{watch_id}** The id of the watch containing the action to be acknowledged. Required.

**{action_id}** The id of the action to be acknowledged. Optional. If not specified, all actions of the watch will be acknowledged.

## Request Body

No request body is required for this endpoint.

## Responses

### 200 OK

A watch identified by the given id exists and was successfully acknowledged.

### 403 Forbidden

The user does not have the permission to acknowledge watches for the currently selected tenant. 

### 404 Not Found

A watch with the given id does not exist for the current tenant.

### 412 Precondition Failed

The specified action was not executed during its last scheduled run. Thus, it cannot be acknowledged.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/ack` for the currently selected tenant.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_WATCH\_ACKNOWLEDGE

## Examples


```
PUT /_signals/watch/_main/bad_weather/_ack/email
```

**Response**

```
200 OK
``` 

