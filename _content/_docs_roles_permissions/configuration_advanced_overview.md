---
title: Advanced topics
html_title: Advanced authorization configuration
permalink: authorization-advanced-overview
layout: docs
edition: community
description: Advanced authorization topics
---
<!---
Copyright 2022 floragunn GmbH
-->
# Permissions and action groups
{: .no_toc}

{% include toc.md %}

Hint: You can also use the [Search Guard Configuration GUI](../_docs_configuration_changes/configuration_config_gui.md) for configuring the Action Groups.

An action group is simply a collection of permissions with a telling name. Action groups are defined in the file `sg_action_groups.yml` and can be referred to in `sg_roles.yml`. Action groups can be nested. 

Using action groups is the preferred way of assigning permissions to a role.
{: .note .js-note .note-info}

The file structure is very simple:

```yaml
<action group name>:
  reserved: true|false #optional
  description: "..." #optional
  type: "index" #or cluster or kibana, is optional
  allowed_actions:
    - '<permission or action group>'
    - '<permission or action group>'
    - ...
```

Example:

```yaml
_sg_meta:
  type: "actionsgroups"
  config_version: 2
  
MY_ACTION_GROUP:
  reserved: false
  allowed_actions:
    - "indices:data/read/search*"
    - "indices:data/read/msearch*"
    - MY_OTHER_ACTION_GROUP
MY_OTHER_ACTION_GROUP:
  reserved: true
  description: "my other action group"
  type: "index"
  allowed_actions:
    - "indices:data/read/suggest*"
```

## Built-in action groups

Search Guard ships with a list of built-in action groups that are suitable for most use cases. 

### General

| Name | Description |
|---|---|
| SGS_UNLIMITED | Grants complete access, can be used on index- and cluster-level. Equates to `"*"`.|
{: .config-table}

### Index-level action groups

| Name | Description |
|---|---|
| SGS\_INDICES\_ALL | Grants all permissions on the index. Equates to `indices:*`| 
| SGS_READ | Grants read permissions to read (but not search) data, and permissions to fetch field mappings. | 
| SGS_SEARCH | Grants permission to search documents. Includes SUGGEST. |
| SGS_DELETE | Grants permission to delete documents |
| SGS_WRITE | Grants write and delete permissions to documents |
| SGS_CRUD | Combines the READ and WRITE action groups |
| SGS_GET | Grants permission to use get and mget actions |
| SGS_SUGGEST | Grants permission to use the suggest API. Already included in the READ action group. |
| SGS_CREATE_INDEX | Grants permission to create indices and mappings| 
| SGS_MANAGE_ALIASES | Grants permission to manage aliases | 
| SGS_INDICES_MONITOR | Grants permission to execute all actions regarding index monitoring, e.g. recovery, segments info, index stats & status |
| SGS_MANAGE | Grants all monitor and index administration permissions | 
| SGS_INDICES_MANAGE_ILM | Grants permission to use the index lifecycle management APIs for this index | 
{: .config-table}

### Cluster-level action groups

| Name | Description |
|---|---|
| SGS_CLUSTER_ALL | Grants all cluster permissions. Equates to `cluster:*`|
| SGS_CLUSTER_MONITOR | Grants all cluster monitoring permissions. Equates to `cluster:monitor/*`|
| SGS_CLUSTER\_COMPOSITE\_OPS\_RO | Grants read-only permissions to execute multi requests like mget, msearch or mtv, plus permission to query for aliases. |
| SGS_CLUSTER\_COMPOSITE\_OPS | Same as `CLUSTER_COMPOSITE_OPS_RO`, but also grants bulk write permissions and all aliases permissions. |
| SGS_MANAGE_SNAPSHOTS | Grants full permissions to manage snapshots and repositories. |
| SGS_CLUSTER_MANAGE_ILM | Grants the permissions to use the index lifecycle management APIs. |
| SGS_CLUSTER_READ_ILM | Grants read-only permissions to use the index lifecycle management APIs. |
| SGS_CLUSTER_MANAGE_INDEX_TEMPLATES | Grants permission to manage index templates. |
| SGS_CLUSTER_MANAGE_PIPELINES | Grants permissions to manage pipelines. |
{: .config-table}

### Multi- and bulk requests

To execute multi- and bulk requests, the respective user needs to have

* multi and/or bulk permission on cluster level.
  * Assign the `SGS_CLUSTER_COMPOSITE_OPS_RO` or `SGS_CLUSTER_COMPOSITE_OPS` action group on cluster level
* READ and/or WRITE permissions on index level
  * Assign the READ or WRITE action group on index level 

For example, if a user executes a bulk request containing a delete request for index1 and an update request for index2, three permissions are required

* `SGS_CLUSTER_COMPOSITE_OPS` on cluster level
* `SGS_DELETE` permission for index1
* `SGS_WRITE` permission for index2

## Defining your own action groups

You can define your own action groups in `sg_action_groups.yml`. You can use any name you want. And you can also reference an action group from within another action group:

```yaml
MY_ACTION_GROUP:
  allowed_actions:
    - "indices:data/read/search*"
    - "indices:data/read/msearch*"
    - MY_OTHER_ACTION_GROUP
MY_OTHER_ACTION_GROUP:
  allowed_actions:
    - "indices:data/read/suggest*"
```

In this case, the action group `MY_ACTION_GROUP` includes the (wildcarded) `search*` and `msearch*` permissions, and also all permissions defined by the action group `MY_OTHER_ACTION_GROUP`.

You can then reference these action groups in the file `sg_roles.yml` simply by name:

```yaml
sg_human_resources:
  cluster_permissions:
    - SGS_CLUSTER_COMPOSITE_OPS
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - MY_ACTION_GROUP
```        