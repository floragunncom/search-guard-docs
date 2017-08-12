<!---
Copryight 2016 floragunn GmbH
-->

# LDAP and Active Directory

## Installation

Download the LDAP enterprise module from Maven Central:

[LDAP module on Maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-authbackend-ldap%22) 

and place it in the folder

* `<ES installation directory>/plugins/search-guard-2`

or

* `<ES installation directory>/plugins/search-guard-5`

if you are using Search Guard 5.

**Choose the module version matching your Elasticsearch version, and download the jar with dependencies.**

After that, restart all nodes to activate the module.

## Activating the module

LDAP and Active Directory can be used both in the `authc` and `authz` section of the configuration. The `authc` section is used for configuring authentication, which means to check if the user has entered the correct credentials. The `authz` is used for authorisation, which defines how the role(s) for an authenticated user are retrieved and mapped.

In most cases, you want to configure both authentication and authorization, however, it is also possible to use authentication only and map the users retrieved from LDAP directly to Search Guard roles. This can be done in the `sg_roles_mappig.yml` configuration.

To enable LDAP authentication and authorization, add the following lines to sg_config.yml

**Authentication:**

```
authc:
  ldap:
    enabled: true
    order: 1
    http_authenticator:
      type: basic
      challenge: false
    authentication_backend:
      type: ldap
      config:
        ...
```

**Authorization:**

```
authz:
  ldap:
    enabled: true
  authorization_backend:
    type: ldap
    config:
      ...
```
## Configuring the connection settings
    
For both entries you need to specify additional configuration parameters. Some of them are identical between the `authc` and `authz` section. 

Common configuration parameters:

```
config:
  # enable ldaps
  enable_ssl: <true|false>
  # enable start tls, enable_ssl should be false
  enable_start_tls: <true|false>
  # send client certificate
  enable_ssl_client_auth: <true|false>
  # verify ldap hostname
  verify_hostnames: <true|false>
  hosts:
    - localhost:8389
  bind_dn: null
  password: null
```

### TLS settings

The first entries control the TLS settings of the connection to your LDAP server.

| Name | Description |
|---|---|
| enable_ssl | Whether to use LDAP over SSL (LDAPS) or not |
| enable\_start\_tls | Whether to use STARTTLS or not. Cannot be used in combination with LDAPS. |
| enable\_ssl\_client\_auth | Whether to send the client certificate to the LDAP server or not. The client certificate is taken from the keystore configured in `elasticsearch.yml` |

To verify the validity of the certificates, Search Guard uses the transport truststore configured in `elasticsearch.yml`. This means that the certificate (-chain) from your LDAP server must be signed by one of the certificates in the transport truststore.

### Enabled ciphers and protocols

You can limit the allowed ciphers and TLS protocols for the LDAP connection. For example, you can only allow strong ciphers and limit the TLS versions to the most recent ones.

| Name | Description |
|---|---|
| enabled\_ssl\_ciphers | Array, enabled TLS ciphers. Only Java format is supported. |
| enabled\_ssl\_protocols | Array, enabled TLS protocols. Only Java format is supported. |

Example:

```
ldap:
  enabled: true
  ...
  authentication_backend:
    type: ldap
    config:
      enabled_ssl_ciphers:
        - "TLS_DHE_RSA_WITH_AES_256_CBC_SHA"
        - "TLS_DHE_DSS_WITH_AES_128_CBC_SHA256"
      enabled_ssl_protocols:
        - "TLSv1.1"
        - "TLSv1.2"
```

**Note: By default Search Guard disables `TLSv1` because it is unsecure. If you need to use `TLSv1` and you know what you  are doing, you can re-enable it like:**

```
enabled_ssl_protocols:
  - "TLSv1"
  - "TLSv1.1"
  - "TLSv1.2"
```

### LDAP server settings

Next, configure how Search Guard connects to your LDAP server(s):

| Name | Description |
|---|---|
| hosts | Host and port of your LDAP server(s). Hostnames and IPs are allowed, and you can define multiple LDAP servers. |
| bind_dn | The DN to use when connecting to LDAP. If anonymous auth is allowed, can be set to null |
| password | The password to use when connecting to LDAP. If anonymous auth is allowed, can be set to null |

## Configuring Authentication

Authentication works by issuing an *LDAP query* containing the *username* against the *user subtree* of the *LDAP tree*.

Search Guard first takes the configured LDAP query, and replaces the placeholder `{0}` with the username from users credentials.

```
usersearch: '(sAMAccountName={0})'
```

Search Guard then issues this query against the user subtree ("userbase"). Currently the whole subtree beneath the configured `userbase` is searched:

```
userbase: 'ou=people,dc=example,dc=com'
```

If the query was successful, Search Guard retrieves the username from the LDAP entry. You can specify which attribute from the LDAP entry Search Guard should use as the username:

```
username_attribute: uid
```

If this key is not set, or null, then the DN of the LDAP entry is used.

### Configuration summary

| Name | Description |
|---|---|
| userbase | Specifies the subtree in the directory where user information is stored |
| usersearch | The actual LDAP query that Search Guard executes when trying to authenticate a user. The variable {0} is substituted with the username.|
| username_attribute | Search Guard uses this attribute of the directory entry to look for the user name. If set to null, the DN is used (default). |

### Complete authentication example

```
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
      userbase: 'ou=people,dc=example,dc=com'
      usersearch: '(uid={0})'
      username_attribute: uid
```
            
## Configuring Authorisation

Authorisation is the process of retrieving backend roles for an authenticated user from an LDAP server. This is typically the same server(s) you use for authentication, but you can also use a different server if necessary. The only requirement is that the user to fetch the roles for actually exists on the LDAP server.

Since Search Guard always checks if a user exists in the LDAP server, you need to configure `userbase`, `usersearch` and `username_attribute` also in the `authz` section.
      
Authorisation works similarly to authentication. Search Guard issues an *LDAP query* containing the *username* against the *role subtree* of the *LDAP tree*.

As an alternative, Search Guard can also fetch roles that are defined as a direct attribute of the user entry in the user subtree.

Both methods can also be combined.  Usually you will have either roles defined as an attribute of the user entry or roles stored in a seperate subtree.

### Approach 1: Querying the role subtree

Search Guard first takes the LDAP query for fetching roles ("rolesearch"), and substitutes any variables found in the query. For example, for a standard Active Directory installation, you would use the following role search:

```
rolesearch: '(member={0})'
```

You can use the following variables:

* {0} is substituted with the DN of the user
* {1} is substituted with the username, as defined by the `username_attribute` setting
* {2} is substituted with an arbitrary attribute value from the authenticated user's directory entry

The variable `{2}` refers to an attribute from the user's directory entry. Which attribute you want to use is specified by the `userroleattribute` setting.

```
userroleattribute: myattribute
```

Search Guard then issues the substituted query against the configured role subtree. The whole subtree underneath `rolebase` will be searched.

```
rolebase: 'ou=groups,dc=example,dc=com'
```

If you use nested roles (roles which are members of other roles etc.), you can configure Search Guard to resolve these roles as well:

```
resolve_nested_roles: false
```

After all roles have been fetched, Search Guard extracts the final role names from a configurable attribute of the role entries:

```
rolename: cn
```

If this is not set, the DN of the role entry is used. You can now use this role name for mapping it to one or more Search Guard roles, as defined in `roles_mapping.yml`.

### Approach 2: Using a user's attribute as role name

If you store the roles as a direct attribute of the user entries in the user subtree, you only need to configure the attributes name:

```
userrolename: roles
```

### Advanced: Exclude certain users from role lookup

If you are using multiple authentication methods, it can make sense to exclude certain users from the LDAP role lookup.

Consider the following scenario for a typical Kibana setup:

All Kibana users are stored in an LDAP/Active Directory server.

However, you also need a Kibana server user. This is used by Kibana internally to manage stored objects and perform monitoring and maintenance tasks. You do not want to add this Kibana-internal user to your Active Directory installation, but store it in the Search Guard internal user database.

In this case, it makes sense to exclude the Kibana server user from the LDAP authorisation, since we already know that there is no corresponding entry. You can use the `skip_users` configuration setting to define which users should be skipped. **Wildcards** and **regular expressions** are supported.

```
skip_users:
  - kibanaserver
  - 'cn=Michael Jackson,ou*people,o=TEST'
  - '/\S*/'
```

### Advanced: Exclude roles from nested roles lookups

If the users in your LDAP installation have a large amount of roles, and you have the requirement to resolve nested roles as well, you might run into the following performance issue:

* For each of the users roles, Search Guard resolves nested roles.
* This means at least one additional LDAP query per role.
* If a user has many roles, and these roles are deeply nested, this results in a lot of additional LDAP queries
* This means more network roundtrips and thus, depending on your network latency and LDAP response times, a performance penalty.

However, in most cases not all roles a user has are related to Elasticsearch / Kibana / Search Guard. You might need just one or two roles, and all other roles are irrelevant. If this is the case, you can use the nested role filter feature.

With this feature, you can define a list of roles which are filtered out from the list of the user's roles, **before** nested roles are resolved. **Wildcards** and **regular expressions** are supported.

So if you already know which roles are relevant for your Elasticsearch cluster and which aren't, simply list the irrelevant roles and enjoy improved performance.

This only has an effect if `resolve_nested_roles` is `true`.

```
nested_role_filter: <true|false>
  - 'cn=Michael Jackson,ou*people,o=TEST'
  - ...
```

### Advanced: Disable the role search completely

If your roles are not stored in a role subtree (approach 1 from above), but only as direct attributes of the user's entry in the user subtree (approach 2 from above), you can disable the role search completely for better performance.

```
rolesearch_enabled: <true|false>
```

### Advanced: Active Directory Global Catalog (DSID-0C0906DC)

Depending on your configuration you may need to use port 3268 instead of 389 so that the LDAP module is able to query the global catalog. Changing the port can help to avoid warnings like

```
[WARN ][o.l.r.SearchReferralHandler] Could not follow referral to ldap://ForestDnsZones.xxx.xxx.local/DC=ForestDnsZones,DC=xxx,DC=xxx,DC=local
org.ldaptive.LdapException: javax.naming.NamingException: [LDAP: error code 1 - 000004DC: LdapErr: DSID-0C0906DC, comment: In order to perform this operation a successful bind must be completed on the connection., data 0, v1db0]; remaining name 'DC=ForestDnsZones,DC=xxx,DC=xxx,DC=local'
...
Caused by: javax.naming.NamingException: [LDAP: error code 1 - 000004DC: LdapErr: DSID-0C0906DC, comment: In order to perform this operation a successful bind must be completed on the connection., data 0, v1db0]
```

For more details refer to https://technet.microsoft.com/en-us/library/cc978012.aspx

### Configuration summary

| Name | Description |
|---|---|
| rolebase  | Specifies the subtree in the directory where role/group information is stored. |
| rolesearch | The actual LDAP query that Search Guard executes when trying to determine the roles of a user. You can use three variables here (see below).|
| userroleattribute  | The attribute in a user entry to use for `{2}` variable substitution. |
| userrolename  | If the roles/groups of a user are not stored in the groups subtree, but as an attribute of the user's directory entry, define this attribute name here. |
| rolename  | The attribute of the role entry which should be used as role name. |
| resolve\_nested\_roles  | Boolean, whether or not to resolve nested roles transitively (roles which are members of other roles and so on ...), default: false. |
| skip_users  | Array of users that should be skipped when retrieving roles. Wildcards and regular expressions are supported.  |
| nested\_role\_filter  | Array of role DNs that should be filtered before resolving nested roles. Wildcards and regular expressions are supported.  |
| rolesearch_enabled  | Boolean, enable or disable the role search, default: true.  |

### Complete authorization example

```
authz:
  ldap:
    enabled: true
    authorization_backend:
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
        usersearch: '(uid={0})'
        username_attribute: uid
        rolebase: 'ou=groups,dc=example,dc=com'
        rolesearch: '(member={0})'
        userroleattribute: null
        userrolename: none
        rolename: cn
        resolve_nested_roles: true
        skip_users:
          - kibanaserver
          - 'cn=Michael Jackson,ou*people,o=TEST'
          - '/\S*/'
```
