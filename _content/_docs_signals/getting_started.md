---
title: Getting started with Signals Alerting
html_title: Getting started 
permalink: elasticsearch-alerting-getting-started
category: signals
order: 100
layout: docs
edition: community
description: How to get started with Signals Alerting for Elasticsearch to find anomalies in your data and send alerts
---

<!--- Copyright 2022 floragunn GmbH -->

# Getting started with Signals Alerting for Elasticsearch
{: .no_toc}

{% include toc.md %}

Since v40, Signals Alerting for Elasticsearch is distributed as part of Search Guard. To use Signals, you just need to [install the Search Guard plugin for Elasticsearch and  (optional) Kibana](search-guard-versions) version 40 and above.

Signals is enabled by default, so after the cluster is up you can either use the [REST API](elasticsearch-alerting-rest-api-overview) or the Signals Kibana app to create your first watch.

If you need to disable it, add the following setting to your `elasticsearch.yml`:

```
signals.enabled: false
```

## Users and permissions

Signals integrates perfectly with the Search Guard role-based access control features, so you can define what Search Guard roles should be permitted to use Signals. Signals ships with [pre-defined alerting action groups](elasticsearch-alerting-security-permissions) that can be assigned to any Search Guard role.

A role with full access to all Signals features looks like:

```
sg_signals_manager:
  cluster_permissions:
    - SGS_SIGNALS_ACCOUNT_MANAGE
    - SGS_CLUSTER_COMPOSITE
  index_permissions:
    ...
  tenant_permissions:
    - tenant_patterns:
        - 'SGS_GLOBAL_TENANT'
      allowed_actions:
        - 'SGS_SIGNALS_ALL'
```

Note that Signals is fully compatible with [Search Guard multi-tenancy](kibana-multi-tenancy), which means watches and watch execution can be separated by tenants.

## Sample watches

To start quickly with Signals, we have [prepared sample watches](sample_watches.md) that can be either installed by using the REST API, or the Kibana plugin.

The examples are based on the [Kibana sample data](https://www.elastic.co/guide/en/kibana/current/add-sample-data.html), so you need to import it first.

## First steps

In order to get to speed with Signals quickly, we recommend following our [Signals Alerting: First Steps](https://search-guard.com/signals-elasticsearch-alerting/) blog post. We will release a series of articles describing all Signals features in detail.

## Advanced configuration

Following is advanced configuration for signals that can be added to `elasticsearch.yml` file:

- `signals.all_tenants_active_by_default`: By default, each tenant gets an active Signals scheduler. Set this to false in order to disable this. In order to have an Signals scheduler for a tenant, you then need to use the Signals activate tenant API to explicitly activate a tenant.

- `signals.worker_threads.pool.max_size`: Maximum number of Signals watch runner threads spawned by tenant. Defaults to `3`.

- `signals.worker_threads.pool.keep_alive`: If a Signals watch runner thread is idle for more than the specified time, the thread will be automatically terminated. Defaults to `100` minutes.

- `signals.worker_threads.prio`: The priority used by watch runner threads. Defaults to the normal priority (`5`)

- `signals.watch_log.mapping_total_fields_limit`: The maximum number of field in signals index. Default is `2000`.

- `signals.worker_threads.pool.max_size`: The maximum threads per tenant. Default is `10`.

### MISFIRE STRATEGY

Signals "misfire" can occur when there are not enough threads to execute the signal. You can configure the relevant strategy for interval and cron triggers using the following configuration.

Simple trigger: `SIGNALS_SIMPLE_MISFIRE_STRATEGY`
Cron trigger: `SIGNALS_CRON_MISFIRE_STRATEGY`

The possible values are listed in [quartz scheduler](https://www.quartz-scheduler.org/api/2.1.7/constant-values.html)

## Community support

If you have any questions, please refer to our [Signals Community forum](https://forum.search-guard.com/c/alerting-signals/12).