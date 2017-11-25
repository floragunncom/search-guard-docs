---
title: X-Pack Machine Learning
slug: search-guard-xpack-machine-learning
category: xpack
order: 300
layout: docs
description: How to configure Search Guard and X-Pack Machine Learning for Elasticsearch
---
<!---
Copryight 2017 floragunn GmbH
-->
# Using Search Guard with X-Pack Machine Learning

Search Guard is compatible with the X-Pack Machine Learning component. 

This documentation assumes that you already installed and configured Kibana and the [Search Guard Kibana](kibana.md) plugin.

## Elasticsearch: Install X-Pack and enable Machine Learning

Install X-Pack on every node in your Elasticsearch Cluster. Please refer to the official X-Pack documentation regarding [installation instructions](https://www.elastic.co/guide/en/x-pack/current/installing-xpack.html).

In `elasticsearch.yml`, disable X-Pack Security and enable X-Pack Machine Learning:


```
xpack.security.enabled: false
xpack.ml.enabled: true
...
```

## Elasticsearch: Add the machine learning user

Add the following role definition to `sg_roles.yml`, and map a user to it.

In addition to the `sg_machine_learning` role, the user should also be assigned to the `sg_kibana` role.

```
sg_machine_learning:
  cluster:
    - CLUSTER_MONITOR
    - CLUSTER_COMPOSITE_OPS
    - cluster:admin/xpack/ml*
    - cluster:admin/persistent*
    - cluster:internal/xpack/ml*
    - indices:data/read/scroll*
  indices:
    '*':
      '*':
        - READ
        - indices:admin/get*
    '?ml-*':
      '*':
        - "*"
```

## Kibana: Install X-Pack

As with Elasticsearch, install X-Pack on Kibana. Please refer to the official X-Pack documentation regarding [installation instructions](https://www.elastic.co/guide/en/x-pack/current/installing-xpack.html).
      
## Kibana: Enable X-Pack Machine Learning

In `kibana.yml`, disable X-Pack Security and enable X-Pack Machine Learning:


```
xpack.security.enabled: false
xpack.ml.enabled: true
...
```