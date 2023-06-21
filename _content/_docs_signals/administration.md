---
title: Administration
html_title: Administration
permalink: elasticsearch-alerting-administration
category: signals
order: 1100
layout: docs
edition: community
description: How to configure and administer Signals Alerting for Elasticsearch and adapt it to your use cases.
---

<!--- Copyright 2022 floragunn GmbH -->

# Signals Administration
{: .no_toc}

{% include toc.md %}

This chapter describes the admin's point of view of a Signals installation.

## Nodes on which Signals watches are executed

By default, Signals uniformly distributes its watches over all nodes of an Elasticsearch cluster. While a cluster is unchanged, a watch is pinned to exactly one node. The node a watch executes on can be found out using the `_state` REST API.

If a cluster changes, for example because a node joins the cluster, all watches are automatically redistributed to ensure a uniform distribution.

If you want to have a closer control over the distribution of the watches, you can use the Signals configuration setting `tenant.{tenant_name}.node_filter`. You can configure this setting using the settings REST API.

A node filter specifies the nodes on which the watches of a tenant shall be distributed. It uses the same node specification syntax as the Nodes Stats and Nodes Info REST APIs of Elasticsearch. The syntax is documented in detail in the chapter [No specification](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster.html) of the Elasticsearch docs.

For example, using the node filter `signals:true` limits the watch execution to nodes which have `node.attr.signals: true` set in their `elasticsearch.yml`. You can also list node names like `node1,node2,node3`. 

The setting is tenant-specific. So, you can do assign different nodes to each tenant.

**Note:** Don't use the elasticsearch.yml option `signals.enabled` for controlling the distribution. Setting this flag to false will use disable watch execution on a particular node without affecting the distribution. Thus, watches may be assigned to that node. As Signals is disabled, the watch won't be executed, though.


## Dynamic Configuration Options

These settings can be set using the Signals settings REST API:

**active:** If this flag is false, Signals will not execute any scheduled watches. See `tenant.{tenant_name}.active` for the same setting affecting only a single tenant.

**execution.default_throttle_period:** The throttle period to be used if an action does not specify an explicit one. Defaults to `10s`. 

**execution.throttle_period_lower_bound:** A configurable lower bound for throttling. This can serve as a rate limiting feature for watches. If this option is set, actions without an explicit throttle value will default to the lower bound instead of the default throttle period.

**watch_log.index:** The name of the watch log index. Defaults to `<signals_log_{now/d}>` which starts a new index every day. If you expect a higher throughput which makes it necessary to start an index more often, you can use another [date math expression](https://www.elastic.co/guide/en/elasticsearch/reference/current/date-math-index-names.html).

**watch_log.include_node:** If true, the name of the node which executed a watch is logged into the watch log index.

**http.allowed_endpoints:** This settings can be used to restrict the endpoints which can be used from HTTP inputs and webhook actions. This setting defaults to `*`, allowing the use of any endpoint. In order to restrict the endpoints, list the URIs of the endpoints here. You can use `*` as a wildcard anywhere in the URI.

**tenant.{tenant_name}.active:** If this flag is false, Signals will not execute any scheduled watches of the respective tenant.

**tenant.{tenant_name}.node_filter:** Specifies the nodes watches shall be executed on. See [Nodes on which Signals watches are executed](#Nodes-on-which-Signals-watches-are-executed) for details.





## Static Configuration Options

The following configuration options can be made in the elasticsearch.yml configuration file. A restart of the respective node is necessary to bring these options into effect.

**signals.enabled:** Can be used to enable or disable Signals. Optional, boolean, defaults to true. Take care that the value of this setting is consistent for all nodes in a cluster. It is not supported to enable Signals only on a subset of a cluster using this setting. Use the `node_filter` settings for this purpose instead.

**signals.index_names.log:** Specifies the name of the watch log index. Optional, defaults to `<signals_log_{now/d}>`.

**Note:** There are some further configuration options for configuring internal index names. These are not needed for normal operation and should be not used except in very special circumstances.


