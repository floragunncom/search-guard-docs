---
title: Sentinl
slug: search-guard-sentinl
category: x-pack-alternatives
order: 200
layout: docs
description: Replace X-Pack Alerting and Reporting with Sentinl, the alerting and reporting Kibana app by Siren Solutions.
---
<!---
Copryight 2017 floragunn GmbH
-->
# Using Search Guard with SENTINL

As an alternative to X-Pack Alerting and X-Pack Monitoring, we recommend Sentinl by [Siren Solutions](https://siren.io/){:target="_blank"})

Sentinl

> [...] extends Kibi/Kibana 5 with Alerting and Reporting functionality to monitor, notify and report on data series changes using standard queries, programmable validators and a variety of configurable actions - Think of it as a free an independent "Watcher" which also has scheduled "Reporting" capabilities (PNG/PDFs snapshots). SENTINL is also designed to simplify the process of creating and managing alerts and reports in Kibi/Kibana via its App and Spy integration, directly in the Kibi/Kibana UI.

([https://github.com/sirensolutions/sentinl](https://github.com/sirensolutions/sentinl){:target="_blank"})

It's completely free, Open Source, compatible with Search Guard, and a perfect alternative to X-Pack Alerting and X-Pack Monitoring.

In the following description, we assume that you have already installed Elasticsearch and Search Guard.

## Installing Sentinl

Sentinl can be installed like any other Kibana plugin. Simply follow the installation instructions on the [Sentinl Github Page](https://github.com/sirensolutions/sentinl).

## Configuring Search Guard for Sentinl

In order to use Sentinl with Search Guard, the [Kibana server user role](kibana_installation.md) requires additionl permissions. If you use the demo roles shipped with Search Guard, add the following permissions for the Sentinl internal watcher `indices`:

```
sg_kibana_server:
  cluster:
    ...
  indices:
    ...
    'watcher*':
      '*':
       - indices:data/read/search
       - MANAGE
       - CREATE_INDEX
       - INDEX
       - READ
       - WRITE
       - DELETE
```

The [Kibana server user role](kibana_installation.md) also needs read access to all indices that you want to create alerts or reports for:

```
sg_kibana_server:
  cluster:
    ...
  indices:
    ...
    'watcher*':
      '*':
       - indices:data/read/search
       - MANAGE
       - CREATE_INDEX
       - INDEX
       - READ
       - WRITE
       - DELETE
    'human_resources':
      '*':
       - indices:data/read/search
    'finance':
      '*':
       - indices:data/read/search
    ...
```

If you want to be able to create alerts and reports for all indices, use a wildcard as index name:

```
sg_kibana_server:
  cluster:
    ...
  indices:
    ...
    'watcher*':
      '*':
       - indices:data/read/search
       - MANAGE
       - CREATE_INDEX
       - INDEX
       - READ
       - WRITE
       - DELETE
    '*':
      '*':
       - indices:data/read/search
    ...
```