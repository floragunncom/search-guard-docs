---
title: Search Guard 7.x-46.0.0
permalink: changelog-searchguard-7.x-46_0_0
category: changelogs-searchguard
order: 100
layout: changelogs
description: Changelog for Search Guard 7.x-46.0.0	
---

<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 06.10.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## New Features



### Privileges and Permissions

This release introduces the ability to define excluded permissions in Search Guard role definitions. 

Thus, while granting broad permissions, you can selectively subtract access to special indexes. The exclusion configuration is also available for cluster permission.

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
  exclude_index_permissions:
    - index_patterns:
       - "secret"
      actions: 
       - "*"
```

A user with this role gets granted all cluster permission except permissions for managing snapshots. Furthermore, the user gets access to all indexes except the index `secret`. 

**Note:** The Kibana configuration UI does not support roles with exclusions yet. Support will come up in the next Search Guard release.

See here for details:

- [Defining Search Guard Roles](../_docs_roles_permissions/configuration_roles_permissions.md)

### Using Regular Expressions for Supporting Multi-Valued Attributes in Index Patterns

When using new-style user attributes in an expression in the `sg_roles` configuration, you can now use the new `|toRegexFragment` function in order to convert the user attribute to a fragment of a regular expression.

This is especially useful for index patterns:

If you have a user attribute - lets call it `departments` - which contains an array of deparment names, you can the define a role like this:

```
department_access:
  index_permissions:
    - index_patterns:
        - "/dept_${user.attrs.departments|toRegexFragment}/"
      allowed_actions:
        - SGS_CRUD
```

If the `departments` array contains the values `10`, `18` and `42` for a particular user, the effective index pattern will look like this:

```
/dept_(10|18|42)/
```

Thus, the user will get access to the indexes `dept_10`, `dept_18` and `dept_42`. 

### Multi-Valued Attributes for Internal User Database

After Search Guard 45 already provided the new-style user attributes for LDAP, JWT and proxy authentication, this release now also introduces support the new-style user attributes in the internal user database.

The old mechanism, which used attributes prefixed with `${attr.ldap...}, `${attr.jwt...}` had a number of issues and limitations. For example, it was not possible to construct DLS queries which could be used both with an LDAP and a JWT auth domain. Also, multi-valued or other complex attributes were not supported. The old mechanism remains available for now, but should be considered as deprecated.

The new mechanism makes changes both to the source and to the sink of the attributes:

- In `sg_internal_users.yml` and also the corresponding REST API, the attribute `attributes` can now take arbitrarily structured data trees. Besides strings, you can use numbers, booleans, arrays and objects. 
- Attributes now need to be explicitely mapped in `sg_config.yml` in order to be included in the Search Guard user attributes. For the internal user database, this mapping looks like this:
```
        basic_internal_auth_domain: 
          http_enabled: true
          order: 4
          http_authenticator:
            type: basic
            challenge: true
          authentication_backend:
            type: intern
            config: 
              map_db_attrs_to_user_attrs:
                 user_attribute: json.path.to.attribute.in.sg_internal_users  
```

- Inside DLS queries and index patterns, these mapped attributes are now made available under the prefix `${user.attrs...}`. The variable substitution syntax has been extended to have greater control over the format of the substituted string. For example, the expression `${user.attrs.department?:["99"]|toList|toJson}` makes sure that the value stored in the attribute called `department` is a list and converts it to JSON syntax. If the attribute is unset, `["99"]` is used as fallback value.

More details can be found here:

- [Index Patterns](https://docs.search-guard.com/latest/roles-permissions)
- [DLS](https://docs.search-guard.com/latest/document-level-security)



## Bug Fixes



### Signals

* E-Mail accounts using TLS could not be configured if the `trusted_hosts` property was not set. Fixed.
<p />


### Search Guard Core

* The process of changing root certificates using the TLS reload feature did not work because of checks performed on the new certificates. Further consideration of these checks lead to the result that the checks don't provide actual benefit. Thus, they have been removed.
<p />
* New user attributes: Using `?:` for specifying a default value did not work correctly. Fixed.
<p />


### Privileges and Permissions

* Even though the  SGS_CLUSTER_COMPOSITE_OPS_RO action group provided privileges for scrolling searches, it did not provide privileges for clearing scrolling searches. This could also affect SQL operations and cause error messages about a missing privilege for `indices:data/read/scroll/clear`. Fixed.
<p />


