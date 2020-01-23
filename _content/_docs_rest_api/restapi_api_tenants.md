---
title: Tenants API
html_title: Tenants API
slug: rest-api-tenants
category: restapi
order: 460
layout: docs
edition: enterprise
description: How to use the tenants REST API endpoints to create, edit and delete Search Guard tenants.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Tenants API
{: .no_toc}

{% include toc.md %}

Used to receive, create, update and delete tenants.

## Endpoint

```
/_searchguard/api/tenants/{tenantname}
```
Where `tenantname` is the name of the tenant.

## GET

### Get a single tenant

```
GET /_searchguard/api/tenant/{tenantma,e}
```
Returns the settings for the respective tenant in JSON format, for example:

```
GET /_searchguard/api/tenants/human_resources
```
```json
{
  "human_resources" : {
    "reserved" : false,
    "hidden" : false,
    "static" : false,
    "description" : "The human resources tenant"
  }
}
```

### Get all tenants

```
GET /_searchguard/api/tenants/
```

Returns all tenants in JSON format.

## DELETE

```
DELETE /_searchguard/api/tenants/{tenantname}
```

Deletes the tenant specified by `tenantname `. If successful, the call returns with status code 200 and a JSON success message.

```
DELETE /_searchguard/api/tenants/human_resources
```
```json
{
  "status":"OK",
  "message":"tenant human_resources deleted."
}
```

## PUT

```
PUT /_searchguard/api/tenants/{tenantname}
```

Replaces or creates the tenant specified by `tenantname `.

```
PUT /_searchguard/api/tenants/human_resources
{
  "description": "The human resources tenant."
}
```

```json
{
  "status":"CREATED",
  "message":"tenant human_resources created"
}
```

## PATCH

The PATCH endpoint can be used to change individual attributes of a tenant, or to create, change and delete tenants in a bulk call. The PATCH endpoint expects a payload in JSON Patch format. Search Guard supports the complete JSON patch specification.

[JSON patch specification: http://jsonpatch.com/](http://jsonpatch.com/){:target="_blank"}

### Patch a tenant

```
PATCH /_searchguard/api/tenants/{tenantname}
```

Adds, deletes or changes one or more attributes of a tenant specified by `tenantname`.

```json
PATCH /_searchguard/api/tenants/human_resources
[ 
  { 
    "op": "replace", "path": "/description", "value": "An updated description"
  }
]
```

### Bulk add, delete and change tenants

```json
PATCH /_searchguard/api/tenants
[ 
  { 
    "op": "replace", "path": "/human_resources/description", "value": "An updated description" 
  },
  { 
    "op": "remove", "path": "/another_tenant"
  }
]
```

