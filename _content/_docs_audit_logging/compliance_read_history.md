---
title: Read History Audit Logging
html_title: Read History
permalink: compliance-read-history
layout: docs
edition: compliance
description: Use the Read History Audit Logging to monitor read access to sensitive
  data and stay compliant with GDRP, HIPAA, PCI and SOX.
resources:
- https://search-guard.com/read-history-gdpr/|Using X-Pack Monitoring with Search
  Guard (blog post)
---
<!---
Copyright 2022 floragunn GmbH
-->

# Read History Audit Logging
{: .no_toc}

{% include toc.md %}

Search Guard can monitor read access to sensitive data and fields in Elasticsearch, and produce an audit trail of all access activity. It uses the [Audit Logging storage](audit-logging-storage) engine to ship the emitted audit events to one or more storage endpoints.

Search Guard emits read events if one or more of the configured watched fields was part of the search result. If the watched fields are filtered from the result, for example by source filtering or applying [field-level security](field-level-security), no events are emitted. 

This can be used to track access to PII or otherwise sensitive data. The audit trail will contain date of access, the username, the document id, and a list of the watched fields that were contained in the result. This makes it extremely easy to implement GDPR, HIPAA, PCI or SOX compliance.

Audit logging and also the compliance features are statically configured in `elasticsearch.yml` and cannot be changed at runtime.

## Audit Log Category

Events generated by the read history audit trail are logged in the `COMPLIANCE_DOC_READ` category.

## Configuring the indices and fields to watch

To enable the read history audit trail, list the indices and fields to watch in elasticsearch.yml:

```yaml
searchguard.compliance.history.read.watched_fields:
  - indexname1, field1.1, field1.2, field1.3 ...
  - indexname2, field2.1, field.2.2, field2.3 ...
```

For example:

```yaml
searchguard.compliance.history.read.watched_fields:
  - humanresources,Designation,FirstName,LastName
```

In the example above, any access by any user to either the `Designation`, `FirstName` or `LastName` field will generate an audit event. Wildcards ares supported for both index names and fields.

## Excluding users

You can exclude users from the read history by listing them in `elasticsearch.yml`: 

```yaml
searchguard.compliance.history.read.ignore_users:
  - admin
```

## Logging only metadata

If you do not want to list the accessed fields but only the accessed documents, you can choose to log metadata only:

```yaml
searchguard.compliance.history.read.metadata_only: <true|false>
```


## Field reference

Events in the `COMPLIANCE_DOC_READ` category have the following attributes:

### Format, timestamp and category attributes

| Name | Description |
|---|---|
| audit\_format\_version | Audit log message format version, current: 3|
| audit\_utc\_timestamp | UTC timestamp when the event was generated|
| audit\_category | Audit log category, `COMPLIANCE_DOC_READ` for all events|
{: .config-table}

### Cluster and node attributes

| Name | Description |
|---|---|
| audit\_cluster\_name | Name of the cluster this event was emitted on.|
| audit\_node\_id  | The ID of the node where the event was generated.|
| audit\_node\_name | The name of the node where the event was generated. |
| audit\_node\_elasticsearch\_version        | The Elasticsearch version of the node where the event was generated.|
| audit\_node\_host\_address |The host address of the node where the event was generated.|
| audit\_node\_host\_name |The host address of the node where the event was generated. |
{: .config-table}

### Request attributes

| Name | Description |
|---|---|
| audit\_request\_origin | The layer from which the event originated. One if `TRANSPORT` or `REST`.  |
| audit\_request\_remote\_address | The address where the request came from.  |
{: .config-table}

### User attributes

| Name | Description |
|---|---|
| audit\_request\_effective\_user | The username of the user that has accessed watched fields |
{: .config-table}

### Index attributes

| Name | Description |
|---|---|
| audit\_trace\_indices | Array, the index name(s) as contained in the request. Can contain wildcards, date patterns and aliases.|
| audit\_trace\_resolved\_indices | Array, the resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |
{: .config-table}

### Accessed document and fields attributes

| Name | Description |
|---|---|
| audit\_trace\_doc\_id | Id of the document containing the watched fields. |
| audit\_request\_body | The fields and their value as seen by the user, in JSON format. |
{: .config-table}

## Example

```json
{
  "audit_cluster_name": "searchguard",
  "audit_node_name": "BLK1Yjy",
  "audit_node_elasticsearch_version": "7.17.11",
  "audit_category": "COMPLIANCE_DOC_READ",
  "audit_request_origin": "REST",
  "audit_request_body": "{\"Designation\":\"Manager\",\"FirstName\":\"KRISTI\",\"LastName\":\"LOVIE\"}",
  "audit_node_id": "BLK1YjyTTfCBQf9w-9gEUg",
  "audit_format_version": 3,
  "audit_utc_timestamp": "2018-01-23T15:47:19.374+00:00",
  "audit_request_remote_address": "172.16.0.254",
  "audit_trace_doc_id": "108",
  "audit_node_host_address": "172.16.0.3",
  "audit_request_effective_user": "hr_employee",
  "audit_trace_indices": [
    "humanresources"
  ],
  "audit_trace_resolved_indices": [
    "humanresources"
  ],
  "audit_node_host_name": "sgssl-2.example.com"
}
```

## Performance considerations

### Keeping the watched fields at a minimum

The more fields you watch, the more events are possibly created. Consider only watching fields that you are required to monitor.

### If possible, don't use wildcards in field names

Field names can contain simple wildcards like `*` and `?`. If this is not strictly required by your use case, consider listing all watched fields individually. 

### Use a high-volume storage type

The read history can emit a lot of events in a short time. Consider using a storage type or cache that can handle a high volume of events, like Kafka, Redis or AWS Kinesis.