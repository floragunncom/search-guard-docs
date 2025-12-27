---
title: Configuration change tracking
html_title: Change tracking
permalink: configuration-integrity
layout: docs
section: security
edition: compliance
description: Track Search Guard configuration changes by using the advanced audit
  logging features.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Search Guard configuration change tracking
{: .no_toc}

{% include toc.md %}

Search Guard is able to monitor read- and write access to the Search Guard configuration index. This makes it possible to track which user has accessed the configuration information, and get notified about any changes immediately.

## Enabling and disabling configuration change tracking

The elasticsearch configuration monitoring can be switched on an off by the following entry in elasticsearch.yml:

| Name | Description |
|---|---|
| searchguard.compliance.history.internal_config_enabled | boolean, whether to enable or disable Search Guard configuration monitoring. Default: true |
{: .config-table}

## Audit log category

The Elasticsearch configuration events are logged in the `COMPLIANCE_INTERNAL_CONFIG_READ` and `COMPLIANCE_INTERNAL_CONFIG_WRITE` category. 

## Read Field reference

### Format, timestamp and category attributes

| Name | Description |
|---|---|
| audit\_format\_version | Audit log message format version, current: 3|
| audit\_utc\_timestamp | UTC timestamp when the event was generated|
| audit\_category | Audit log category, `COMPLIANCE_EXTERNAL_CONFIG` for all events|
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

### Configuration attributes

| Name | Description |
|---|---|
| audit\_trace\_indices | The index name used to read the config. May contain aliases or wildvards.  |
| audit\_trace\_resolve\_indices | The index name used to read the config. May contain aliases or wildcards.  |
| audit\_trace\_doc\_id | The configuration that has been read, one of `internalusers`, `roles`, `rolesmapping`, `actiongroups`, `config`  |
| audit\_request\_body | The configuration that has been read, as JSON string  |
{: .config-table}

### Logged configuration

The `audit_request_body` contains the exact configuration settings the user has seen, for example:

```json
{  
  "SGS_ALL_ACCESS":{  
     "readonly":true,
     "cluster_permissions":[  
        "UNLIMITED"
     ],
     "index_permissions": [
        "index_patterns": ["humanresources", "finance"],
        "allowed_actions": ["READ"]
        "fls": ["FirstName", "LastName"]
     ],
     "tenant_permissions": [
        ...
     ]
}
```

Since the JSON object is stored as String, the quotation marks are escaped in the original output. Depending on your JSON parser you might need to remove them first.
{: .note .js-note .note-warning}

## Write Field reference

### Format, timestamp and category attributes

| Name | Description |
|---|---|
| audit\_format\_version | Audit log message format version, current: 3|
| audit\_utc\_timestamp | UTC timestamp when the event was generated|
| audit\_category | Audit log category, `COMPLIANCE_EXTERNAL_CONFIG` for all events|
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
| audit\_request\_effective\_user | The username of the user that has changed the configuration |
{: .config-table}

### Index attributes

| Name | Description |
|---|---|
| audit\_trace\_indices | Array, the index name(s) as contained in the request. Can contain wildcards, date patterns and aliases.|
| audit\_trace\_resolved\_indices | Array, the resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |
{: .config-table}

### Document and fields attributes

| Name | Description |
|---|---|
| audit\_compliance\_operation | The operation on the configuration, can be one of `CREATE`, `UPDATE` or `DELETE`.  |
| audit\_trace\_doc\_id | Name of the configuration that has changed, one of `internalusers`, `roles`, `rolesmapping`, `actiongroups`, `config` |
{: .config-table}