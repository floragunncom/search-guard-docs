---
title: User and roles troubleshooting
slug: troubleshooting-search-guard-user-roles
category: troubleshooting
order: 210
layout: troubleshooting
description: How to troubleshoot problems with Search  Guard users and roles.
---

<!--- Copryight 2018 floragunn GmbH -->

# User and roles troubleshooting

When debugging user and roles issues, please issue a call against the Search Guard authinfo endpoint first. This endpoint will print out information about the currently logged in user in JSON format.

**Request:**

```
curl -k -u admin:admin -XGET "https://sgssl-0.example.com:9200/_searchguard/authinfo?pretty"
```

**Response**

```
{
  "user" : "User [name=admin, roles=[admin], requestedTenant=null]",
  "user_name" : "admin",
  "user_requested_tenant" : null,
  "remote_address" : "172.16.0.254:47496",
  "backend_roles" : [
    "admin"
  ],
  "custom_attribute_names" : [
    "attr.internal.attribute1",
    "attr.internal.attribute2",
    "attr.internal.attribute3"
  ],
  "sg_roles" : [
    "sg_all_access",
    "sg_own_index"
  ],
  "sg_tenants" : {
    "admin_tenant" : true,
    "admin" : true
  },
  "principal" : null,
  "peer_certificates" : "0",
  "sso_logout_url" : null
}
```

## Backend roles

The `backend_roles` section will list all backend roles assigned to this user:

```
"backend_roles" : [
  "admin"
]
```

Depending on your configured authentication and authorization types, backend roles can come from the internal user database, LDAP groups, JSON web token claims or SAML assertions. Check that the user has the backend roles that you expect.

## Search Guard roles

The sg_roles section lists all assigned Search Guard roles:

```
"sg_roles" : [
  "sg_all_access",
  "sg_own_index"
]
```

Search Guard uses the [roles mapping configuration to map users to Search Guard roles](../_docs/configuration_roles_mapping.md). You can either use the username or the backend roles for the mapping. Using backend roles is preferred since it will give you greater flexibility.

If the user does not have the expected Search Guard roles, please check and correct your `sg_roles_mapping.yml` configuration.

## Custom attributes

A user can have one or more custom attributes, which can be used in index names and DLS queries. The `custom_attribute_names` section lists all available attribute names:

```
"custom_attribute_names" : [
  "attr.internal.attribute1",
  "attr.internal.attribute2",
  "attr.internal.attribute3"
]
```

For security reasons, only the attribute names are listed, not their actual values.
{: .note .js-note .note-warning}

## Kibana tenants

If you are using Kibana multi tenancy, the `sg_tenants` section lists all available tenants:

```
"sg_tenants" : {
  "admin_tenant" : true,
  "admin" : true
}
```

The keys denote the tenant names. If the value is true, it means the user has RW access to this tenant. If it is false, the user has RO access.