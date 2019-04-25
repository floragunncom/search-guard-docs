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
Copyright 2019 floragunn GmbH
-->


# Roles and Tenants API
{: .no_toc}

{% include toc.md %}

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

## PATCH

The PATCH endpoint can be used to change individual attributes of a rolw, or to create, change and delete roles in a bulk call. The PATCH endpoint expects a payload in JSON Patch format. Search Guard supports the complete JSON patch specification.

[JSON patch specification: http://jsonpatch.com/](http://jsonpatch.com/){:target="_blank"}


The PATCH endpoint is only available for Elasticsearch 6.4.0 and above.
{: .note .js-note .note-warning}

### Patch a single role

```
PATCH /_searchguard/api/roles/{rolename}
```

Adds, deletes or changes one or more attributes of a role specified by `rolename`.

```json
PATCH /_searchguard/api/roles/starfleet
[ 
  { 
    "op": "replace", "path": "/indices/public/_fls_", "value": ["field1"] 
  }, 
  { 
    "op": "remove", "path": "/indices/public/_dls_" 
  }   
]
```

### Bulk add, delete and change users

```json
PATCH /_searchguard/api/roles
[ 
  { 
    "op": "add", "path": "/klingons",  "value": { "indices" : { "klingonindex" : { "*" : [ "READ" ] }  } } 
  },
  { 
    "op": "add", "path": "/romulans",  "value": { "indices" : { "romulansindex" : { "*" : [ "READ" ] }  } } 
  }
]
```