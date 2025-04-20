---
title: Put Policy
html_title: Put Policy
permalink: automated-index-management-rest-policy-put
layout: docs
edition: community
description: Use the put policy REST API to create or update policies
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Put Policy
{: .no_toc}

{% include toc.md %}

## Endpoint

```
PUT /_aim/policy/{policy_name}
{
    "steps": [ ... ]
}
```

Creates or updates a Policy

## Path Parameters

| Parameter       | Note               |
|-----------------|--------------------|
| `policy_name` | Name of the policy |

## Request Body

The policy has to be specified as JSON document in the request body.

## Responses

### 200 OK

The policy was successfully updated.

### 201 Created

The policy was successfully created.

### 400 Bad Request

The request was malformed. A detailed validation error will be included in the response body.

### 403 Forbidden

The user does not have sufficient privileges to access this endpoint.

### 412 Precondition Failed

The policy already exists and is still in use.

### 415 Unsupported Media Type

The policy was not encoded as JSON document.

### 503 Service Unavailable

AIM is currently inactive.

## Privileges

The user needs to have the privilege `cluster:admin:searchguard:aim:policy/put` to access this endpoint.

This permission is included in the following built-in action groups:

- SGS_AIM_ALL
- SGS_AIM_POLICY_MANAGE
