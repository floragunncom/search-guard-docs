---
title: Search Guard roles
html_title: Search Guard roles
slug: roles-permissions
category: rolespermissions
order: 400
layout: docs
edition: community
description: How to define role based access to Elasticsearch on index level with Search Guard.
---
<!---
Copyright 2019 floragunn GmbH
-->

# Defining Search Guard Roles
{: .no_toc}

{% include toc.md %}

Hint: You can also use the [Kibana Confguration GUI](../_docs_configuration_changes/configuration_config_gui.md) for configuring Roles and Permissions.

Search Guard roles are the central place to configure access permissions on:

* Cluster level
* Index level
* Document level
* Field level
* Kibana level

Search Guard roles and their associated permissions are defined in the file `sg_roles.yml`. The syntax to define a role is as follows:

```yaml
_sg_meta:
  type: "roles"
  config_version: 2

<role_name>:
  cluster_permissions:
    - '<action group or single permission>'
    - ...
  index_permissions:
    - index_patterns:
      - <index pattern the allowed actions should be applied to>
      - <index pattern the allowed actions should be applied to>
      - ...      
      allowed_actions:
        - '<action group or single permission>'
        - ...
      dls: '<Document level security query>'
      fls:
        - '<field level security field>'
        - '<field level security field>'        
        - ...
    - index_patterns:
      - ...
  tenant_permissions:
    - tenant_patterns:
      - <tenant pattern the allowed actions should be applied to>
      - <tenant pattern the allowed actions should be applied to>
      - ...      
      allowed_actions:
        - SGS_KIBANA_ALL_WRITE
    - tenant_patterns:
      - ...
```

## Description

| Name | Description |
|---|---|
| cluster_permissions | Permissions that apply on the cluster level, e.g. monitoring the cluster health|
| index_permissions | Permissions that apply to one or more index patterns |
| allowed_actions | The actions that are allowed for the index or tenant patterns |
| dls | The [Document-level security filter query](../_docs_dls_fls/dlsfls_dls.md) that should be applied to the index patterns. Used to filter documents from the result set. |
| fls | The [fields that should be exluded or included](../_docs_dls_fls/dlsfls_fls.md) that should be applied to the index patterns. Used to filter fields from the documents in the result set. |
| tenant_permissions | Permissions that apply to [Kibana tenants](../_docs_kibana/kibana_multitenancy.md). Used to control access to Kibana. |


## Cluster-level permissions

The `cluster_permissions` entry is used to define permissions on cluster level. Cluster-level permissions are used to allow/disallow actions that affect either the whole cluster, like querying the cluster health or the nodes stats. 

They are also used to allow/disallow actions that affect multiple indices, like `mget`, `msearch` or `bulk` requests.

Example:

```yaml
sg_finance:
  cluster_permissions:
    - SGS_CLUSTER_COMPOSITE_OPS
  index_permissions:
    ...
```

## Index-level permissions

The `index_permissions` entry is used to allow/disallow actions that affect indices matching the configured index patterns.

For example, to apply `READ` permissions on a single index called `humanresources` the configuration would look like:

```yaml
<role_name>:
  cluster_permissions:
    - ...
  index_permissions:
    - index_patterns:
      - "humanresources"
      allowed_actions:
        - READ
```

To apply `READ` permissions to two indices called `humanresources` and `finance` you would write:

```yaml
<role_name>:
  cluster_permissions:
    - ...
  index_permissions:
    - index_patterns:
      - "humanresources"
      - "finance"
      allowed_actions:
        - READ
```

To apply `READ` and `WRITE` permissions to two indices called `humanresources` and `finance` you would write:

```yaml
<role_name>:
  cluster_permissions:
    - ...
  index_permissions:
    - index_patterns:
      - "humanresources"
      - "finance"
      allowed_actions:
        - READ
        - WRITE
```

### Dynamic index patterns: Wildcards and regular expressions

When defining index patterns you can use wildcards and regular expressions:

* An asterisk (`*`) will match any character sequence (or an empty sequence)
  * `*my*index` will match `my_first_index` as well as `myindex` but not `myindex1`. 
* A question mark (`?`) will match any single character (but NOT empty character)
  * `?kibana` will match `.kibana` but not `kibana` 
* Regular expressions have to be enclosed in `/`: `'/<java regex>/'`
  * `'/\S*/'` will match any non whitespace characters

Example: 

```yaml
<role_name>:
  cluster_permissions:
    - ...
  index_permissions:
    - index_patterns:
      - "logstash-*"
      allowed_actions:
        - CRUD
```

### Dynamic index patterns: User name substitution

When defining index patterns the placeholder `${user.name}` is allowed to support indices or aliases which contain the name of the user. 

```yaml
<role_name>:
  cluster_permissions:
    - ...
  index_permissions:
    - index_patterns:
      - "index-${user_name}"
      allowed_actions:
        - CRUD
```

### Dynamic index patterns: User attributes

Any authentication and authorization backend can add additional user attributes that you can use for variable substitution.

For Active Directory and LDAP, these are all attributes stored in the user's Active Directory / LDAP record.  For JWT, these are all claims from the JWT token. For the internal user database, they are configured in sg_internalusers.yml.

You can use these attributes in index patterns to implement index-level access control based on user attributes: 

* for internal users, the attributes start with `attr_internal_*`
* for JWT, the attributes start with `attr_jwt_*`
* for LDAP they start with `attr_ldap_*`.

If you're unsure, what attributes are accessible for the current user you can always check the `/_searchguard/authinfo` endpoint. This endpoint will list all attribute names for the currently logged in user.

### Internal users Example:

If the internal users entry contains an attribute `department`:

```yaml
jdoe:
  hash: ...
  attributes:
    department: "operations"
```

You can use this `department` attribute to control index access like:

```yaml
sg_own_index:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS
  index_permissions:
    - index_patterns:  
      - '${attr_internal_department}':
      allowed_actions:
        - SGS_CRUD
```

In this example, Search Guard grants the `SGS_CRUD` permissions to the index `operations` for the user `jdoe`.


### JWT Example:

If the JWT contains a claim `department`:

```json
{
  "sub": "jdoe"
  "name": "John Doe",
  "roles": "admin, devops",
  "department": "operations"
}
```

You can use this `department` claim to control index access like:

```yaml
sg_own_index:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS
  index_permissions:
    - index_patterns:  
      - '${attr_jwt_department}':
      allowed_actions:
        - SGS_CRUD
```

In this example, Search Guard grants the `SGS_CRUD` permissions to the index `operations` for the user `jdoe`.

### Active Directory / LDAP Example

If the Active Directory / LDAP entry of the current user contains an attribute `department`, you can use it in the same way as as a JWT claim, but with the `ldap.` prefix:

```yaml
sg_own_index:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS
  index_permissions:
    - index_patterns:  
      - '${attr_ldap_department}':
      allowed_actions:
        - SGS_CRUD
```

In this example, Search Guard grants the `SGS_CRUD` permissions to the index `operations`.

### Multiple Variables

You can use as many variables, wildcards and regular expressions as needed, for example:

```yaml
sg_own_index:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS
  index_permissions:
    - index_patterns:  
      - 'logfiles-${attr_ldap_department}-${user_name}-*':
      allowed_actions:
        - SGS_CRUD
```

## Built-in Roles

Search Guard ships with the following built-in (static) roles:

| Role name | Description |
|---|---|
| SGS\_ALL\_ACCESS | All cluster permissions and all index permissions on all indices |
| SGS\_READALL | Read permissions on all indices, but no write permissions |
| SGS\_READALL\_AND\_MONITOR | Read and monitor permissions on all indices, but no write permissions |
| SGS\_KIBANA\_SERVER | Role for the internal Kibana server user, please refer to the [Kibana setup](../_docs_kibana/kibana_installation.md) chapter for explanation |
| SGS\_KIBANA\_USER | Minimum permission set for regular Kibana users. In addition to this role, you need to also grant READ permissions on indices the user should be able to access in Kibana.|
| SGS\_LOGSTASH | Role for logstash and beats users, grants full access to all logstash and beats indices. |
| SGS\_MANAGE\_SNAPSHOTS | Grants full permissions on snapshot, restore and repositories operations |
| SGS\_OWN\_INDEX | Grants full permissions on an index named after the authenticated user's username. |
| SGS\_XP\_MONITORING | Role for X-Pack Monitoring. Users who wish to use X-Pack Monitoring need this role in addition to the sg\_kibana\_user role |
| SGS\_XP\_ALERTING | Role for X-Pack Alerting. Users who wish to use X-Pack Alerting need this role in addition to the sg\_kibana role |
| SGS\_XP\_MACHINE\_LEARNING | Role for X-Pack Machine Learning. Users who wish to use X-Pack Machine Learning need this role in addition to the sg\_kibana role |