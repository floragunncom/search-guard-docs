---
title: Cross Cluster Search
html_title: Cross Cluster Search
permalink: cross-cluster-tribe
category: elasticstack
order: 450
layout: docs
edition: community
description: Search Guard fully supports the Cross Cluster Search feature of Elasticsearch. Implement access control on distributed clusters.
---
<!---
Copyright 2020 floragunn GmbH
-->
# Cross Cluster Search Support
{: .no_toc}

{% include toc.md %}

Search Guard supports [Cross Cluster Search](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-cross-cluster-search.html){:target="_blank"} out of the box, so there is nothing special to configure to make it work. Cross Cluster Search will replace Tribe nodes which are deprecated in Elasticsearch 6.x.

## Authentication Flow

When accessing a `remote cluster` from a `coordinating cluster` via Cross Cluster Search:

* Search Guard authenticates the user on the coordinating cluster
* Search Guard fetches the users backend roles on the coordinating cluster
* The call including the authenticated user is forwarded to the remote cluster
* The user's permissions are evaluated on the remote cluster

While it is possible to have different configurations regarding authentication and authorization on the remote and coordinating cluster, it is highly recommended to use the same settings on both.

## Permissions

To query indices on remote clusters, the user needs to have the following permissions for this index, in addition to the READ or SEARCH permissions:

```
indices:admin/shards/search_shards
```

Example:

```yaml
sg_ humanresources:
  cluster_permissions:
    - SGS_CLUSTER_COMPOSITE_OPS
    - "indices:data/write/bulk"
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - SGS_READ
        - indices:admin/shards/search_shards # needed for CCS        
```