---
title: Configuring Audit Logging
permalink: audit-logging-compliance
category: auditlog
order: 100
layout: docs
edition: enterprise
description: Implement Audit Logging on your Elasticsearch cluster and stay compliant with GDPR, HIPAA, ISO, PCI and SOX.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Audit Logging
{: .no_toc}

{% include toc.md %}

Audit logging enables you to track access to your Elasticsearch cluster, log security related events and provide evidence in case of an attack. Audit logging helps you to stay compliant with security regulations like GDPR, HIPAA, ISO, PCI or SOX. 

You can configure the categories to be logged, the detail level of the logged messages and how the events should be persisted.

Audit logging is disabled by default. To enable it, you need to configure at least `searchguard.audit.type` in `elasticsearch.yml`. This defines the endpoint where the audit events are stored. To log the events in Elasticsearch and use the Audit Log default settings, simply add the following line in `elasticsearch.yml`:

```
searchguard.audit.type: internal_elasticsearch
```

## Audit Categories

Search Guard tracks the following types of events, on REST and Transport layer:

| Category | Logged on REST | Logged on Transport | Description |
|---|---|---|---|
| FAILED_LOGIN | yes | yes | The provided credentials of a request could not be validated, most likely because the user does not exist or the password is incorrect.|
| AUTHENTICATED | yes | yes | A user has been authenticated successfully. |
| MISSING_PRIVILEGES | no | yes | The user does not have the required permissions to execute the submitted request.|
| GRANTED_PRIVILEGES | no | yes | Represents a successful request to Elasticsearch. |
| SSL_EXCEPTION | yes | yes | An attempt was made to access Elasticsearch without a valid SSL/TLS certificate.|
| SG\_INDEX\_ATTEMPT | no | yes | an attempt was made to modify the Search Guard internal user and privileges index without the required permissions or TLS admin certificate.|
| BAD_HEADERS | yes | yes | An attempt was made to spoof a request to Elasticsearch with Search Guard internal headers.|
{: .config-table}

For security reasons, audit logging has to be configured in `elasticsearch.yml`, not in `sg_config.yml`. Changes to the audit log settings require a restart of all participating nodes in the cluster. 

## Configuring the log level

Search Guard already ships with sensible defaults for the audit log module. These defaults are suitable for almost all cases. However, you can configure and tweak nearly all settings manually to adap the amount and type of information to your specific use case.  

### Excluding categories

Each request can generate audit events in multiple categories, on REST and on Transport layer. By default the Audit Log module logs all events in all categories, but excludes `AUTHENTICATED` and `GRANTED_PRIVILEGES`, which represent successful requests.

You can configure which categories should be excluded for the REST and the Transport layer by setting:

```yaml
searchguard.audit.config.disabled_rest_categories: [disabled categories]
searchguard.audit.config.disabled_transport_categories: [disabled categories]
```

For example:

```yaml
searchguard.audit.config.disabled_rest_categories: AUTHENTICATED, SG_INDEX_ATTEMPT
searchguard.audit.config.disabled_transport_categories: GRANTED_PRIVILEGES
```

In this case, events in the categories `AUTHENTICATED` and `SG_INDEX_ATTEMPT` will not be logged on REST layer, and `GRANTED_PRIVILEGES` events will not be logged on Transport layer.

If you want to log events in all categories, use `NONE`:

```yaml
searchguard.audit.config.disabled_rest_categories: NONE
searchguard.audit.config.disabled_transport_categories: NONE
```

### Disabling REST or Transport events completely

By default Search Guard logs events on both the REST and the Transport layer. If you don't want to log events on a certain layer, instead of excluding all categories for that layer you can also switch it off completely:

```yaml
# Enable/disable rest request logging (default: true)
searchguard.audit.enable_rest: true
# Enable/disable transport request logging (default: true)
searchguard.audit.enable_transport: false
```

### Logging the request body

By default Search Guard includes the body of the request (if available) for both REST and transport layer. 

For the REST layer, this is the body of the HTTP request and contains e.g. the query that the user has submitted:

```json
"audit_request_body": "{\"query\":{\"term\":{\"Designation\":\"Manager\"}}}"
```

For the Transport layer, this is the source field of the transport request:

```json
"audit_request_body": "{\"query\":{\"term\":{\"Designation\":{\"value\":\"Manager\",\"boost\":1.0}}}}"
```

If you do not want or need the request body, you can disable it like:

```yaml
# Enable/disable request body logging (default: true)
searchguard.audit.log_request_body: false
```

### Resolving and logging index names

By default Search Guard will resolve and log all indices affected by the request. Since an index name can be an alias, contain wildcards or date patterns, Search Guard will log both the index name the user has submitted originally, and the concrete index names to which it resolves.

For example, if you use an alias or a wildcard, the respective fields in the audit event may look like:

```json
audit_trace_indices: [
  "human*"
],
audit_trace_resolved_indices: [
  "humanresources"
]
```

You can disable this feature by setting:

```yaml
# Enable/disable resolving index names (default: true)
searchguard.audit.resolve_indices: false
```

Note: Disabling this feature only takes effect if `searchguard.audit.log_request_body ` is also set to `false`
{: .note .js-note .note-warning}

### Configuring bulk request handling

Bulk requests can contain an arbitrary number of sub requests. By default, Search Guard will not log these sub requests as separate events. Only the original request will be logged and carries the subrequests in the request body in JSON format.

Search Guard can be configured to log each subrequest as separate event like:

```yaml
# Enable/disable bulk request logging (default: false)
# If enabled all subrequests in bulk requests will be logged too
searchguard.audit.resolve_bulk_requests: true
```

This also means that a bulk request containing 2000 sub requests will generate 2000 separate audit events. Only enable this feature if your usage of bulk requests is limited.

### Excluding requests

You can exclude certain requests from being logged completely, by either configuring actions (for Transport requests) and/or REST request paths (for REST requests). Events for these actions/request paths will be discarded.

```yaml
# Disable some requests (wildcard or regex of actions or rest request paths)
searchguard.audit.ignore_requests: ["indices:data/read/*", "SearchRequest"]
```

### Excluding users

By default, Search Guard logs events from all users, but excludes the internal Kibana server user `kibanaserver`. You can define users to be excluded from Audit Logging by setting the following configuration:

```yaml
searchguard.audit.ignore_users:
  - kibanaserver
  - admin
```

If requests from all users should be logged, use `NONE`:

```yaml
searchguard.audit.ignore_users: NONE
```

## Configuring the audit log index name

By default Search Guard stores audit events in a daily rolling index named:

```
sg6-auditlog-YYYY.MM.dd
```

You can configure the name of the index in `elasticsearch.yml` like:

```yaml
searchguard.audit.config.index: myauditlogindex 
```

You can use a date pattern in the index name, for example to configure daily, weeky or monthly rolling indices like:

```yaml
searchguard.audit.config.index: "'sg6-auditlog-'YYYY.MM.dd"
```

For a reference on the date/time pattern format, please refer to the [Joda DateTimeFormat docs](http://www.joda.org/joda-time/apidocs/org/joda/time/format/DateTimeFormat.html).


## Performance considerations

### AUTHENTICATED and GRANTED_PRIVILEGES categories

If the AUTHENTICATED and/or GRANTED_PRIVILEGES category is enabled, Search Guard will log all requests, including valid, authenticated requests. Depending on the load on your cluster, this can lead to a huge amount of messages. If you're only interested in security relevant events, do not enable these categories.

### Bulk request handling

If `searchguard.audit.resolve_bulk_requests` is set to true, all sub requests in a bulk request are logged separately. This makes sense, since some of these sub requests may be permitted, others not, leading to events in the MISSING_PRIVILEGES category. Since bulk requests can carry an arbitrary number of sub requests, this may lead to a huge number of additional audit events being logged.  

### External storage types

Due to the amount of information stored, the audit log index can grow quite big. It's recommended to use an external storage for the audit messages, like `external_elasticsearch` or `webhook`, so you dont' put your production cluster in jeopardy. See chapter [Audit Logging Storage Types](auditlogging_storage.md) for a list of available storage endpoints.


## Configuring retries

In case your audit log sinks fail occasionally you can configure a retry mechanism. Please note that the messages for which a retry is needed are only held in memory. So this is not reliable in case of an expected or unexpected node shutdown. If you need reliable audit logs you need to have a performant and high available sink like Apache Kafka.

To enable retry define `searchguard.audit.config.retry_count` in elasticsearch.yml with a value greater then zero. You can also set `searchguard.audit.config.retry_delay_ms` to configure the waiting time until the next retry (default: 1000 which is 1 sec).

A `searchguard.audit.config.retry_count` of 1 means: try and if it fails wait delayMs and try once again.

Example:

```yaml
# try and if it fails wait 500ms and try 10 times again (and wait 500 ms between each try) again
searchguard.audit.config.retry_count: 10
searchguard.audit.config.retry_count: 500

```

## Expert: Finetuning the thread pool

All events are logged asynchronously, so the overall performance of your cluster will only be affected minimally. Search Guard uses a fixed thread pool to submit log events. You can define the number of threads in the pool by the following configuration key in `elasticsearch.yml`:

```yaml
# Tune threadpool size, default is 10 and 0 means disabled
searchguard.audit.threadpool.size: <integer>
```

The default setting is `10`. Setting this value to `0` disables the thread pool completey, and the events are logged synchronously. 

The maximum queue length per thread can be configured by setting:

```yaml
# Tune threadpool max size queue length, default is 100000
searchguard.audit.threadpool.max_queue_len: 100000
```