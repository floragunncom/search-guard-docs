---
title: Immutable indices
html_title: Immutable indices
slug: immutable-indices
category: auditlog
order: 700
layout: docs
edition: compliance
description: Use the Search Guard Compliance edition to create immutable indices. Documents created in an immutable index cannot be changed after they have been created.
resources:
  - "https://search-guard.com/immutable-indices-gdpr/|
How Immutable Indices help you to stay GDPR compliant (blog post)"


---
<!---
Copyright 2019 floragunn GmbH
-->

# Immutable indices
{: .no_toc}

{% include toc.md %}

You can mark any index in Elasticsearch as immutable. Documents in immutable indices follow the write-once, read-many paradigm. This means that you can create documents, but once created, they cannot be changed anymore, thus making them immutable.

To mark an index immutable, list the index name in elasticsearch.yml like:

```
searchguard.compliance.immutable_indices: 
  - indexA
  - indexB
  - ...
```

## Forbidden operations

Marking an index immutable prevents the following actions from being executed:

* Changing or deleting any existing document
  * this also includes bulk operations
* Deleting the index
* Opening anc closing the index
* Performing a reindex
* Snapshot / restore

## Using an admin certificate

A configured TLS admin certificate can be used to bypass the immutable index checks.