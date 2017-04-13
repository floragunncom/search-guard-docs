<!---
Copryight 2016 floragunn GmbH
-->

# Configure internal users and roles

## Installation

Search Guard already ships with the internal user database, no additional installation steps are required.

## Defining users, roles and passwords

If you do not have any external authentication backend like LDAP or Kerberos, you can define an internal list of users and their passwords and roles. This is done in the file `sg_internal_users.yml`. The syntax is:

```
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

This internal user database is stored in the Search Guard index, and updated by using [sgadmin](sgadmin.sh).

**Please note that the username cannot contain dots. If you need usernames with dots, use the `username` attribute:**

```
mister_picard:
  username: mister.picard
  hash: ...
```

## Generating hashed passwords

The password hash is a salted bcrypt hash of your cleartext password. You can use the `hasher.sh` script that is shipped with Search Guard to generate them:

``plugins/search-guard-2/tools/hasher.sh -p mycleartextpassword``

## Configuration

On order to use the internal user database, you just need to set the `authentication_backend` to `internal`. For example, if you want to use HTTP Basic Authentication and the interna user database, the configuration looks like:

```
basic_internal_auth_domain: 
  enabled: true
  order: 1
  http_authenticator:
    type: basic
    challenge: true
  authentication_backend:
    type: internal
```

