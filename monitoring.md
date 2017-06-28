# Using Search Guard with X-Pack Monitoring

Search Guard is compatible with the free X-Pack monitoring component. At the moment, you can only use exporters of type `http`. Support for `local` exporters will be added soon.

This documentation assumes that you already installed and configured Kibana and the [Search Guard Kibana](kibana.md) plugin.

## Elasticsearch: Install X-Pack and enable Monitoring

Install X-Pack on every node in your Elasticsearch Cluster. Please refer to the official X-Pack documentation regarding [installation instructions](https://www.elastic.co/guide/en/x-pack/current/installing-xpack.html).

In `elasticsearch.yml`, disable all componentes but monitoring:

```
xpack.monitoring.enabled: true
xpack.graph.enabled: false
xpack.ml.enabled: false
xpack.reporting.enabled: false
xpack.security.enabled: false
xpack.watcher.enabled: false
```

## Elasticsearch: Add the monitoring user

For the `http` monitoring type, add a user with all permissions to carry out the monitoring calls to your cluster. If you're using Search Guard v13 and above, you can simply map a new or existing user to the `sg_monitor` role. For Search Guard v12 and below, add the following role definition to sg_roles.yml, and map a user to it: 

```
sg_monitor:
  cluster:
    - "cluster:admin/xpack/monitoring/*"
    - "indices:admin/template/get"
    - "indices:admin/template/put"
    - "indices:admin/*get"
    - CLUSTER_MONITOR
    - CLUSTER_COMPOSITE_OPS
  indices:
    '.monitoring*':
      '*':
        - INDICES_ALL
```

## Elasticsearch: Add additional permissions to the Kibana server user

Add the `cluster:admin/xpack/monitoring/bulk*` permission to the Kibana server user:

```
sg_kibana_server:
  cluster:
      ...
      - cluster:admin/xpack/monitoring/bulk*
  indices:
    '?kibana':
      '*':
        ...
```

## Elasticsearch: Configure a monitoring exporter

At the moment Search Guard supports exporters of type `http` only. Configure your `http` exporter, and configure the user you have mapped to the `sg_monitor` role you created in the last step:

```
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

## Kibana: Install X-Pack

As with Elasticsearch, install X-Pack on Kibana. Please refer to the official X-Pack documentation regarding [installation instructions](https://www.elastic.co/guide/en/x-pack/current/installing-xpack.html).
      
## Kibana: Configure X-Pack

As with Elasticsearch, disable all components but monitoring:

```
xpack.monitoring.enabled: true
xpack.graph.enabled: false
xpack.ml.enabled: false
xpack.reporting.enabled: false
xpack.security.enabled: false
xpack.watcher.enabled: false
```

## Known issues and limitations

### Exporter types

At the moment, only `http` is supported. 

### X-Pack welcome screen

With the Kibana plugin v3 and below, you will see an error message and the "X-Pack welcome screen" on the login page:

[Disable X-Pack Welcome screen](https://github.com/floragunncom/search-guard/issues/345)

This will be fixed in the next version of the Kibana plugin.