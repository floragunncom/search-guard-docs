---
title: Runtime index privilege evaluation
html_title: Search Guard runtime index privilege evaluation
permalink: authorization-runtime-index-privilege-evaluation
layout: docs
edition: community
description: Understanding how Search Guard performs privilege evaluation at runtime
---
<!---
Copyright 2022 floragunn GmbH
-->
# Runtime index privilege evaluation
{: .no_toc}

{% include toc.md %}

This chapter takes a closer look at how Search Guard applies the configured privileges to actually executed operations in Elasticsearch. 


## Handling references to unauthorized indices

There are several ways how the privileges of a user can be applied to operations performed by that user:

- In the simplest cases, it is a yes/no decision: If a user has the necessary privileges, the operation succeeds and the user gets a `200 OK` result (or similar). On the other hand, if a user does not have the necessary privileges, the operation is not performed and the user receives a `403 Forbidden` result.

- However, depending on the type of operation, the result might be more gradual: Take for example search operations on index patterns (such as the wildcard `*`, which searches all indices). By default, Search Guard will make all indices for which the user does not have privileges, "invisible" to the operation. This means that a search on the index pattern `*` will only return results for indices the user is allowed to see. If a user does not have access to any indices that are matched by the pattern, the user will get a search result with zero search hits. This gradual application of index privileges is also referred to as the `ignore_unauthorized` mode. The name was chosen following the `ignore_unavailable` index option of Elasticsearch, which has a similar goal and operates with similar semantics.

The `ignore_unauthorized` mode of Search Guard is configurable to a certain extent and is described more in detail in the following sections. If you do not want Search Guard to reduce the searched indices based on privileges, you can turn this feature completely off by setting `ignore_unauthorized.enabled` to `false` in `sg_authz.yml`. However, we are not recommending this mode of operation, as disadvantages clearly outweigh advantages. 

**Note:** Older versions of Search Guard had a similar feature called `do_not_fail_on_forbidden`. The `ignore_unauthorized` mode has broader support for operations and refined semantics.

### Rules for ignoring of unauthorized indices

Search Guard applies the  `ignore_unauthorized` treatment only under a set of conditions:

- The `ignore_unauthorized` mode is enabled.

- One of the supported operations is executed. Search Guard supports operations of Elasticsearch which support index patterns or operate on all indices on the cluster. Furthermore, Search Guard provides configuration options to control what operations shall be affected by the `ignore_unauthorized` mode. <!-- See TODO for details. -->

<!-- 
| Name | Rest endpoint | Action |
|---|---|---|
| Field capabilities | `GET /_field_caps` | `indices:data/read/field_caps` |
| Term vectors | `GET /<index>/_termvectors/<id>` | `indices:data/read/tv` |
| Multi term vectors | `POST /_mtermvectors` | `indices:data/read/mtv` |

-->

- The request refers to indices using a pattern (like `*`, `_all` or `index_*`) *OR* has the index option `ignore_unavailable` activated. If you are using the REST API directly, you can activate this option by appending `?ignore_unavailable=true` to the URL.

### Disabling `ignore_unauthorized`

If you choose to disable the `ignore_unauthorized` feature, there are a couple of things to take care of:

- Operations referencing `_all` or `*` will also apply to the legacy `searchguard` index, if it exists. As normal users are normally not allowed to access this index, you will get `403 Forbidden` errors for operations referencing `_all` or `*`. This can be avoided by migrating the `searchguard` index to a hidden index called `.searchguard`. See TODO for details on how to perform this migration.
- Kibana will only work properly for users with full access. Users having access to only a subset of indices will get lots of error messages within Kibana.


## Index alias handling

Before applying any security checks, Search Guard first resolves any alias to the concrete index name(s). Index aliases are thus transparent to Search Guard. The same is true for 

* Index wildcards, also with multiple index names
  * e.g. `https://localhost:9200/i*ex*,otherindex/_search` 
* Date math index names
  * e.g.  `https://localhost:9200/<logstash-{now/d}>/_search/_search`
* Filtered index aliases 

In practice this means that you do not need or can grant permissions on index aliases. You just need to grant permissions on actual index names. For example, if you have an index alias `myalias` pointing to an index `myindex`, you only need to configure permissions for `myindex`. These permissions apply regardless whether the user accesses the index via `myalias` or `myindex`.
