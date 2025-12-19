---
title: Search Guard 7.x-40.0.0
permalink: changelog-searchguard-7x-40_0_0
layout: docs
section: security
description: Changelog for Search Guard 7.x-40.0.0
---
<!--- Copyright 2020 floragunn GmbH -->

# Changelog for Search Guard 7.x-40.0.0

**Release Date: 22.01.2020**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7)

## Signals Alerting GA

Search Guard v40 now comes with the GA version of Signals, the free Enterprise Alerting solution for Elasticsearch.

Signals Highlights:

* Create an [unlimited amount of watches](elasticsearch-alerting-watches-sample)
* Create datafeeds from the [local or remote Elasticsearch clusters](elasticsearch-alerting-inputs-elasticsearch)
* Create datafeeds from [HTTP endpoints](elasticsearch-alerting-inputs-http)
* Combine and transform data by [using Painless scripting](elasticsearch-alerting-transformations-calculations-overview)
* Create [conditions](elasticsearch-alerting-conditions) and [severity](elasticsearch-alerting-severity) levels to control execution of actions
* [Throttle or acknowledge](elasticsearch-alerting-throttling) watches
* Create notifications via 
  * [Slack](elasticsearch-alerting-actions-slack)
  * [Email](elasticsearch-alerting-actions-email)
  * [Webhooks](elasticsearch-alerting-actions-webhook)
  * [PagerDuty](elasticsearch-alerting-actions-pagerduty)
  * [JIRA](elasticsearch-alerting-actions-jira)
* Write data back to the [local or remote Elasticsearch clusters](elasticsearch-alerting-actions-index)
* Get notified once a [condition has been resolved](elasticsearch-alerting-how-it-works)

Signals can be configured by

* using the [REST API](elasticsearch-alerting-rest-api-overview)
* using the Kibana Signals UI


## Breaking changes

### Signals is enabled by default

When you start your Elasticsearch cluster with Search Guard v40 and above, Signals will be enabled by default.

As long as you do not use Signals, e.g. by creating a watch, there is no performance overhead on your cluster whatsoever. However, Signals will create corresponding indices that it needs to run.

If you do no want to use Signals, you can disable it completely by adding the following  setting to your `elasticsearch.yml`:

```
signals.enabled: false
```

### Signals configuration indices

As Search Guard, Signals stores all configuration settings in protected Elasticsearch   indices.  Upon startup, Signals will create five indexes, all starting with the prefix `.signals_`.

Since those indices store confidential information, for regular users they are only accessible by using the [REST API](elasticsearch-alerting-rest-api-overview). In order to fully access the indices, please use an Admin TLS certificate with tools like curl or sgadmin.

The Signals configuration indices are implemented and behave in the same way as the [Search Guard configuration index](search-guard-index)

### Using wildcard index queries

If you are using wildcard queries, you have two choices:

#### Exclude the protected Signals indices manually

For example:

```
https://sgssl-0.example.com:9200/*,-.signals*,-searchguard/_settings?pretty
```

#### Exclude the indices automatically

Search Guard can exclude both the Search Guard and Signals configuration indices automatically from wildcard or `_all` requests. For backwards compatibility this features is not enabled by default, but will become default in future.

To enable add the following line to elasticsearch.yml:

```
searchguard.filter_sgindex_from_all_requests: true
```

To disable Signals completely, including index creation, add the following line to `elasticsearch.yml` before starting ES with Search Guard 40 installed:

```
signals.enabled: false
```

### Configuring index names

Even though, it should be rarely needed, it is possible to configure the names of the indexes created by Signals. The index names Signals uses can be controlled by the following settings in elasticsearch.yml:

```
signals.index_names.watches: "<indexname>"
signals.index_names.watches_state: "<indexname>"
signals.index_names.watches_trigger_state: "<indexname>"
signals.index_names.accounts: "<indexname>"
```

Please note that changing index names after having started to use Signals is not supported and may lead to failing watches.