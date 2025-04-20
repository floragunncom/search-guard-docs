---
title: Internal users database
permalink: internal-users-database
layout: docs
edition: community
description: How to store and manage Search Guard users directly in Elasticsearch
  by using the Internal Users Database.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Configuring the Internal Users Database
{: .no_toc}

{% include toc.md %}


Search Guard ships with an internal user database. You can use this user database if you do not have any external authentication system like LDAP or Active Directory in place. Users, their hashed passwords and roles are stored in the internal Search Guard configuration index on your cluster.

You can use `sgctl` or the [Search Guard configuration GUI](../_docs_configuration_changes/configuration_config_gui.md) for adding users to the internal users database. You can also directly edit the file `sg_internal_users.yml` and upload it as a whole with `sgctl`. 

**Note:** You should prefer to use `sgctl` or the [Search Guard configuration GUI](../_docs_configuration_changes/configuration_config_gui.md). If you choose to directly edit `sg_internal_users.yml`, keep in mind that you might overwrite changes if you work on an old copy. Thus, before modifying `sg_internal_users.yml`, be sure to get an up-to-date version of the file from the cluster. 

## Initial `sg_authc.yml` configuration 

If you are using the internal users database for the first time, you need to make sure that it is configured in `sg_authc.yml`. 

The minimal `sg_authc.yml` configuration for using Search Guard with the internal users database looks like this:

```yaml
auth_domains:
- type: basic/internal_users_db
```

For basic use, no further configuration is necessary. Users authenticated via the internal users database automatically have the roles that are associated with them in the database (both backend roles and Search Guard roles). 

### Attribute mapping

If you want to use [user-attribute-based authorization](../docs_roles_permissions/configuration_roles_permissions.md), you have to define an attribute mapping. This mapping maps the attributes stored in the internal user database to the attributes the logged-in user will have.  Suppose users in the internal user database are defined like this:

```yaml
hr_employee:
  [...]
  attributes:
    manager: "layne.burton"
    department: 
      name: "operations"
      number: 52
```

The `internal_users_db` makes the attributes available for mapping below the key `user_entry.attributes`. Thus, you can map the attribute `department.number` like this:

```yaml
auth_domains:
- type: basic/internal_users_db
  user_mapping.attributes.from:
    dept_no: user_entry.attributes.department.number
```


## Structure

You can find a template in `<ES installation directory>/plugins/search-guard-flx/sgconfig/sg_internal_users.yml`

Syntax:
 
```yaml
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
| backend_roles | The backend roles of the user. Backend roles can be used to group users and them [map the groups to Search Guard roles](../_docs_roles_permissions/configuration_roles_permissions.md). This provides more flexibility than using Search Guard roles directly, but introduces a level on indirection.|
| attributes | Any additional attributes of the user. Can be used for [variable substitution in index names](../_docs_roles_permissions/configuration_roles_permissions.md#dynamic-index-names-user-attributes) and DLS queries. You can also use arrays and nested objects here.|
| description | A description of the user. Optional.|
{: .config-table}

### Example

```yaml
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

## Using `sgctl` to directly add new users

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

Directly modifying the `sg_internal_users.yml` file can be useful for initial configuration or when generating the configuration using scripts.

You have two choices:

- You edit the `sg_internal_users.yml` file manually. This requires you to calculate the BCrypt hash of the user password. You can use any offline or [online tool](https://bcrypt-generator.com/) that is able to produce BCrypt hashes.
- You use the `sgctl add-user-local` command to modify an `sg_internal_users.yml` file and have the BCrypt hash automatically generated. The `add-user-local` command uses the same options as the the `add-user` command described above.

In order to add the user `jdoe` to the file at `/path/to/a/local/sg_internal_users.yml`, use this command:

```
$ ./sgctl.sh add-user-local jdoe --backend-roles hr_department --password -o /path/to/a/local/sg_internal_users.yml
```

