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

Audit logging enables you to track access to your Elasticsearch cluster. Search Guard tracks the following types of events, on REST and transport levels:

* FAILED_LOGIN—the provided credentials of a request could not be validated, most likely because the user does not exist or the password is incorrect. 
* MISSING_PRIVILEGES—an attempt was made to access Elasticsearch, but the user does not have the required permissions.
* BAD_HEADERS—an attempt was made to spoof a request to Elasticsearch with Search Guard internal headers.
* SSL_EXCEPTION—an attempt was made to access Elasticsearch without a valid SSL/TLS certificate.
* SG\_INDEX\_ATTEMPT—an attempt was made to access the Search Guard internal user and privileges index without a valid admin TLS certificate. 
* AUTHENTICATED—represents a successful request to Elasticsearch. 

All events are logged asynchronously, so the audit log has only minimal impact on the performance of your cluster. You can tune the number of threads that Search Guard uses for audit logging.  See the section "Finetuning the thread pool" below.
  
For security reasons, audit logging has to be configured in `elasticsearch.yml`, not in `sg_config.yml`. Thus, changes to the audit log settings require a restart of all participating nodes in the cluster.

## Installation

Download the Audit Log enterprise module:

[Auditlog module](https://oss.sonatype.org/service/local/repositories/releases/content/com/floragunn/dlic-search-guard-module-auditlog/5.3-7/dlic-search-guard-module-auditlog-5.3-7-jar-with-dependencies.jar){:target="_blank"}

and place it in the folder


`<ES installation directory>/plugins/search-guard-5`

After that, restart all nodes to activate the module.
  
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

Search Guard also provides an extended log format, which includes the requested index (including composite index requests), and the query that was submitted. This extended logging can be enabled and disabled by setting:

```yaml
searchguard.audit.enable_request_details: <boolean>
```

Since this extended logging comes with an performance overhead, the default setting is `false`.

### Extended logging caveats

The extended logging can produce a considerable amount of log information. If you plan to use extended logging in production, please keep the following things in mind:

**Exclude the AUTHENTICATED category**

If the AUTHENTICATED category is enabled, Search Guard will log all requests, including valid, authenticated requests. This can lead to a huge amount of messages and **should be avoided in combination with extended logging**.

**Composite requests and field limits**

If a request contains subrequests, Search Guard adds audit information for each subrequest to the audit message separately. This includes the index name, the document type or the source. Each subrequest is identified by a consecutive number, appended to the field name of the logged data.

For example, if a request contains three subrequests, the audit message will contain the affected indices for each subrequest, like:

```yaml
audit_trace_indices_sub_1: ...
audit_trace_indices_sub_2: ...
audit_trace_indices_sub_3: ...
```

If your composite request contains a huge number of subrequests, the produced audit messages will contain a huge number of fields as well. You will likely hit the field limit of Elasticsearch, which defaults to 1000 per index (see the corresponding issue on [GitHub](https://github.com/elastic/elasticsearch/pull/17357)).

If necessary, you can set a higher value for the field limit, even after the index has been created:

```json
PUT auditlog/_settings
{
  "index.mapping.total_fields.limit": 10000
} 
```

However, before increasing the field limit, please think about if it is really necessary to log these kinds of messages at all.

**Use an external storage type**

Due to the amount of information stored, the audit log index can grow quite big. It's recommended to use an external storage for the audit messages, like `external_elasticsearch` or `webhook`, so you dont' put your production cluster in jeopardy.  

## Configuring excluded users (requires Audit Log v5 or above)

By default, Search Guard logs events from all users. In some cases you might want to exclude events created by certain users from being logged. For example, you might want to exclude the Kibana server user or the logstash user. You can define users to be excluded by setting the following configuration:

```yaml
searchguard.audit.ignore_users:
  - kibanaserver
```
## Advanced settings: Finetuning the thread pool

All events are logged asynchronously, so the overall performance of our cluster will only be affected minimally. Search Guard internally uses a fixed thread pool to submit log events. You can define the number of threads in the pool by the following configuration key in `elasticsearch.yml`:

```yaml
searchguard.audit.threadpool.size: <integer>
```

The default setting is `10`. Setting this value to `0` disables the thread pool completey, and the events are logged synchronously. 
