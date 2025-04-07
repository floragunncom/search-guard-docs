---
title: Mapping users to Search Guard roles
html_title: Mapping users to Search Guard roles
permalink: mapping-users-roles
layout: docs
edition: community
description: How to map users and backend roles to Search Guard roles to implement
  flexible access control to an Elasticsearch cluster.
---
<!---
Copyright 2022 floragunn GmbH
-->
# Map users to Search Guard roles
{: .no_toc}

{% include toc.md %}

Hint: You can also use the [Kibana Configuration GUI](../_docs_configuration_changes/configuration_config_gui.md) for configuring the Roles Mapping.

After a user is authenticated, Search Guard uses the role mappings to determine which Search Guard roles should be assigned to the user.

You can use the following data to assign a user to one or more Search Guard roles:

* the username
* the backend roles of the user as collected by [authentication modules or user information backends](../docs_auth_auth/auth_auth_rest_config_overview.md)
  * e.g. backend roles defined in the internal user database
  * e.g. LDAP groups
  * e.g. JWT claims or SAML assertions
* the host name or IP the request originated from.

## Mapping

Users, backend roles and hosts are mapped to Search Guard roles in the file `sg_roles_mapping.yml`.

Syntax:

```yaml
<Search Guard role name>:
  users:
    - <username>
    - ...
  backend_roles:
    - <rolename>
    - ...
  hosts:
    - <hostname>
    - ...
  ips:
    - <CIDR>
    - ...  
```

Example:

```yaml
sg_read_write:
  users:
    - janedoe
    - johndoe
  backend_roles:
    - management
    - operations
    - 'cn=ldaprole,ou=groups,dc=example,dc=com'
  hosts:
    - "*.devops.company.com"
  ips:
    - "10.12.13.0/24"
```

A request can be assigned to one or more Search Guard roles. If a request is mapped to more than one role, the permissions of these roles are combined.

**Note:** If you use the `host` option, Search Guard might have to perform a reverse DNS lookup to resolve the host name.

## Use wildcards and regular expressions

For users, backendroles, and hosts you can also use wildcards and regular expressions.

* An asterisk (`*`) will match any character sequence (or an empty sequence)
* A question mark (`?`) will match any single character (but NOT empty character)
* Regular expressions have to be enclosed in `/`: `'/<java regex>/'`
  * `'/\S*/'` will match any non whitespace characters
