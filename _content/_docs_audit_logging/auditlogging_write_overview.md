---
title: Overview
html_title: Document Write History
permalink: compliance-write-history-overview
category: auditlog-write-history
order: 100
layout: docs
edition: compliance
description: Use the Write History Audit Logging to monitor changes to sensitive data and stay compliant with GDRP, HIPAA, PCI and SOX.
resources:
  - "https://search-guard.com/gdpr-write-history/|
Write History: Monitoring document changes for GDPR compliance (blog post)"

---
<!---
Copyright 2022 floragunn GmbH
-->

# Write History Audit Logging
{: .no_toc}

{% include toc.md %}

Search Guard can monitor write access to sensitive data in Elasticsearch, and produce an audit trail of all write activity. It uses the [Audit Logging storage](auditlogging_storage.md) engine to ship the emitted audit events to one or more storage endpoints.

Search Guard tracks 

* insertion and deletion of documents 
* insertion and deletion of index templates 
* changes on field level

Changes on field level are written in [JSON patch format](http://jsonpatch.com/):

```json
[
  {
    "op": "remove",
    "path": "/date"
  },
  {
    "op": "replace",
    "path": "/revenue",
    "value": 67000
  },
  {
    "op": "remove",
    "path": "/customers"
  },
  {
    "op": "add",
    "path": "/remarks",
    "value": "none"
  }
]
```

The write history can be used to track changes to PII or otherwise sensitive data. The audit trail will contain date of access, the username, the document id, and a list of the changes on JSON patch format. 

By tracking the insertion and the deletion of documents you can prove when PII data was created and also deleted. This makes it extremely easy to implement GDPR, HIPAA, PCI or SOX compliance.

Audit logging and also the compliance features are statically configured in `elasticsearch.yml` and cannot be changed at runtime.

## Excluding users

You can exclude users from the write history by listing them in `elasticsearch.yml`: 

```yaml
searchguard.compliance.history.write.ignore_users:
  - admin
```

## Configuring the event content

By default Search Guard logs

* the complete document content, in case it is newly created or updated
* a diff in [JSON patch format](http://jsonpatch.com/), in case a document was changed

You can control the level of detail by the following configuration settings in elasticsearch.yml:

| Name | Description |
|---|---|
| searchguard.compliance.history.write.metadata_only | boolean, if set to true Search Guard will not log any document content, only meta data. Enable this if you need to know when a document was created, changed or delete, but you are not interested in the actual content. Default is false. |
| searchguard.compliance.history.write.log_diffs | boolean, if set to true Search Guard will log diffs for document updates. Default is false. |
{: .config-table}

## Performance considerations

### Use a high-volume storage type

The write history can emit a lot of events in a short time. Consider using a storage type or cache that can handle a high volume of events, like Kafka, Redis or AWS Kinesis.