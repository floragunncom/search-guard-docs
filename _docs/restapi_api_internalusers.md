---
title: Internal users API
html_title: Internal users REST API endpoints
slug: rest-api-internalusers
category: restapi
order: 400
layout: docs
edition: enterprise
description: How to use the internal users REST API endpoints to manage users.
---
<!---
Copryight 2018 floragunn GmbH
-->

# Internal Users API

Used to receive, create, update and delete users. Users are added to the internal user database. It only makes sense to use this if you use `internal` as `authentication_backend`.

## Endpoint

```
/_searchguard/api/internalusers/{username}
```

Where `username` is the name of the user.

Note: The `user` endpoint is deprecated in Search Guard 6 and will be removed with Search Guard 7.
{: .note .js-note .note-warning}

## GET

### Get a single user

```
GET /_searchguard/api/internalusers/{username}
```
Returns the settings for the respective user in JSON format, for example:

```
GET /_searchguard/api/internalusers/kirk
```

```json
{
  "kirk": {
    "hash": "$2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO",
    "roles": [ "captains", "starfleet" ],
    "attributes": {
       "attribute1": "value1",
       "attribute2": "value2",       	
    }
  }
}
```

### Get all users

```
GET /_searchguard/api/internalusers/
```

Returns all users in JSON format.

## Delete

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

## PUT

```
PUT /_searchguard/api/internalusers/{username}
```

Replaces or creates the user specified by `username`.

```json
PUT /_searchguard/api/internalusers/kirk
{
  "hash": "$2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO",
  "password": "kirk",
  "roles": ["captains", "starfleet"],
   "attributes": {
     "attribute1": "value1",
     "attribute2": "value2",       	
   }
}
```

If `username` contains a dot you need to do

```json
PUT /_searchguard/api/internalusers/misterkirk
{
  "hash": "$2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO",
  "username": "mister.kirk",
  "password": "kirk",
  "roles": ["captains", "starfleet"],
   "attributes": {
     "attribute1": "value1",
     "attribute2": "value2",       	
   }
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

## PATCH

The PATCH endpoint can be used to change individual attributes of a user, or to create, change and delete users in a bulk call. The PATCH endpoint expects a payload in JSON Patch format. Search Guard supports the complete JSON patch specification.

[JSON patch specification: http://jsonpatch.com/](http://jsonpatch.com/){:target="_blank"}

The PATCH endpoint is only available for Elasticsearch 6.4.0 and above.
{: .note .js-note .note-warning}

### Patch a single user

```
PATCH /_searchguard/api/internalusers/{username}
```

Adds, deletes or changes one or more attributes of a user specified by `username`.

```json
PATCH /_searchguard/api/internalusers/kirk
[ 
  { 
    "op": "replace", "path": "/roles", "value": ["klingons"] 
  },
  { 
    "op": "replace", "path": "/attributes", "value": {"newattribute": "newvalue"} 
  }
]
```

### Bulk add, delete and change users

```json
PATCH /_searchguard/api/internalusers
[ 
  { 
    "op": "add", "path": "/spock", "value": { "password": "testpassword1", "roles": ["testrole1"] } 
  },
  { 
    "op": "add", "path": "/worf", "value": { "password": "testpassword2", "roles": ["testrole2"] } 
  },
  { 
    "op": "delete", "path": "/riker"
  }
]
```

## Password rules

In order to enforce password rules (e.g. mixed letters and digits, minimum length), you can configure a regular expression in `elasticsearch.yml`:

```
searchguard.restapi.password_validation_regex: "(?=.*[A-Z])(?=.*[^a-zA-Z\d])(?=.*[0-9])(?=.*[a-z]).{8,}"
```

The above regex expression, for example, will only permit passwords with a minimum length of eight characters and it must contain at least one upper case, one special char, one digit and one lower case char.

If the password does not match the configured regular expression, Search Guard will return:

```
{
	"status": "error",
	"reason": "<error message>"
} 
```

The error message should match your regular expression and tell the user what rules the password must meet. If you are using the Kibana config GUI, the error message will be displayed to the user. You can set the error message in `elasticsearch.yml`:

```
searchguard.restapi.password_validation_error_message: "Password must be at least 8 characters ..."
```
