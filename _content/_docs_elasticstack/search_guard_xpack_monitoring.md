---
title: X-Pack Monitoring
permalink: search-guard-xpack-monitoring
layout: docs
section: security
edition: community
description: How to configure Search Guard to integrate with the free X-Pack Monitoring
  for Elasticsearch
resources:
- https://search-guard.com/elasticsearch-monitoring-searchguard/|Using X-Pack Monitoring
  with Search Guard (blog post)
---
<!---
Copyright 2022 floragunn GmbH
-->
# Using Search Guard with X-Pack Monitoring
{: .no_toc}

{% include toc.md %}

Search Guard is compatible with the free X-Pack monitoring component. This documentation assumes that you already installed and configured Kibana and the [Search Guard Kibana](kibana-plugin-installation) plugin.

## Elasticsearch: Enable Monitoring

In `elasticsearch.yml`, disable X-Pack Security and enable X-Pack Monitoring:

```yaml
xpack.security.enabled: false
xpack.monitoring.enabled: true
...
```

## Elasticsearch: Add the monitoring user

For using X-Pack Monitoring, the respective user must have the built-in `SGS_XP_MONITORING` and `SGS_KIBANA_USER` role assigned.

## Elasticsearch: Configure a monitoring exporter

Configure your `http` exporter, and configure the user you have mapped to the `SGS_XP_MONITORING` and the `SGS_KIBANA_USER` role in the last step:

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
{: .config-table}

## Kibana: Enable X-Pack Monitoring

In `kibana.yml`, disable X-Pack Security and enable X-Pack Monitoring:

```yaml
xpack.security.enabled: false
xpack.monitoring.enabled: true
...
``` 

{% include es8_migration_note.html deprecated_properties="xpack.security.enabled, xpack.monitoring.enabled" %}
