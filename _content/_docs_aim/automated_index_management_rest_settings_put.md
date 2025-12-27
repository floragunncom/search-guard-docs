---
title: Put Settings
html_title: Put Settings
permalink: automated-index-management-rest-settings-put
layout: docs
section: index_management
edition: community
description: Use the put settings REST API to update dynamic AIM settings
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Put Settings
{: .no_toc}

{% include toc.md %}

## Endpoint

```
PUT /_aim/settings/{key}
```

Updates a setting.

## Path Parameters

| Parameter | Note                |
|-----------|---------------------|
| `key`     | Name of the setting |

## Request Body

The settings value has to be specified in JSON format in the request body.

## Responses

### 200 OK

The settings key exists and the user has sufficient privileges to access it. The setting has been updated.

### 403 Forbidden

The user does not have sufficient privileges to access this endpoint.

### 404 Not Found

The requested settings key does not exist.

## Example

```
PUT /_aim/settings/execution.delay
"5m"
```

This sets the execution delay setting to 5 minutes (see [settings](automated-index-management-settings)).

## Privileges

The user needs to have the privilege `cluster:admin:searchguard:aim:settings/put` to access this endpoint.

This permission is included in the following built-in action groups:

- SGS_AIM_ALL
