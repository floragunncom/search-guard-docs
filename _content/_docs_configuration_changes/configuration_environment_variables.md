---
title: Passwords in configuration files
slug: configuration-password-handling
category: configuration
order: 210
layout: docs
edition: community
description: How to use environment variables to remove sensitive information like passwords from the Search Guard configuration.
---

<!--- Copyright 2019 floragunn GmbH -->

# Handling sensitive data in configuration files
{: .no_toc}

{% include toc.md %}

The Search Guard configuration is stored in a secured Elasticsearch index. Without an admin certificate, it is not possible to acces its content. Therefore storing sensitive data in this index, like passwords or other access credentials, is safe. 

After uploading configuration changes with `sgadmin`, the actual configuration files that may contain sensitive information, can be discarded.

There is no need to place any configuration file physically on your nodes.
{: .note .js-note .green}

If you want to keep the configuration files free from any sensitive data, you can use environment variable substitutions.

## Using environment variables

Search Guard supports environment variable substitution for all configuration files. Before uploading the configuration to Search Guard, `sgadmin` will scan the file content and replace all environment variables with their actual values. 

sgadmin replaces environment variables in-memory before uploading the configuration. The actual file contents are not changed.
{: .note .js-note .green}

<p align="center">
<img src="config_environment_variables.png" style="width: 60%" class="md_image"/>
</p>

## Plain value substitution

To replace a variable with its plain content, use:

```
${env.<variable name>}

or

${env.<variable name>:-<default value>}
```

### Example

```
ldap:
  http_enabled: true
    ...
    config:
      hosts:
        - ${env.LDAP_HOST:-ldapdev.example.com}
      bind_dn: ${env.LDAP_BIND_DN}
      password: ${env.LDAP_BIND_DN_PASSWORD}
      ...
```

The `host` entry in the file will be replaced with the content of the environment variable `LDAP_HOST`. If this variable is not defined, the default value `ldapdev.example.com` will be used.

The `bind_dn` and `password` entries will be replaced with the content of the environmt variables `LDAP_BIND_DN` and `LDAP_BIND_DN_PASSWORD`.

## Base64 substitution

To replace a variable with an environment that is base64 encoded, use:

```
${envbase64.<variable name>}

or

${envbase64.<variable name>:-<default value>}
```

Search Guard will *base64-decode* the environment variable before applying it.

### Example

```
ldap:
  http_enabled: true
    ...
    config:
      rolebase: '${envbase64.LDAP_ROLEBASE_BASE64}'
      ...
```

If the environment variable `LDAP_ROLEBASE_BASE64` contains a base64 encoded String `b3U9Z3JvdXBzLGRjPWV4YW1wbGUsZGM9Y29t`, Search Guard will decode it and use the decoded value:

```
ldap:
  http_enabled: true
    ...
    config:
      rolebase: 'ou=groups,dc=example,dc=com'
      ...
```

## BCrypt passwords

To replace a variable with the BCrypt hash of an environment variable, use:

```
${envbc.<variable name>}

or

${envbc.<variable name>:-<default value>}
```

Search Guard will calculate the BCrypt hash of the environment variable before applying it. This is especially useful for the `internal_users.yaml` file.

### Example

```
my_user:
  hidden: true
  reserved: false
  hash: ${envbc.MY_USER_PASSWORD}
```

If the environment variable `MY_USER_PASSWORD` contains a String `mypwd`, Search Guard will calculate the BCrypt hash of `mypwd` before substituting it:

```
my_user:
  hidden: true
  reserved: false
  hash: $2y$12$8/gQtVE58Yf8btfTktLSlOrsLD0pHzwYJscqc5kXC3FpV52MWTGxC
```
