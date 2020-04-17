---
title: Authentication
html_title: LDAP Authentication
slug: active-directory-ldap-authentication
category: ldap
order: 200
layout: docs
edition: enterprise
description: Use Search Guard's Active Directory and LDAP feature to authenticate users.
resources:
  - "search-guard-presentations#active-directory-ldap|LDAP & Active Directory configuration (presentation)"

---
<!---
Copyright 2020 floragunn GmbH
-->

# Active Directory and LDAP Authentication
{: .no_toc}

{% include toc.md %}

## Activating Authentication

To use Active Directory / LDAP for authentication first configure a respective authentication domain in the `authc` section of `sg_config`:

```yaml
authc:
  ldap:
    http_enabled: true
    order: 1
    http_authenticator:
      type: basic
      challenge: true
    authentication_backend:
      type: ldap
      config:
        ...
```

Afterwards add the [connection settings](../_docs_auth_auth/auth_auth_ldap_connection_settings.md) for your Active Directory / LDAP server to the config section of the authentication domain, e.g.:

```yaml
config:
  enable_ssl: true
  enable_start_tls: false
  enable_ssl_client_auth: false
  verify_hostnames: true
  hosts:
    - ldap.example.com:8389
  bind_dn: cn=admin,dc=example,dc=com
  password: passw0rd
```

## Configuring Authentication

Authentication works by issuing an *LDAP query* containing the *username* against the *user subtree* of the *LDAP directory*.

Search Guard first takes the configured LDAP query, and replaces the placeholder `{0}` with the username from the user's credentials.

```yaml
usersearch: '(sAMAccountName={0})'
```

Search Guard then issues this query against the user subtree ("userbase"). Currently the whole subtree beneath the configured `userbase` is searched:

```yaml
userbase: 'ou=people,dc=example,dc=com'
```

If the query was successful, Search Guard retrieves the username from the LDAP entry. You can specify which attribute from the LDAP entry Search Guard should use as the username:

```yaml
username_attribute: uid
```

If this key is not set, or null, then the DN of the LDAP entry is used.

### Configuration summary

| Name | Description |
|---|---|
| userbase | Specifies the subtree in the directory where user information is stored |
| usersearch | The actual LDAP query that Search Guard executes when trying to authenticate a user. The variable {0} is substituted with the username.|
| username_attribute | Search Guard uses this attribute of the directory entry to look for the user name. If set to null, the DN is used (default). If this references a multi-value field it is undefined which value will be used. It's therefore not recommended to set it to a multi-value field.|
{: .config-table}

### Complete authentication example

```yaml
ldap:
  enabled: true
  order: 1
  http_authenticator:
    type: basic
    challenge: true
  authentication_backend:
    type: ldap
    config:
      enable_ssl: true
      enable_start_tls: false
      enable_ssl_client_auth: false
      verify_hostnames: true
      hosts:
        - ldap.example.com:636
      bind_dn: cn=admin,dc=example,dc=com
      password: password
      userbase: 'ou=people,dc=example,dc=com'
      usersearch: '(sAMAccountName={0})'
      username_attribute: uid
```

## Multiple user bases

You can also configure multiple user bases. Search Guard will query the user bases one after the other until the user was authenticated successfully:

```yaml
users:
  primary-userbase:
    base: 'ou=people,dc=example,dc=com'
    search: '(uid={0})'
  secondary-userbase:
    base: 'ou=otherpeople,dc=example,dc=com'
    search: '(initials={0})'
  tertiary-rolebase:    
    ...
```

The names of the configuration keys (`primary-userbase`, `secondary-userbase`...) are just telling names. You can choose them freely and you can configure as many user bases as you need.

### Complete authentication example

```yaml
ldap:
  enabled: false
  order: 1
  http_authenticator:
    type: basic
    challenge: true
  authentication_backend:
    type: ldap
    config:
      enable_ssl: true
      enable_start_tls: false
      enable_ssl_client_auth: false
      verify_hostnames: true
      hosts:
        - ldap.example.com:636
      bind_dn: cn=admin,dc=example,dc=com
      password: password
      users:
        primary-userbase:
          base: 'ou=people,dc=example,dc=com'
          search: '(uid={0})'
        secondary-userbase:
          base: 'ou=otherpeople,dc=example,dc=com'
          search: '(initials={0})'
      username_attribute: uid
```

### Advanced: Exclude certain users from role lookup

It is possible to exclude users from LDAP authentication by specifying a 'skip_users' section inside the domain configuration. **Wildcards** and **regular expressions** are exported.

```yaml
skip_users:
  - kibanaserver
  - 'cn=Michael Jackson,ou*people,o=TEST'
  - '/\S*/'
```