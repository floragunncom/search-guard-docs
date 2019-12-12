---
title: Put Destination
html_title: Put a destination with the REST API
slug: elasticsearch-alerting-rest-api-destination-put
category: signals-rest
order: 900
layout: docs
edition: community
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Get Settings API
{: .no_toc}

{% include toc.md %}



## Endpoint

```
GET /_signals/settings
```

```
GET /_signals/settings/{key}
```

Retries all Signals settings or a single setting item.

## Path Parameters

**{key}** The configuration setting to be retrieved. See (Signals Administration)[administration.md] for a list of the available settings.

## Responses

### 200 OK

The setting could be successfully retrieved. The value of the settings is returned in the response body.

### 403 Forbidden

The user does not have the permission to retrieve settings.

### 404 Not Found

A setting does not exist for the particular key.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:settings/put`.

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL

## Examples

```
GET /_signals/settings
```

**Response**

```
TODO
```



