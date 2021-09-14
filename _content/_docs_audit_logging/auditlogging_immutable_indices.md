---
title: Immutable indices
html_title: Immutable indices
slug: immutable-indices
category: auditlog
order: 700
layout: docs
edition: compliance
description: Use immutable indices to ensure a document cannot be changed once indexed.
resources:
  - "https://search-guard.com/immutable-indices-gdpr/|
How Immutable Indices help you to stay GDPR compliant (blog post)"


---
<!---
Copyright 2020 floragunn GmbH
-->

# Immutable indices
{: .no_toc}

{% include toc.md %}

You can mark any index as immutable. Documents in immutable indices follow the write-once, read-many paradigm. This means that you can create documents, but once created, they cannot be changed anymore, thus making them immutable.

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

## Audit Categories

Search Guard tracks attempts to immutable indices in the auditlog:

| Category | Logged on REST | Logged on Transport | Description |
|---|---|---|---|
| COMPLIANCE_IMMUTABLE_INDEX_ATTEMPT | yes | yes | Attempt to access and immutable index in a way which is not allowed.|
