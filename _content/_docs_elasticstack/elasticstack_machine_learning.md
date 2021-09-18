---
title: X-Pack Machine Learning
permalink: search-guard-xpack-machine-learning
category: elasticstack
order: 800
layout: docs
edition: community
description: How to configure Search Guard to integrate with the X-Pack Machine Learning for Elasticsearch
---
<!---
Copyright 2020 floragunn GmbH
-->
# Using Search Guard with X-Pack Machine Learning
{: .no_toc}

{% include toc.md %}

Search Guard is compatible with the X-Pack Machine Learning component. 

This documentation assumes that you already installed and configured Kibana and the [Search Guard Kibana](../_docs_kibana/kibana_installation.md) plugin.

## Elasticsearch: Enable Machine Learning

In `elasticsearch.yml`, disable X-Pack Security and enable X-Pack Machine Learning:

```yaml
xpack.security.enabled: false
xpack.ml.enabled: true
...
```

## Elasticsearch: Add the machine learning user

For using  X-Pack Machine learning, the respective user must have the built-in `SGS_XP_MACHINE_LEARNINGG` and `SGS_KIBANA_USER` role assigned.

## Kibana: Enable X-Pack Machine Learning

In `kibana.yml`, disable X-Pack Security and enable X-Pack Machine Learning:

```
xpack.security.enabled: false
xpack.ml.enabled: true
...
```
