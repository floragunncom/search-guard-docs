---
title: Delete Policy
html_title: Delete Policy
permalink: automated-index-management-rest-policy-delete
layout: docs
edition: community
description: Use the delete policy REST API to delete policies
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Delete Policy
{: .no_toc}

{% include toc.md %}

## Endpoint

```
DELETE /_aim/policy/{policy_name}
```

Deletes a Policy

## Path Parameters

| Parameter       | Note               |
|-----------------|--------------------|
| `policy_name` | Name of the policy |

## Responses

### 200 OK

The policy was successfully deleted.

### 403 Forbidden

The user does not have sufficient privileges to access this endpoint.

### 404 Not Found

The requested policy does not exist.

### 412 Precondition Failed

The policy exists and is still in use.

### 503 Service Unavailable

AIM is currently inactive.

## Privileges

The user needs to have the privilege `cluster:admin:searchguard:aim:policy/delete` to access this endpoint.

This permission is included in the following built-in action groups:

- SGS_AIM_ALL
- SGS_AIM_POLICY_MANAGE
