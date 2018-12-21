---
title: Roles and Tenants API
html_title: Search Guard roles and tenants REST API endpoints
slug: rest-api-roles
category: restapi
order: 410
layout: docs
edition: enterprise
description: How to use the interal usersroles REST API endpoints to manage users.
---

<!---
Copryight 2017 floragunn GmbH
-->


# Roles and Tenants API

Used to receive, create, update and delete roles and their respective permissions.

## Endpoint

```
/_searchguard/api/roles/{rolename}
```
Where `rolename` is the name of the role.

## GET

### Get a single role

```
GET /_searchguard/api/roles/{rolename}
```

Retrieve a role and its permissions, specified by rolename, in JSON format.

```
GET /_searchguard/api/roles/sg_role_starfleet
```
```json
{
  "sg_role_starfleet" : {
    "indices" : {
      "pub*" : {
        "*" : [ "READ" ],
        "_dls_": "{ \"bool\": { \"must_not\": { \"match\": { \"Designation\": \"CEO\"  }}}}",
        "_fls_": [
          "Designation",
          "FirstName",
          "LastName",
          "Salary"
        ]
      }
    }
  }
}
```

### Get all roles

```
GET /_searchguard/api/roles/{rolename}
```

Returns all roles in JSON format.

## DELETE
```
DELETE /_searchguard/api/roles/{rolename}
```
Deletes the role specified by `rolename`. If successful, the call returns with status code 200 and a JSON success message.

```
DELETE /_searchguard/api/roles/sg_role_starfleet
```
```json
{
  "status":"OK",
  "message":"role sg_role_starfleet deleted."
}
```

## PUT
```
PUT /_searchguard/api/roles/{rolename}
```
Replaces or creates the role specified by `rolename`.

```json
PUT /_searchguard/api/roles/sg_role_starfleet
{
  "cluster" : [ "*" ],
  "indices" : {
    "pub*" : {
      "*" : [ "READ" ],
      "_dls_": "{ \"bool\": { \"must_not\": { \"match\": { \"Designation\": \"CEO\"}}}}",
      "_fls_": ["field1", "field2"]
    }
  },
  "tenants": {
    "tenant1": "RW",
    "tenant2": "RO"
  }  
}
```

The JSON format resembles the format used in `sg_roles.yml`:

```json
{
  "cluster" : [ "<cluster permission>", "<cluster permission>", ... ],
  "indices" : {
    "<indexname>" : {
      "<typename>" : [ "<index/type permission>", "<index/type permission>", ... ],
      "_dls_": "<DLS query>",
      "_fls_": ["field", "field"]
    },
    "<indexname>" : {
      "<typename>" : [ "<index/type permission>", "<index/type permission>", ... ],
    },
    "tenants": {
      "<tenantname>" : "<RW | RO>",
      "<tenantname>" : "<RW | RO>",
      ...
    }
  }
}
```

If you're using DLS in the role definition, make sure to escape the quotes correctly!
{: .note .js-note .note-warning}

If the call is succesful, a JSON structure is returned, indicating whether the role was created or updated.

```json
{
  "status":"OK",
  "message":"role sg_role_starfleet created."
}
```