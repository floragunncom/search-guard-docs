# REST management API

This module adds the capability of managing users, roles, roles mapping and action groups via a REST Api.

The management API is part of the enterprise features, thus it requires a license when used in production. The management API can be used with Search Guard from version 7 onwards (e.g. Search Guard 2.4.1.7).

**The API is in beta at the time of writing, so please report any bugs or missing features on our [github issue tracker](https://github.com/floragunncom/search-guard-rest-api/issues).**
 
## Prerequisites

The Search Guard index is specially secured, so that it can only be accessed with a valid admin certificate. This is the same certificate that you use when executing [sgadmin](sgadmin.md).

In order for Search Guard to pick up this certificate on the REST layer, you need to set the `clientauth_mode` in `elasticsearch.yml` to either `OPTIONAL` or `REQUIRED`:

```
searchguard.ssl.http.clientauth_mode: OPTIONAL
```

If you plan to use the REST API via a browser, you will need to install the admin certificate in your browser. This varies from browser to browser, so please refer to the documentation of your browser-of-choice to learn how to do so. 

For curl, you need to specify the admin certificate with it's complete certificate chain, and also the key:

```
curl --insecure --cert chain.pem --key kirk.key.pem "<API Endpoint>"
```

If you use the example PKI scripts provided by Search Guard SSL, the `kirk.key.pem` is already generated for you. You can generate the chain file by `cat`ing the certificate and the ca chain file:

```
cd search-guard-sll
cat example-pki-scripts/kirk.crt.pem example-pki-scripts/ca/chain-ca.pem > chain.pem
```

## General usage and return values

The API provides `GET`, `PUT` and `DELETE` handlers for users, roles, roles mapping and action groups. The general format is:

```
/_searchguard/api/<configuration type>/{resource name}
```

The `configuration type` specifies the configuration you want to operate on, and can be one of:

* internalusers
* rolesmapping
* roles
* actiongroups

The resource name specifies the entry in the `configuration type` you want to operat on. In case of the internal user database, it specifies a user. In case of roles, it specifies the role name, and so on.

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

The last three entries are returned if you `PUT` a new resource, but the content is malformed. `invalid_keys` is used when the content contains invalid keys, `missing_mandatory_keys` is used when a mandatory key is missing, and `specify_one_of` is used when the content is missing at least one of the specified keys.


## Get Configuration API

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

## User API

Used to receive, create, update and delete users. Users are added to the internal user database. This API only makes sense if you use `internal` as `authentication_backend`.

### Endpoint

```
/_searchguard/api/user/{username}
```
Where `username` is the name of the user.

### GET
```
GET /_searchguard/api/user/{username}
```
Returns the settings for the respective user in JSON format, for example:

```
GET /_searchguard/api/user/kirk
```
```
{
  "kirk" : {
    "hash" : "$2a$12$xZOcnwYPYQ3zIadnlQIJ0eNhX1ngwMkTN.oMwkKxoGvDVPn4/6XtO",
    "roles" : [ "captains", "starfleet" ]
  }
}
```  
### Delete

```
DELETE /_searchguard/api/user/{username}
```

Deletes the user specified by `username`. If successful, the call returns with status code 200 and a JSON success message.

```
DELETE /_searchguard/api/user/kirk
```
```
{
  "status":"OK",
  "message":"user kirk deleted."
}
```

### PUT

```
PUT /_searchguard/api/user/{username}
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
You need to specify either `hash` or `password`. `hash` contains the hashed password of the user. `password` contains the cleartext password, and is hashed automatically. If both are specified, `hash` takes precedence.

`roles` contains an array of the users backend roles. This is optional. If the call is succesful, a JSON structure is returned, indicating whether the user was created or updated.

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

```
GET /_searchguard/api/rolesmapping/{rolename}
```

Retrieve a rolemapping, specified by rolename, in JSON format.

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
  "message":"rolesmapping sg_role_starfleet created."
}
```		
		
## Action groups API				

Used to receive, create, update and delete action groups.
### Endpoint

```
/_searchguard/api/actiongroup/{actiongroup}
```
Where `actiongroup` is the name of the role.

### GET
```
GET /_searchguard/api/actiongroup/{actiongroup}
```
Returns the settings for the respective action group in JSON format, for example:

```
GET /_searchguard/api/actiongroup/SEARCH
```
```
{
  "SEARCH" : [ "indices:data/read/search*", "indices:data/read/msearch*", "SUGGEST" ]
}
```  
### Delete

```
DELETE /_searchguard/api/actiongroup/{actiongroup}
```

Deletes the action group specified by `actiongroup `. If successful, the call returns with status code 200 and a JSON success message.

```
DELETE /_searchguard/api/actiongroup/SEARCH
```
```
{
  "status":"OK",
  "message":"actiongroup SEARCH deleted."
}
```

### PUT

```
PUT /_searchguard/api/user/{username}
```

Replaces or creates the user specified by `username`.

```
PUT /_searchguard/api/user/{username}
{
  "hash": <password hash>,
  "password": <cleartext password>,
  "roles": ["role1", "role2]
}
```
You need to specify either `hash` or `password`. `hash` contains the hashed password of the user. `password` contains the cleartext password, and it is hashed internally. If both are specified, `hash` takes precedence.

`roles` contains an array of the users backend roles. This is optional. If the call is succesful, a JSON structure is returned, indicating whether the user was created or updated.

```
{
  "status":"CREATED",
  "message":"User spock created"
}
```