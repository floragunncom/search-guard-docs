---
title: Authorisation
html_title: LDAP Authorisation
slug: active-directory-ldap-authorisation
category: ldap
order: 300
layout: docs
edition: enterprise
description: Use Search Guards Active Directory and LDAP feature to fetch the roles of a user from an Active Directory server.
resources:
  - "search-guard-presentations#active-directory-ldap|LDAP & Active Directory configuration (presentation)"

---
<!---
Copyright 2020 floragunn GmbH
-->

# Active Directory and LDAP Authorisation
{: .no_toc}

{% include toc.md %}

## Activating Authorisation

To use Active Directory / LDAP for authorisation first configure a respective authorisation domain in the `authz` section of `sg_config`:

```yaml
authz:
  ldap:
    http_enabled: true
  authorization_backend:
    type: ldap
    config:
      ...
```
      
## Configuring Authorisation

Authorisation is the process of retrieving backend roles for an authenticated user from an LDAP server. This is typically the same server(s) you use for authentication, but you can also use a different server if necessary. The only requirement is that the user to fetch the roles for actually exists on the LDAP server.

Since Search Guard always checks if a user exists in the LDAP server, you need to configure `userbase`, `usersearch` and `username_attribute` also in the `authz` section.
      
Authorisation works similarly to authentication. Search Guard issues an *LDAP query* containing the *username* against the *role subtree* of the *LDAP tree*.

As an alternative, Search Guard can also fetch roles that are defined as a direct attribute of the user entry in the user subtree.

Both methods can also be combined.  Usually you will have either roles defined as an attribute of the user entry or roles stored in a seperate subtree.

### Approach 1: Querying the role subtree

Search Guard first takes the LDAP query for fetching roles ("rolesearch"), and substitutes any variables found in the query. For example, for a standard Active Directory installation, you would use the following role search:

```yaml
rolesearch: '(member={0})'
```

You can use the following variables:

* {0} is substituted with the DN of the user
* {1} is substituted with the username, as defined by the `username_attribute` setting
* {2} is substituted with an arbitrary attribute value from the authenticated user's directory entry

The variable `{2}` refers to an attribute from the user's directory entry. Which attribute you want to use is specified by the `userroleattribute` setting.

```yaml
userroleattribute: myattribute
```

Search Guard then issues the substituted query against the configured role subtree. The whole subtree underneath `rolebase` will be searched.

```yaml
rolebase: 'ou=groups,dc=example,dc=com'
```

Since Search Guard v24 you can alternatively configure multiple role bases (this combines and replaces the `rolesearch` and `rolebase` attribute): 

```yaml
roles:
  normalroles:
    base: 'ou=groups,dc=example,dc=com'
    search: '(uniqueMember={0})'
  other:
    base: 'ou=othergroups,dc=example,dc=com'
    search: '(owner={0})'
```

If you use nested roles (roles which are members of other roles etc.), you can configure Search Guard to resolve these roles as well:

```yaml
resolve_nested_roles: false
```

After all roles have been fetched, Search Guard extracts the final role names from a configurable attribute of the role entries:

```yaml
rolename: cn
```

If this is not set, the DN of the role entry is used. You can now use this role name for mapping it to one or more Search Guard roles, as defined in `roles_mapping.yml`.

### Approach 2: Using a user's attribute as role name

If you store the roles as a direct attribute of the user entries in the user subtree, you only need to configure the attribute name:

```yaml
userrolename: roles
```

You can configure multiple attribute names separated by comma:

```yaml
userrolename: roles, otherroles
```
This approach can be combined with querying the role subtree. Search Guard will first fetch the roles from the user's role attribute, and the execute the role search.

If you don't use/have a role subtree, you can disable the role search completely:

```yaml
rolesearch_enabled: false
```

### Performance: Controlling LDAP user attributes

By default, Search Guard will read all LDAP user attributes and make them available for [index name variable substitution](../_docs_roles_permissions/configuration_roles_permissions.md) or [DLS query variable substitution](../_docs_dls_fls/dlsfls_dls.md).

If your LDAP entries have a lot of attributes, you may want to control which attributes should be made available as variables. Fewer attributes result in better runtime performance behaviour.

| Name | Description |
|---|---|
| custom\_attr\_whitelist  | String array, specifies the LDAP attributes that should be made available for variable substitution. |
| custom\_attr\_maxval\_len  | Integer, specifies the maximum allowed length of each attribute. All attributes longer than this value will be discarded. A value of `0` will disable custom attributes altogether. Default: 36 |
{: .config-table}

Example:

```yaml
authz:
  ldap:
    http_enabled: true
  authorization_backend:
    type: ldap
    config:
      custom_attr_whitelist:
        - attribute1
        - attribute2
      custom_attr_maxval_len
      ...
```

### Advanced: Exclude certain users from role lookup

If you are using multiple authentication methods, it can make sense to exclude certain users from the LDAP role lookup.

Consider the following scenario for a typical Kibana setup:

All Kibana users are stored in an LDAP/Active Directory server.

However, you also need a Kibana server user. This is used by Kibana internally to manage stored objects and perform monitoring and maintenance tasks. You do not want to add this Kibana-internal user to your Active Directory installation, but store it in the Search Guard internal user database.

In this case, it makes sense to exclude the Kibana server user from the LDAP authorisation, since we already know that there is no corresponding entry. You can use the `skip_users` configuration setting to define which users should be skipped. **Wildcards** and **regular expressions** are supported.

```yaml
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

```yaml
nested_role_filter: <true|false>
  - 'cn=Michael Jackson,ou*people,o=TEST'
  - ...
```

For more information on how to exclude users from lookups see the page [Exclude certain users from authentication/authorization](../_docs_auth_auth/auth_auth_configuration.md).

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
| userroleattribute  | The attribute in a user entry to use for `{2}` variable substitution. If this references a multi-value field it is undefined which value will be used. It's therefore not recommended to set it to a multi-value field.|
| userrolename  | If the roles/groups of a user are not stored in the groups subtree, but as an attribute of the user's directory entry, define this attribute name here. If this references a multi-value field it is undefined which value will be used. It's therefore not recommended to set it to a multi-value field.|
| rolename  | The attribute of the role entry which should be used as role name. If this references a multi-value field it is undefined which value will be used. It's therefore not recommended to set it to a multi-value field.|
| resolve\_nested\_roles  | Boolean, whether or not to resolve nested roles transitively (roles which are members of other roles and so on ...), default: false. |
| skip_users  | Array of users that should be skipped when retrieving roles. Wildcards and regular expressions are supported.  |
| nested\_role\_filter  | Array of role DNs that should be filtered before resolving nested roles. Wildcards and regular expressions are supported.  |
| rolesearch_enabled  | Boolean, enable or disable the role search, default: true.  |
| custom\_attr\_whitelist  | String array, specifies the LDAP attributes that should be made available for variable substitution. |
| custom\_attr\_maxval\_len  | Integer, specifies the maximum allowed length of each attribute. All attributes longer than this value will be discarded. A value of `0` will disable custom attributes altogether. Default: 36 |
{: .config-table}

### Complete authorization example

```yaml
authz:
  ldap:
    http_enabled: true
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

## Configuring multiple role bases

You can also configure multiple role bases. Search Guard will query all role bases to fetch the users LDAP groups:


```yaml
authz:
  ldap:
    http_enabled: true
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
        users:
          primary-userbase:
            base: 'ou=people,dc=example,dc=com'
            search: '(uid={0})'
          secondary-userbase:
            base: 'ou=otherpeople,dc=example,dc=com'
            search: '(initials={0})'
        username_attribute: uid
        roles:
          primary-rolebase:
            base: 'ou=groups,dc=example,dc=com'
            search: '(uniqueMember={0})'
          secondary-rolebase:
            base: 'ou=othergroups,dc=example,dc=com'
            search: '(owner={0})'
        userroleattribute: null
        userrolename: none
        rolename: cn
        resolve_nested_roles: true
        skip_users:
          - kibanaserver
          - 'cn=Michael Jackson,ou*people,o=TEST'
          - '/\S*/'
```

The names of the configuration keys (`primary-rolebase`, `secondary-rolebase`...) are just telling names. You can choose them freely and you can configure as many role bases as you need.
