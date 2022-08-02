---
title: Internal users API
html_title: Users API
permalink: rest-api-internalusers
category: restapi
order: 400
layout: docs
edition: enterprise
description: How to use the users REST API endpoints to create, update and delete Search Guard users.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Internal Users API
{: .no_toc}

{% include toc.md %}

Used to receive, create, update and delete users. Users are added to the internal user database. It only makes sense to use this if you use `internal` as `authentication_backend`.

## Endpoint

```
/_searchguard/api/internalusers/{username}
```

Where `username` is the name of the user.

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
    "description": "The captain.",
    "hash": "",
    "backend_roles": [ "captains", "starfleet" ],
    "attributes": {
       "attribute1": "value1",
       "attribute2": "value2"   	
    }
  }
}
```

The password hash is not returned by this API endpoint.
{: .note .js-note}

### Get all users

```
GET /_searchguard/api/internalusers/
```

Returns all users in JSON format.

## DELETE

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
  "hash": "$2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO", OR
  "password": "kirk",
  "backend_roles": ["captains", "starfleet"],
   "attributes": {
     "attribute1": "value1",
     "attribute2": "value2",       	
   }
}
```


You need to specify either `hash` or `password`. 
{: .note .js-note}

You can either use an already hashed password (`hash field`) or provide it in clear text (`password` field). In the latter case the password hashed automatically before storing it. If both fields are specified, `hash` takes precedence.

`backend_roles` contains an array of the user's backend roles. This is optional. If the call is successful, a JSON structure is returned, indicating whether the user was created or updated.

```json
{
  "status":"CREATED",
  "message":"User kirk created"
}
```

## PATCH

The PATCH endpoint can be used to change individual attributes of a user, or to create, change and delete users in a bulk call. The PATCH endpoint expects a payload in JSON Patch format. Search Guard supports the complete JSON patch specification.

[JSON patch specification: http://jsonpatch.com/](http://jsonpatch.com/){:target="_blank"}

### Patch a single user

```
PATCH /_searchguard/api/internalusers/{username}
```

Adds, deletes or changes one or more attributes of a user specified by `username`.

```json
PATCH /_searchguard/api/internalusers/kirk
[ 
  { 
    "op": "replace", "path": "/backend_roles", "value": ["klingons"] 
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
    "op": "add", "path": "/spock", "value": { "password": "testpassword1", "backend_roles": ["testrole1"] } 
  },
  { 
    "op": "add", "path": "/worf", "value": { "password": "testpassword2", "backend_roles": ["testrole2"] } 
  },
  { 
    "op": "remove", "path": "/riker"
  }
]
```

## Changing the internal user password

The password of internal users can easily be updated either via the Kibana dashboard in `Home -> Internal Users -> Update User` or via REST

```
PUT /_searchguard/api/internalusers/<user name>
{
  "password": "<new password>"
}
```

Please note that the password is immediately changed and you might need to update your `Basic Authorization` header (username:password) in subsequent requests.

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
