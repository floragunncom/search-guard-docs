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

If the audit log events are stored in an Elasticsearch cluster (see Storage Types), you can configure the name of the index in `elasticsearch.yml` like:

```yaml
searchguard.audit.config.index: auditlog6 
```

You can also use a date pattern in the index name, and by default Search Guard uses a daily rolling index for storing the log events:

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

## Performance considerations

### AUTHENTICATED and GRANTED_PRIVILEGES categories

If the AUTHENTICATED and/or GRANTED_PRIVILEGES category is enabled, Search Guard will log all requests, including valid, authenticated requests. Depending on the load of your cluster, this can lead to a huge amount of messages. If you're only interested in security relevant events, disable these categories.

### Bulk request handling

If `searchguard.audit.resolve_bulk_requests` is set to true, all sub requests in a bulk request are logged separately. This makes sense, since some of these sub requests may be permitted, others not, leading to events in the MISSING_PRIVILEGES category. Since bulk requests can carry an arbitrary number of sub requests, this may lead to a huge number of audit events being logged.  

### External storage types

Due to the amount of information stored, the audit log index can grow quite big. It's recommended to use an external storage for the audit messages, like `external_elasticsearch` or `webhook`, so you dont' put your production cluster in jeopardy. 

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