---
title: Configuration change tracking
html_title: Configuration change tracking
slug: configuration-integrity
category: compliance
order: 600
layout: docs
edition: compliance
description: How to configure event routing to ship the compliance events to their correct storage destination
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard configuration change tracking
{: .no_toc}

{% include_relative _includes/toc.md %}

Search Guard is able to monitor read- and write access to the Search Guard configuration index. This makes it possible to track which user has accessed the configuration information, and get notified about any changes immediately.

## Enabling and disabling configuration change tracking

The elasticsearch configuration monitoring can be switched on an off by the following entry in elasticsearch.yml:

| Name | Description |
|---|---|
| searchguard.compliance.history.internal_config_enabled | boolean, whether to enable or disable Search Guard configuration monitoring. Default: true |

## Audit log category

The Elasticsearch configuration events are logged in the `COMPLIANCE_INTERNAL_CONFIG_READ` and `COMPLIANCE_INTERNAL_CONFIG_WRITE` category. 

## Read Field reference

### Format, timestamp and category attributes

| Name | Description |
|---|---|
| audit\_format\_version | Audit log message format version, current: 3|
| audit\_utc\_timestamp | UTC timestamp when the event was generated|
| audit\_category | Audit log category, `COMPLIANCE_EXTERNAL_CONFIG` for all events|

### Cluster and node attributes

| Name | Description |
|---|---|
| audit\_cluster\_name | Name of the cluster this event was emitted on.|
| audit\_node\_id  | The ID of the node where the event was generated.|
| audit\_node\_name | The name of the node where the event was generated. |
| audit\_node\_host\_address |The host address of the node where the event was generated.|
| audit\_node\_host\_name |The host address of the node where the event was generated. |

### Configuration attributes

| Name | Description |
|---|---|
| audit\_trace\_indices | The index name used to read the config. May contain aliases or wildvards.  |
| audit\_trace\_resolve\_indices | The index name used to read the config. May contain aliases or wildcards.  |
| audit\_trace\_doc\_id | The configuration that has been read, one of `internalusers`, `roles`, `rolesmapping`, `actiongroups`, `config`  |
| audit\_request\_body | The configuration that has been read, as JSON string  |

### Logged configuration

The `audit_request_body` contains the exact configuration settings the user has seen, for example:

```json
{  
   "roles":{  
      "sg_all_access":{  
         "readonly":true,
         "cluster":[  
            "UNLIMITED"
         ],
         "indices":{  
            "*":{  
               "*":[  
                  "UNLIMITED"
               ]
            }
         },
         "tenants":{  
            "admin_tenant":"RW"
         }
      }
     ...
   }
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

### Cluster and node attributes

| Name | Description |
|---|---|
| audit\_cluster\_name | Name of the cluster this event was emitted on.|
| audit\_node\_id  | The ID of the node where the event was generated.|
| audit\_node\_name | The name of the node where the event was generated. |
| audit\_node\_host\_address |The host address of the node where the event was generated.|
| audit\_node\_host\_name |The host address of the node where the event was generated. |

### Request attributes

| Name | Description |
|---|---|
| audit\_request\_origin | The layer from which the event originated. One if `TRANSPORT` or `REST`.  |
| audit\_request\_remote\_address | The adress where the request came from.  |

### User attributes

| Name | Description |
|---|---|
| audit\_request\_effective\_user | The username of the user that has changed the configuration |

### Index attributes

| Name | Description |
|---|---|
| audit\_trace\_indices | Array, the index name(s) as contained in the request. Can contain wildcards, date patterns and aliases.|
| audit\_trace\_resolved\_indices | Array, the resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |

### Document and fields attributes

| Name | Description |
|---|---|
| audit\_compliance\_operation | The operation on the configuration, can be one of `CREATE`, `UPDATE` or `DELETE`.  |
| audit\_trace\_doc\_id | Name of the configuration that has changed, one of `internalusers`, `roles`, `rolesmapping`, `actiongroups`, `config` |
