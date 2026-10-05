---
title: Permissions
html_title: API Permissions
permalink: elasticsearch-alerting-security-permissions
layout: docs
section: alerting
edition: community
description: Configure access permissions for the Alerting API running on Elasticsearch,
  including Watches and Accounts.
---
<!--- Copyright 2022 floragunn GmbH -->

# Setting permissions for Alerting API
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

If you do not use the Search Guard Multi-Tenancy feature, permissions are assigned to the default SGS\_GLOBAL\_TENANT.

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

If you are using Multi-Tenancy, API permissions can also be configured per tenant:

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

Signals supports tenant-independent (global) accounts and tenant accounts. Their permissions are assigned in different sections of a Search Guard role.

### Global account permissions

Permissions for tenant-independent accounts are assigned in `cluster_permissions`:

| Action group name | Description |
|---|---|
| SGS\_SIGNALS\_ALL | Grants all Signals permissions, including account and watch operations.|
| SGS\_SIGNALS\_ACCOUNT\_MANAGE | Grants permission to read, search, create, update and delete tenant-independent accounts.|
| SGS\_SIGNALS\_ACCOUNT\_READ | Grants read-only access to tenant-independent accounts.|
{: .config-table}

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

### Tenant account permissions

Permissions for tenant accounts are assigned in `tenant_permissions`. They apply only to the tenant patterns configured in that entry:

| Action group name | Description |
|---|---|
| SGS\_SIGNALS\_ALL | Grants all tenant-specific Signals permissions in the configured tenants.|
| SGS\_SIGNALS\_TENANT\_ACCOUNT\_MANAGE | Grants permission to read, search, create, update and delete accounts in the configured tenants.|
| SGS\_SIGNALS\_TENANT\_ACCOUNT\_READ | Grants read-only access to accounts in the configured tenants.|
{: .config-table}

```
sg_tenant_account_manager:
  cluster_permissions:
    - SGS_CLUSTER_COMPOSITE
  index_permissions:
    ...
  tenant_permissions:
    - tenant_patterns:
        - 'tenant_1'
        - 'tenant_2'
      allowed_actions:
        - SGS_SIGNALS_TENANT_ACCOUNT_MANAGE
```

`SGS_SIGNALS_ALL` is broader than account management. Prefer the narrower account action groups when a role does not need access to all Signals features.

## Proxy APIs

[Proxies](elasticsearch-alerting-proxies) are managed globally, so permissions are assigned in `cluster_permissions`:

| Action group name | Description |
|---|---|
| SGS\_SIGNALS\_ALL | Grants all Signals permissions, including proxy management.|
| SGS\_SIGNALS\_PROXY\_CONFIG\_WRITE | Grants permission to read, create, update and delete proxies. Includes SGS\_SIGNALS\_PROXY\_CONFIG\_READ.|
| SGS\_SIGNALS\_PROXY\_CONFIG\_READ | Grants read-only access to proxies.|
{: .config-table}

```
sg_signals_watch_manager:
  cluster_permissions:
    - SGS_CLUSTER_COMPOSITE
    - SGS_SIGNALS_PROXY_CONFIG_READ
  index_permissions:
    ...
  tenant_permissions:
    - tenant_patterns:
        - 'SGS_GLOBAL_TENANT'
      allowed_actions:
        - SGS_SIGNALS_WATCH_MANAGE
```

A watch can reference a stored proxy by its ID without any proxy permission. SGS\_SIGNALS\_WATCH\_MANAGE does not include SGS\_SIGNALS\_PROXY\_CONFIG\_READ, though. Grant it to users who create watches in Kibana, so that the **Proxy** field of webhook actions lists the stored proxies. Without it, the field only offers **Default** and **None**, says that the stored proxies can't be listed, and a stored proxy has to be entered by its ID. See [Selecting a proxy in Kibana](elasticsearch-alerting-actions-webhook#selecting-a-proxy-in-kibana).
