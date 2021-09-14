---
title: Docker Demo
html_title: Docker Demo
slug: docker
category: quickstart
order: 100
layout: docs
edition: community
description: Use the Search Guard Docker image to quickly spin up a Search Guard equipped OpenSearch/Elasticsearch and Dashboards/Kibana instance.

---

<!--- Copyright 2020 floragunn GmbH -->

# Docker Demo 
{: .no_toc}

To quickly try out Search Guard and Signals Alerting, you can use our demo Docker image. The image comes with a one node OpenSearch/Elasticsearch cluster and Dashboards/Kibana, both already have Search Guard Security and Signals Alerting pre-installed.

To start the image, run:

```
docker run -ti -p 9200:9200 -p 5601:5601 floragunncom/sgdemo
```

After the container is up and OpenSearch/Elasticsearch and Dashboards/Kibana have started, you can access Dashboards/Kibana on:

```
http://localhost:5601 
```

OpenSearch/Elasticsearch runs on:

```
http://localhost:9200
```

The container uses self-signed certificates, so your browser might issue a warning when accessing the OpenSearch/Elasticsearch cluster.

The container comes with some pre-installed demo users. For full access and to configure new roles and permissions, use ```admin/admin``` for login. 

## Troubleshooting

Please note that it might be necessary to set the following host configuration:

`sysctl -w vm.max_map_count=262144`