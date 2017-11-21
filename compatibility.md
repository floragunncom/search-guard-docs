## Compatibility

### Compatibility with other plugins

If you have other plugins installed, please check the compatibility with Search Guard.

As a rule of thumb, if a plugin is compatible with Shield, it is also compatible with Search Guard. Specifically:

If the plugin talks to Elasticsearch using REST and you have REST TLS enabled, the plugin must also support TLS and HTTP Basic Authentication.

If the plugin talks to Elasticsearch on the transport layer, you need to be able to add the Search Guard SSL plugin and its configuration settings to the transport client. You can read more about using transport clients with a Search Guard secured cluster [in this blog post](https://floragunn.com/searchguard-elasicsearch-transport-clients/).

#### Compatible plugins and tools

The following plugins and tools have been tested for compatibility with Search Guard:

* [Kibana](https://www.elastic.co/de/products/kibana) (with the Search Guard Kibana plugin installed)
* [Logstash](https://www.elastic.co/de/products/logstash)
* [Beats](https://www.elastic.co/de/products/beats)
* [X-Pack Monitoring](https://www.elastic.co/guide/en/x-pack/current/xpack-monitoring.html)
* [X-Pack Alerting](https://www.elastic.co/guide/en/x-pack/current/xpack-alerting.html)
* [X-Pack Machine Learning](https://www.elastic.co/guide/en/x-pack/current/xpack-ml.html)
* [ElastAlert](https://github.com/Yelp/elastalert)
* [Curator](https://github.com/elastic/curator)
* [Kibi](https://siren.solutions/kibi/)
* [syslog-ng](https://syslog-ng.org/) 
* Kopf / [Cerebro](https://github.com/lmenezes/cerebro)
* [Grafana](https://grafana.com/)
* ES-Hadoop / Spark
* [Graylog](http://docs.graylog.org/en/2.3/pages/configuration/elasticsearch.html)

#### Incompatible plugins and tools

* [JDBC Importer](https://github.com/jprante/elasticsearch-jdbc)
