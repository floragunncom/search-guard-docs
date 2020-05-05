---
title: Activate and Deactivate Watch
html_title: Activating and deactivating a watch with the REST API
slug: elasticsearch-alerting-rest-api-watch-activate
category: signals-rest
order: 500
layout: docs
edition: community
description: 
---

<!--- Copyright 2020 floragunn GmbH -->

# Activate/Deactivate Watch API
{: .no_toc}

{% include toc.md %}


## Endpoint

```
PUT /_signals/watch/{tenant}/{watch_id}/_active
```

```
DELETE /_signals/watch/{tenant}/{watch_id}/_active
```

These endpoints can be used to activate and deactivate watches. Inactive watches are not automatically executed.

Using the PUT verb activates a watch, using the DELETE verb deactivates a watch.

## Path Parameters

**{tenant}:** The name of the tenant which contains the watch to be activated or deactivated. `_main` refers to the default tenant. Users of the community edition will can only use `_main` here.

**{watch_id}:** The id of the watch to be activated or deactivated. Required.

## Request Body

No request body is required for this endpoint.

## Responses

### 200 OK

A watch identified by the given id exists and was successfully activated or deactivated.

### 403 Forbidden

The user does not have the permission to activate or deactivate watches for the currently selected tenant. 

### 404 Not found

A watch with the given id does not exist for the current tenant.


## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:watch/activate_deactivate` for the currently selected tenant.

This permission is distinct for the permission required to create or updated watches. Thus, a user may be allowed to activate or deactivate watches without being allowed to create or update watches.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_WATCH\_ACTIVATE

## Examples

### Deactivate a Watch 

```
DELETE /_signals/watch/_main/bad_weather/_active
```

**Response**

```
200 OK
``` 

