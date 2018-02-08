---
title: Defining Roles and permissions
html_title: Roles and permissions
slug: roles-permissions
category: rolespermissions
order: 400
layout: docs
edition: community
description: How to define role based access to Elasticsearch on index- and document-type level with Search Guard.
---
<!---
Copryight 2017 floragunn GmbH
-->
# Defining Roles and permissions

Hint: You can also use the [Kibana Confguration GUI](kibana_config_gui.md) for configuring Roles and Permissions.

Search Guard roles and their associated permissions are defined in the file `sg_roles.yml`. You can define as many roles as you like. The syntax to define a role, and associate permissions with it, is as follows:

```yaml
<sg_role_name>:
  cluster:
    - '<action group or single permission>'
    - ...
  indices:
    '<indexname or alias>':
      '<document type>':  
        - '<action group or single permission>'
        - ...
      '<document type>':  
        - '<action group or single permission>'
        - ...
      _dls_: '<Document level security query>'
      _fls_:
        - '<field level security fiels>'
        - ...
    tenants:
      <tenantname>: <RW|RO>
      <tenantname>: <RW|RO>        
```

**The Search Guard role name must not contain dots.**

The keys `_dls_` and `_fls_` are used to configure [Document- and Field-level security](dlsfls_dls.md). Please refer to this chapter for details.

The key `tenants` is used to configure [Kibana multi-tenancy](kibana_multitenancy.md). Please refer to this chapter for details.

**Document types are deprecated in Elasticsearch 6 and will be removed with Elasticsearch 7. Search Guard still supports document types for backwards compatibility. This support will be removed in Search Guard 7. To define permissions for all document types, use an asterisk ('\*') as document type.**

## Cluster-level permissions

The `cluster` entry is used to define permissions on cluster level. Cluster-level permissions are used to allow/disallow actions that affect either the whole cluster, like querying the cluster health or the nodes stats. 

They are also used to allow/disallow actions that affect multiple indices, like `mget`, `msearch` or `bulk` requests.

Example:

```yaml
sg_finance:
  cluster:
    - CLUSTER_COMPOSITE_OPS_RO
  indices:
    ...
```

## Index-level permissions

The `indices` entry is used to allow/disallow actions that affect a single index. You can define permissions for each document type in your index separately.

**Document types are deprecated in Elasticsearch 6 and will be removed with Elasticsearch 7. Search Guard still supports document types for backwards compatibility. This support will be removed in Search Guard 7. To define permissions for all document types, use an asterisk ('\*') as document type.**


### Dynamic index names: Wildcards and regular expressions

The index name supports (filtered) index aliases. Both the index name and the document type entries support wildcards and regular expressions.

* An asterisk (`*`) will match any character sequence (or an empty sequence)
  * `*my*index` will match `my_first_index` as well as `myindex` but not `myindex1`. 
* A question mark (`?`) will match any single character (but NOT empty character)
  * `?kibana` will match `.kibana` but not `kibana` 
* Regular expressions have to be enclosed in `/`: `'/<java regex>/'`
  * `'/\S*/'` will match any non whitespace characters

**Note: The index name cannot contain dots. Instead, use the `?` wildcard, as in `?kibana`.** 

Example: 

```yaml
sg_kibana:
  cluster:
    - CLUSTER_COMPOSITE_OPS_RO    
  indices:
    '?kibana':
      '*':
        - INDICES_ALL
```

### Dynamic index names: User name substitution

For `<indexname or alias>` also the placeholder `${user.name}` is allowed to support indices or aliases which contain the name of the user. During evaluation of the permissions, the placeholder is replaced with the username of the authenticated user for this request. Example:

```yaml
sg_own_index:
  cluster:
    ...
  indices:
    '${user_name}':
      '*':
        - INDICES_ALL
```

### Dynamic index names: User attributes

Any authentication and authorization backend can add additional user attributes that you can then use for variable substitution.

For Active Directory and LDAP, these are all attributes stored in the user's Active Directory / LDAP record.  For JWT, these are all claims from the JWT token. 

You can use these attributes in index names to implement index-level access control based on user attributes. For JWT, the attributes start with `attr.jwt.*`, for LDAP they start with `attr.ldap.*`. 

If you're unsure, what attributes are accessible for the current user you can always check the `/_searchguard/authinfo` endpoint. This endpoint will list all attribute names for the currently logged in user.

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
  cluster:
    - CLUSTER_COMPOSITE_OPS
  indices:
    '${attr.jwt.department}':
      '*':
        - INDICES_ALL
```

In this example, Search Guard grants the `INDICES_ALL` permissions to the index `operations` for the user `jdoe`.

### Active Directory / LDAP Example

If the Active Directory / LDAP entry of the current user contains an attribute `department`, you can use it in the same way as as a JWT claim, but with the `ldap.` prefix:

```yaml
sg_department_index:
  cluster:
    - CLUSTER_COMPOSITE_OPS
  indices:
    '${attr.ldap.department}':
      '*':
        - INDICES_ALL
```

In this example, Search Guard grants the `INDICES_ALL` permissions to the index `operations`.

### Multiple Variables

You can use as many variables, wildcards and regular expressions as needed, for example:

```yaml
sg_department_index:
  cluster:
    - CLUSTER_COMPOSITE_OPS
  indices:
    'logfiles-${attr.ldap.department}-${user_name}-*':
      '*':
        - INDICES_ALL
```

## Using action groups to assign permissions

Search Guard comes with the ability to group permissions and give them a telling name. These groups are called [action groups](configuration_action_groups.md) and are the **preferred way of assigning permissions to roles**. Search Guard ships with a predefined set of action groups that will cover most use cases. See chapter [action groups](configuration_action_groups.md) for an overview. Action groups are written in upper case by convention.

Example:

```yaml
myrole:
  cluster:
    - CLUSTER_COMPOSITE_OPS_RO    
  indices:
    'index1':
      '*':
        - SEARCH
    'index2':
      '*':
        - CRUD
```

## Using single permissions

If you need to apply a more fine-grained permission schema, Search Guard also supports assigning single permissions to a role.

Single permissions either start with `cluster:` or `indices:`, followed by a REST-style path that further defines the exact action the permission grants access to.

For example, this permission would grant the right to execute a search on an index:

```
indices:data/read/search
```

While this permission grants the right to write to the index:

```
indices:data/write/index
```

On cluster-level, this permission grants the right to display the cluster health:

```
cluster:monitor/health
```

Single permissions also support wildcards. The following permission grants all admin actions on the index: 

```
indices:admin/*
```

