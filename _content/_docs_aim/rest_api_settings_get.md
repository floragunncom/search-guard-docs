---
title: Get Settings
html_title: Get Settings
permalink: automated-index-management-rest-settings-get
layout: docs
edition: community
description: Use the get settings REST API to retrieve dynamic AIM settings
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Get Settings
{: .no_toc}

{% include toc.md %}

## Endpoint

```
GET /_aim/settings/{key}
```

Retrieves a dynamic setting and includes the current value in the response body.

## Path Parameters

| Parameter | Note                |
|-----------|---------------------|
| `key` | Name of the setting |

## Responses

### 200 OK

The settings key exists and the user has sufficient privileges to access it. The response body contains the settings value in JSON format.

### 403 Forbidden

The user does not have sufficient privileges to access this endpoint.

### 404 Not Found

The requested setting does not exist.

## Privileges

The user needs to have the privilege `cluster:admin:searchguard:aim:settings/get` to access this endpoint.

This permission is included in the following built-in action groups:

- SGS_AIM_ALL