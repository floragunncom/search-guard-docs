---
title: Get Policy
html_title: Get Policy
permalink: automated-index-management-rest-policy-get
layout: docs
edition: community
description: Use the get policy REST API to get a policy
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Get Policy
{: .no_toc}

{% include toc.md %}

## Endpoint

```
GET /_aim/policy/{policy_name}
```

Retrieves a policy in JSON format.

```
GET /_aim/policy/{policy_name}/internal
```

Retrieves a policy in JSON format including internal steps.

## Path Parameters

| Parameter       | Note               |
|-----------------|--------------------|
| `policy_name` | Name of the policy |

## Responses

### 200 OK

The policy exists and the user has sufficient privileges to access it. The response body contains the policy in JSON format.

### 403 Forbidden

The user does not have sufficient privileges to access this endpoint.

### 404 Not Found

The requested policy does not exist.

## Privileges

The user needs to have the privilege `cluster:admin:searchguard:aim:policy/get` to access this endpoint.

This permission is included in the following built-in action groups:

- SGS_AIM_ALL
- SGS_AIM_POLICY_READ
- SGS_AIM_POLICY_MANAGE
- SGS_AIM_POLICY_INSTANCE_READ
- SGS_AIM_POLICY_INSTANCE_MANAGE
