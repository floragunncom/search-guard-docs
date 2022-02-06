---
title: Quick Start
html_title: Active Directory and LDAP Quick Start
permalink: active-directory-ldap
category: ldap
order: 100
layout: docs
description: Use Search Guard's Active Directory and LDAP module to protect your OpenSearch/Elasticsearch cluster against unauthorized access.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Active Directory and LDAP
{: .no_toc}

{% include toc.md %}

Active Directory and LDAP can be used as authentication backend and user information backend. Thus, you can choose whether you want to authenticate your uses with LDAP or just want to retrieve roles and attributes by LDAP.

This chapter describes the basic setup of LDAP with Search Guard. This will work in most cases. However, some setups require special configurations for TLS, proxies, or similar things. Please refer to the section Advanced Configuration for this.

## Prerequisites

To use LDAP, you need to have access to an Active Directory/LDAP server. You need to have credentials which Search Guard can use to perform searches in the LDAP directory. Furthermore, you need to know the LDAP directory structure in order to configure how searches in the LDAP directory are performed. 

## Search Guard setup

A minimal `sg_authc.yml` using LDAP looks like this:

```yaml
auth_domains:
- type: basic/ldap
  ldap.idp.hosts:
  - "ldaps://ldap.example.com"
```

This way, Search Guard will connect by TLS on port 636 to the LDAP server `ldap.example.com`. With this configuration, the LDAP server must allow searches by anonymous connections. If you need to authenticate for doing servers on the LDAP server, you can provide the credentials using the config options `ldap.idp.bind_dn` and `ldap.idp.password`:

```yaml
auth_domains:
- type: basic/ldap
  ldap.idp.hosts:
  - "ldaps://ldap.example.com"
  ldap.idp.bind_dn: "cn=searchguard,ou=people,dc=example,dc=com"
  ldap.idp.password: "secret-ldap-password-123"
```

If you need to special TLS settings for creating TLS connections to the LDAP server,  you can use the attributes below `ldap.idp.tls`. See TODO for details on this.

### User search

When a user tries to authenticate at OpenSearch/Elasticsearch, Search Guard will search the whole LDAP directory tree for an entry where the attribute `sAMAccountName` equals the user name provided to OpenSearch/Elasticsearch. 

If you need to search using a different attribute, you can use the `ldap.user_search.filter.by_attribute` option to specify this:

```yaml
auth_domains:
- type: basic/ldap
  ldap.idp.hosts:
  - "ldaps://ldap.example.com"
  ldap.user_search.filter.by_attribute: "uid"
```

Search Guard allows you to configure all aspects of the user search: The search tree root, the search scope and complex filter expressions. See TODO for details.

### Roles

The `ldap` authentication backend offers two methods for determining the roles of a user:

- Attributes of the LDAP user entry
- The result of an additional LDAP search for groups where the user is member of.

You can choose to use one of the methods or both.

#### User entry attributes

You can use the standard Search Guard `user_mapping` functionality to retrieve roles from the LDAP user entry. Suppose the entries in your LDAP directory look like this:

```
dn: cn=karlotta,ou=people,dc=example,dc=com
objectClass: inetOrgPerson
sAMAccountName: karlotta
memberOf: cn=devops,ou=groups,dc=example,dc=com
memberOf: cn=hr,ou=groups,dc=example,dc=com
```

To access attributes of the LDAP entry during user mapping, the `ldap` authentication backend provides the `ldap_entry` object. If you want the values of the `memberOf` attribute as role names, you can use this user mapping:

```yaml
auth_domains:
- type: basic/ldap
  [...]
  user_mapping.roles.from: ldap_entry.memberOf
```

In Search Guard, the logged in users will then have the attribute values entries as backend roles; in the example, these would be the distinguished names `cn=devops,ou=groups,dc=example,dc=com` and `cn=hr,ou=groups,dc=example,dc=com`. You can use [the role mapping configuration](../_docs_roles_permissions/configuration_roles_mapping.md) to map these to Search Guard roles.

#### LDAP group search

If user entry attributes are not a sufficient source for roles, you can search a whole LDAP directory tree for entries where the user is member. The following snippet shows the minimal configuration for this:

```yaml
auth_domains:
- type: basic/ldap
  [...]
  ldap.group_search.base_dn: "ou=groups,dc=example,dc=com"  
```

With this configuration, Search Guard will search the directory tree below `ou=groups,dc=example,dc=com` for all entries which have a `member` attribute which equals the dn of the user logging in. The options of `group_search` are similar to `user_search`. If you need to search using a different attribute, you can use the `ldap.group_search.filter.by_attribute` option. See TODO for all available configuration options.

By default, the logged in users will then have the distinguished names ("dn") of the LDAP entries as backend roles. If you want to use a different attribute, you can specify this using `ldap.group_search.role_name_attribute`. For advanced mapping, you can also reference the group search result via `user_mapping`. See below for more on this.

#### Recursive group search

Normally, the group search will only search for groups where the user is a *direct* member. However, in LDAP directories, it might be also possible that groups are member of further groups. If the user shall transitively get the memberships of all the groups they are member in, you need to use recursive group search. This is just activated by the flag `ldap.group_search.recursive.enabled`: 

```yaml
auth_domains:
- type: basic/ldap
  [...]
  ldap.group_search.base_dn: "ou=groups,dc=example,dc=com"  
  ldap.group_search.recursive.enabled: true
```

**Note:** When doing recursive group search, Search Guard has to issue one further LDAP query for each level of recursion. This can slow down the authentication process. 

There are a couple of further configuration options to control and limit the recursive group search. See TODO.

## Activate the setup

After having applied the changes to `sg_authc.yml`, use `sgctl` to upload the file to Search Guard:

```
$ ./sgctl.sh update-config sg_authc.yml
```

That’s it. If you navigate in a browser to your OpenSearch/Elasticsearch instance, you should get a basic authentication popup asking for your username and password.


## Where to go next

* Check the  [advanced configuration options for LDAP](../_docs_auth_auth/auth_auth_ldap_advanced.md)