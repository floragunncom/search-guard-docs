---
title: Permissions
html_title: Configure permissions for Signals Alerting users
slug: elasticsearch-alerting-security-permissions
category: security
order: 100
layout: docs
edition: community
description: 
---

<!--- Copyright 2020 floragunn GmbH -->

# Permissions
{: .no_toc}

{% include toc.md %}

Access control to the Signals API is governed by Search Guard roles. Signals ships  with action groups you can use to grant access to the Signals APIs.

## Watch APIs

| Action group name | Description |
|---|---|
| SGS\_SIGNALS\_ALL | Grants access to all Watch APIs|
| SGS\_SIGNALS\_WATCH\_MANAGE | Grants permission to manage watches. Includes create, read, write and delete operations, and execute, activate/deactivate and acknowledging watches. |
| SGS\_SIGNALS\_WATCH\_READ | Grants read-only access to all Watch APIs. Includes retrieving watches and search for watches, and excludes everything else.|
| SGS\_SIGNALS\_WATCH\_EXECUTE | Grants permissions to manually execute watches using the REST API. |
| SGS\_SIGNALS\_WATCH\_ACTIVATE | Grants permissions to activate and deactivate watches. |
| SGS\_SIGNALS\_WATCH\_ACKNOWLEDGE | Grants permissions to acknowledge watches. |
{: .config-table}

### Applying Watch permissions to roles

Permissions for the Watch API are assigned to roles in the `tenant_permissions` section of the role definition. 

If you do not use the Search Guard multi tenancy feature, permissions are assigned to the default SGS\_GLOBAL\_TENANT.

```
sg_signals_manager:
  cluster_permissions:
    ...
  index_permissions:
    ...
  tenant_permissions:
    - tenant_patterns:
        - 'SGS_GLOBAL_TENANT'
      allowed_actions:
        - 'SGS_SIGNALS_WATCH_MANAGE'
```

If you are using multi tenancy, API permissions can also be configured per tenant:

```
sg_signals_multitenancy:
  cluster_permissions:
    ...
  index_permissions:
    ...
  tenant_permissions:
    - tenant_patterns:
        - 'tenant_1'
      allowed_actions:
        - 'SGS_SIGNALS_WATCH_MANAGE'
    - tenant_patterns:
        - 'tenant_2'
      allowed_actions:
        - 'SGS_SIGNALS_READ'

```

In the example above, a user with the `sg_signals_multitenancy` role has `manage` permissions for watches in `tenant_1`, and `read` only permissions for watches in `tenant_2`.

## Account APIs

Accounts are managed globally, so permissions are assigned to Search Guard roles in the  `cluster_permissions` section. Signals ships with the following action groups:

| Action group name | Description |
|---|---|
| SGS\_SIGNALS\_ACCOUNT\_MANAGE | Grants access to all Account APIs. Allows reading, searching, creating, updating and deleting accounts.|
| SGS\_SIGNALS\_ALL | Equivalent to SGS\_SIGNALS\_ACCOUNT\_MANAGE|
| SGS\_SIGNALS\_ACCOUNT\_READ | Grants read-only access to the Account APIs.|
{: .config-table}

### Applying Account permissions to roles

```
sg_account_manager:
  cluster_permissions:
    - SGS_SIGNALS_ACCOUNT_MANAGE
    - SGS_CLUSTER_COMPOSITE
  index_permissions:
    ...
  tenant_permissions:
    ...
```