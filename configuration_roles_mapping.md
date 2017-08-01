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
