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

### MISFIRE STRATEGY

Signals "misfire" can occur when there are not enough threads to execute the signal. You can configure the relevant strategy for interval and cron triggers using the following configuration.

Simple trigger: `signals.simple_misfire_strategy` (Default is `-1`)
Cron trigger: `signals.cron_misfire_strategy` (Default is `-1`)

The possible values and further details can be found on [quartz scheduler](https://www.quartz-scheduler.org/api/2.1.7/constant-values.html)

## Community support

If you have any questions, please refer to our [Signals Community forum](https://forum.search-guard.com/c/alerting-signals/12).