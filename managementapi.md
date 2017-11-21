<!---
Copryight 2016 floragunn GmbH
-->

# REST management API

This module adds the capability of managing users, roles, roles mapping and action groups via a REST Api. It is required if you plan to use the Kibana config GUI.

## Access control

Since the REST management API makes it possible to change users, roles and permissions, access to this functionality is restricted by Search Guard. Access is granted either by a user's role or by providing an admin certificate.

## Role-based access control

All roles that should have access to the API must be configured in `elasticsearch.yml` with the following key:

```
searchguard.restapi.roles_enabled: ["sg_all_access", ...]
```

This will grant full access permission to the REST API for all users that have the Search Guard role `sg_all_access`.

You can further limit access to certain API endpoints and methods on a per role basis. For example, you can give a user permission to retrieve role information, but not to change or delete it.

The structure of the respective configuration is:
```
searchguard.restapi.endpoints_disabled.<role>.<endpoint>: ["<method>",...]
```

For example:

```
searchguard.restapi.endpoints_disabled.sg_all_access.ROLES: ["PUT", "POST", "DELETE"]
```

Possible values for endpoint are:

```
ACTIONGROUPS
ROLES
ROLESMAPPING
INTERNALUSERS
SGCONFIG
CACHE
LICENSE
SYSTEMINFO
```

Possible values for then method are:

```
GET
PUT
POST
DELETE
```

## Admin certicate access control

Access can also be granted by using an admin certificate. This is the same certificate that you use when executing [sgadmin](sgadmin.md).

In order for Search Guard to pick up this certificate on the REST layer, you need to set the `clientauth_mode` in `elasticsearch.yml` to either `OPTIONAL` or `REQUIRE`:

```
searchguard.ssl.http.clientauth_mode: OPTIONAL
```

For curl, you need to specify the admin certificate with it's complete certificate chain, and also the key:

```
curl --insecure --cert chain.pem --key kirk.key.pem "<API Endpoint>"
```

If you use the example PKI scripts provided by Search Guard SSL, the `kirk.key.pem` is already generated for you. You can generate the chain file by `cat`ing the certificate and the ca chain file:

```
cd search-guard-sll
cat example-pki-scripts/kirk.crt.pem example-pki-scripts/ca/chain-ca.pem > chain.pem
```

## Reserved resources

You can mark any user, role, action group or roles mapping as `readonly` in their respective configuration files. Resources that have this flag set to true can not be changed via the REST API and are marked as `reserved` in the Kibana Configuration GUI.

You can use this feature to give users or customers permission to add and edit their own users and roles, while making sure your own built-in resources are left untouched. For example, it makes sense to mark the Kibana server user as `readonly`.

To mark a resource `readonly`, add the following flag:

```
sg_kibana_user:
  readonly: true
  ...
```

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

```
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

### GET

#### Get a single user

```
GET /_searchguard/api/internalusers/{username}
```
Returns the settings for the respective user in JSON format, for example:

```
GET /_searchguard/api/internalusers/kirk
```
```
{
  "kirk" : {
    "hash" : "$2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO",
    "roles" : [ "captains", "starfleet" ]
  }
}
```

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
```
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

```
PUT /_searchguard/api/user/kirk
{
  "hash": "$2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO",
  "password": "kirk",
  "roles": ["captains", "starfleet"]
}
```

You need to specify either `hash` or `password`. `hash` is the hashed user password. You can either use an already hashed password (“hash” field) or provide it in clear text (“password”). (We never store clear text passwords.) In the latter case it is hashed automatically before storing it. If both are specified,`hash` takes precedence.

`roles` contains an array of the user's backend roles. This is optional. If the call is succesful, a JSON structure is returned, indicating whether the user was created or updated.

```
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
```
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
```
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

```
PUT /_searchguard/api/rolesmapping/sg_role_starfleet
{
  "backendroles" : [ "starfleet", "captains", "defectors", "cn=ldaprole,ou=groups,dc=example,dc=com" ],
  "hosts" : [ "*.starfleetintranet.com" ],
  "users" : [ "worf" ]
}
```

You need to specify at least one of `backendroles`, `hosts` or `users`.

If the call is succesful, a JSON structure is returned, indicating whether the roles mapping was created or updated.

```
{
  "status":"OK",
  "message":"rolesmapping sg_role_starfleet created."
}
```

## Roles API

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
```
{
  "sg_role_starfleet" : {
    "indices" : {
      "pub*" : {
        "*" : [ "READ" ]
      },
      "sf" : {
        "alumni" : [ "READ" ],
        "students" : [ "READ" ],
        "ships" : [ "READ" ],
        "public" : [ "indices:*" ]
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
```
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

```
PUT /_searchguard/api/rolesmapping/sg_role_starfleet
{
  "cluster" : [ "*" ],
  "indices" : {
    "pub*" : {
      "*" : [ "READ" ]
    },
    "sf" : {
      "alumni" : [ "READ" ],
      "students" : [ "READ" ],
      "ships" : [ "READ" ],
      "public" : [ "indices:*" ]
    }
  }  
}
```

The JSON format resembles the format used in `sg_roles.yml`:

```
{
  "cluster" : [ "<cluster permission>", "<cluster permission>", ... ],
  "indices" : {
    "<indexname>" : {
      "<typename>" : [ "<index/type permission>", "<index/type permission>", ... ],
      "<typename>" : [ "<index/type permission>", "<index/type permission>", ... ]
    },
    "<indexname>" : {
      "<typename>" : [ "<index/type permission>", "<index/type permission>", ... ],
      "<typename>" : [ "<index/type permission>", "<index/type permission>", ... ],
    }
  }
}
```

If the call is succesful, a JSON structure is returned, indicating whether the role was created or updated.

```
{
  "status":"OK",
  "message":"role sg_role_starfleet created."
}
```

## Action groups API

Used to receive, create, update and delete action groups.

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
```
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
```
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

```
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

```
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

```
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

```
  "sg_role_starfleet" : {
    "backendroles" : [ "starfleet", "captains", "cn=ldaprole,ou=groups,dc=example,dc=com" ],
    "hosts" : [ "*.starfleetintranet.com" ],
    "users" : [ "worf" ]
  }
```
