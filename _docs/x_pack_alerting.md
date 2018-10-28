---
title: X-Pack Alerting
slug: search-guard-xpack-alerting
category: xpack
order: 200
layout: docs
edition: community
description: How to configure Search Guard and X-Pack Alerting for Elasticsearch
---
<!---
Copryight 2017 floragunn GmbH
-->
# Using Search Guard with X-Pack Alerting
{: .no_toc}

{% include_relative _includes/toc.md %}

Search Guard is compatible with the X-Pack Alerting component. 

This documentation assumes that you already installed and configured Kibana and the [Search Guard Kibana](kibana_installation.md) plugin.

## Elasticsearch: Install X-Pack and enable Alerting

Install X-Pack on every node in your Elasticsearch Cluster. Please refer to the official X-Pack documentation regarding [installation instructions](https://www.elastic.co/guide/en/x-pack/current/installing-xpack.html){:target="_blank"}.

In `elasticsearch.yml`, disable X-Pack Security and enable X-Pack Alerting:

```yaml
xpack.security.enabled: false
xpack.watcher.enabled: true
...
```

## Elasticsearch: Add the alerting user

For using X-Pack Alerting, the respective user must have the `sg_xp_alerting` and `sg_kibana_user` role assigned.

```yaml
sg_xp_alerting:
  cluster:
    - indices:data/read/scroll
    - cluster:admin/xpack/watcher*
    - cluster:monitor/xpack/watcher*
  indices:
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
        - indices:admin/aliases/get
```

## Kibana: Install X-Pack

As with Elasticsearch, install X-Pack on Kibana. Please refer to the official X-Pack documentation regarding [installation instructions](https://www.elastic.co/guide/en/x-pack/current/installing-xpack.html){:target="_blank"}.
      
## Kibana: Enable X-Pack Alerting

In `kibana.yml`, disable X-Pack Security and enable X-Pack Alerting:


```yaml
xpack.security.enabled: false
xpack.watcher.enabled: true
...
```
