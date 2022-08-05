---
title: Put Settings
html_title: Put Settings
permalink: elasticsearch-alerting-rest-api-settings-put
category: signals-rest
order: 910
layout: docs
edition: community
description: Use the Alerting for Elasticsearch Put Settings API to update the Signals Settings
---

<!--- Copyright 2022 floragunn GmbH -->

# Put Settings API
{: .no_toc}

{% include toc.md %}



## Endpoint

```
PUT /_signals/settings/{key}
```

Updates a Signals configuration setting.

## Path Parameters

**{key}** The configuration setting to be updated. See (Signals Administration)[administration.md] for a list of the available settings.

## Request Body

The value of the setting as JSON. This means that if a setting is a simple textual value, you need to specify the value within quotes.

## Responses

### 200 OK

The setting was updated.

### 400 Bad Request

The request was malformed. 


### 403 Forbidden

The user does not have the permission to set settings.



## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:settings/put`.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL

## Examples

### Node Filter

```
PUT /_signals/tenant._main.node_filter
```
```
"signals:true"
```

**Response**

```
200 OK
```

### Active

```
PUT /_signals/active
```
```
true
```

**Response**

```
200 OK
```


