---
title: Cross Cluster Search Support
html_title: Cross Cluster Search
slug: cross-cluster-search
category: esstack
order: 800
layout: docs
description: Search Guard fully supports the Cross Cluster Search feature of Elasticsearch. Implement access control on distributed clusters.
---
<!---
Copryight 2017 floragunn GmbH
-->
# Cross Cluster Search Support

Search Guard supports [Cross Cluster Search](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-cross-cluster-search.html){:target="_blank"} out of the box, so there is nothing special to configure to make it work. Cross Cluster Search will replace the  [Tribe nodes feature](tribenodes.md), which is deprecated in Elasticsearch 6.x.

## Authentication Flow

When accessing a `remote cluster` from a `coordinating cluster` via Cross Cluster Search:

* Search Guard authenticates the user on the coordinating cluster
* Search Guard fetches the users backend roles on the coordinating cluster
* The call including the authenticated user is forwarded to the remote cluster
* The user's permissions are evaluated on the remote cluster

While it is possible to have different configurations regarding authentication and authorization on the remote and coordinating cluster, it is highly recommended to use the same settings on both.


