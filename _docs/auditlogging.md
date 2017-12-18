---
title: Configuring Audit Logging
slug: audit-logging-compliance
category: auditlog
order: 200
layout: docs
description: Implement Audit Logging on your Elasticsearch cluster and stay compliant with GDPR, HIPAA, ISO, PCI and SOX.
---
<!---
Copryight 2017 floragunn GmbH
-->

# Audit Logging

Audit logging enables you to track access to your Elasticsearch cluster, log security related events and provide evidence in case of an attack. Audit logging helps you to stay compliant with security regulations like GDPR, HIPAA, ISO, PCI or SOX. 

You can configure the categories to be logged, the detail level of the logged messages and how the events should be persisted.

Audit logging is disabled by default. To enable it, you need to configure at least `searchguard.audit.type` in `elasticsearch.yml`. This defines the endpoint where the audit events are stored. To log the events in Elasticsearch and use the Audit Log default settings, simply add the following line in `elasticsearch.yml`:

```
searchguard.audit.type: internal_elasticsearch
```

## Audit Categories

Search Guard tracks the following types of events, on REST and Transport layer:

**TODO: Make table and add on which layer they are used:**

* FAILED_LOGIN — the provided credentials of a request could not be validated, most likely because the user does not exist or the password is incorrect. 
* MISSING_PRIVILEGES — an attempt was made to access Elasticsearch, but the user does not have the required permissions.
* BAD_HEADERS — an attempt was made to spoof a request to Elasticsearch with Search Guard internal headers.
* SSL_EXCEPTION — an attempt was made to access Elasticsearch without a valid SSL/TLS certificate.
* SG\_INDEX\_ATTEMPT — an attempt was made to access the Search Guard internal user and privileges index without a valid admin TLS certificate. 
* AUTHENTICATED — A user has been authenticated successfully
* GRANTED_PRIVILEGES - represents a successful request to Elasticsearch.

For security reasons, audit logging has to be configured in `elasticsearch.yml`, not in `sg_config.yml`. Changes to the audit log settings require a restart of all participating nodes in the cluster. 

## Configuring the log level

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

**TODO: Example**

For the Transport layer, this is the source field of the transport request:

**TODO: Example**

If you do not want or need the request body, you can disable it like:

```yaml
# Enable/disable request body logging (default: true)
searchguard.audit.log_request_body: false
```

### Resolving and logging index names

By default Search Guard will resolve and log all indices affected by the request. Since an index name can be an alias, contain wildcards or date patterns, Search Guard will log both the index name the user has submitted originally, and the concrete index names to which it resolves.

For example, if you use an alias, the respective fields in the audit event may look like:

**TODO: Example**

Likewise, if the index name contains a wildcard, the fields may look like:

**TODO: Example**

You can disable this feature by setting:

```yaml
# Enable/disable resolving index names (default: true)
searchguard.audit.resolve_indices: false
```

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
searchguard.audit.ignore_requests: ["indices:data/read/*","*_bulk"]
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
auditlog6-YYYY.MM.dd
```

You can configure the name of the index in `elasticsearch.yml` like:

```yaml
searchguard.audit.config.index: myauditlogindex 
```

You can use a date pattern in the index name, for example to configure daily, weeky or monthly rolling indices like:

```yaml
searchguard.audit.config.index: "'auditlog6-'YYYY.MM.dd"
```

For a reference on the date/time pattern format, please refer to the [Joda DateTimeFormat docs](http://www.joda.org/joda-time/apidocs/org/joda/time/format/DateTimeFormat.html).


## Performance considerations

### AUTHENTICATED and GRANTED_PRIVILEGES categories

If the AUTHENTICATED and/or GRANTED_PRIVILEGES category is enabled, Search Guard will log all requests, including valid, authenticated requests. Depending on the load on your cluster, this can lead to a huge amount of messages. If you're only interested in security relevant events, do not enable these categories.

### Bulk request handling

If `searchguard.audit.resolve_bulk_requests` is set to true, all sub requests in a bulk request are logged separately. This makes sense, since some of these sub requests may be permitted, others not, leading to events in the MISSING_PRIVILEGES category. Since bulk requests can carry an arbitrary number of sub requests, this may lead to a huge number of additional audit events being logged.  

### External storage types

Due to the amount of information stored, the audit log index can grow quite big. It's recommended to use an external storage for the audit messages, like `external_elasticsearch` or `webhook`, so you dont' put your production cluster in jeopardy. See chapter [Audit Logging Storage Types](auditlogging_storage.md) for a list of available storage endpoints.

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