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
  "kirk" : {
    "hash" : "$2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO",
    "roles" : [ "captains", "starfleet" ]
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