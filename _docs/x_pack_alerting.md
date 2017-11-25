---
title: X-Pack Alerting
slug: search-guard-xpack-alerting
category: xpack
order: 200
layout: docs
description: How to configure Search Guard and X-Pack Alerting for Elasticsearch
---
<!---
Copryight 2017 floragunn GmbH
-->
# Using Search Guard with X-Pack Alerting

Search Guard is compatible with the X-Pack Alerting component. 

This documentation assumes that you already installed and configured Kibana and the [Search Guard Kibana](kibana.md) plugin.

## Elasticsearch: Install X-Pack and enable Alerting

Install X-Pack on every node in your Elasticsearch Cluster. Please refer to the official X-Pack documentation regarding [installation instructions](https://www.elastic.co/guide/en/x-pack/current/installing-xpack.html).

In `elasticsearch.yml`, disable X-Pack Security and enable X-Pack Alerting:

```
xpack.security.enabled: false
xpack.watcher.enabled: true
...
```

## Elasticsearch: Add the alerting user

If you're using Elasticsearch 5.5.0 with Search Guard v14 and above, you can simply map a new or existing user to the `sg_alerting` role. For Search Guard v12 and below, add the following role definition to `sg_roles.yml`, and map a user to it.

In addition to the `sg_alerting` role, the user should also be assigned to the `sg_kibana` role.

```
sg_alerting:
  cluster:
    - indices:data/read/scroll
    - cluster:admin/xpack/watcher/watch/put
    - cluster:admin/xpack/watcher*
    - CLUSTER_MONITOR
    - CLUSTER_COMPOSITE_OPS
  indices:
    '?kibana*':
      '*':
        - READ
    '?watches*':
      '*':
        - INDICES_ALL
    '?watcher-history-*':
      '*':
        - INDICES_ALL
    '?triggered_watches':
      '*':
        - INDICES_ALL
    '*':
      '*':
        - READ
```

## Kibana: Install X-Pack

As with Elasticsearch, install X-Pack on Kibana. Please refer to the official X-Pack documentation regarding [installation instructions](https://www.elastic.co/guide/en/x-pack/current/installing-xpack.html).
      
## Kibana: Enable X-Pack Alerting

In `kibana.yml`, disable X-Pack Security and enable X-Pack Alerting:


```
xpack.security.enabled: false
xpack.watcher.enabled: true
...
```