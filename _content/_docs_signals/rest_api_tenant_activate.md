---
title: Activate and Deactivate Tenant
html_title: Activating Watch by tenant
slug: elasticsearch-alerting-rest-api-tenant-activate
category: signals-rest
order: 950
layout: docs
edition: community
description: These endpoints can be used to activate and deactivate the execution of all watches configured for a Signals tenant.
---

<!--- Copyright 2020 floragunn GmbH -->

# Activate/Deactivate Watches by Tenant API
{: .no_toc}

{% include toc.md %}


## Endpoint

```
PUT /_signals/tenant/{tenant}/_active
```

```
DELETE  /_signals/tenant/{tenant}/_active
```

These endpoints can be used to activate and deactivate the execution of all watches configured for a Signals tenant.

Using the PUT verb activates the execution, using the DELETE verb deactivates the execution.

This is equivalent to changing the value of the Signals setting `tenant.{tenant}.active`. However, this API requires a distinct permission. Thus, it is possible to allow a user activation and deactivation of a tenant while the user cannot change other settings.

## Path Parameters

**{tenant}:** The name of the tenant to be activated or deactivated. `_main` refers to the default tenant. Users of the community edition will can only use `_main` here.

## Request Body

No request body is required for this endpoint.

## Responses

### 200 OK

The execution was successfully enabled or disabled.

### 403 Forbidden

The user does not have the permission to activate or deactivate the execution of a tenant. 

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:tenant:signals:tenant/start_stop` .

This permission is included in the following [built-in action groups](security_permissions.md):

* SGS\_SIGNALS\_ALL
