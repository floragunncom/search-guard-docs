---
title: Audit Logging
slug: audit-logging
category: eeadvanced
order: 200
layout: docs
description: Implement Audit Logging on your Elasticsearch cluster and stay compliant with GDPR, HIPAA, ISO, PCI and SOX.
---
<!---
Copryight 2017 floragunn GmbH
-->

# Audit Logging

Audit logging enables you to track access to your Elasticsearch cluster and stay compliant with security regulations like GDPR, HIPAA, ISO, PCI or SOX. 

Search Guard tracks the following types of events, on REST and transport levels:

* FAILED_LOGIN — the provided credentials of a request could not be validated, most likely because the user does not exist or the password is incorrect. 
* MISSING_PRIVILEGES — an attempt was made to access Elasticsearch, but the user does not have the required permissions.
* BAD_HEADERS — an attempt was made to spoof a request to Elasticsearch with Search Guard internal headers.
* SSL_EXCEPTION — an attempt was made to access Elasticsearch without a valid SSL/TLS certificate.
* SG\_INDEX\_ATTEMPT — an attempt was made to access the Search Guard internal user and privileges index without a valid admin TLS certificate. 
* AUTHENTICATED — A user has been authenticated successfully
* GRANTED_PRIVILEGES - represents a successful request to Elasticsearch.

All events are logged asynchronously, so the audit log has only minimal impact on the performance of your cluster. You can tune the number of threads that Search Guard uses for audit logging.  See the section "Finetuning the thread pool" below.
  
For security reasons, audit logging has to be configured in `elasticsearch.yml`, not in `sg_config.yml`. Thus, changes to the audit log settings require a restart of all participating nodes in the cluster.

## Configuring the categories to be logged

Per default, the audit log module logs all events in all categories. If you want to log only certain events, you can disable categories individually in the `elasticsearch.yml` configuration file:

```yaml
searchguard.audit.config.disabled_categories: [disabled categories]
```

For example:

```yaml
searchguard.audit.config.disabled_categories: AUTHENTICATED, SG_INDEX_ATTEMPT
```

In this case, events in the categories `AUTHENTICATED` and `SG_INDEX_ATTEMPT` will not be logged.

## Configuring the log level

By default, Search Guard logs a reasonable amount of information for each audit log event, suitable for identifying attempted security breaches. This includes the audit category, user information, source IP, date, reason etc.

Search Guard also provides an extended log format, which includes the requested index (including composite index requests), and the query that was submitted. 

This extended logging can be enabled and disabled by setting:

```yaml
# Enable/disable request details logging (default: false)
searchguard.audit.enable_request_details: false
```

## Configuring on which layers audit events are generated

By default, Search Guard logs events on the REST layer only. Since nearly all REST requests are transformed to transport requests internally by Elasticsearch, logging on both layers would lead to duplicate events.

However, if you also use the transport layer to access your Elasticsearch cluster, for example by a TransportClient, you might want to enable transport audit logging as well.

You can configure on which layer Search Guard will produce audit events by the following keys:

```yaml
# Enable/disable rest request logging (default: true)
searchguard.audit.enable_rest: true
# Enable/disable transport request logging (default: false)
searchguard.audit.enable_transport: false
```
## Configuring bulk request handling

Bulk requests can contain an arbitrary number of sub requests. By default, Search Guard will not log these sub requests separately. You can enable this feature by adding:  

```yaml
# Enable/disable bulk request logging (default: false)
# If enabled all subrequests in bulk requests will be logged too
searchguard.audit.resolve_bulk_requests: true
```

This also means that a bulk request containing 2000 sub requests will generate 2000 separate audit events, so only enable this if the usage of bulk requests is limited.

## Configuring the audit log index name

If the audit log events are stored in an Elasticsearch cluster (see Storage Types), Search Guard uses the default index name `auditlog6`. You can change the index name like:

```yaml
searchguard.audit.config.index: auditlog6 
```
You can also use a date pattern in the index name, so you can setup a daily rotating index for example:

```yaml
searchguard.audit.config.index: "'auditlog6-'YYYY.MM.dd"
```

For a reference on the date/time pattern format, please refer to the [Joda DateTimeFormat docs](http://www.joda.org/joda-time/apidocs/org/joda/time/format/DateTimeFormat.html).

## Excluding requests

You can exclude certain requests from being logged completely, by either configuring actions (for transport requests) and/or REST request paths (for REST requests). Events for these actions/request paths will be discarded.

```yaml
# Disable some requests (wildcard or regex of actions or rest request paths)
searchguard.audit.ignore_requests: ["indices:data/read/*","*_bulk"]
```

## Excluding users

By default, Search Guard logs events from all users. In some cases you might want to exclude events created by certain users from being logged. For example, you might want to exclude the Kibana server user or the logstash user. You can define users to be excluded by setting the following configuration:

```yaml
searchguard.audit.ignore_users:
  - kibanaserver
```

## Configuring the storage type

Search guard comes with three audit log storage types. This specifies where you want to store the tracked events. You can choose from:

* debug—outputs the events to stdout.
* internal_elasticsearch—writes the events in a separate audit index on the same cluster.
* external_elasticsearch—writes the events in a separate audit index on another ES cluster.
* webhook-writes the events to an arbitrary HTTP endpoint.

You configure the type of audit logging in the `elasticsearch.yml` file:

```
searchguard.audit.type: <debug|internal_elasticsearch|external_elasticsearch|webhook>
```

Note that it is not possible to specify more than one storage type at the moment.

You can also use your own, custom implementation of storage in case you have special requirements that are not covered by the built-in types. See the section "Custom storage types" below.

### Storage type 'debug'

There are no special configuration settings for this audit type.  Just add the audit type setting in `elasticsearch.yml`:

```
searchguard.audit.type: debug
```

This will output tracked events to stdout, and is mainly useful when debugging or testing.

### Storage type 'internal_elasticsearch'

There are no special configuration settings for this audit type.  Just add the audit type setting in `elasticsearch.yml`:

```yaml
searchguard.audit.type: internal_elasticsearch
```

In addition, you can also specify the index name for the audit events as descibed above.

### Storage type 'external_elasticsearch'

If you want to store the tracked events in a different Elasticsearch cluster than the cluster producing the events, you use `external_elasticsearch` as audit type, configure the Elasticsearch endpoints with hostname/IP and port and optionally the index name and document type:

```yaml
searchguard.audit.type: internal_elasticsearch
searchguard.audit.config.http_endpoints: <endpoints>
searchguard.audit.config.index: <indexname>
searchguard.audit.config.type: <typename>
```

Since v5, you can use date/time pattern in the index name as well, as described for storage type `internal_elasticsearch`.

SearchGuard uses the Elasticsearch REST API to send the tracked events. So, for `searchguard.audit.config.http_endpoints`, use a comma-delimited list of hostname/IP and the REST port (default 9200). For example:

```
searchguard.audit.config.http_endpoints: [192.168.178.1:9200,192.168.178.2:9200]
```

#### Storing audit logs in a Search Guard secured cluster

If you use `external_elasticsearch` as audit type, and the cluster you want to store the audit logs in is also secured by Search Guard, you need to supply some additional configuration parameters.

The parameters depend on what authentication type you configured on the REST layer.

#### TLS settings

| Name | Description |
|---|---|
| searchguard.audit.config.enable_ssl | Boolean, whether or not to use SSL/TLS. If you enabled SSL/TLS on the REST-layer of the receiving cluster, set this to true. Default is false.|
| searchguard.audit.config.verify_hostnames |  Boolean, whether or not to verify the hostname of the SSL/TLS certificate of the receiving cluster. Default is true.|
| searchguard.audit.config.pemtrustedcas_filepath | The trusted Root CA of the external Elasticsearch cluster, **relative to the `config/` directory**. Used to verify the TLS certificate of this cluster|
| searchguard.audit.config.pemtrustedcas_content | Same as `searchguard.audit.config.pemtrustedcas_filepath`, but you can configure the base 64 encoded certificate content directly.|
| searchguard.audit.config.enable\_ssl\_client\_auth | Boolean,  Whether or not to enable SSL/TLS client authentication. If you set this to true, the audit log module will send the node's certificate along with the request. The receiving cluster can use this certificate to verify the identity of the caller.|
| searchguard.audit.config.pemcert_filepath | The path to the TLS certificate to send to the external Elasticsearch cluster, **relative to the `config/` directory**.|
| searchguard.audit.config.pemcert_content | Same as `searchguard.audit.config.pemcert_filepath`, but you can configure the base 64 encoded certificate content directly.|
| searchguard.audit.config.pemkey_filepath | The path to the private key of the TLS certificate to send to the external Elasticsearch cluster, **relative to the `config/` directory**.|
| searchguard.audit.config.pemkey_content | Same as `searchguard.audit.config.pemkey_filepath`, but you can configure the base 64 encoded certificate content directly.|
| searchguard.audit.config.pemkey_password | The password of the private key|


#### Basic auth settings

If you enabled HTTP Basic auth on the receiving cluster, use these settings to specify username and password the the audit log module should use:

```yaml
searchguard.audit.config.username: <username>
searchguard.audit.config.password: <password>
```

### Storage type 'webhook'

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

## Performance considerations

Depending on your configuration, audit logging can have an impact on the performance of your cluster.

### AUTHENTICATED and GRANTED_PRIVILEGES categories

If the AUTHENTICATED and/or GRANTED_PRIVILEGES category is enabled, Search Guard will log all requests, including valid, authenticated requests. Depending on the load of your cluster, this can lead to a huge amount of messages. If you're only interested in security relevant events, disable these categories.

### Bulk request handling

If `searchguard.audit.resolve_bulk_requests` is set to true, all sub requests in a bulk request are logged separately. This makes sense, since some of these sub requests may be permitted, others not, leading to events in the MISSING_PRIVILEGES category. Since bulk requests can carry an arbitrary number of sub requests, this may lead to a huge number of audit events being logged.  

### External storage types

Due to the amount of information stored, the audit log index can grow quite big. It's recommended to use an external storage for the audit messages, like `external_elasticsearch` or `webhook`, so you dont' put your production cluster in jeopardy. 

## Expert: Customizing the audit log event format

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

Make sure that the class is accessible by Search Guard by putting the respective `jar` file in the `plugins/search-guard-2` or `plugins/search-guard-5` folder.


## Expert: Finetuning the thread pool

All events are logged asynchronously, so the overall performance of our cluster will only be affected minimally. Search Guard internally uses a fixed thread pool to submit log events. You can define the number of threads in the pool by the following configuration key in `elasticsearch.yml`:

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