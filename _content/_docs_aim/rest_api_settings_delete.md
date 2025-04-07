---
title: Delete Settings
html_title: Put Settings
permalink: automated-index-management-rest-settings-delete
layout: docs
edition: community
description: Use the put settings REST API to update dynamic AIM settings
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Delete Settings
{: .no_toc}

{% include toc.md %}

## Endpoint

```
DELETE /_aim/settings/{key}
```

Deletes a setting. AIM will fall back to default configuration for the specified setting.

## Path Parameters

| Parameter | Note                |
|-----------|---------------------|
| `key` | Name of the setting |

## Responses

### 200 OK

The settings key exists and the user has sufficient privileges to access it. The setting has been deleted.

### 403 Forbidden

The user does not have sufficient privileges to access this endpoint.

### 404 Not Found

The requested settings key does not exist.

## Privileges

The user needs to have the privilege `cluster:admin:searchguard:aim:settings/delete` to access this endpoint.

This permission is included in the following built-in action groups:

- SGS_AIM_ALL