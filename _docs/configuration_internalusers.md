---
title: Internal Users Database
slug: internal-users-database
category: rolespermissions
order: 100
layout: docs
description: How to store and manage Search Guard users directly in Elasticsearch by using the Internal Users Database.
---
<!---
Copryight 2017 floragunn GmbH
-->

# Configuring the Internal Users Database

Hint: You can also use the [Kibana Confguration GUI](kibana_config_gui.md) for configuring the Internal Users Database.

Search Guard ships with an internal user database. You can use this user database if you do not have any external authentication system like LDAP or Active Directory in place. Users, their hashed passwords and roles are stored in the internal Search Guard configuration index on your cluster.

Internal users are configured in `sg_internal_users.yml`. You can find a template in `<ES installation directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/sgconfig/sg_internal_users.yml`

Syntax:
 
```yaml
<username>:
  hash: <hashed password>
  roles:
    - <rolename>
    - <rolename>
```

Example:

```yaml
admin:
  hash: $2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO
  roles:
    - readall
    - writeall

analyst:
  hash: $2a$12$ae4ycwzwvLtZxwZ82RmiEunBbIPiAmGZduBAjKN0TXdwQFtCwARz2
  roles:
    - readall

```

**Note that the username cannot contain dots. If you need usernames with dots, use the `username` attribute:**

```yaml
<username>:
  username: username.with.dots
  hash: ...
```

## Generating hashed passwords

The password hash is a salted BCrypt hash of the cleartext password. You can use the `hash.sh` script that is shipped with Search Guard to generate them:

``plugins/search-guard-{{site.searchguard.esmajorversion}}/tools/hasher.sh -p mycleartextpassword``

## Configuration

In order to use the internal user database, set the `authentication_backend` to `internal`. For example, if you want to use HTTP Basic Authentication and the internal user database, the configuration looks like:

```yaml
basic_internal_auth_domain:
  enabled: true
  order: 1
  http_authenticator:
    type: basic
    challenge: true
  authentication_backend:
    type: internal
```