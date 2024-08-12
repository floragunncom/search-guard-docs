---
title: Policy Instance Execute
html_title: Policy Instance Execute
permalink: automated-index-management-rest-policy-instance-execute
category: aim-rest
order: 411
layout: docs
edition: community
description: Use the execute REST API to execute a managed index
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Policy Instance Execute
{: .no_toc}

{% include toc.md %}

## Endpoint

```
POST /_aim/execute/{index_name}
```

Executes the policy instance for the specified index immediately.

## Path Parameters

| Parameter      | Note                      |
|----------------|---------------------------|
| `index_name` | Name of the managed index |

## Responses

### 200 OK

The requested index exists and is managed by AIM. The execution was scheduled successfully.

### 403 Forbidden

The user does not have sufficient privileges to access this endpoint.

### 404 Not Found

The requested index does not exist or is not managed by AIM.

### 503 Service Unavailable

AIM is currently inactive.

## Privileges

The user needs to have the privilege `cluster:admin:searchguard:aim:policy:instance:execute/post` to access this endpoint.

This permission is included in the following built-in action groups:

- SGS_AIM_ALL
- SGS_AIM_POLICY_INSTANCE_MANAGE
