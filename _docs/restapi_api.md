---
title: Endpoints
html_title: REST API Endpoints
slug: rest-api
category: restapi
order: 300
layout: docs
edition: enterprise
description: Use the Search Guard REST management API to change your configuration with simple HTTP REST calls.
---
<!---
Copryight 2017 floragunn GmbH
-->

## General usage and return values

The API provides `GET`, `PUT` and `DELETE` handlers for users, roles, roles mapping and action groups. The general format is:

```
/_searchguard/api/<configuration type>/{resource name}
```

The `configuration type` can be one of:

* internalusers
* rolesmapping
* roles
* actiongroups

The resource name specifies the entry in the `configuration type` you want to operate on. In case of the internal user database, it specifies a user. In case of roles, it specifies the role name, and so on.

The API returns the following HTTP status codes:

* 200: A resource was modified succesfully
* 201: A resource was created
* 400: The request could not be processed
* 404: The resource could not be found

The response body has the format:

```json
{
  "status":<HTTP status code>,
  "message":<message>
  "invalid_keys":
  "missing_mandatory_keys"
  "specify_one_of:"
}
```

The last three entries are returned if you `PUT` a new resource but the content is malformed. `invalid_keys` is used when the content contains invalid keys. `missing_mandatory_keys` is used when a mandatory key is missing. And `specify_one_of` is used when the content is missing a key.


## Internal Users API

Used to receive, create, update and delete users. Users are added to the internal user database. It only makes sense to use this if you use `internal` as the `authentication_backend`.

### Endpoint

```
/_searchguard/api/internalusers/{username}
```

Where `username` is the name of the user.

**Note: The `user` endpoint is deprecated in Search Guard 6 and will be removed with Search Guard 7**

### GET

#### Get a single user

```
GET /_searchguard/api/internalusers/{username}
```
Returns the settings for the respective user in JSON format, for example:

```
GET /_searchguard/api/internalusers/kirk
```

<div class="code-highlight" data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span>
<pre class="language-markup">
<code class="js-code language-json">
{
  "kirk" : {
    "hash" : "$2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO",
    "roles" : [ "captains", "starfleet" ]
  }
}
</code>
</pre>
</div>

#### Get all users

```
GET /_searchguard/api/internalusers/
```

Returns all users in JSON format.

### Delete

```
DELETE /_searchguard/api/internalusers/{username}
```

Deletes the user specified by `username`. If successful, the call returns with status code 200 and a JSON success message.

```
DELETE /_searchguard/api/internalusers/kirk
```

```json
{
  "status":"OK",
  "message":"user kirk deleted."
}
```

### PUT

```
PUT /_searchguard/api/internalusers/{username}
```

Replaces or creates the user specified by `username`.

```json
PUT /_searchguard/api/user/kirk
{
  "hash": "$2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO",
  "password": "kirk",
  "roles": ["captains", "starfleet"]
}
```

You need to specify either `hash` or `password`. `hash` is the hashed user password. You can either use an already hashed password ("hash" field) or provide it in clear text ("password"). (We never store clear text passwords.) In the latter case it is hashed automatically before storing it. If both are specified,`hash` takes precedence.

`roles` contains an array of the user's backend roles. This is optional. If the call is succesful, a JSON structure is returned, indicating whether the user was created or updated.

```json
{
  "status":"CREATED",
  "message":"User kirk created"
}
```

## Roles mapping API

Used to receive, create, update and delete the mapping of users, backendroles and hosts to Search Guard roles.

### Endpoint

```
/_searchguard/api/rolesmapping/{rolename}
```
Where `rolename` is the name of the role.

### GET

#### Get a single role mapping

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

#### Get all role mappings

```
GET /_searchguard/api/rolesmapping/{rolename}
```

Returns all role mappings in JSON format.

### DELETE
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

### PUT
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

## Roles and Tenants API

Used to receive, create, update and delete roles and their respective permissions.

### Endpoint

```
/_searchguard/api/roles/{rolename}
```
Where `rolename` is the name of the role.

### GET

#### Get a single role

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
        "*" : [ "READ" ]
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

#### Get all roles

```
GET /_searchguard/api/roles/{rolename}
```

Returns all roles in JSON format.

### DELETE
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

### PUT
```
PUT /_searchguard/api/roles/{rolename}
```
Replaces or creates the role specified by `rolename `.

```json
PUT /_searchguard/api/rolesmapping/sg_role_starfleet
{
  "cluster" : [ "*" ],
  "indices" : {
    "pub*" : {
      "*" : [ "READ" ],
      _dls_: "{ \"bool\": { \"must_not\": { \"match\": { \"Designation\": \"CEO\"}}}}"
      _fls_: ["field1", "field2"]
    },
    "tenants": {
      tenant1: RW,
      tenant2: RO
    }    
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
      "_dls_": "<DLS query>"
      "_fls_": ["field", "field"]
    },
    "<indexname>" : {
      "<typename>" : [ "<index/type permission>", "<index/type permission>", ... ],
    },
    "tenants": {
      <tenantname> : <RW | RO>,
      <tenantname> : <RW | RO>,
      ...
    }    
  }
}
```

**If you're using DLS in the role definition, make sure to escape the quotes correctly!**

If the call is succesful, a JSON structure is returned, indicating whether the role was created or updated.

```json
{
  "status":"OK",
  "message":"role sg_role_starfleet created."
}
```

## Action groups API

Used to receive, create, update and delete action groups.

**Note: The `actiongroup` (singular) endpoint is deprecated in Search Guard 6 and will be removed with Search Guard 7**

### Endpoint

```
/_searchguard/api/actiongroups/{actiongroup}
```
Where `actiongroup` is the name of the role.

### GET

#### Get a single action group

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

#### Get all action groups

```
GET /_searchguard/api/actiongroups/
```


Returns all action groups in JSON format.

### Delete

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

### PUT

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

## Authentication and Authorization API

Used to retrieve the configured authentication and authorization modules.

### Endpoint

```
/_searchguard/api/sgconfig
```

### GET

```
GET /_searchguard/api/sgconfig
```

Returns the configured authentication and authorization modules in JSON format.

## License API

Used to retrieve and update the Search Guard license.

### Endpoint

```
/_searchguard/api/license/
```

### GET

```
GET /_searchguard/api/license/
```
Returns the currently installed license in JSON format. 

### PUT

```
PUT /_searchguard/api/license/
```

Validates and replaces the currently active Search Guard license. Invalid (e.g. expired) licensens are rejected.

```json
PUT /_searchguard/api/license/
{ 
  "sg_license": <licensestring>
}
```

## Cache API

Used to manage the Search Guard internal user, authentication and authorization cache.

### Endpoint

```
/_searchguard/api/cache
```

### Delete

```
DELETE /_searchguard/api/cache
```

Flushes the Search Guard cache.

```json
{
  "status":"OK",
  "message":"Cache flushed successfully."
}
```

## DEPRECATED: Get Configuration API

This endpoint is deprecated and will be removed in future Search Guard versions. Instead, use the GET endpoint without a resource name on each API endpoint separately.

### Endpoint
```
/_searchguard/api/configuration/{configname}
```
Where `configname` can be one of

* config
* internalusers
* rolesmapping
* roles
* actiongroups

### GET

```
GET /_searchguard/api/configuration/{configname}
```
A successful call returns a JSON structure containing the complete settings for the requested configuration, for example: 

```json
  "sg_role_starfleet" : {
    "backendroles" : [ "starfleet", "captains", "cn=ldaprole,ou=groups,dc=example,dc=com" ],
    "hosts" : [ "*.starfleetintranet.com" ],
    "users" : [ "worf" ]
  }
```
