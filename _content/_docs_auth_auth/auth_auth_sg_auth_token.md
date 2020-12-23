---
title: Search Guard Auth Tokens
slug: search-guard-auth-tokens
category: authauth
order: 11000
layout: docs
edition: beta
description: Creating API auth tokens for accessing Elasticsearch using Search Guard

---
<!---
Copyright 2020 floragunn GmbH
-->

# Creating API Auth Tokens with Search Guard
{: .no_toc}

{% include toc.md %}

The auth token feature is so far only available in the special beta release. It is not available in the normal Search Guard 47.0.0 release. See [here](../_docs_versions/versions_versionmatrix.md) for the download.<br><br>The auth token feature will be Search Guard Enterprise feature. You will need a license to use it after the trial period.
{: .note .js-note .note-warning}

Search Guard provides a built-in functionality to create and manage API auth tokens that can be used to access Elasticsearch.

Such an auth token is always associated with the user that has created it. The auth token inherits the privileges of the user and freezes them. Thus, even if the user later gains or loses privileges, the privileges available to a token remain unchanged. 

When creating auth tokens, it is possible to limit the privileges available to the token to a subset of the user's privileges. Also, it is possible to limit the lifetime of an auth token. 

Additionally, tokens can be revoked. A revoked token won't be accepted by Search Guard anymore, even though its expiry time has not been reached yet. Management and revocation of auth tokens are available to the users who created the tokens. Furthermore, administrators with special privileges can manage and revoke auth tokens of any user.

Auth tokens issued by Search Guard are based on the JSON Web Token (JWT) standard and are cryptographically signed. However, in order to allow management and revocation of tokens, Search Guard also keeps an internal list of issued auth tokens. In addition to verifying the JWT signature, Search Guard also uses this internal list to ensure that a token has not been revoked yet. 

## Configuring the Search Guard Auth Token Service

The built-in auth token functionality is disabled by default. It can be enabled by editing the `sg_config.yml` configuration file. You need to modify the `auth_token_provider` section, set `enabled` to true and configure a key used for JWT signing. Additionally, an authentication domain for SG auth tokens needs to be enabled.

```yaml
sg_config:
  dynamic:
      [...]
      auth_token_provider:
        enabled: true
        jwt_signing_key_hs512: "..."
        jwt_encryption_key_a256kw: "..."   # Omit this to have unencrypted keys
        max_validity: "1y"                 # Omit this to have keys with unlimited lifetime
        max_tokens_per_user: 100    
      authc:
		 [...]
        sg_issued_jwt_auth_domain:
          description: "Authenticate via Json Web Tokens issued by Search Guard"
          http_enabled: true
          transport_enabled: false
          order: 0
          http_authenticator:
            type: sg_auth_token
            challenge: false
          authentication_backend:
            type: sg_auth_token            
```

### Configuring Keys

When using the `jwt_signing_key_hs512` and `jwt_encryption_key_a256kw` configuration keys, the generated JWKs will be signed using a HMAC 512 hash and AES 256 encryption. Thus, the value for `jwt_signing_key_hs512` must be a random value with 512 bits in Base64URL encoding. Likewise, the value for `jwt_encryption_key_a256kw` must be a random value with 256 bits in Base64URL encoding. 

In a shell, you can generate such values using the command `openssl rand -base64 <bytes> | tr '/+' '_-'`. Replace `<bytes>` by the desired byte length. 

To generate 512 bit keys use:

```
openssl rand -base64 64 | tr '/+' '_-'
```

To generate 256 bit keys use:

```
openssl rand -base64 32 | tr '/+' '_-'
```

In order to use other signature or encryption methods available for JWTs, you can use the options `jwt_signing_key` and `jwt_encryption_key` to specify the complete key configuration using the [JSON Web Key](https://tools.ietf.org/html/rfc7517) (JWK) standard. For example, you can use Elliptic Curve based signatures like this:

```yaml
sg_config:
  dynamic:
      [...]
      auth_token_provider:
        enabled: true
        jwt_signing_key:
        	kty: EC
        	alg: ES256
        	crv: P-256
        	use: sig
        	d: "..."
        	x: "..."
        	y: "..."
```

### Other Configuration Options

**enabled:** Specify `true` here to activate the auth token service. If the value is false or omitted, no new tokens can be created and authentication using auth tokens won't work.

**max_validity:** Specify a time period here in order to limit the time an auth token will be valid. If you omit this value, auth tokens with an unlimited validity time are allowed. Note that users can always specify a *shorter* validity time period when creating auth tokens. The format of this setting is a number followed by `y` for year, `M` (upper case) for months, `d` for days.

**max_tokens_per_user:** This setting limits the number of valid tokens a user can have at the same time. For performance reasons, Search Guard keeps all auth tokens in heap. Thus, it is not possible to have an arbitrarily large number of auth tokens. This settings defaults to 100. 

**exclude_cluster_permissions:** You can specify cluster permissions here, which an auth token may never grant. This option defaults to `cluster:admin:searchguard:authtoken/_own/create`, which means that auth tokens cannot grant the permission to create new auth tokens. The format of this option is a list of action names; like in [role definitions](../_docs_roles_permissions/configuration_roles_permissions.md), wildcards are supported as well. 

**exclude_index_permissions:** You can specify index permissions here, which an auth token may never grant. This option is empty by default. The format of this option is identical to the `exclude_index_permissions` setting in  in [role definitions](../_docs_roles_permissions/configuration_roles_permissions.md).

**freeze_privileges:** This option controls how users can use the `freeze_privileges` attribute in create auth token request bodies. This defaults to `user_chooses` which allows users to choose whether they want to create a config snapshot or not. If you specify `always`, all auth token creation requests will create a snapshot the role configuration; the user won't be able to choose. If you specify `never`, no auth token creation requests will create such a snapshot. Note that changes to this config option won't affect auth tokens which have been already created.


### Authentication Domain

In addition to the `auth_token_provider` config, you have to configure a separate [authentication domain](../_docs_auth_auth/auth_auth_configuration.md#authentication) in the `authc` section.

Not much needs to be configured there, though. The `order` attribute should be chosen in a way that this authentication domain is checked before any domain which sends authentication challenges. For example, if you have Basic Auth sending challenges at `order` 1, you should have the auth token domain at `order` 0. Otherwise, the configuration must stay the same as shown above. The keys for verifying the JWTs are automatically obtained from the `auth_token_provider` section.

## Required Privileges

All auth token functionality provided by Search Guard is protected by privileges. Thus, users who want to create or manage auth tokens, need the additional privileges specified in the action group `SGS_CREATE_MANAGE_OWN_AUTH_TOKEN`. 

In order to enable an administrator to manage and revoke auth tokens by all users, the administrator needs the privileges specified in the action group `SGS_MANAGE_ALL_AUTH_TOKEN`. 

## Creating Auth Tokens

Search Guard provides a REST API for creating auth tokens. In order to create an auth token do a REST request like this:

```json
POST /_searchguard/authtoken
Content-Type: application/json

{
  "name": "my_new_token",
  "requested": {
    "index_permissions": 
    [
      {
        "index_patterns": ["my_index_*"],
        "allowed_actions": ["*"]
      }
    ],
    "cluster_permissions": ["*"]
  },
  "expires_after": "1d"
}
```

This returns a response like this:

```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9.eyJuYmYiOj...",
  "token_name": "my_new_token",
  "requested": { ... },
  "base": { ... },
  "created_at": 1598525691
  "expires_at": 1630061691
}
```

The value of the `token` attribute is the JWT token that can now be used to send authenticated requests to Elasticsearch. The token provides a subset of the privileges the user had at the point in time the token was created. The token allows only actions on indices matching the pattern `my_index_*`. Because the `allowed_actions` attribute is `*`, the token provides all index permissions the user has. The cluster permissions are also identical to the user's cluster permissions.

In a request to create an auth token, it is possible to specify privileges that exceed the actual privileges the user has. Search Guard will only grant the intersection of the requested and the available privileges.

### Supported Attributes

This is an overview of all attributes Search Guard supports in requests sent to the `POST /_searchguard/authtoken` REST API.

**name:** A name giving a human-readable description of the token. Required.

**expires_after:** A time period specification which defines the maximum lifetime of the token. If this attribute is omitted, the token will have an unbounded lifetime. If the configuration in `sg_config.yml` specified a `max_validity` attribute, the validity will be always bounded by this value. Examples for valid values for this attribute are: `1y`: one year; `1y 6M`: one year and six months; `7d`: seven days; `1h 30m`: one hour and 30 minutes. Optional, defaults to no bound.

**requested.index_permissions:** An array of objects with the attributes `index_patterns` and `allowed_actions`. The `index_patterns` attribute specifies an array of index patterns which define the indices the privileges in `allowed_actions` apply to. Likewise,  `allowed_actions`  is an array of patterns to match on Elasticsearch actions. Optional.

**requested.cluster_permissions:** An array of pattern strings that match on Elasticsearch cluster actions. Optional.

**requested.exclude_index_permissions:** This attribute can be used to specify index permissions the auth token must not grant. The format is the same as `requested.index_permissions`. Optional.

**requested.exclude_cluster_permissions:** This attribute can be used to specify cluster permissions the auth token must not grant. The format is the same as `requested.cluster_permissions`. Optional.


**requested.roles:** It is also possible to specify the requested permissions by roles. If one or more role names are specified here, the created token will only have the privileges the roles have in the Search Guard configuration. Optional.

**freeze_privileges:** You can choose whether Search Guard will create a snapshot of the current role configuration which will be used by the auth token. This ensures that an auth token will continue to work, even if you redesign your role configuration. By default, (or by setting this to true) Search Guard will create a configuration snapshot; setting this to false will always use the current role configuration. Note: Administrators can use the `sg_config.yml` configuration option `sg_config.dynamic.auth_token_provider.freeze_privileges` to prevent normal users from choosing this option while creating new auth tokens. See [Other Configuration Options](#other-configuration-options) for details.


## Using Auth Tokens

Search Guard auth tokens must be specified as `Bearer` tokens in the `Authorization` header of REST requests. Such a header might look like this:

```
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJuYmYiOj...
```

### Curl

When you are using `curl` to make requests to Elasticsearch, you can specify the access token like this:

```
curl -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9..." -X GET "$ES_HOST/kibana_sample_data_flights/_search"
```

### Java RestHighLevelClient

When using the Java `RestHighLevelClient` to make requests to Elasticsearch, you can use the `setDefaultHeaders()` method in the `RestClientBuilder` class to
specify the access token:

```
Header header = new BasicHeader("Authorization", "Bearer eyJhbGciOiJIUzUxMiJ9...");

RestClientBuilder builder = RestClient.builder(new HttpHost(host, port, "https")).setDefaultHeaders(header);

RestHighLevelClient client = new RestHighLevelClient(builder);
```

## Managing and Revoking Auth Tokens

Search Guard provides further REST APIs to manage and revoke auth tokens.

### List and Search Auth Tokens

A user can list all auth tokens that have been issued to them by doing this request:

```
GET /_searchguard/authtoken/_search
```

The result is formed like a standard Elasticsearch search response:

```
{
  "hits": {
    "total": {
      "value": 1,
      "relation": "eq"
    },
    "max_score": 1,
    "hits": [
      {
        "_index": ".searchguard_authtokens",
        "_type": "_doc",
        "_id": "iZ-sC_s5QO-Y1Jc5ypZ6AQ",
        "_score": 1,
        "_source": {
          "user_name": "nils",
          "token_name": "my_new_token",
          "requested": {
            "cluster_permissions": [
              "*"
            ],
            "index_permissions": [
              {
                "index_patterns": [
                  "my_index_*"
                ],
                "allowed_actions": [
                  "*"
                ]
              }
            ]
          },
          "created_at": 1598532876,
          "expires_at": 1598619276
        }
      }
    ]
  }
}
```

You can specify search criteria by issuing POST requests to the same endpoint. This works like other Elasticsearch searches. The following query searches for all auth tokens that have index patterns that match `*my_index*`.


```
POST /_searchguard/authtoken/_search

{
    "query": {
        "wildcard": {
            "requested.index_permissions.index_patterns": {
                "value": "*my_index*"
            }
        }
    }
}
```

### Revoking Auth Tokens

For revoking an auth token, you need its ID. The ID can be obtained using the search API. It is the `_id` attribute of the search hit corresponding to the auth token.

Then you can call the DELETE method for the `/_searchguard/authtoken/{id}` endpoint.

For example:

```
DELETE /_searchguard/authtoken/iZ-sC_s5QO-Y1Jc5ypZ6AQ
```

### Administrator-Level Auth Token Management

Users which have the privileges provided by the action group `SGS_MANAGE_ALL_AUTH_TOKEN` can use the APIs described above to list and revoke auth tokens of all users. 

This is especially important if users are deleted or have their privileges lowered. As auth tokens freeze the privileges, administrators might want to check for auth tokens which still have the privileges.

## Advanced Topics

### Auth Tokens and the Search Guard REST Management API

The REST API provided by Search Guard to manage the Search Guard configuration (the [Search Guard REST Management API](../_docs_rest_api/rest_api_access.md)), does not use normal privileges for access control. Instead, access to the API is granted by special roles. If a user owns such a role, they can also use the Auth Token Service to create auth tokens which can be used for accessing the REST Management API. For creating such a token, you have to set the request attribute `requested.cluster_permissions` to either `*` or `cluster:admin:searchguard:configrestapi` when calling the create auth token API.

To create auth tokens, which cannot use the REST management API, put  `cluster:admin:searchguard:configrestapi` into `requested.exclude_cluster_permissions`. 
