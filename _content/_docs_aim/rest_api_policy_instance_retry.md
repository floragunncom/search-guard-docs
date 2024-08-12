---
title: Policy Instance Retry
html_title: Policy Instance Retry
permalink: automated-index-management-rest-policy-instance-retry
category: aim-rest
order: 412
layout: docs
edition: community
description: Use the retry REST API to set the retry flag for a managed index
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Policy Instance Retry
{: .no_toc}

{% include toc.md %}

## Endpoint

```
POST /_aim/retry/{index_name}
```

Sets the retry flag to `true` for the specified managed index. If the policy instance failed, it will be retried on next execution.

## Path Parameters

| Parameter      | Note                      |
|----------------|---------------------------|
| `index_name` | Name of the managed index |

## Responses

### 200 OK

The requested index exists and is managed by AIM. The retry flag was set to `true` successfully.

### 403 Forbidden

The user does not have sufficient privileges to access this endpoint.

### 404 Not Found

The requested index does not exist or is not managed by AIM.

### 503 Service Unavailable

AIM is currently inactive.

## Privileges

The user needs to have the privilege `cluster:admin:searchguard:aim:policy:instance:retry/post` to access this endpoint.

This permission is included in the following built-in action groups:

- SGS_AIM_ALL
- SGS_AIM_POLICY_INSTANCE_MANAGE
