---
title: Search Guard Compatibility
html_title: Compatibility
permalink: search-guard-compatibility
category: installation
order: 1000
layout: docs
description: Compatibility of Search Guard with other plugins and tools like Dashboards/Kibana, logstash, Beats, Grafana or Cerebro. 
---
<!---
Copyright 2020 floragunn GmbH
-->
# Compatibility
{: .no_toc}

{% include toc.md %}

## Compatibility with other plugins

If you have other plugins installed, please check the compatibility with Search Guard.

As a rule of thumb, if a plugin is compatible with Elasticstack Security, it is also compatible with Search Guard. Specifically:

If the plugin talks to OpenSearch/Elasticsearch using REST and you have REST TLS enabled, the plugin must also support TLS and HTTP Basic Authentication.

If the plugin talks to OpenSearch/Elasticsearch on the transport layer, you need to be able to add the Search Guard SSL plugin and its configuration settings to the transport client. You can read more about using transport clients with a Search Guard secured cluster [in this blog post](https://search-guard.com/searchguard-elasicsearch-transport-clients/){:target="_blank"}.

## Compatible plugins and tools

The following plugins and tools have been tested for compatibility with Search Guard:

* [Kibana](https://www.elastic.co/de/products/kibana){:target="_blank"} (with the Search Guard Kibana plugin installed)
* [Logstash](https://www.elastic.co/de/products/logstash){:target="_blank"}
* [Beats](https://www.elastic.co/de/products/beats){:target="_blank"}
* [X-Pack Monitoring](https://www.elastic.co/guide/en/x-pack/current/xpack-monitoring.html){:target="_blank"}
* [X-Pack Alerting](https://www.elastic.co/guide/en/x-pack/current/xpack-alerting.html){:target="_blank"}
* [X-Pack Machine Learning](https://www.elastic.co/guide/en/x-pack/current/xpack-ml.html){:target="_blank"}
* [ElastAlert](https://github.com/Yelp/elastalert){:target="_blank"}
* [Curator](https://github.com/elastic/curator){:target="_blank"}
* [Kibi](https://siren.solutions/kibi/){:target="_blank"}
* [syslog-ng](https://syslog-ng.org/){:target="_blank"}
* Kopf / [Cerebro](https://github.com/lmenezes/cerebro){:target="_blank"}
* [Grafana](https://grafana.com/){:target="_blank"}
* ES-Hadoop / Spark
* [Graylog](http://docs.graylog.org/en/2.3/pages/configuration/elasticsearch.html){:target="_blank"}


## Incompatible plugins and tools

* [JDBC Importer](https://github.com/jprante/elasticsearch-jdbc){:target="_blank"}
