---
title: Roles mapping API
html_title: Roles mapping REST API endpoints
slug: rest-api-roles-mapping
category: restapi
order: 420
layout: docs
edition: enterprise
description: How to use the roles mapping REST API endpoints to assign users to Search Guard roles.
---
<!---
Copryight 2018 floragunn GmbH
-->

# Roles mapping API

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
    "backendroles" : [ "starfleet", "captains", "defectors", "cn=ldaprole,ou=groups,dc=example,dc=com" ],
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
  "backendroles" : [ "starfleet", "captains", "defectors", "cn=ldaprole,ou=groups,dc=example,dc=com" ],
  "hosts" : [ "*.starfleetintranet.com" ],
  "users" : [ "worf" ]
}
```

You need to specify at least one of `backendroles`, `hosts` or `users`.

If the call is succesful, a JSON structure is returned, indicating whether the roles mapping was created or updated.

```json
{
  "status":"OK",
  "message":"rolesmapping sg_role_starfleet created."
}
```
