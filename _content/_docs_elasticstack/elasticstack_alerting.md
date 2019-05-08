---
title: X-Pack Alerting
slug: search-guard-xpack-alerting
category: elasticstack
order: 700
layout: docs
edition: community
description: How to configure Search Guard to integrate with the X-Pack Alerting for Elasticsearch
---
<!---
Copyright 2019 floragunn GmbH
-->
# Using Search Guard with X-Pack Alerting
{: .no_toc}

{% include toc.md %}

Search Guard is compatible with the X-Pack Alerting component. 

This documentation assumes that you already installed and configured Kibana and the [Search Guard Kibana](../_docs_kibana/kibana_installation.md) plugin.

## Elasticsearch: Enable Alerting

In `elasticsearch.yml`, disable X-Pack Security and enable X-Pack Alerting:

```yaml
xpack.security.enabled: false
xpack.watcher.enabled: true
...
```

## Elasticsearch: Add the alerting user

For using X-Pack Alerting, the respective user must have the built-in `SGS_XP_ALERTING` and `SGS_KIBANA_USER` role assigned.
      
## Kibana: Enable X-Pack Alerting

In `kibana.yml`, disable X-Pack Security and enable X-Pack Alerting:


```yaml
xpack.security.enabled: false
xpack.watcher.enabled: true
...
```
