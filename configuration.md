<!---
Copryight 2016 floragunn UG (haftungsbeschränkt)
-->
# Configuration Basics

## Configuring authentication and authorisation 

The main configuration file for Search Guard is `sg_config.yml`. This file is used to specify both authentication and authorisation and has three main parts:

```
searchguard:
  dynamic:
    http:
      ...
    authc:
      ...
    authz:
      ...
```

In short, these sections are used to specify how Search Guard retrieves the user credentials, how to verify these credentials, and where to get the (additional) users roles from. The latter is optional.

_Note: Some versions ago, the configuration had a `static` and `dynamic` part. Since we made the complete configuration hot reloadable, there is no `static` part anymore, and thus we might remove the `dynamic` entry in future versions._

### Authentication

Let's first look at the `authc` section. This section has the following format:

```
<name>: 
  enabled: <true|false>
  order: <integer>
    http_authenticator:
      ...
    authentication_backend:
      ...
```

An entry in the `authc` section of the config file is called an `authentication domain`. It specifies where to get the user credentials from, and against which backend they should be authenticated.

The first thing you'll notice is that you can define more than one authentication domains in this section. Each authentication domain has a telling name (e.g. "basic\_auth\_internal"), an `enabled` flag and an `order`. This makes it possible to chain authentication domains together, and Search Guard will execute them in the order provided. Let's concentrate on a single entry first.

The two sections you need to fill are `http_authenticator` and the `authentication_backend`. The `http_authenticator` specifies which authentication method you want to use on the HTTP layer.

The syntax for defining an authenticator on the HTTP layer is:

```
http_authenticator:
  type: <type>
  challenge: <true|false>
  config:
    ...
```

Allowed values for `type` are:

* basic
 * HTTP basic authentication. This type needs `challenging` set to `true`. No additional configuration is needed. See [HTTP Basic Authentication](httpbasic.md) for further details.
* kerberos
 * Kerberos authentication. This type needs `challenging` set to `false`. Additional, [Kerberos-specific configuration](kerberos.md) is needed.
* clientcert
 * Authentication via a client TLS certificate. This certificate must be trusted by one of the Root CAs in the truststore of your nodes. See [TLS Client Certification](httpbasic.md) for further details.
* jwt
 * Use JSON web tokens as authentication method. Needs additonal settings.
* proxy
 * Use an external, proxy based authentication. This type needs `challenging` set to `false`. Additional, proxy-specific configuration is needed, and the "X-forwarded-for" module has to be enabled as well. See [Proxy authentication](proxy.md) for further details.

The config section contains specific configuration settings for the selected type. At the moment, only Kerberos, JWT and Proxy need additional configuration. See these sections in the documentation for further information.

After the HTTP authenticator was executed, you need to specify against which backend system you want to authenticate the user. This is specified in the `authentication_backend` section and has the following format:

```
authentication_backend:
  type: <type>
  config:
    ...
```

Possible vales for `type` are:

* noop
 * This means that no authentication against a backend system is performed. This setting only makes sense if the HTTP authenticator already authenticated the user , or if the request carries some credentials that are implicitly trusted. The former is true if you choose Kerberos as HTTP authentication type, the latter is true if you choose Proxy as HTTP authentication type. 
* internal
 * Use the users and roles defined in `sg_internal_users` for authentication. This requires you to specify users and roles in the file `sg_internal_users.yml`, and load them into Search Guard by using the `sgadmin` command line tool.
* ldap
 *  Authenticate users against an LDAP server. This requires additional configuration settings, see [LDAP and Active Directory](ldap.md) for further details.

### Authorization

After the user has been authenticated, Search Guard can optionally collect additional user roles from backend systems. Authorisation configuration has the following format:

```
authz:    
  <name>:
    enabled: <true|false>
    authorization_backend:
      type: <type>
      config:
        ...
```

You can also define multiple entries in this section, the same way as you can for authentication entries. The execution order is not relevant here, hence there is no `order` field.

Possible vales for `type` are:

* noop
 * Used for skipping this step altogether
* ldap 
 * Fetch additional roles from an LDAP server. This requires additional configuration settings, see section "LDAP and Active Directory" for further details.


#### Examples

Please refer to the [Addendum A](addendum_a_configuration_examples.md) of this documentation for some common configuration examples.

## Map users, backend roles and hosts to Search Guard roles

As outlined in chapter [Search Guard main concepts](concepts.md), Search Guard 

* retrieves the user credentials
* validates them against the configured authentication backend(s)
* collects additional roles from the configured authorization backend(s)

Depending on your configuration, you can now use the following data to assign the request to one or more Search Guard role:

* username: the name of the user
* backend roles: the additional roles fetched by the authorization backend(s)
* hostname / IP: the hostname or IP the request originated from
* Common name: The DN of the client certificate sent with the request

Backend users, roles and hosts need to be mapped to Search Guard roles. This is done in the file `sg_roles_mapping.yml`. 

```
sg_read_write:
  backendroles:
    - management
    - operations
    - 'cn=ldaprole,ou=groups,dc=example,dc=com'
  hosts:
    - "*.devops.company.com"
  users:
    - janedoe
    - johndoe
```

A request can be assigned to one or more Search Guard roles. If a request is mapped to more than one role, the permissions of these roles are combined with `AND`.

## Define roles and the associated permissions

Search Guard roles and their associated permissions are defined in the file `sg_roles.yml`. You can define as many roles as you like. The syntax to define a role, and associate permissions with it, is as follows:

```
<sg_role_name>:
  cluster:
    - '<permission>'
  indices:
    '<indexname or alias>':
      '<type>':  
        - '<permission>'
    _dls_: '<querydsl query>'
    _fls_:
      - '<field>'
      - '<field>'
```

The `cluster` entry is used to define permissions on cluster level. The `indices` entry is used to define permissions as well as [Document- and field-level security](dlsfls.md) on index level.

For `<permission>`, `<indexname or alias>` and `<type>` simple wildcards are possible:
 
* An asterisk (\*) will match any character sequence (or an empty sequence)
* A question mark (?) will match any single character (but NOT empty character)

Example: `\*my\*index` will match `my_first_index` as well as `myindex` but not `myindex1`

Example: `?kibana` will match `.kibana` but not `kibana`

For <permission>, <indexname or alias> and <type> also regular expressions are possible. You have to pre- and append a `/` to use regex instead of simple wildcards: `/<java regex>/`.

Example: `/\S*/` will match any non whitespace characters

**Note: You cannot have a dot (.) in the <permission>, <indexname or alias> or <type> regex. Use `\S` instead.**

See [https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html](https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html)

### Defining permissions

Permissions can be applied on cluster- and index level. Cluster-level permissions always start with `cluster:`, while index-level permissions start with `indices:`. After that, a REST-style path further defines the exact action the permission grants.

For example, this permission would grant the right to execute a search on an index:

```
indices:data/read/search
```

While this permission grants the right to delete write to the index:

```
indices:data/write/index
```

On cluster-level, this permission grants the right to display the cluster health:

```
cluster:monitor/health
```

There is a plethora of permissions you can set. Search Guard is compatible with the permission definition of Shield up to version 2.1, so you can see [here](https://www.elastic.co/guide/en/shield/2.1/reference.html#ref-actions-list) for a complete list.

Since there are so many permissions you can use, we strongly recommend to use action grouping (see next chapter) and work with action group aliases in `sg_roles.yml`.

## Defining action groups

Since defining permissions based on fine-grained actions can be quite verbose, Search Guard comes with a feature called *action groups*. As the name implies, this is a named group of actions. After an action group has been defined, you can refer to the group of actions simply by its name.

Action groups are defined in the file `sg_action_groups.yml`. The file structure is very simple:

```
<action group name>:
    - '<permission>'
    - '<permission>'
    - '<permission>'
    - ...
```

The definition of actions is the same as outlined in the chapter "Defining permissions". Wildcards are also supported. You can use any telling name you want, and you can also refernce an action group from within another action group:

```
SEARCH:
  - "indices:data/read/search*"
  - "indices:data/read/msearch*"
  - SUGGEST
SUGGEST:
  - "indices:data/read/suggest*" 
```
 
In this case, the action group `SEARCH` includes the (wildcarded) `search*` and `msearch*` permissions, and also all permissions defined by the action group `SUGGEST`. 

You can then reference these action groups in the file `sg_roles.yml` simply by name:

```
sg_readall:
  indices:
    '*':
      '*':
        - SEARCH 
```
