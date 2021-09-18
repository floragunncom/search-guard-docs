---
title: Search Guard roles
html_title: Search Guard roles
permalink: roles-permissions
category: rolespermissions
order: 400
layout: docs
edition: community
description: How to define role based access to Elasticsearch on index level with Search Guard.
---
<!---
Copyright 2020 floragunn GmbH
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
{: .config-table}

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
      - "index-${user.name}"
      allowed_actions:
        - CRUD
```

### Dynamic index patterns: User attributes

Any authentication and authorization domain can provide additional user attributes that you can use for variable substitution in index patterns. 

For this, the auth domains need to configure a mapping from attributes specific to the particular domain to Search Guard user attributes. See the documentation of the respective auth method for details and examples:

- [JWT](../_docs_auth_auth/auth_auth_jwt.md#using-further-attributes-from-the-jwt-claims)
- [LDAP](../_docs_auth_auth/auth_auth_ldap_authentication.md#using-further-active-directory-attributes)
- [Proxy](../_docs_auth_auth/auth_auth_proxy2.md#using-further-headers-as-search-guard-user-attributes)


If you're unsure what attributes are available, you can always access the `/_searchguard/authinfo` REST endpoint to check. The endpoint will list all attribute names for the currently logged in user.

**Note:** The attribute mapping mechanism described here supersedes the old mechanism which would automatically provide all attributes from the authentication domain under the prefix `${attr....}`. The old mechanism is now deprecated but still supported. However, attributes from the internal user database are **not yet supported** using the new mechanism.  For now, you need to stick to the old mechanism (`${attr.internal...}`) for these attributes.



### JWT Example:


Suppose a JWT which contains a claim `department`:

```json
{
  "name": "John Doe",
  "roles": "admin, devops",
  "department": 
  {
    "name": "operations",
    "number": "17"
  }
}
```

Then, you need to map it to a Search Guard user attribute in the JWT authenticator configuration:

```yaml
jwt_auth_domain:
  http_enabled: true
  order: 0
  http_authenticator:
    type: jwt
    challenge: false
    config:
      map_claims_to_user_attrs:
        department: department.number
```

Afterwards, you can use this `department` claim to control index access like this:

```yaml
sg_own_index:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS
  index_permissions:
    - index_patterns:  
      - 'dept_${user.attrs.dept}':
      allowed_actions:
        - SGS_CRUD
```


In this example, Search Guard grants the `SGS_CRUD` permissions to the index `dept_17` for the user `jdoe`.

### Active Directory / LDAP Example

Suppose the  LDAP entry of the current user contains an attribute `departmentNumber` with value `49`; furthermore, you configured LDAP like this:

```yaml
ldap:
  http_enabled: true
  order: 1
  http_authenticator:
    type: basic
    challenge: true
  authentication_backend:
    type: ldap
    config:
      map_ldap_attrs_to_user_attrs:
        department: departmentNumber
```


Then, you can control index access like this:

```yaml
sg_own_index:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS
  index_permissions:
    - index_patterns:  
      - 'dept_${user.attrs.department}':
      allowed_actions:
        - SGS_CRUD
```

In this example, Search Guard grants the `SGS_CRUD` permissions to the index `dept_49`.



### Internal users Example

**Note:** As the new mechanism for user attributes is not yet available for the internal user database, this example still shows the old mechanism.


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


### Subtitution Variable Functionality

Substitution variables are always enclosed in the characters `${` and `}`. Inside the brackets, you specify the attribute name, optionally followed by a chain of operations on the attribute value.

The pipe character `|` followed by a function name causes the attribute value to be processed by the function. You can arbitrarily chain functions.

Available functions are:

**`|toJson`:** Converts the value to a string in JSON format. If the value is a string, it will be properly quoted and escaped. If the value is a number, it will be left untouched. If the value is an object or array, it will be converted into the corresponding JSON syntax.

**`|toString`:** Converts the value to a simple string format. If the value is a string, it will be left without quotes. 

**`|toList`:** Makes sure that the value is a list (or, in JSON terms, an array). If the value is already a list, it will be left unchanged. If the value is a single value, it will be converted to a list containing the single value. You can use this function to ensure that the substituted value is always a list.

**`|head`:** Extracts the first element of a list. If the current value is not a list, the current value is left unchanged. If the current value is an empty list, the current value will be changed to `null`.  You can use this function to ensure that the substituted value is always a scalar value.

**`|tail`:** Extracts all but the first element of a list. If the current value is not a list, the current value will be set to an empty list.


Additionally, you can use the `?:` operator to provide a value in case the current value is unset, resp. `null`. The value to be used in this case is specified after the `?:` in JSON syntax. You can use the `?:` operator at any place between other operations. 

It is recommended to use the `?:` operator for all cases where it is not absolutely sure that a value is always present. If an attribute is unset and no fallback is provided by `?:`, the ES operation triggering the DLS query will be aborted with an error.

**Examples:**

`${user.attr.department?:["17"]|toList|toJson}`: Provides a list/array of departments in JSON format. If the attribute `user.attr.department` is not defined, an array containing the string `"17"` is provided. 

`${user.attr.email|head?:"nobody@nowhere"|toJson}`: Extracts the first element from the list stored by the attribute `user.attr.email`. If the attribute is unset, `nobody@nowhere` will be used as fallback value. Additionally, if the attribute `user.attr.email` contains an empty list, the `|head` function will change the current value to `null`; thus, also in this case the `?:` operator will provide `"nobody@nowhere"` as a fallback.
  
`${user.attr.xyz|tail|head?:0|toJson}`: Extracts the second element of a list and converts it to JSON format. If there is no second element, 0 is returned.


 
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
{: .config-table}