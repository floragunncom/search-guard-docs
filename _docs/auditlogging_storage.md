---
title: Audit Logging Storage Types
slug: audit-logging-storage
category: auditlog
order: 200
layout: docs
description: Search Guard supports a range of storage types to ship audit log events to. Store them in Elasticsearch, external SIEM or monitoring systems, or implement a custom storage.
---
<!---
Copryight 2017 floragunn GmbH
-->
# Configuring the storage type

Search guard comes with three audit log storage types. This specifies where you want to store the tracked events. You can choose from:

* debug—outputs the events to stdout.
* internal_elasticsearch—writes the events in a separate audit index on the same cluster.
* external_elasticsearch—writes the events in a separate audit index on another ES cluster.
* webhook-writes the events to an arbitrary HTTP endpoint.

You configure the type of audit logging in the `elasticsearch.yml` file:

```yaml
searchguard.audit.type: <debug|internal_elasticsearch|external_elasticsearch|webhook>
```

Note that it is not possible to specify more than one storage type at the moment.

You can also use your own, custom implementation of storage in case you have special requirements that are not covered by the built-in types. See the section "Custom storage types" below.

## Storage type 'debug'

There are no special configuration settings for this audit type.  Just add the audit type setting in `elasticsearch.yml`:

```yaml
searchguard.audit.type: debug
```

This will output tracked events to stdout, and is mainly useful when debugging or testing.

## Storage type 'internal_elasticsearch'

In addition to specifying the type as `internal_elasticsearch`, you can set the index name and the document type:

```yaml
searchguard.audit.type: internal_elasticsearch
searchguard.audit.config.index: <indexname>
searchguard.audit.config.type: <typename>
```

If not specified, Search Guard uses the default value `auditlog` for both index name and document type.

Since v5, you can use a date/time pattern in the index name as well, for example to set up a daily rolling index. For a reference on the date/time pattern format, please refer to the [Joda DateTimeFormat docs](http://www.joda.org/joda-time/apidocs/org/joda/time/format/DateTimeFormat.html).

Example:

```yaml
searchguard.audit.config.index: "'auditlog-'YYYY.MM.dd"
```
 

## Storage type 'external_elasticsearch'

If you want to store the tracked events in a different Elasticsearch cluster than the cluster producing the events, you use `external_elasticsearch` as audit type, configure the Elasticsearch endpoints with hostname/IP and port and optionally the index name and document type:

```yaml
searchguard.audit.type: internal_elasticsearch
searchguard.audit.config.http_endpoints: <endpoints>
searchguard.audit.config.index: <indexname>
searchguard.audit.config.type: <typename>
```

Since v5, you can use date/time pattern in the index name as well, as described for storage type `internal_elasticsearch`.

SearchGuard uses the Elasticsearch REST API to send the tracked events. So, for `searchguard.audit.config.http_endpoints`, use a comma-delimited list of hostname/IP and the REST port (default 9200). For example:

```yaml
searchguard.audit.config.http_endpoints: 192.168.178.1:9200,192.168.178.2:9200
```

### Storing audit logs in a Search Guard secured cluster

If you use `external_elasticsearch` as audit type, and the cluster you want to store the audit logs in is also secured by Search Guard, you need to supply some additional configuration parameters.

The parameters depend on what authentication type you configured on the REST layer.

### TLS settings

Use the following settings to control SSL/TLS:

```yaml
searchguard.audit.config.enable_ssl: <true|false>
```
Whether or not to use SSL/TLS. If you enabled SSL/TLS on the REST-layer of the receiving cluster, set this to true. The default is false.

```yaml
searchguard.audit.config.verify_hostnames: <true|false>
```
Whether or not to verify the hostname of the SSL/TLS certificate of the receiving cluster. The default is true.

```yaml
searchguard.audit.config.enable_ssl_client_auth: <true|false>
```
Whether or not to enable SSL/TLS client authentication. If you set this to true, the audit log module will send the nodes certificate from the keystore along with the request. The receiving cluster can use this certificate to verify the identity of the caller.

Note: The audit log module will use the key and truststore settings configured in the HTTP/REST layer SSL section of elasticsearch.yml. Please refer to the [Search Guard SSL](https://github.com/floragunncom/search-guard-ssl-docs/blob/master/configuration.md) configuration chapter for more information.

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

In addition, you can configure the following keys:

```yaml
searchguard.audit.config.webhook.url: <string>
```
The URL that the log events are shipped to. Can be an HTTP or HTTPS URL.

```yaml
webhook.ssl.verify: <boolean>
```

If true, the TLS certificate provided by the endpoint (if any) will be verified. If set to false, no verification is performed. You can disable this check if you use self-signed certificates, for example.

```yaml
webhook.format: <URL_PARAMETER_GET|URL_PARAMETER_POST|TEXT|JSON|SLACK>
```

The format in which the audit log message is logged:

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

## Customizing the audit log event format

If you need to provide the audit log event in a special format, suitable for consumption by your SIEM system, for example, you can subclass the `com.floragunn.searchguard.auditlog.impl.WebhookAuditLog` class and configure it as custom storage type (see below).

The relevant methods are:

```java
protected String formatJson(final AuditMessage msg) {
  return ...
}
```

This method is called when the webhook format is set to JSON.

```java
protected String formatText(final AuditMessage msg) {
  return ...
}
```

This method is called when the webhook format is set to TEXT.

```java
protected String formatUrlParameters(final AuditMessage msg) {
  return ...
}
```

This method is called when using URL\_PARAMETER\_GET or URL\_PARAMETER\_POST as webhook format.

## Custom storage types

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

Make sure that the class is accessible by Search Guard by putting the respective `jar` file in the `plugins/search-guard-2` or `plugins/search-guard-5` folder.