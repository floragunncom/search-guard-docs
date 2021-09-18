---
title: Roles API
html_title: Roles API
permalink: rest-api-roles
category: restapi
order: 410
layout: docs
edition: enterprise
description: How to use the roles REST API endpoints to manage roles and permissions.
---

<!---
Copyright 2020 floragunn GmbH
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
GET /_searchguard/api/roles/sg_human_resources_trainee
```
```json

{  
  "sg_human_resources_trainee" : {
    "reserved" : false,
    "hidden" : false,
    "static" : false,
    "cluster_permissions" : [
      "SGS_CLUSTER_COMPOSITE_OPS_RO"
    ],
    "index_permissions" : [
      {
        "index_patterns" : [
          "humanresources"
        ],
        "dls" : "{ \"bool\": { \"must_not\": { \"match\": { \"Designation\": \"CEO\"  }}}}",
        "fls" : [
          "Designation",
          "FirstName",
          "LastName",
          "Salary"
        ],
        "masked_fields" : [ ],
        "allowed_actions" : [
          "SGS_READ"
        ]
      }
    ],
    "tenant_permissions" : [
      {
        "tenant_patterns" : [
          "human_resources"
        ],
        "allowed_actions" : [
          "SGS_KIBANA_ALL_WRITE"
        ]
      }
    ]    
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
DELETE /_searchguard/api/roles/sg_human_resources_trainee
```
```json
{
  "status":"OK",
  "message":"role sg_human_resources_trainee deleted."
}
```

## PUT
```
PUT /_searchguard/api/roles/{rolename}
```
Replaces or creates the role specified by `rolename`.

The JSON format resembles the format used in `sg_roles.yml`:

```json
{  
  "cluster_permissions" : [ "...", "..."],
  "index_permissions" : [
    {
      "index_patterns" : [ "...", "..." ],
      "dls" : "{ \"bool\": { \"must_not\": { \"match\": { \"Designation\": \"CEO\"  }}}}",
      "fls" : [ "...", "..." ],
      "masked_fields" : ["...", "..." ],
      "allowed_actions" : [ "...", "..." ]
    }
  ],
  "tenant_permissions" : [
    {
      "tenant_patterns" : [ "...", "..." ],
      "allowed_actions" : [ "...", "..." ]
    }
  ]    
}
```

Example:

```
PUT /_searchguard/api/roles/sg_human_resources_trainee
```
```json
{  
  "cluster_permissions" : [
    "SGS_CLUSTER_COMPOSITE_OPS_RO"
  ],
  "index_permissions" : [
    {
      "index_patterns" : [
        "humanresources"
      ],
      "dls" : "{ \"bool\": { \"must_not\": { \"match\": { \"Designation\": \"CEO\"  }}}}",
      "fls" : [
        "Designation",
        "FirstName",
        "LastName",
        "Salary"
      ],
      "masked_fields" : [ ],
      "allowed_actions" : [
        "SGS_READ"
      ]
    }
  ],
  "tenant_permissions" : [
    {
      "tenant_patterns" : [
        "human_resources"
      ],
      "allowed_actions" : [
        "SGS_KIBANA_ALL_WRITE"
      ]
    }
  ]    
}
```

If you're using DLS in the role definition, make sure to escape the quotes correctly!
{: .note .js-note .note-warning}

If the call is succesful, a JSON structure is returned, indicating whether the role was created or updated.

```json
{
  "status":"OK",
  "message":"role sg_human_resources_trainee created."
}
```

## PATCH

The PATCH endpoint can be used to change individual attributes of a rolw, or to create, change and delete roles in a bulk call. The PATCH endpoint expects a payload in JSON Patch format. Search Guard supports the complete JSON patch specification.

[JSON patch specification: http://jsonpatch.com/](http://jsonpatch.com/){:target="_blank"}

### Patch a single role

```
PATCH /_searchguard/api/roles/{rolename}
```

Adds, deletes or changes one or more attributes of a role specified by `rolename`.

```json
PATCH /_searchguard/api/roles/starfleet
[ 
  { 
    "op": "replace", "path": "/index_permissions[0]/fls", "value": ["field1"] 
  }, 
  { 
    "op": "remove", "path": "/index_permissions[0]/dls" 
  }   
]
```

### Bulk add, delete and change users

```json
PATCH /_searchguard/api/roles
[ 
  { 
    "op": "add", "path": "/klingons",  "value": { "index_permissions": [...] } 
  },
  { 
    "op": "add", "path": "/romulans",  "value": { "index_permissions": [...] }
  }
]
```