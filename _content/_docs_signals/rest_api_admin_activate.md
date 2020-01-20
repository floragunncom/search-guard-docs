---
title: Activate and deactivate watch
html_title: Activating and deactivating a watch with the REST API
slug: elasticsearch-alerting-rest-api-watch-activate
category: signals-rest
order: 500
layout: docs
edition: beta
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Activate/Deactivate Signals API
{: .no_toc}

{% include toc.md %}


## Endpoint

```
PUT /_signals/admin/_active
```

```
DELETE /_signals/admin/_active
```

These endpoints can be used to globally activate and deactivate the execution of all watches in Signals. 

Using the PUT verb activates the execution, using the DELETE verb deactivates the execution.

This is equivalent to changing the value of the Signals setting `active`. However, this API requires a distinct permission. Thus, it is possible to allow a user activation and deactivation of Signals while the user cannot change other settings.

## Request Body

No request body is required for this endpoint.

## Responses

### 200 OK

The execution was successfully enabled or disabled.

### 403 Forbidden

The user does not have the permission to activate or deactivate the execution globally. 

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:admin/start_stop` .

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL
