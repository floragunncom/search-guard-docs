---
title: Internal Users Database
permalink: internal-users-database
category: rolespermissions
order: 100
layout: docs
edition: community
description: How to store and manage Search Guard users directly in Elasticsearch by using the Internal Users Database.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Configuring the Internal Users Database
{: .no_toc}

{% include toc.md %}

Hint: You can also use the [Kibana Confguration GUI](../_docs_configuration_changes/configuration_config_gui.md) for configuring the Internal Users Database.

Search Guard ships with an internal user database. You can use this user database if you do not have any external authentication system like LDAP or Active Directory in place. Users, their hashed passwords and roles are stored in the internal Search Guard configuration index on your cluster.

Internal users are configured in `sg_internal_users.yml`. You can find a template in `<ES installation directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/sgconfig/sg_internal_users.yml`

Syntax:
 
```yaml
_sg_meta:
  type: "internalusers"
  config_version: 2
  
<username>:
  hash: <hashed password>
  search_guard_roles:
    - <rolename>
    - <rolename>
  backend_roles:
    - <backend rolename>
    - <backend rolename>
  attributes:
    key: value
    key: value
  description: <String>
```

## Description

| Name | Description |
|---|---|
| username | The name of the user. Can be used to [map the user to Search Guard roles](../_docs_roles_permissions/configuration_roles_mapping.md).|
| password | The BCrypt hash of the user's password.|
| search\_guard\_roles | The [Search Guard roles](../_docs_roles_permissions/configuration_roles_mapping.md). this user is assigned to.|
| backend_roles | The backend roles of the user. Backend roles can be used to group users and them [map the groups to Search Guard roles](../_docs_roles_permissions/configuration_roles_permissions.md). This provides morre flexibility than using Search Guard roles directly, but introduces a level on indirection.|
| attributes | Any additional attributes of the user. Can be used for [variable substitution in index names](../_docs_roles_permissions/configuration_roles_permissions.md#dynamic-index-names-user-attributes) and DLS queries. You can also use arrays and nested objects here.|
| description | A description of the user. Optional.|
{: .config-table}

## Example

```yaml
_sg_meta:
  type: "internalusers"
  config_version: 2
  
hr_employee:
  hash: $2a$12$7QIoVBGdO41qSCNoecU3L.yyXb9vGrCvEtVlpnC4oWLt/q0AsAN52
  search_guard_roles:
    - SGS_LOGSTASH
  backend_roles:
    - kibanauser
    - humanresources_department
  attributes:
    manager: "layne.burton"
    departmentNumber:
      - 5
      - 17
      - 42
  description: "A user from the HR department"
  
finance_employee:
  - hash: ...
  ...

```


## Generating hashed passwords

The password is a BCrypt hash of the cleartext password. You can use the `hash.sh` script that is shipped with Search Guard to generate them:

``plugins/search-guard-{{site.searchguard.esmajorversion}}/tools/hash.sh -p mycleartextpassword``

You can also use any offline or [online tool](https://bcrypt-generator.com/) that is able to produce BCrypt hashes, like the 

## Activating the internal user database

In order to use the internal user database for authentication, set the `authentication_backend` in `sg_config.yml` to `internal`. For example, if you want to use HTTP Basic Authentication and the internal user database, the configuration looks like:

```yaml
basic_internal_auth_domain:
  http_enabled: true
  order: 1
  http_authenticator:
    type: basic
    challenge: true
  authentication_backend:
    type: internal
```

## Using attributes from the internal user database

If you want to use attributes from the internal user database for the new-style  [variable substitution in index names](../_docs_roles_permissions/configuration_roles_permissions.md#dynamic-index-names-user-attributes) and DLS queries, you need to provide a mapping in the `authentication_backend` entry in `sg_config.yml`. This might look like this:

```yaml
basic_internal_auth_domain:
  http_enabled: true
  order: 1
  http_authenticator:
    type: basic
    challenge: true
  authentication_backend:
    type: internal
    config:
      map_db_attrs_to_user_attrs:
        department: departmentNumber      
```

This makes the value of the attribute `departmentNumber` in the internal user database available under the name `department`. Besides using a plain attribute name, you can also use JSON path expressions to extract values from complex attribute values.

For details, refer to:

- [Index name variable substitution](../_docs_roles_permissions/configuration_roles_permissions.md#dynamic-index-names-user-attributes)
- [DLS query variable substitution](../_docs_dls_fls/dlsfls_dls.md)


## Authorization

You can also use the internal user database for authorization only. This is useful when your primary way of authentication does not provide any role information.

For example, you can use LDAP or JWT for authentication, and the internal user database for authorization/assigning roles.

Search Guard will use the name of the authenticated user to look up the corresponding entry in the internal user database. If found, the configures roles will be assigned as backend roles to this user.

If you use the internal user database for authorization only, there is no need to set a password hash. The entries are solely used for assigning backend roles.

Configuration:

```yaml
authz:
  internal_authorization:
    http_enabled: true
    authorization_backend:
      type: internal
```      
