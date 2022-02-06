---
title: Internal Users Database
permalink: internal-users-database
category: rolespermissions
order: 100
layout: docs
edition: community
description: How to store and manage Search Guard users directly in OpenSearch/Elasticsearch by using the Internal Users Database.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Configuring the Internal Users Database
{: .no_toc}

{% include toc.md %}


Search Guard ships with an internal user database. You can use this user database if you do not have any external authentication system like LDAP or Active Directory in place. Users, their hashed passwords and roles are stored in the internal Search Guard configuration index on your cluster.

You can use `sgctl` or the [Search Guard confguration GUI](../_docs_configuration_changes/configuration_config_gui.md) for adding users to the internal users database. You can also directly edit the file `sg_internal_users.yml` and upload it as a whole with `sgctl`. 

**Note:** You should prefer to use `sgctl` or the [Search Guard confguration GUI](../_docs_configuration_changes/configuration_config_gui.md). If you choose to directly edit `sg_internal_users.yml`, keep in mind that you might overwrite changes if you work on an old copy. Thus, before modifying `sg_internal_users.yml`, be sure to get an up-to-date version of the file from the cluster. 

If you are using the internal users database for the first time, make sure that it is configured in `sg_authc.yml`. See the [authentication docs](../_docs_auth_auth/auth_auth_httpbasic.md) for details on this. 

## Structure

You can find a template in `<ES installation directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/sgconfig/sg_internal_users.yml`

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

### Description

| Name | Description |
|---|---|
| username | The name of the user. Can be used to [map the user to Search Guard roles](../_docs_roles_permissions/configuration_roles_mapping.md).|
| password | The BCrypt hash of the user's password.|
| search\_guard\_roles | The [Search Guard roles](../_docs_roles_permissions/configuration_roles_mapping.md). this user is assigned to.|
| backend_roles | The backend roles of the user. Backend roles can be used to group users and them [map the groups to Search Guard roles](../_docs_roles_permissions/configuration_roles_permissions.md). This provides morre flexibility than using Search Guard roles directly, but introduces a level on indirection.|
| attributes | Any additional attributes of the user. Can be used for [variable substitution in index names](../_docs_roles_permissions/configuration_roles_permissions.md#dynamic-index-names-user-attributes) and DLS queries. You can also use arrays and nested objects here.|
| description | A description of the user. Optional.|
{: .config-table}

### Example

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
    departmentName: "operations"
  description: "A user from the Ops department"
  
finance_employee:
  - hash: ...
  ...

```

## Using `sgctl` 

You can use `sgctl` to modify the internal users database if your cluster is already running and you have connected `sgctl` to the cluster. See the [general `sgctl` docs](../_docs_configuration_changes/configuration_sgctl.md) for more on this.

### Adding users

In order to add a new user to the internal users database, you can use the following command:

```
$ ./sgctl.sh add-user user_name --sg-roles sg_role1,sg_role2 --password
```
This will prompt you to enter a password. Then, a user with the name `user_name` and the Search Guard roles `sg_role1` and `sg_role2` is created. Instead of `--sg-roles`, you can also use the shortcut `-r`. 

You can also specify a comma separated list of backend roles using the option `--backend-roles`. 

You can define attributes using the option `--attributes` (or `-a`: 

```
$ ./sgctl.sh add-user user_name --sg-roles sg_role1,sg_role2 -a a=1,b.c.d=3,e=foo --password
```

### Editing users 

To edit existing users, use the `update-user` command. The options are similar to the `add-user` command:

```
$ ./sgctl.sh update-user user_name --sg-roles sg_role3 
```

This **adds** the role `sg_role3` to the existing Search Guard roles. Likewise, the option `--backend-roles` *adds* new roles to the existing backend roles. To remove existing roles, use the options `--remove-sg-roles` and `--remove-backend-roles`. 

To change the password of a user, use this:

```
$ ./sgctl.sh update-user user_name --password 
```


### Deleting users

To delete users, use the `delete-user` command:

```
$ ./sgctl.sh delete-user user_name 
```
 
## Directly modifying `sg_internal_users.yml` 

Directly modifying the `sg_internal_users.yml` file can be useful fFor initial configuration or when generating the configuration using scripts.

In order to set a password for users, you need to calculate its BCrypt hash. You can use the `hash.sh` script that is shipped with Search Guard to generate them:

``plugins/search-guard-{{site.searchguard.esmajorversion}}/tools/hash.sh -p mycleartextpassword``

You can also use any offline or [online tool](https://bcrypt-generator.com/) that is able to produce BCrypt hashes.
