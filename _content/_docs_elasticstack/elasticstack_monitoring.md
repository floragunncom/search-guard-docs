---
title: X-Pack Monitoring
slug: search-guard-xpack-monitoring
category: elasticstack
order: 600
layout: docs
edition: community
description: How to configure Search Guard and X-Pack Monitoring for Elasticsearch
resources:
  - "https://search-guard.com/elasticsearch-monitoring-searchguard/|Using X-Pack Monitoring with Search Guard (blog post)"

---
<!---
Copyright 2019 floragunn GmbH
-->
# Using Search Guard with X-Pack Monitoring
{: .no_toc}

{% include toc.md %}

Search Guard is compatible with the free X-Pack monitoring component. This documentation assumes that you already installed and configured Kibana and the [Search Guard Kibana](../_docs_kibana/kibana_installation.md) plugin.

## Elasticsearch: Enable Monitoring

In `elasticsearch.yml`, disable X-Pack Security and enable X-Pack Monitoring:

```yaml
xpack.security.enabled: false
xpack.monitoring.enabled: true
...
```

## Elasticsearch: Add the monitoring user

For the `http` monitoring type, add a user with all permissions to carry out the monitoring calls to your cluster. If you are using the demo configuration files, assign the roles `sg_xp_monitoring` and the `sg_kibana_user` role to this user.

```yaml
sg_xp_monitoring:
  readonly: true
  indices:
    '?monitor*':
      '*':
        - INDICES_ALL
```

## Elasticsearch: Configure a monitoring exporter

At the moment Search Guard supports exporters of type `http` only. Configure your `http` exporter, and configure the user you have mapped to the `sg_xp_monitoring` and the `sg_kibana_user` role in the last step:

```yaml
xpack.monitoring.exporters:
  id1:
    type: http
    host: ["https://127.0.0.1:9200"]
    auth.username: monitor
    auth.password: monitor
    ssl:
      truststore.path: truststore.jks
      truststore.password: changeit
```

| Name | Description |
|---|---|
| host  |  The hostname of the cluster to monitor |
| auth.username  |  The username of the user mapped to the monitor role|
| auth.password  |  The password of the user mapped to the monitor role|
| truststore.path | the truststore that contains the Root CA and intermediate certificates used to sign the certificates of the cluster to monitor |
| truststore.password | the password for the truststore |

## Kibana: Enable X-Pack Monitoring

In `kibana.yml`, disable X-Pack Security and enable X-Pack Monitoring:

```yaml
xpack.security.enabled: false
xpack.monitoring.enabled: true
...
``` 