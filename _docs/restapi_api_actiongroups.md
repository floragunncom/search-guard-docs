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
Copryight 2018 floragunn GmbH
-->

# Action groups API

Used to receive, create, update and delete action groups.

Note: The `actiongroup` (singular) endpoint is deprecated in Search Guard 6 and will be removed with Search Guard 7.
{: .note .js-note .note-warning}

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
  "SEARCH" : [ "indices:data/read/search*", "indices:data/read/msearch*", "SUGGEST" ]
}
```

### Get all action groups

```
GET /_searchguard/api/actiongroups/
```


Returns all action groups in JSON format.

## Delete

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
  "permissions": ["indices:data/read/search*", "indices:data/read/msearch*", "SUGGEST" ]
}
```
The field permissions is mandatory and contains permissions or references to other action groups.

```json
{
  "status":"CREATED",
  "message":"action group SEARCH created"
}
```