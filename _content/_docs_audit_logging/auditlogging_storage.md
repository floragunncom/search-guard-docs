---
title: Storage Types
html_title: Audit Logging Storage
permalink: audit-logging-storage
category: auditlog
order: 200
layout: docs
edition: enterprise
description: How to store audit events in OpenSearch/Elasticsearch, external SIEM or monitoring systems, or a custom storage.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Configuring storage types
{: .no_toc}

{% include toc.md %}

Search guard comes with multiple audit log storage types. This specifies where you want to store the tracked events. You can choose from:

* debug — outputs the events to stdout.
* internal_elasticsearch — writes the events to an audit index on the same OpenSearch/Elasticsearch cluster.
* external_elasticsearch — writes the events to an audit index on a remote OpenSearch/Elasticsearch cluster.
* webhook - writes the events to an arbitrary HTTP endpoint.
* log4j - writes the events to a log4j logger. You can use any log4j appender like SNMP, JDBC, Cassandra, Kafka etc.
 
You configure the type of audit logging in the `opensearch.yml`/`elasticsearch.yml` file:

```
searchguard.audit.type: <debug|internal_elasticsearch|external_elasticsearch|webhook|log4j>
```

You can also use your own, custom implementation of an audit log storage in case you have special requirements that are not covered by the built-in types. See the section "Custom storage types" below.

## Storage type 'debug'

There are no special configuration settings for this audit type.  Just add the audit type setting in `opensearch.yml`/`elasticsearch.yml`:

```
searchguard.audit.type: debug
```

This will output tracked events to stdout, and is mainly useful when debugging or testing.

## Storage type 'internal_elasticsearch'

There are no special configuration settings for this audit type.  Just add the audit type setting in `opensearch.yml`/`elasticsearch.yml`:

```yaml
searchguard.audit.type: internal_elasticsearch
```

In addition, you can also specify the index name for the audit events as descibed above.

## Storage type 'external_elasticsearch'

If you want to store the tracked events in a different OpenSearch/Elasticsearch cluster than the cluster producing the events, you use `external_elasticsearch` as audit type, configure the OpenSearch/Elasticsearch endpoints with hostname/IP and port and optionally the index name and document type:

```yaml
searchguard.audit.type: internal_elasticsearch
searchguard.audit.config.http_endpoints: <endpoints>
searchguard.audit.config.index: <indexname>
searchguard.audit.config.type: <typename>
```

Since v5, you can use date/time pattern in the index name as well, as described for storage type `internal_elasticsearch`.

SearchGuard uses the OpenSearch/Elasticsearch REST API to send the tracked events. So, for `searchguard.audit.config.http_endpoints`, use a comma-delimited list of hostname/IP and the REST port (default 9200). For example:

```
searchguard.audit.config.http_endpoints: [192.168.178.1:9200,192.168.178.2:9200]
```

### Storing audit logs in a Search Guard secured cluster

If you use `external_elasticsearch` as audit type, and the cluster you want to store the audit logs in is also secured by Search Guard, you need to supply some additional configuration parameters.

The parameters depend on what authentication type you configured on the REST layer.

### TLS settings

| Name | Description |
|---|---|
| searchguard.audit.config.enable_ssl | Boolean, whether or not to use SSL/TLS. If you enabled SSL/TLS on the REST-layer of the receiving cluster, set this to true. Default is false.|
| searchguard.audit.config.verify_hostnames |  Boolean, whether or not to verify the hostname of the SSL/TLS certificate of the receiving cluster. Default is true.|
| searchguard.audit.config.pemtrustedcas_filepath | The trusted Root CA of the external OpenSearch/Elasticsearch cluster, **relative to the `config/` directory**. Used to verify the TLS certificate of this cluster|
| searchguard.audit.config.pemtrustedcas_content | Same as `searchguard.audit.config.pemtrustedcas_filepath`, but you can configure the base 64 encoded certificate content directly.|
| searchguard.audit.config.enable\_ssl\_client\_auth | Boolean,  Whether or not to enable SSL/TLS client authentication. If you set this to true, the audit log module will send the node's certificate along with the request. The receiving cluster can use this certificate to verify the identity of the caller.|
| searchguard.audit.config.pemcert_filepath | The path to the TLS certificate to send to the external OpenSearch/Elasticsearch cluster, **relative to the `config/` directory**.|
| searchguard.audit.config.pemcert_content | Same as `searchguard.audit.config.pemcert_filepath`, but you can configure the base 64 encoded certificate content directly.|
| searchguard.audit.config.pemkey_filepath | The path to the private key of the TLS certificate to send to the external OpenSearch/Elasticsearch cluster, **relative to the `config/` directory**.|
| searchguard.audit.config.pemkey_content | Same as `searchguard.audit.config.pemkey_filepath`, but you can configure the base 64 encoded certificate content directly.|
| searchguard.audit.config.pemkey_password | The password of the private key|
{: .config-table}

### Basic auth settings

If you enabled HTTP Basic auth on the receiving cluster, use these settings to specify username and password the the audit log module should use:

```yaml
searchguard.audit.config.username: <username>
searchguard.audit.config.password: <password>
```

## Storage type 'webhook'

This storage type ships the audit log events to an arbitrary HTTP endpoint. Enable this storage type by adding the following to `elasticsearch.yml:`

```yaml
searchguard.audit.type: webhook
```

Ypu can use the following keys to configure the storage type `webhook`:

| Name | Description |
|---|---|
| searchguard.audit.config.webhook.url | The URL that the log events are shipped to. Can be an HTTP or HTTPS URL.|
| searchguard.audit.config.webhook.ssl.verify | Boolean, if true, the TLS certificate provided by the endpoint (if any) will be verified. If set to false, no verification is performed. You can disable this check if you use self-signed certificates. |
| searchguard.audit.config.webhook.ssl.pemtrustedcas_filepath | The path to the trusted certificate against which the webhook's TLS certificate is validated. |
| searchguard.audit.config.webhook.ssl.pemtrustedcas_content | Same as `searchguard.audit.config.webhook.ssl.pemtrustedcas_content`, but you can configure the base 64 encoded certificate content directly. |
| searchguard.audit.config.webhook.format | The format in which the audit log message is logged, can be one of URL\_PARAMETER\_GET, URL\_PARAMETER\_POST, TEXT, JSON, SLACK |
{: .config-table}

Formats:

**URL\_PARAMETER\_GET**

The audit log message is submitted to the configured webhook URL as HTTP GET. All logged information is appended to the URL as request parameters.

**URL\_PARAMETER\_POST**

The audit log message is submitted to the configured webhook URL as an HTTP POST. All logged information is appended to the URL as request parameters.

**TEXT**

The audit log message is submitted to the configured webhook URL as HTTP POST. The body of the HTTP POST request contains the audit log message in plain text format.

**JSON**

The audit log message is submitted to the configured webhook URL as an HTTP POST. The body of the HTTP POST request contains the audit log message in JSON format.

**SLACK**

The audit log message is submitted to the configured webhook URL as an HTTP POST. The body of the HTTP POST request contains the audit log message in JSON format suitable for consumption by Slack. The default implementation returns `"text": "<AuditMessage#toText>"`

## Storage type 'log4j'

This storage type ships the audit log events to `log4j` to be handled by a `log4j appender`. Enable this storage type by adding the following to `elasticsearch.yml:`

```yaml
searchguard.audit.type: log4j
```

In addition, you can specify the name of the logger and the log level

```yaml
searchguard.audit.config.log4j.logger_name: sgaudit
searchguard.audit.config.log4j.level: INFO
```

By default, Search Guard uses the logger name `sgaudit` and logs the events on `INFO` level. The audit events are stored in JSON format.

log4j comes with a wide range of appenders, and you can use all of them to define where the event is finally stored, including:

* JDBC
* Cassandra
* Kafka
* JMS
* Flume
* ans many more

## Performance considerations

Depending on your configuration, audit logging can have an impact on the performance of your cluster.

### AUTHENTICATED and GRANTED_PRIVILEGES categories

If the AUTHENTICATED and/or GRANTED_PRIVILEGES category is enabled, Search Guard will log all requests, including valid, authenticated requests. Depending on the load of your cluster, this can lead to a huge amount of messages. If you're only interested in security relevant events, disable these categories.

### Bulk request handling

If `searchguard.audit.resolve_bulk_requests` is set to true, all sub requests in a bulk request are logged separately. This makes sense, since some of these sub requests may be permitted, others not, leading to events in the MISSING_PRIVILEGES category. Since bulk requests can carry an arbitrary number of sub requests, this may lead to a huge number of audit events being logged.  

### External storage types

Due to the amount of information stored, the audit log index can grow quite big. It's recommended to use an external storage for the audit messages, like `external_elasticsearch` or `webhook`, so you dont' put your production cluster in jeopardy. 

## Expert: Custom storage types

If you have special requirements regarding the storage, you can always implement your own storage type and let the audit log module use it instead of the built in types.

### Implementing a custom storage

Implementing a custom storage is very easy. You just write a class with **a default constructor** that extends `com.floragunn.searchguard.auditlog.impl.AbstractAuditLog`. You need to implement only two methods:

```java
protected void save(final AuditMessage msg) {
}

public void close() throws IOException {
}
```

The `save` method is responsible for storing the event to whatever storage you require. The interface `AuditLog` also extends `java.io.Closeable`. If the node is shut down, this method is called, and you can use it to close any resources you have used. For example, the `HttpESAuditLog` uses it to close the connection to the remote ES cluster.

### Configuring a custom storage

In order for Search Guard to pick up your custom implementation, specify its fully qualified name as `searchguard.audit.type`:

```yaml
searchguard.audit.type: com.example.MyCustomAuditLogStorage
```

Make sure that the class is accessible by Search Guard by putting the respective `jar` file in the `plugins/search-guard-{{site.searchguard.esmajorversion}}` folder.


## Expert: Finetuning the thread pool

All events are logged asynchronously, so the overall performance of our cluster will only be affected minimally. Search Guard internally uses a fixed thread pool to submit log events. You can define the number of threads in the pool by the following configuration key in `opensearch.yml`/`elasticsearch.yml`:

```yaml
# Tune threadpool size, default is 10 and 0 means disabled
searchguard.audit.threadpool.size: <integer>
```

The default setting is `10`. Setting this value to `0` disables the thread pool completey, and the events are logged synchronously. 

The maximum queue length per thread can also be configured:

```yaml
# Tune threadpool max size queue length, default is 100000
searchguard.audit.threadpool.max_queue_len: 100000
```