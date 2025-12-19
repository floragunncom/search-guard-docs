---
title: Blocks API
html_title: Blocks API
permalink: rest-api-blocks
layout: docs
section: security
edition: enterprise
description: How to use the Blocks REST API endpoints to create, edit and delete Search
  Guard blocks.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Blocks API
{: .no_toc}

{% include toc.md %}

Used to receive, create, update and delete blocks, i.e. blocking users / IP addresses.

## Endpoint

```
/_searchguard/api/blocks/{name}
```

Scheme of a block definition:
```json
{
  "<block_name>" : {
    "type" : <"ip" | "name" | "net_mask">
    "value" : "8.8.8.8" | "john doe" | "127.0.0.0/8",
    "verdict" : "allow | disallow"
    "description" : "A simple block"
  }
}
```

Note that it's possible to use regular expressions and wildcard for a user name, e.g. "value: * Doe".

## GET

### Get a single block

```
GET /_searchguard/api/blocks/{name}
```
Returns the settings for the respective block in JSON format, for example:

```
GET /_searchguard/api/blocks/some_block
```
```json
{
  "block" : {
    "type" : "ip",
    "value" : "8.8.8.8",
    "description" : "A simple IP block"
  }
}
```

### Get all blocks

```
GET /_searchguard/api/blocks/
```

Returns all blocks in JSON format.

## DELETE

```
DELETE /_searchguard/api/blocks/{name}
```

Deletes the block specified by `name `. If successful, the call returns with status code 200 and a JSON success message.

```
DELETE /_searchguard/api/blocks/some_block
```
```json
{
  "status":"OK",
  "message":"some_block deleted."
}
```

## PUT

```
PUT /_searchguard/api/blocks/{name}
```

Replaces or creates the block specified by `name `.

```
PUT /_searchguard/api/blocks/some_block
{
  "description": "Some block."
}
```

```json
{
  "status":"CREATED",
  "message":"Block some_block created"
}
```

## PATCH

The PATCH endpoint can be used to change individual attributes of a block, or to create, change and delete blocks in a bulk call. The PATCH endpoint expects a payload in JSON Patch format. Search Guard supports the complete JSON patch specification.

[JSON patch specification: http://jsonpatch.com/](http://jsonpatch.com/){:target="_blank"}

### Example: Patch a block

```
PATCH /_searchguard/api/blocks/{name}
```

Adds, deletes or changes one or more attributes of a block specified by `name`.

```json
PATCH /_searchguard/api/blocks/some_block
[ 
  { 
    "op": "replace", "path": "/description", "value": "An updated description"
  }
]
```

### Example: Bulk add, delete and change blocks

```json
PATCH /_searchguard/api/blocks
[ 
  { 
    "op": "replace", "path": "/some_block/description", "value": "An updated description" 
  },
  { 
    "op": "remove", "path": "/another_block"
  }
]
```

For more examples, please refer to [JSON patch format documentation](http://jsonpatch.com/).
