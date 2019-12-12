---
title: Multi tenancy
html_title: Using multi-tenancy with Signals Alerting
slug: elasticsearch-alerting-security-multi-tenancy
category: security
order: 300
layout: docs
edition: community
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Multi tenancy
{: .no_toc}

{% include toc.md %}

Signals is fully compatible with Search Guard multi tenancy. To use multi tenancy with Signals, make sure it is enabled in sg_config.yml first:

```yaml
sg_config:
  dynamic:
    do_not_fail_on_forbidden: true 
    kibana:
      multitenancy_enabled: true
```

## How it works

Signals multi tenancy works very similar to [Kibana multi tenancy](../_docs_kibana/kibana_multitenancy.md).

By using multi tenancy, you can separate the management and execution of watches by tenant: 

1. Watches in one tenant will not be accessible for users in another tenant. 
2. Execution of watches in one tenant will not interfere with execution of watches in another tenant.

## API permissions

Access to the [Watch REST API](rest_api.md) can be [granted per tenant](security_permissions.md) as well.

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

## Watch execution in multi tenancy mode

When watches are executed in multi tenancy mode, a thread pool is created for each tenant. This means that execution of watches in one tenant will not interfere with execution of watches in other tenants.
