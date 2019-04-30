---
title: Action groups API
html_title: Action groups REST API endpoints
slug: rest-api-actiongroups
category: restapi
order: 440
layout: docs
edition: enterprise
description: How to use the action groups REST API endpoints to create, edit and delte Search Guard action groups.
---
<!---
Copyright 2019 floragunn GmbH
-->

# Action groups API
{: .no_toc}

{% include toc.md %}

Used to receive, create, update and delete action groups.

## Endpoint

```
/_searchguard/api/actiongroups/{actiongroup}
```
Where `actiongroup` is the name of the role.

## GET

### Get a single action group

```
GET /_searchguard/api/actiongroups/{actiongroup}
```
Returns the settings for the respective action group in JSON format, for example:

```
GET /_searchguard/api/actiongroups/SEARCH
```
```json
{
  "allowed_actions" : [ "indices:data/read/search*", "indices:data/read/msearch*", "SUGGEST" ]
}
```

### Get all action groups

```
GET /_searchguard/api/actiongroups/
```

Returns all action groups in JSON format.

## DELETE

```
DELETE /_searchguard/api/actiongroups/{actiongroup}
```

Deletes the action group specified by `actiongroup `. If successful, the call returns with status code 200 and a JSON success message.

```
DELETE /_searchguard/api/actiongroups/SEARCH
```
```json
{
  "status":"OK",
  "message":"actiongroup SEARCH deleted."
}
```

## PUT

```
PUT /_searchguard/api/actiongroups/{actiongroup}
```

Replaces or creates the action group specified by `actiongroup `.

```
PUT /_searchguard/api/actiongroups/SEARCH
{
  "allowed_actions": ["indices:data/read/search*", "indices:data/read/msearch*", "SUGGEST" ]
}
```
The field `allowed_actions` is mandatory and contains permissions or references to other action groups.

```json
{
  "status":"CREATED",
  "message":"action group SEARCH created"
}
```

## PATCH

The PATCH endpoint can be used to change individual attributes of an action group, or to create, change and delete action groups in a bulk call. The PATCH endpoint expects a payload in JSON Patch format. Search Guard supports the complete JSON patch specification.

[JSON patch specification: http://jsonpatch.com/](http://jsonpatch.com/){:target="_blank"}

### Patch an action group

```
PATCH /_searchguard/api/actiongroups/{actiongroup}
```

Adds, deletes or changes one or more attributes of a user specified by `actiongroup `.

```json
PATCH /_searchguard/api/actiongroups/CREATE_INDEX
[ 
  { 
    "op": "replace", "path": "/allowed_actions", "value": ["indices:admin/create", "indices:admin/mapping/put"] 
  }
]
```

### Bulk add, delete and change action groups

```json
PATCH /_searchguard/api/actiongroups
[ 
  { 
    "op": "add", "path": "/CREATE_INDEX/allowed_actions", "value": ["indices:admin/create", "indices:admin/mapping/put"] 
  },
  { 
    "op": "remove", "path": "/CRUD"
  }
]
```

