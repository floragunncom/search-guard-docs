---
title: OpenID Connect
html_title: OpenID Connect
slug: openid-json-web-keys
category: authauth
order: 600
layout: docs
edition: enterprise
description: How to connect Search Guard with an OpenID provider like Keycloak and how to use JSON web keys to automatially fetch encryption keys
resources:
  - "https://search-guard.com/kibana-openid-keycloak/|Dashboards/Kibana Single Sign-On with OpenID and Keycloak"

---
<!---
Copyright 2020 floragunn GmbH
-->

# Integrating with OpenID providers
{: .no_toc}

{% include toc.md %}

Search Guard can integrate with *identity providers* (IdP) that are compatible with the OpenID standard. This will allow for:

* Automatic configuration
  * You just need to point Search Guard to the *metadata* of your IdP, and Search Guard will use that data for configuration
* Automatic key fetching
  * Search Guard will retrieve the public key for validating the JSON web tokens automatically from the JWKS endpoint of your IdP. There is no need to configure keys or shared secrets in `sg_config.yml`.
* Key rollover
  * You can change the keys used for signing the JWTs directly in your IdP. If Search Guard detects an unknown key, it tries to retrieve it from the IdP, transparent to the user.
* [Dashboards/Kibana Single Sign On](../_docs_kibana/kibana_authentication_openid.md)
   
## Configuring OpenID integration

To integrate with an OpenID IdP, set up an authentication domain and choose `openid` as HTTP authentication type. Since JSON web tokens already contain all required information to verify the request, `challenge` can be set to `false` and `authentication_backend` to `noop`.

Minimal configuration:

```yaml
openid_auth_domain:
  http_enabled: true
  transport_enabled: true
  order: 0
  http_authenticator:
    type: openid
    challenge: false
    config:
      subject_key: preferred_username
      roles_key: roles
      openid_connect_url: https://keycloak.example.com:8080/auth/realms/master/.well-known/openid-configuration
  authentication_backend:
    type: noop
```

Configuration parameters:

| Name | Description |
|---|---|
| openid\_connect\_url | The URL of your IdP where Search Guard can find the OpenID metadata/configuration settings. This URL differs between IdPs, please refer to your IdP configuration. Mandatory. |
| jwt\_header | The HTTP header which stores the token. This is typically the `Authorization` header with the `Bearer` schema: `Authorization: Bearer <token>`. Optional. The default is `Authorization`.|
| jwt\_url\_parameter | If the token is not transmitted in the HTTP header, but as an URL parameter, define the name of this parameter here. Optional.|
| subject_key | The key in the JSON payload that stores the user's name. If not defined, the [subject](https://tools.ietf.org/html/rfc7519#section-4.1.2) registered claim is used. Most IdP providers use the `preferred_username` claim. Optional.|
| roles_key | The key in the JSON payload that stores the user's roles. The value of this key must be a comma-separated list of roles. Mandatory only if you want to use roles in the JWT.|
| subject_pattern | A regular expression that defines the structure of an expected user name. You can use capturing groups to use only a certain part of the subject supplied by the JWT as the Search Guard user name. If the pattern does not match, login will fail. See [below](#using-only-certain-sections-of-a-jwt-subject-claim-as-user-name) for details. Optional, defaults to no pattern. |
| proxy | If the IdP is only reachable via an HTTP proxy, you can use the `proxy` option to define the URI of the proxy. Optional, defaults to no proxy.
{: .config-table}

## OpenID connect URL

OpenID specifies various endpoints for integration purposes. The most important endpoint is the `well-known` configuration endpoint: It lists endpoints and other configuration options relevant to Search Guard.

The URL differs between IdPs, but it usually ends in `/.well-known/openid-configuration`. Keycloak example:

```
http(s)://<server>:<port>/auth/realms/<realm>/.well-known/openid-configuration
```

The main information that Search Guard needs is the `jwks_uri`. This URI specifies where the IdP's public key(s) in JWKS format can be found. Example:

```
jwks_uri: "https://keycloak.example.com:8080/auth/realms/master/protocol/openid-connect/certs"
```

```
{  
   keys:[  
      {  
         kid:"V-diposfUJIk5jDBFi_QRouiVinG5PowskcSWy5EuCo",
         kty:"RSA",
         alg:"RS256",
         use:"sig",
         n:"rI8aUrAcI_auAdF10KUopDOmEFa4qlUUaNoTER90XXWADtKne6VsYoD3ZnHGFXvPkRAQLM5d65ScBzWungcbLwZGWtWf5T2NzQj0wDyquMRwwIAsFDFtAZWkXRfXeXrFY0irYUS9rIJDafyMRvBbSz1FwWG7RTQkILkwiC4B8W1KdS5d9EZ8JPhrXvPMvW509g0GhLlkBSbPBeRSUlAS2Kk6nY5i3m6fi1H9CP3Y_X-TzOjOTsxQA_1pdP5uubXPUh5YfJihXcgewO9XXiqGDuQn6wZ3hrF6HTlhNWGcSyQPKh1gEcmXWQlRENZMvYET-BuJEE7eKyM5vRhjNoYR3w",
         e:"AQAB"
      }
   ]
}
```

You can find more information about the endpoint for your IdP here:

* [Okta](https://developer.okta.com/docs/api/resources/oidc#well-knownopenid-configuration){:target="_blank"}
* [Kecloak](https://www.keycloak.org/docs/3.0/securing_apps/topics/oidc/oidc-generic.html){:target="_blank"}
* [Auth0](https://auth0.com/docs/protocols/oidc/openid-connect-discovery){:target="_blank"}
* [Connect2ID](https://connect2id.com/products/server/docs/api/discovery){:target="_blank"}
* [Salesforce](https://help.salesforce.com/articleView?id=remoteaccess_using_openid_discovery_endpoint.htm&type=5){:target="_blank"}
* [IBM OpenID connect](https://www.ibm.com/support/knowledgecenter/en/SSEQTP_8.5.5/com.ibm.websphere.wlp.doc/ae/rwlp_oidc_endpoint_urls.html){:target="_blank"}

## Fetching public keys: The key id

When an IdP generates and signs a JSON web token, it must add the id of the key to the *header* part of the JWT. Example:

```
{
  "alg": "RS256",
  "typ": "JWT",
  "kid": "V-diposfUJIk5jDBFi_QRouiVinG5PowskcSWy5EuCo"
}
```

As per [OpenID specification](http://openid.net/specs/openid-connect-messages-1_0-20.html){:target="_blank"}, the `kid` ("key id") is mandatory. Token verification will not work if an IdP fails to add the `kid` field to the JWT. 

If Search Guard receives a JWT with an unknown `kid`, it will visit the IdP's `jwks_uri` and retrieve all currently available valid keys. These keys will be used and cached until a refresh is triggered by retrieving another unknown key id.

## Key rollover and multiple public keys

Search Guard is capable of maintaining multiple valid public keys at once. Since the OpenID specification does not allow for a validity period of public keys, a key is deemed valid until it has been removed from the list of valid keys in your IdP, and until the list of valid keys has been refreshed.

If you want to roll over a key in your IdP, it is good practice to:

* Create a new key pair in your IdP, and give the new key a higher priority than the currently used key
* Your IdP will use this new key over the old key
* Upon first appearance of the new `kid` in a JWT, Search Guard will refresh the key list 
  * At this point, both the old key and the new key are valid
  * Tokens signed with the old key are also still valid 
* The old key can be removed from your IdP when the last JWT signed with this key has timed out

If you have to immediately change your public key, because the currently used key has been comprised, you can also delete the old key first and then create a new one. In this case, all JWTs signed with the old key will become invalid immediately.


### Using only certain sections of a JWT subject claim as user name

In some cases, the subject claim in a JWT might be more complex than needed or wanted. For example, a JWT subject claim could be specified as an email address like `exampleuser@example.com`. The `subject_pattern` option gives you the possibility to only use the local part (i.e., `exampleuser`) as the user name inside Search Guard.

With `subject_pattern` you specify a regular expression that defines the structure of an expected user name. You can then use capturing groups (i.e., sections enclosed in round parentheses; `(...)`) to use only a certain part of the subject supplied by the JWT as the Search Guard user name.

For example:

```yaml
jwt_auth_domain:
  http_enabled: true
  order: 0
  http_authenticator:
    type: openid
    challenge: false
    config:
      subject_pattern: "^(.+)@example\.com$"
```

In this example, `(.+)` is the capturing group, i.e., at least one character. This group must be followed by the string `@example.com`, which must be present, but will not be part of the resulting user name in Search Guard. If you try to login with a subject that does not match this pattern (e.g. `foo@bar`), login will fail.

You can use all the pattern features which the Java `Pattern` class supports. See the [official documentation](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html) for details. 

Keep in mind that all capturing groups are used for constructing the user name. If you need grouping only because you want to apply a pattern quantifier or operator, you should use non-capturing groups: `(?:...)`. 

Example for using capturing groups and non-capturing groups:

```yaml
      subject_pattern: "^(.+)@example\.(?:com|org)$"
```

In this example, the group around `com` and `org` is required to use the alternative operator `|`. But it must be non-capturing, because otherwise it would show up in the user name.

You can however also use several capturing groups if you want to use these groups for the user name:

```yaml
      subject_pattern: "^(.+)@example\.com|(.+)@foo\.bar$"
```

## TLS settings

In order to prevent man-in-the-middle attacks and other attack scenarios you should secure the connection between Search Guard and your IdP with TLS.

### Enabling TLS

Use the following parameters to enable TLS for connecting to your IdP:

```yaml
config:
  openid_connect_idp:
    enable_ssl: <true|false>
    verify_hostnames: <true|false>
```

| Name | Description |
|---|---|
| enable_ssl | Whether to use a custom TLS configuration. Defaults to false which indicates that the certificate specified in the configuration `searchguard.ssl.transport.pemtrustedcas_filepath` is used.  |
| verify\_hostnames | Whether to verify the hostnames of the IdP's TLS certificate or not. Default: true  |
{: .config-table}

### Certificate validation

To validate the TLS certificate of your IdP, configure either the path to the IdP's root CA or the root certificates content like:

```yaml
config:
  openid_connect_idp:
    enable_ssl: true
    pemtrustedcas_filepath: /path/to/trusted_cas.pem
```

or

```yaml
config:
  openid_connect_idp:
    enable_ssl: true
    pemtrustedcas_content: |-
      MIID/jCCAuagAwIBAgIBATANBgkqhkiG9w0BAQUFADCBjzETMBEGCgmSJomT8ixk
      ARkWA2NvbTEXMBUGCgmSJomT8ixkARkWB2V4YW1wbGUxGTAXBgNVBAoMEEV4YW1w
      bGUgQ29tIEluYy4xITAfBgNVBAsMGEV4YW1wbGUgQ29tIEluYy4gUm9vdCBDQTEh
    ...
```

| Name | Description |
|---|---|
| pemtrustedcas\_filepath | Absolute path to the PEM file containing the root CA(s) of your IdP |
| pemtrustedcas\_content | The root CA content of your IdP. Cannot be used when `pemtrustedcas_filepath` is set. |
{: .config-table}

### TLS client authentication

To use TLS client authentication, configure the PEM certificate and private key Search Guard should send for TLS client authentication, or its contents like:

```yaml
config:
  openid_connect_idp:
    enable_ssl: true
    pemkey_filepath: /path/to/private.key.pem
    pemkey_password: private_key_password
    pemcert_filepath: /path/to/certificate.pem
```

or

```yaml
config:
  openid_connect_idp:
    enable_ssl: true
    pemkey_content: |-
      MIID2jCCAsKgAwIBAgIBBTANBgkqhkiG9w0BAQUFADCBlTETMBEGCgmSJomT8ixk
      ARkWA2NvbTEXMBUGCgmSJomT8ixkARkWB2V4YW1wbGUxGTAXBgNVBAoMEEV4YW1w
      bGUgQ29tIEluYy4xJDAiBgNVBAsMG0V4YW1wbGUgQ29tIEluYy4gU2lnbmluZyBD
    ...
    pemkey_password: private_key_password
    pemcert_content: |-
      MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCHRZwzwGlP2FvL
      oEzNeDu2XnOF+ram7rWPT6fxI+JJr3SDz1mSzixTeHq82P5A7RLdMULfQFMfQPfr
      WXgB4qfisuDSt+CPocZRfUqqhGlMG2l8LgJMr58tn0AHvauvNTeiGlyXy0ShxHbD
    ...
```

| Name | Description |
|---|---|
| enable\_ssl\_client\_auth | Whether to send the client certificate to the IdP server or not. Default: false |
| pemcert_filepath | Absolute path to the the client certificate. |
| pemcert_content | The content of the client certificate. Cannot be used when `pemcert_filepath` is set. |
| pemkey\_filepath | Absolute path to the file containing the private key of the client certificate. |
| pemkey\_content | The content of the private key of your client certificate. Cannot be used when `pemkey_filepath` is set. |
| pemkey\_password | The password of your private key, if any. |
{: .config-table}

### Enabled ciphers and protocols

You can limit the allowed ciphers and TLS protocols by using the following keys:

| Name | Description |
|---|---|
| enabled\_ssl\_ciphers | Array, enabled TLS cipher suites. Only Java format is supported. |
| enabled\_ssl\_protocols | Array, enabled TLS protocols. Only Java format is supported. |
{: .config-table}



## Expert: DOS protection

In theory it is possible to DOS attack an OpenID based infrastructure by sending tokens with randomly generated, non-existing key ids at a high frequency. In order to mitigate this, Search Guard will only allow a maximum number of new key ids in a certain time frame. If more unknown key ids are receievd, Search Guard will return a HTTP status code 503 (Service not available) and refuse to query the IdP. By defaut, Search Guard does not allow for more than 10 unknown key ids in a time window of 10 seconds. You can control these settings by the following configuration keys: 

| Name | Description |
|---|---|
| refresh\_rate\_limit\_count | The maximum number of unknown key ids in the time window. Default: 10  |
| refresh\_rate\_limit\_time\_window\_ms | The time window to use when checking the maximum number of unknown key ids, in milliseconds. Default: 10000 |
{: .config-table}

## Dashboards/Kibana Single Sign On

The Dashboards/Kibana Plugin has OpenID support built in since version 14. Please refer to the [Dashboards/Kibana OpenID configuration](../_docs_kibana/kibana_authentication_openid.md) for details.