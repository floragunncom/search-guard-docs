---
title: Roles mapping API
html_title: Roles mapping API
slug: rest-api-roles-mapping
category: restapi
order: 420
layout: docs
edition: enterprise
description: How to use the roles mapping REST API endpoints to assign users to Search Guard roles.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Roles mapping API
{: .no_toc}

{% include toc.md %}

Used to receive, create, update and delete the mapping of users, backendroles and hosts to Search Guard roles.

## Endpoint

```
/_searchguard/api/rolesmapping/{rolename}
```
Where `rolename` is the name of the role.

## GET

### Get a single role mapping

```
GET /_searchguard/api/rolesmapping/{rolename}
```

Retrieve a role mapping, specified by rolename, in JSON format.

```
GET /_searchguard/api/rolesmapping/sg_role_starfleet
```

```json
{
  "sg_role_starfleet" : {
    "description": "...",
    "backend_roles" : [ "starfleet", "captains", "defectors", "cn=ldaprole,ou=groups,dc=example,dc=com" ],
    "hosts" : [ "*.starfleetintranet.com" ],
    "users" : [ "worf" ]
  }
}
```

### Get all role mappings

```
GET /_searchguard/api/rolesmapping
```

Returns all role mappings in JSON format.

## DELETE
```
DELETE /_searchguard/api/rolesmapping/{rolename}
```

Deletes the rolemapping specified by `rolename`. If successful, the call returns with status code 200 and a JSON success message.

```
DELETE /_searchguard/api/rolesmapping/sg_role_starfleet
```

```json
{
  "status":"OK",
  "message":"rolesmapping sg_role_starfleet deleted."
}
```

## PUT

```
PUT /_searchguard/api/rolesmapping/{rolename}
```
Replaces or creates the role mapping specified by `rolename `.

```json
PUT /_searchguard/api/rolesmapping/sg_role_starfleet
{
  "backend_roles" : [ "starfleet", "captains", "defectors", "cn=ldaprole,ou=groups,dc=example,dc=com" ],
  "hosts" : [ "*.starfleetintranet.com" ],
  "users" : [ "worf" ]
}
```

You need to specify at least one of `backend_roles`, `hosts` or `users`.

If the call is succesful, a JSON structure is returned, indicating whether the roles mapping was created or updated.

```json
{
  "status":"OK",
  "message":"rolesmapping sg_role_starfleet created."
}
```

## PATCH

The PATCH endpoint can be used to change individual attributes of a roles mapping, or to create, change and delete roles mappings in a bulk call. The PATCH endpoint expects a payload in JSON Patch format. Search Guard supports the complete JSON patch specification.

[JSON patch specification: http://jsonpatch.com/](http://jsonpatch.com/){:target="_blank"}

### Patch a roles mapping

```
PATCH /_searchguard/api/rolesmapping/{rolename}
```

Adds, deletes or changes one or more attributes of a user specified by `rolename `.

```json
PATCH /_searchguard/api/rolesmapping/sg_human_resources
[ 
  { 
    "op": "replace", "path": "/users", "value": ["myuser"] 
  },
  { 
    "op": "replace", "path": "/backend_roles", "value": ["mybackendrole"] 
  }
]
```

### Bulk add, delete and change roles mappings

```json
PATCH /_searchguard/api/rolesmapping
[ 
  { 
    "op": "add", "path": "/sg_human_resources", "value": { "users": ["user1"], "backend_roles": ["backendrole2"] } 
  },
  { 
    "op": "add", "path": "/sg_finance", "value": { "users": ["user2"], "backend_roles": ["backendrole2"] } 
  },
  { 
    "op": "remove", "path": "/sg_management"
  }
]
```