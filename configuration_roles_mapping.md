## Map users, backend roles and hosts to Search Guard roles

Depending on your configuration, you can use the following data to assign a request to one or more Search Guard roles:

* username
  * the name of the authenticated user.
* backend roles
  * the roles fetched by the authorization backend(s), like LDAP, JWT or the internal user database.
* hostname / IP
  * the hostname or IP the request originated from.
* Common name
  * the DN of the client certificate sent with the request.

Backend roles are not the same as searchguard roles. 

Backend roles are roles that Search Guard retrieves from an authorization backend like LDAP, which is configured in the authz section of the sg_config file. These roles are then mapped to the roles Search Guard uses to define which permissions a given user or host possesses. The permissions themselves can be defined in sg_action_groups, and the searchguard (not backend) roles are defined in sg_roles, while sg_roles_mapping defined the connection between particular users and specific roles. If you have not defined or enabled an authorization backend in sg_config, and thus have no additional backend roles being fetched, there will be nothing to enter in the backendroles entry of the mapping file.

Backend users, roles and hosts are mapped to Search Guard roles in the file `sg_roles_mapping.yml`.

Syntax:

```
<Search Guard role name>:
  users:
    - <username>
    - ...
  backendroles:
    - <rolename>
    - ...
  hosts:
    - <hostname>
    - ...
```

Example:

```
sg_read_write:
  users:
    - janedoe
    - johndoe
  backendroles:
    - management
    - operations
    - 'cn=ldaprole,ou=groups,dc=example,dc=com'
  hosts:
    - "*.devops.company.com"
```

A request can be assigned to one or more Search Guard roles. If a request is mapped to more than one role, the permissions of these roles are combined.
