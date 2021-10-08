---
title: Action Groups
slug: action-groups
category: rolespermissions
order: 200
layout: docs
edition: community
description: How to define and use Search Guard action groups for easy configuration of index-level permissions
---

<!---
Copyright 2017 floragunn GmbH
-->
# Using and defining action groups
{: .no_toc}

{% include_relative _includes/toc.md %}

Hint: You can also use the [Kibana Confguration GUI](kibana_config_gui.md) for configuring the Action Groups.

An action group is simply a collection of permissions with a telling name. Action groups are defined in the file `sg_action_groups.yml` and can be referred to in `sg_roles.yml`. Action groups can be nested. 

The file structure is very simple:

```yaml
<action group name>:
  permissions:
    - '<permission or action groups>'
    - '<permission or action group>'
    - ...
```

**The action group name must not contain dots.**

Using action groups is the preferred way of assigning permissions to a role.

## Pre-defined action groups

Search Guard ships with a list of pre-defined action groups that are suitable for most use cases. 

### General

| Name | Description |
|---|---|
| UNLIMITED | Grants complete access, can be used on index- and cluster-level. Equates to `"*"`.|

### Index-level action groups

| Name | Description |
|---|---|
| INDICES_ALL | Grants all permissions on the index. Equates to `indices:*`| 
| GET | Grants permission to use get and mget actions only |
| READ | Grants read permissions like get, mget or getting field mappings, and search permissons | 
| WRITE | Grants write permissions to documents |
| DELETE | Grants permission to delete documents |
| CRUD | Combines the READ, WRITE and DELETE action groups |
| SEARCH | Grants permission to search documents. Includes SUGGEST. |
| SUGGEST | Grants permission to use the suggest API. Already included in the READ action group. |
| CREATE_INDEX | Grants permission to create indices and mappings| 
| INDICES_MONITOR | Grants permission to execute all actions regarding index monitoring, e.g. recovery, segments info, index stats & status |
| MANAGE_ALIASES | Grants permission to manage aliases | 
| MANAGE | Grants all `monitor` and index administration permissions | 



### Cluster-level action groups

| Name | Description |
|---|---|
| CLUSTER_ALL | Grants all cluster permissions. Equates to `cluster:*`|
| CLUSTER_MONITOR | Grants all cluster monitoring permissions. Equates to `cluster:monitor/*`|
| CLUSTER\_COMPOSITE\_OPS\_RO | Grants read-only permissions to execute multi requests like mget, msearch or mtv, plus permission to query for aliases. |
| CLUSTER\_COMPOSITE\_OPS | Same as `CLUSTER\_COMPOSITE\_OPS\_RO`, but also grants bulk write permissions and all aliases permissions. |
| MANAGE_SNAPSHOTS | Grants full permissions to manage snapshots and repositories. |

### Multi- and bulk requests

To execute mult- and bulk requests, the respective user needs to have

* multi and/or bulk permission on cluster level. 
* the respective permission(s) on index level

For example, if a user exeuctes a bulk request containing a delete request for index1 and an update request for index2, three permissions are required

* bulk permission on cluster level
* delete permission for index1
* write permission for index2

## Defining your own action groups

You can define your own action groups in `sg_action_groups.yml`. You can use any name you want. And you can also reference an action group from within another action group:

```yaml
SEARCH:
  permissions:
    - "indices:data/read/search*"
    - "indices:data/read/msearch*"
    - SUGGEST

SUGGEST:
  permissions:
    - "indices:data/read/suggest*"
```

In this case, the action group `SEARCH` includes the (wildcarded) `search*` and `msearch*` permissions, and also all permissions defined by the action group `SUGGEST`.

You can then reference these action groups in the file `sg_roles.yml` simply by name:

```yaml
sg_readall:
  indices:
    '*':
      '*':
        - SEARCH
```
