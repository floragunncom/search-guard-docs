---
title: Introduction to sg_authc
html_title: Introduction to sg_authc
permalink: authentication-authorization-configuration
category: sg_authc
order: 100
layout: docs
edition: community
description: How to configure, mix and chain authentication and authorization domains for Search Guard.
resources:
  - "search-guard-presentations#configuration-basics|Search Guard configuration basics (presentation)"

---
<!---
Copyright 2020 floragunn GmbH
-->
# Introduction to `sg_authc.yml`
{: .no_toc}

{% include toc.md %}

The main configuration file for authentication is `sg_authc.yml`. It defines how Search Guard retrieves the user credentials, how it verifies these credentials, and how additional user information is fetched from backend systems (optional).

The authentication domains configured in `sg_authc.yml` are used for authenticating REST requests to Elasticsearch and for password-based authentication in Kibana. Authentication for the transport client is configured in the additional configuration file `sg_authc_transport.yml`. Advanced authentication for Kibana like OIDC or SAML can be configured in `sg_frontend_config.yml`. 

## Basics

A minimal `sg_authc.yml` file may look like this:

```yaml
auth_domains:
- type: basic/internal_users_db
```

This way, you configure Search Guard to expect credentials by Basic HTTP authentication. This means, you need to supply a username and password to authenticate. The credentials are checked by Search Guard using its [internal users database](../_docs_roles_permissions/configuration_internalusers.md). If the password is correct, Search Guard allows the user to access Elasticsearch. The user will have the roles that are configured in the internal users database.

Thus, the `type` attribute defines a two-dimensional value: The part in front of the slash - `basic` in the example - identifies the HTTP authentication frontend. It is responsible for retrieving credentials from the request. The part after the slash is the authentication backend. It is responsible for validating the extracted credentials using a backend system. 

**Note:** The authentication backend is optional. In some cases - like signature-based credentials - the authentication frontend is sufficient to securely authenticate a user. Then, you can just omit the second part of the `type` attribute.

A more evolved `sg_authc.yml` file may look like this:

```yaml
auth_domains:
- type: basic/internal_users_db
- type: basic/ldap
  ldap.idp.hosts: ldap.example.com
  ldap.idp.bind_dn: "cn=admin,dc=example,dc=com"
  ldap.idp.password: secret
- type: jwt
  jwt.jwks_endpoint.url: "https://idp.example.com/public-keys.jwks"
```

This configuration contains three *authentication domains*. When Search Guard receives a request, it goes through the list of authentication domains - from top to the bottom - and checks for each authentication domain if it can authenticate the request. When a domain successfully authenticates a request, this process ends. The request passes without checking the succeeding authentication domains.

We already know the first authentication domain of type `basic/internal_users_db`. The second one, `basic/ldap` also uses Basic HTTP authentication to retrieve the supplied user name and password. However, it connects to an external LDAP server to check the credentials. Here, you can see some more configuration properties that specify how to connect to the external LDAP server. See the [LDAP documentation](../_docs_auth_auth/auth_auth_ldap.md) for more details on this.

The third authentication domain has type `jwt`. This type only consists of one part, the authentication frontend. The second part, the authentication backend, is not specified here. This means that the authentication frontend is sufficient to authenticate the request. This is because cryptographic signatures are used to verify the authenticity of a user with JWT. When Search Guard is initialized, it loads the public keys for verification as JWKS file from the URL specified using the `jwt.jwks_endpoint.url` property. However, the necessary keys can be also specified directly inside the configuration. See the [JWT documentation](../_docs_auth_auth/auth_auth_jwt.md) for more on this.

## Debugging the authc configuration

If something regarding authentication does not work as expected, you might want to get additional debugging information from Search Guard. Search Guard offers a special authc debugging mode for this.

**Note:** This mode might reveal sensitive data. Only use this mode on test clusters. Do not forget to switch the debug mode off before going into production.

For this, just add `debug: true` to the top level of `sg_authc.yml`:

```yaml
debug: true
auth_domains:
- type: basic/internal_users_db
- type: jwt
  jwt.jwks_endpoint.url: "https://idp.example.com/public-keys.jwks"
```

You can also use the `sgctl` command to set the flag directly on the cluster without having edit files:

```
$ ./sgctl.sh set authc debug --true
```

To disable it, use this command:

```
$ ./sgctl.sh set authc debug --false
```

If the debug mode is active, open the URL `/_searchguard/auth/debug` - either with your browser, curl or your favorite REST client tool. Provide the credentials you want to test. The endpoints returns a JSON document detailing all intermediate steps of the authentication process and their status.



## Mapping user information

Both authentication frontends and authentication backends can deliver user information in a big variety of different data structures. Most frontends and backends have suitable defaults for retrieving user names. However, for retrieving roles and user attributes, you often need to specify how you want to retrieve these.

This is where the user mapping comes into play. It allows you to map the various information from authentication frontends and backends to the user name, to roles, and to user attributes.


### Example application

Let's have a look at an example:

```yaml
auth_domains:
- type: jwt
  jwt.jwks_endpoint.url: "https://idp.example.com/public-keys.jwks"
  user_mapping.user_name.from: jwt.preferred_user_name
  user_mapping.roles.from: jwt.roles
  user_mapping.attributes.from:
    dept_no: jwt.department.number
    level: jwt.department.access_level
```

The JWT authentication frontend retrieves the user name by default from the `sub` attribute inside the JWT. However, sometimes, this value might be a not really human-readable value like a UUID. Then a different attribute of the JWT might contain a more suitable user name. By specifying `user_mapping.user_name.from: jwt.preferred_user_name` we say that the user name should be taken from the `preferred_user_name` attribute of the JWT. The expression that can be used as value for this setting is a JSON path, which allows you great flexibility in traversing object graphs for values. In front of `preferred_user_name` we need to specify `jwt` to indicate that the value shall be taken from the JWT used for authentication. All authentication frontends and backends can make their own information objects available for querying. See the respective documentation of the frontends and backends for the available objects. Also, there are a couple of global objects which provide request metadata such as originating IP addresses, etc.

Moving on to `user_mapping.roles.from`: This specifies to retrieve roles from an attribute called `roles` inside the JWT. In contrast to the user name, roles are usually multi-valued. Thus, this expects the `roles` attribute in the JWT to be an array of role names which will be then mapped to the user's backend roles.  

Often, it might be the case that roles are specified only as a comma-separated string. In this case, you can write instead `user_mapping.roles.from_comma_separated_value: jwt.roles`.

Finally, `user_mapping.attributes.from` is the most complex setting. In Search Guard, user attributes are used for dynamically defining the data a user has access to - based on index names or document attribute values. A Search Guard user can have an arbitrary number of named attributes. Each attribute can be a string, number, boolean or a complex type such as an array or an object with further attributes. However, it is not desirable to map all possible attributes coming from the request to user attributes. This is both for security and for performance reasons. Thus, the user attribute mapping should just map the attributes that are really necessary. 

In the example, the attribute `department.number` is retrieved from the JWT and put into the Search Guard user with the attribute name `dept_no`. Additionally, the attribute `level` is retrieved from `jwt.department.access_level`. 

### Using static information for user mapping

You can also define constant values to be used for user name, roles or attributes. For this, use the properties `user_mapping.user_name.static`, `user_mapping.roles.static` and `user_mapping.attributes.static`. A case, where this is very useful, is anonymous authentication. See the following example configuration for this:

```yaml
auth_domains:
- type: anonymous
  user_mapping.user_name.static: anon
  user_mapping.roles.static: anon_role
  user_mapping.attributes.static:
    dept_no: 0
    level: 0
```

### Getting the user name from a backend

Usually, the user name is determined by the authentication frontend. For username/password-based authentication, it is quite clear that the username used by Search Guard is normally the same as the one provided by the user during login. Also, JWT, OIDC or SAML protocols usually provide a suitable user name.

In some cases, however, it might be useful to use a backend to provide the actual username which shall be used by Search Guard. For this use-case, you need to use the
configuration option `user_mapping.user_name.from_backend`. 

An example for this might look like this:

```yaml
auth_domains:
- type: basic/ldap
  ldap.idp.hosts:
  - "ldaps://ldap.example.com"
  ldap.user_search.filter.by_attribute: uid
  user_mapping.user_name.from_backend: ldap_user_entry.displayName[0]
```

In this case, the user needs to provide their `uid` as user name in the login form. However, when the user is logged in, the `displayName` attribute from the corresponding LDAP entry is used as the actual user name.

### More details on user mapping

See the section [advanced user mapping](auth_auth_rest_config_advanced_user_mapping.md) for a comprehensive overview over all options.

## Restricting authentication domains

You can selectively restrict each authentication domains to specific origin IPs or to specific users. This may be useful if you want to offer some authentication domains only for specific systems in your network. This may look like this:

```yaml
auth_domains:
- type: jwt
  jwt.jwks_endpoint.url: "https://idp.example.com/public-keys.jwks"
- type: basic/internal_users_db
  accept.ips: '10.10.22.16/30'
  accept.users: 'kibanaserver' 
```

In the example above, JWT authentication is available for all systems. The password-based authentication, however, is only available for certain IPs identified by a CIDR expression. Furthermore, only the user with the name `kibanaserver` is allowed to be authenticated on this domain. For the `accept.users` property, you can also use wildcards like `accept.users: 'kibana*'`. For both properties, you can also specify multiple values as a list.

On the other hand, you can use the `skip.ips` and `skip.users` properties to skip an authentication domain for certain IPs or users:

```yaml
auth_domains:
- type: basic/ldap
  ldap.idp.hosts: ldap.example.com
  ldap.idp.bind_dn: "cn=admin,dc=example,dc=com"
  ldap.idp.password: secret
  skip.users: 'kibanaserver'   
- type: basic/internal_users_db
  accept.users: 'kibanaserver' 
```

You can also combine `skip` and `accept`. When doing so, keep in mind that `accept` is evaluated first; `skip` is evaluated afterwards. This means that `skip` can only further restrict the `accept` settings. However, `accept` *cannot* be used to allow access which would be otherwise denied by a `skip` rule. 


### IP addresses of users behind proxies

If users are required to use proxies to access Elasticsearch, their actual IP address might be obscured by the proxy. However, proxies can report the actual IP address of the user in special HTTP headers, such as the `X-Forwarded-For` header. Search Guard allows you to evaluate these IP addresses as well. You just need to specify the IP addresses of trusted proxies in the configuration. This is one in a special section of `sg_authc.yml`: 

```yaml
auth_domains:
- type: basic/internal_users_db
  accept.originating_ips: '172.16.10.0/24'
network:
  trusted_proxies: '10.111.111.0/30' 
```

The originating IP which is checked in `accept.originating_ips` is determined the following way:

- If the IP address of the directly connecting host does not match the `trusted_proxies` expression, that IP is also the originating IP.
- If the IP address is in a trusted proxy network, Search Guard will look at the `X-Forwarded-For` header.  Search Guard will search the IPs specified in the header from right to left for the first untrusted IP address. This will be the originating IP address.  If you want to use a different header name, you can configure the name with the property `http.remote_ip_header` in the `network` section.s



## Additional user information backends

For each authentication domain, you can configure additional user information backends. These user information backends allow you to enrich the user information by additional roles and attributes. The different to normal authentication backends is that user information backends do not participate in authentication:  If a user information backend has no records on a particular user, the user is able to login anyway.

**Note:** Users of earlier versions of Search Guard know "Authorization Backends" as a similar concept. User information backends are replacing these now. Major differences to authorization backends include: While authorization backends were configured globally, user information backends do always belong to one auth domain. This allows for a more fine-grained configuration. Additionally, user information backends support the retrieval of user attributes.

See the following example:

```yaml
auth_domains:
- type: basic/internal_users_dbs
  additional_user_information:
  - type: ldap
    ldap.idp.hosts: ldap.example.com
    ldap.idp.bind_dn: 'cn=admin,dc=example,dc=com'
    ldap.idp.password: secret
    ldap.group_search.base_dn: 'ou=groups,dc=example,dc=com'
    ldap.group_search.recursive.enabled: true
```

Here, we use LDAP to retrieve additional roles for users which have authenticated using the internal users database. By default, the roles are represented by the distinguished name of the respective LDAP entries found during the role search. If you want to use other attributes for defining the role names or if you also want to retrieve user attributes, you must use the `user_mapping` configuration.

The LDAP group search produces an array of LDAP entries, which are made available for user mapping as `ldap_group_entries`; each entry contains has a name (`dn`) and may have further attributes.  Keep in mind that in LDAP attributes are always multi-valued. Thus, the data structure available for user mapping might look similar to this object tree (rendered in YAML):

```yaml
ldap_user_entry:
   dn: "cn=Karlotta,ou=people,o=TEST"
   cn: ["Karlotta"]
   departmentNumber: [1, 2]
ldap_group_entries:
-  dn: "cn=group1,ou=groups,o=TEST"
   cn: ["group1"]
   businessCategory: ["c"]
-  dn: "cn=group2,ou=groups,o=TEST"
   cn: ["group2"]
   businessCategory: ["d", "e"]
-  dn: "cn=group3,ou=groups,o=TEST"
   cn: ["group3"]
   businessCategory: ["f"]
```

If you want to use the `cn` attributes of the group entries as role names and want to map the `businessCategory` attributes to user attributes, you can use this user mapping:

```yaml
auth_domains:
- type: basic/internal_users_dbs
  additional_user_information:
  - type: ldap
    [...]
    user_mapping.groups.from: ldap_group_entries[*].cn
    user_mapping.attributes.from:
       biz_cat: ldap_group_entries[*].businessCategory
```
   
Remember that the expressions used for retrieving the role and attribute values are JSON path expressions. By writing `[*]` after `ldap_group_entries` you specify, that `ldap_group_entries` is an array and that you want to search all elements of the array. From all the elements, you are then getting the union of the values of the `cn`, resp. `businessCategory` attributes.


## Advanced topics

There are a number of additional advanced options in `sg_authc.yml`. These allow you to customize the following things:

- [Advanced user mapping](auth_auth_rest_config_advanced_user_mapping.md)
- [Global restrictions for IP addresses](auth_auth_rest_config_advanced_options.md)
- [Authentication cache settings](auth_auth_rest_config_advanced_options.md)



