---
title: Search Guard roles
html_title: Search Guard role-based authorization for Elasticsearch
permalink: roles-permissions
category: rolespermissions
order: 390
layout: docs
edition: community
description: How to define role based access to Elasticsearch on index level with Search Guard.
---
<!---
Copyright 2022 floragunn GmbH
-->

The alias and data stream features are only supported in SG FLX version 3.0 and above
{: .note}

# Defining Search Guard roles
{: .no_toc}

{% include toc.md %}

Hint: You can also use the [Search Guard Configuration GUI](../_docs_configuration_changes/configuration_config_gui.md) for configuring Roles and Permissions.

Search Guard roles are the central place to configure access permissions on:

* Cluster level
* Index level
* Alias level
* Data stream level
* Document level
* Field level
* Kibana level

Search Guard roles and their associated permissions are defined in the file `sg_roles.yml`. The syntax to define a role is as follows:

```yaml
<role_name>:
  cluster_permissions:
    # Permissions that apply on the cluster level, e.g. monitoring the cluster health
    - '<action group or single permission>'
    - ...
  index_permissions:
    # Permissions that apply to concrete indices, identified by the index_patterns below. The permissions specified here do not apply to aliases or data streams.
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
  alias_permissions:
    # Permissions that apply to concrete aliases and their member indices. The aliases are identified by the alias_patterns below. 
    - alias_patterns:
        - <alias pattern the allowed actions should be applied to>
        - <alias pattern the allowed actions should be applied to>
        - ...
      allowed_actions:
        - '<action group or single permission>'
        - ...
      dls: '<Document level security query>'
      fls:
        - '<field level security field>'
        - '<field level security field>'
        - ...
    - alias_patterns:
        - ...
  data_stream_permissions:
    # Permissions that apply to data streams and their backing indices. The data streams are identified by the data_stream_patterns below. 
    - data_stream_patterns:
        - <data stream pattern the allowed actions should be applied to>
        - <data stream pattern the allowed actions should be applied to>
        - ...
      allowed_actions:
        - '<action group or single permission>'
        - ...
      dls: '<Document level security query>'
      fls:
        - '<field level security field>'
        - '<field level security field>'
        - ...
    - data_stream_patterns:
        - ...
  tenant_permissions:
    # Permissions that apply to kibana tenants. The tenants are identified by the tenant_patterns below.
    - tenant_patterns:
      - <tenant pattern the allowed actions should be applied to>
      - <tenant pattern the allowed actions should be applied to>
      - ...      
      allowed_actions:
        - SGS_KIBANA_ALL_WRITE
    - tenant_patterns:
      - ...
```

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

### Dynamic index and tenant patterns: User attributes
{: #user-attributes }

Any authentication and authorization domain can provide additional user attributes that you can use for variable substitution in index patterns and [tenant patterns for Kibana multi-tenancy](../_docs_kibana/kibana_multitenancy.md#user-attributes). 

For this, the auth domains need to configure a mapping from attributes specific to the particular domain to Search Guard user attributes. See the documentation of the respective auth method for details and examples:

- [Internal User Database](../_docs_roles_permissions/configuration_internalusers.md#user-attributes)
- [JWT](../_docs_auth_auth/auth_auth_jwt.md#using-further-attributes-from-the-jwt-claims)
- [LDAP](../_docs_auth_auth/auth_auth_ldap_authentication.md#using-further-active-directory-attributes)
- [Proxy](../_docs_auth_auth/auth_auth_proxy2.md#using-further-headers-as-search-guard-user-attributes)

If you're unsure what attributes are available, you can always access the `/_searchguard/authinfo` REST endpoint to check. The endpoint will list all attribute names for the currently logged in user.

**Note:** The attribute mapping mechanism described here supersedes the old mechanism which would automatically provide all attributes from 
the authentication domain under the prefix `${attr....}`. The old mechanism is deprecated but still supported. Please migrate to the new
syntax to ensure compatibility with future Search Guard releases.  

### JWT Example:


Suppose a Json Web Token contains a claim `department`:

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

To use it as variable in index patterns and tenant patterns, map it to a Search Guard user attribute in the JWT authenticator configuration:

```yaml
jwt_auth_domain:
  ...
  http_authenticator:
    type: jwt
    ...
    config:
      map_claims_to_user_attrs:
        `department`: department.name
```

This maps the `department.name` JWT claim to the user attribute `department`.

You can then use the `department` attribute in index patterns and tenant patterns like:

```yaml
sg_own_index:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS
  index_permissions:
    - index_patterns:  
      - 'dept_${user.attrs.department}':
      allowed_actions:
        - SGS_CRUD
  tenant_permissions:
    - tenant_patterns:
      - 'dept_${user.attrs.department}'
      allowed_actions:
      - "SGS_KIBANA_ALL_WRITE"
```

In this example, Search Guard grants the `SGS_CRUD` permissions to the index `dept_operations`, and `SGS_KIBANA_ALL_WRITE` to the tenant named `dept_operations`.

### Active Directory / LDAP Example

Suppose the LDAP record of the current user contains an attribute `departmentName` with value `operations`.
To use it as variable in index patterns and tenant patterns, map it to a Search Guard user attribute in the LDAP authenticator configuration like:


```yaml
ldap:
  ...
  http_authenticator:
    ...
  authentication_backend:
    type: ldap
    config:
      map_ldap_attrs_to_user_attrs:
        department: departmentName
```

This maps the `departmentName` LDAP attribute to the user attribute `department`.

You can then use the `department` attribute in index patterns and tenant patterns like:


```yaml
sg_own_index:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS
  index_permissions:
    - index_patterns:  
      - 'dept_${user.attrs.department}':
      allowed_actions:
        - SGS_CRUD
  tenant_permissions:
    - tenant_patterns:
      - 'dept_${user.attrs.department}'
      allowed_actions:
      - "SGS_KIBANA_ALL_WRITE"
```

Suppose the LDAP attribute has the value `operations`. 
In this case, Search Guard grants the `SGS_CRUD` permissions to the index `dept_operations`, 
and `SGS_KIBANA_ALL_WRITE` to the tenant named `dept_operations`.

### Internal users Example

Suppose the internal users entry contains an attribute `department`:

```yaml
jdoe:
  hash: ...
  attributes:
    departmentName: "operations"
```

In order to use this attribute, you need map it in the `user_mapping.attributes` configuration inside `sg_authc.yml`: 

```yaml
auth_domains:
- type: basic/internal_users_db
  user_mapping.attributes.from:
    department: user_entry.attributes.departmentName
```

You can then use the `department` attribute in index patterns and tenant patterns like:

```yaml
sg_own_index:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS
  index_permissions:
    - index_patterns:  
      - 'dept_${user.attrs.department}':
      allowed_actions:
        - SGS_CRUD
  tenant_permissions:
    - tenant_patterns:
      - 'dept_${user.attrs.department}'
      allowed_actions:
      - "SGS_KIBANA_ALL_WRITE"
```

In this example, Search Guard grants the `SGS_CRUD` permissions to the index `dept_operations`, and `SGS_KIBANA_ALL_WRITE` permissions to the Kibana tenant `dept_operations`.


### Substitution Variable Functionality

Substitution variables are always enclosed in the characters `${` and `}`. Inside the brackets, you specify the attribute name, optionally followed by a chain of operations on the attribute value.

The pipe character `|` followed by a function name causes the attribute value to be processed by the function. You can arbitrarily chain functions.

Available functions are:

**`|toJson`:** Converts the value to a string in JSON format. If the value is a string, it will be properly quoted and escaped. If the value is a number, it will be left untouched. If the value is an object or array, it will be converted into the corresponding JSON syntax.

**`|toRegexFragment`:** Converts the current value to a regular expression fragment. If the current value is a single string, this function just returns the string. However, any characters that would have a special meaning in regular expressions (such as the period `.`) will be escaped in order to be interpreted literally. If the current value is an array, this function returns the values of the array as an regex "or" expression in the form `(value1|value2|value3|...)`.  The values themselves are also escaped as described before. Use this function inside an index pattern of the form `'/dept_${user.attrs.department|toRegexFragment}/'`. 

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

## Alias and data stream-level permissions

Support for aliases and data streams have been added in SG FLX 3.0
{: .note}

The permissions specified for `alias_permissions` and `data_stream_permissions` apply for these cases:

- The user directly specifies an alias or data stream in a request (Like `GET /alias_a1/_search`).
- The user specifies an index which is member of an alias (Like `GET /idx_b1/_search` when `idx_b1` is member of `alias_a1`. The user will have privileges for `idx_b1` then even though the configuration only has direct index permissions for `idx_a*`. The privileges from `alias_a1` will be projected onto the index.)
- The user specifies a backing index of a data stream (Like `GET /.ds-ds_a1-2024.02.16-000001/_search`).

On the other hand, privileges specified for `index_permissions` never apply for aliases or data streams.

For improved performance it is recommended to apply permissions on data stream and alias level, instead of directly on indices
{: .note}

### Creating or modifying aliases
For creating aliases or for adding indices to existing aliases, you will need the permission `indices:admin/aliases` both for the alias and the referenced indices.
This should look similar this:

```
test_role:
  cluster_permissions:
  - "SGS_CLUSTER_COMPOSITE_OPS"
  index_permissions:
  - index_patterns:
    - "member_of_alias_a*"
    allowed_actions:
    - "indices:admin/aliases"
    alias_permissions:
    - alias_patterns:
      - "alias_a"
      allowed_actions:
      - "*"
```

With this configuration, you can create an alias `alias_a` and add indices to it which match the pattern `member_of_alias_a*`.

As the `alias_a` has full privileges (`allowed_actions: *`), you will also gain full privileges to all member indices after these were added.

### Creating data streams
When working with data streams, you only have to consider privileges for the data streams themselves. You do not have to take care to add privileges to the backing indices. These are always implied.
A role which gives a user the rights to create and access data streams can look like this:
```
ds_test_role:
  cluster_permissions:
  - "SGS_CLUSTER_COMPOSITE_OPS"
  data_stream_permissions:
  - data_stream_patterns:
    - "ds_a*"
    allowed_actions:
    - "*"  
```

Test user:
```
test:
  hash: "$2y$12$NbU4RAs.0wwEOaSUldhECeTBUMAKka4ifO0oNjBr460Hn60F/acKO"
  search_guard_roles:
  - ds_test_role

```

Note: This user will not be able to use normal indices, as the `index_permissions section does not exist!

#### DLS/FLS/FM

[Document level security](../_docs_dls_fls/dlsfls_dls.md#document-level-security-for-data-streams-and-aliases), [field level security](../_docs_dls_fls/dlsfls_fls.md#fls-on-data-streams-and-aliases) and [field masking](../_docs_dls_fls/dlsfls_field_anonymization.md) can be applied as normal.

## Cluster Permission Exclusions

Besides using `cluster_permissions` and `index_permissions` to positively define the permissions a user should have, it is also possible to explicitly defined cluster permissions a user may not have.

For this purpose, you can add the entry `exclude_cluster_permissions` to your role definitions. Permissions defined here are **not** granted to the user, even if there are `cluster_permissions` or `index_permissions` properties which would grant these permissions.

This means, that you can use  `cluster_permissions` and `index_permissions` entries to define a broader set of permissions and then use `exclude_cluster_permissions` to selectively subtract permissions a user is not allowed to have.

For example, a role definition might now look like this:

```
my_role_using_exclusions:
  cluster_permissions:
    - *
  exclude_cluster_permissions:
    - SGS_MANAGE_SNAPSHOTS
  index_permissions:
    - index_patterns:
        - "*"
      allowed_actions:
        - SGS_CRUD
```

A user with this role is granted all cluster permissions except permissions for managing snapshots. 

Permission exclusions do not only affect the permissions granted in the same role. Rather, permission exclusions also affect permissions granted by other roles. Thus, you can grant permissions in one role and use an additional role to selectively remove some of these permissions.

Similarly to `cluster_permissions` entries, you can provide a list of cluster permissions to exclude. The list entries can contain wildcards or action groups.

## Support removed for exclude_index_permissions

Support for `exclude_index_permissions` has been removed in SG FLX version 3.0. To achieve similar functionality on index level [index negation](../changelog-searchguard-flx-1_0_0#using-negation-for-index-and-action-patterns) can be used. However the functionality is not identical. Previously `exclude_index_permissions` created an absolute global exclusion. Index negation, however, only affects the current index that is being evaluated.

If you are migrating to SG FLX 3.0 and have been previously using `exclude_index_permissions`, it is recommended to first retrieve the sg_roles.yml configuration and update the necessary roles, as `exclude_index_permissions` will no longer have any effect on the users privileges after migration. Retrieval of previous configuration is also possible post migration if necessary.
{: .warning}

### Example of role using index negation

Previous configuration using `exclude_index_permissions`:

```
example_role:
  index_permissions:
  - index_patterns:
    - "index_a*"
    allowed_actions:
    - "indices:admin/*"
    excluded_index_permissions:
    - index_patterns:
      - "index_a1"
      actions:
    - "indices:admin/*"
```

New configuration using index negation:

```
example_role:
  index_permissions:
  - index_patterns:
    - "index_a*"
    - "-index_a1"
    allowed_actions:
    - "indices:admin/*"
```

Previously `excluded_index_permissions` configuration created global exclusion, meaning another role attached to the same user was not able to overwrite this exclusion. This is not the case with index negation. If another role mapped to the same user allows permission to the negated index, this permission will overwrite the negation.
{: .warning}

If a role with `exclude_index_permissions` is submitted using sgctl.sh tool, following message will be returned:
```
Invalid config files:

plugins/search-guard-flx/sgconfig/sg_roles.yml:
  my_role.exclude_index_permissions:
  	This attribute is no longer supported
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
| SGS\_KIBANA\_USER\_NO\_GLOBAL\_TENANT | Permission for user to access kibana but not global tenant. Cannot be used together with SGS\_KIBANA\_USER\_NO\_MT |
| SGS\_KIBANA\_USER\_NO\_MT | Permits users to access kibana UI only if multi tenancy is disabled. Cannot be used together with SGS\_KIBANA\_USER\_NO\_GLOBAL\_TENANT |
| SGS\_LOGSTASH | Role for logstash and beats users, grants full access to all logstash and beats indices. |
| SGS\_MANAGE\_SNAPSHOTS | Grants full permissions on snapshot, restore and repositories operations |
| SGS\_OWN\_INDEX | Grants full permissions on an index named after the authenticated user's username. |
| SGS\_XP\_MONITORING | Role for X-Pack Monitoring. Users who wish to use X-Pack Monitoring need this role in addition to the sg\_kibana\_user role |
| SGS\_XP\_ALERTING | Role for X-Pack Alerting. Users who wish to use X-Pack Alerting need this role in addition to the sg\_kibana role |
| SGS\_XP\_MACHINE\_LEARNING | Role for X-Pack Machine Learning. Users who wish to use X-Pack Machine Learning need this role in addition to the sg\_kibana role |
{: .config-table}

