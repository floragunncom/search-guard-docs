---
title: Mapping Users to Search Guard Roles
html_title: Mapping Users to Roles
slug: mapping-users-roles
category: rolespermissions
order: 150
layout: docs
edition: community
description: How to map users and backend roles to Search Guard roles to implement flexible access control to an Elasticsearch cluster.
---
<!---
Copyright 2020 floragunn GmbH
-->
# Map users to Search Guard roles
{: .no_toc}

{% include toc.md %}

Hint: You can also use the [Kibana Confguration GUI](../_docs_configuration_changes/configuration_config_gui.md) for configuring the Roles Mapping.

After a user is authenticated, Search Guard uses the role mappings to determine which Search Guard roles should be assigned to the user.

You can use the following data to assign a user to one or more Search Guard roles:

* username
  * the name of the authenticated user.
* backend roles
  * the backend roles of the user as collected in the authentication / authorization step
  * e.g. backend roles defined in the internal user database
  * e.g. LDAP groups
  * e.g. JWT claims or SAML assertions
* hostname / IP
  * the hostname or IP the request originated from.
* Common name
  * the DN of the client certificate sent with the request.


## Mapping

Users, backend roles and hosts are mapped to Search Guard roles in the file `sg_roles_mapping.yml`.

Syntax:

```yaml
_sg_meta:
  type: "rolesmapping"
  config_version: 2
  
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
```

A request can be assigned to one or more Search Guard roles. If a request is mapped to more than one role, the permissions of these roles are combined.

## Use wildcards and regular expressions

For users, backendroles, and hosts you can also use wildcards and regular expressions.

* An asterisk (`*`) will match any character sequence (or an empty sequence)
* A question mark (`?`) will match any single character (but NOT empty character)
* Regular expressions have to be enclosed in `/`: `'/<java regex>/'`
  * `'/\S*/'` will match any non whitespace characters

## Advanced: Hostname lookup

Search Guard provides three different approaches to resolve the actual hostname against the configured hosts mapping in `sg_roles_mapping`. This can be configured in `sg_config.yml`:

```yaml
searchguard
  dynamic
    hosts_resolver_mode: <mode>
```

Where mode is one of:

| Name | Description |
|---|---|
| ip-only | Match IP addresses only. Default. |
| ip-hostname | Match IP addresses and hostnames |
| ip-hostname-lookup | Match IP addresses and hostnames, and perform a reverse hostname lookup |
{: .config-table}