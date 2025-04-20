---
title: Advanced topics
html_title: Search Guard document-level security advanced topics
permalink: advanced-dls
layout: docs
edition: enterprise
description: Use Document- and Field-Level Security to implement fine grained access
  control to documents and fields in your Elasticsearch cluster.
resources:
- search-guard-presentations#dls-fls|Document- and Field-level security (presentation)
- https://search-guard.com/document-field-level-security-search-guard/|Document- and
  field-level security with Search Guard (blog post)
- https://search-guard.com/attribute-based-document-access/|Attribute based document
  access (blog post)
---
<!---
Copyright 2022 floragunn GmbH
-->

# Document-level security advanced topics
{: .no_toc}

{% include toc.md %}

## DLS execution modes

There are two execution modes for DLS:

- Lucene-level DLS, which is the default, is performed by modifying Lucene queries and data structures. This is the most efficient mode. However, it is unable to support certain advanced constructs used in DLS queries; most importantly, this includes term lookup queries.
- Filter-level DLS is performed at the top level of the Elastic stack by modifying queries directly after they have been received by Elasticsearch. This allows the use of term lookup queries (TLQ) inside of DLS queries, but limits the set of operations that can be used to retrieve data from the protected index to `get`, `search`, `mget`, `msearch`. Also, the use of Cross Cluster Searches is limited in this mode.

By default, Search Guard switches automatically between the modes depending on the DLS queries configured for the index. If a term-lookup query is present, DLS will be performed in filter-level mode. Otherwise, lucene-level mode will be used.

It is however possible to configure Search Guard to always use one specific mode, regardless of the used queries. This can be achieved using the setting `dls.mode` in the file `sg_authz_dlsfls.yml`.

The setting `dls.mode` has three possible values:

* `adaptive` (default): DLS queries without TLQ queries will be executed on the Lucene level. This corresponds to the behaviour in previous Search Guard versions. If a term lookup query is configured as DLS query, Search Guard will automatically switch to filter-level DLS for operations involving the particular index. If there are other non-TLQ DLS queries configured for the same index, these queries will be also enforced on the filter level. Actions operating exclusively on indexes with non-TLQ DLS queries will however still use Lucene level DLS.
* `lucene_level`: Forces all DLS queries to be enforced on Lucene level. This completely corresponds to the DLS operation of Search Guard versions before 52. DLS queries using TLQ will fail using this mode.
* `filter_level`: Forces all DLS queries to be enforced on filter level.  




