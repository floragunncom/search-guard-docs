---
title: Policy Instance State
html_title: Policy Instance State
permalink: automated-index-management-rest-policy-instance-state
layout: docs
edition: community
description: Use the state REST API to get a state from a managed index
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Policy Instance State
{: .no_toc}

{% include toc.md %}

## Endpoint

```
GET /_aim/policyinstance/{index_name}/state
```

Retrieves the state of a managed index.

## Path Parameters

| Parameter    | Note                      |
|--------------|---------------------------|
| `index_name` | Name of the managed index |

## Responses

### 200 OK

The requested index exists and is managed by AIM. The response body contains the state in JSON format.

### 403 Forbidden

The user does not have sufficient privileges to access this endpoint.

### 404 Not Found

The requested index does not exist or is not managed by AIM.

## Privileges

The user needs to have the privilege `cluster:admin:searchguard:aim:policy:instance:status/get` to access this endpoint.

This permission is included in the following built-in action groups:

- SGS_AIM_ALL
- SGS_AIM_POLICY_INSTANCE_READ
- SGS_AIM_POLICY_INSTANCE_MANAGE
