---
title: Get Settings
html_title: Get settings
permalink: elasticsearch-alerting-rest-api-settings-get
category: signals-rest
order: 900
layout: docs
edition: community
description: Use the Alerting for Elasticsearch Get Settings API to retrieve the current Signals configuration
---

<!--- Copyright 2020 floragunn GmbH -->

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

The setting could be successfully retrieved. The value of the settings is returned in the response body. The response format is JSON. This means, that if a setting as a simple textual value, the value will be returned in double quotes. If you specify the header `Accept: text/plain` in the request, you will get a plain text response with unquoted textual values.

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
{
  "active": "true",
  "http": {
    "allowed_endpoints": [
      "https://www.example.com/*",
      "https://intra.example.com/*"
    ]
  },
  "tenant": {
    "_main": {
      "active": "true",
      "node_filter": "node.attr.signals: true"
    }
  }
}
```

```
GET /_signals/settings/watchlog.index
```

**Response**

```
"<.signals_log_{now/d}>"
```


