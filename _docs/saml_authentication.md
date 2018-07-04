---
title: SAML Authentication
html_title: SAML Authentication
slug: saml-authentication
category: authauth
order: 580
layout: docs
edition: enterprise
description: How to configure SAML support in Search Guard to implement Kibana Single Sign On.
---
<!---
Copryight 2018 floragunn GmbH
-->

# SAML Authentication

**This is preliminary documentation for the Search Guard SAML Beta. Configuration keys and other values are subject to change.**

Search Guard supports user authentication via SAML Single Sign-On. Search Guard implements the Web Browser SSO profile of the SAML 2.0 protocol.

This profile is intended to be used with web browsers. It is not a general-purpose way of authenticating users against Search Guard, so it is not meant for using it with other REST clients. The primary use case is to support Kibana Single Sign-On. 

If you have problems configuring SAML please refer to the [SAML troubleshooting guide](../_troubleshooting/saml_troubleshooting.md).

## Activating SAML

To use SAML for authentication, you need to configure a respective authentication domain in the `authc` section of `sg_config`. Since SAML works solely on the HTTP layer, you do not need any `authentication_backend` and can set it to noop. Place all SAML specific configuration options in this chapter in the `config` section of the SAML HTTP authenticator like:

```yaml
authc:
  saml:
    enabled: true
    order: 1
    http_authenticator:
      type: saml
      challenge: true
      config:
        idp:
          metadata_file: okta.xml
          ...
    authentication_backend:
      type: noop
```

Once you have configured SAML in `sg_config`, you need to also [activate it in Kibana](kibana_authentication_saml.md). 

## Running multiple authentication domains

We recommend adding at least one other authentication domain, such as LDAP or the internal user database, to support API access to Elasticsearch without SAML. For Kibana and the internal Kibana server user, it is also required to add another authentication domain that supports basic authentication. This authentication domain should be placed first in the chain, and the `challenge` flag has to be set to `false`:

```yaml
authc:
  basic_internal_auth_domain:
    enabled: true
    order: 0
    http_authenticator:
      type: basic
      challenge: false
    authentication_backend:
      type: internal
  saml_auth_domain:
     enabled: true
     order: 1
     http_authenticator:
        type: 'saml'
        challenge: true
        config:
            ...
     authentication_backend:
        type: noop
```


## Identity provider metadata

A SAML IdP provides a SAML 2.0 metadata file describing the IdPs capabilities and configuration. Search Guard can read IdP metadata either from a URL or a file. Which way to choose depends on your IdP and your preferences. The SAML 2.0 metadata file is mandatory.

| Name | Description |
|---|---|
| idp.metadata_file | The path to the SAML 2.0 metadata file of your IdP. Place the metadata file in the `config` directory of Elasticsearch. The path has to be specified relative to the `config` directory. Mandatory if `idp.metadata_url` is not set.|
| idp.metadata_url | The SAML 2.0 metadata URL of your IdP. Mandatory if `idp.metadata_file` is not set. |

## Idp and service provider entity ID

An entity ID is a globally unique name for a SAML entity, either an IdP or a Service Provider (SP). The *IdP entity ID* is usually provided by your IdP. The *SP entity ID* is the name of the configured application or client in your IdP. We recommend to add a new application/client for Kibana and use the URL of your Kibana installation as SP entity id.

| Name | Description |
|---|---|
| idp.entity_id | The entity ID of your IdP. Mandatory.|
| sp.entity_id | The entity ID of the service provider. Mandatory.|

## Kibana settings

The Web Browser SSO profile works by exchanging information via HTTP GET or POST. For example, after you log in to your IdP, it will issue an HTTP POST back to Kibana containing the `SAML Response`. You need to configure the base URL of your Kibana installation where the HTTP requests are being sent to.

| Name | Description |
|---|---|
| kibana_url | The Kibana base URL. Mandatory.|

## Username and Role attributes

Subjects (a.k.a usernames) are usually stored in the NameID element of a SAML response:

```
<saml2:Subject>
  <saml2:NameID>admin</saml2:NameID>
  ...
</saml2:Subject>
```

If your IdP is compliant with the SAML 2.0 specification you do not need to set anything special. If your IdP uses a different element name, you can also specify its name explicitly.

Role attributes are optional. However, most IdPs can be configured to add roles in the SAML assertions as well. You can use these roles for [mapping users to Search Guard roles](configuration_roles_mapping.md). Usually, the `Role` element is used for that, e.g.

```
<saml2:Attribute Name='Role'>
  <saml2:AttributeValue >Everyone</saml2:AttributeValue>
  <saml2:AttributeValue >Admins</saml2:AttributeValue>
</saml2:Attribute>
```

If you want to extract roles from the SAML response, you need to specify the element name that contains the roles. 

| Name | Description |
|---|---|
| subject_key | The attribute in the SAML response where the subject is stored. Optional. If not configured, the NameID attribute is used.|
| roles_key | The attribute in the SAML response where the roles are stored. Optional. If not configured, no roles will be used.|
 
## Request signing

Requests from Search Guard to the IdP can optionally be signed. Use the following settings to configure request signing:

| Name | Description |
|---|---|
| sp.signature\_private\_key | The private key used to sign the requests. Optional. If not provided, requests are not signed.|
| sp.signature\_algorithm | The algorithm used to sign the requests. See below for possible values. |

Search Guard supports the following signature algorithms:

| Algorithm | Value |
|---|---|
| DSA\_SHA1 | http://www.w3.org/2000/09/xmldsig#dsa-sha1;|
| RSA\_SHA1 | http://www.w3.org/2000/09/xmldsig#rsa-sha1;|
| RSA\_SHA256 | http://www.w3.org/2001/04/xmldsig-more#rsa-sha256;|
| RSA\_SHA384 | http://www.w3.org/2001/04/xmldsig-more#rsa-sha384;|
| RSA\_SHA512 | http://www.w3.org/2001/04/xmldsig-more#rsa-sha512;|


## Logout

Usually, IdPs provide information about their individual logout URL in their SAML 2.0 metadata. If this is the case, Search Guard will make use of them and render the correct logout link in Kibana. If your IdP does not support an explicit logout, you can force a re-login when the user visits Kibana again:

| Name | Description |
|---|---|
| sp.forceAuthn | Force a re-login even if the user has an active session with the IdP |

At the moment Search Guard only supports the `HTTP-Redirect` logout binding. Please make sure this is configured correctly in your IdP.

## Exchange key settings

SAML, unlike other protocols like JWT or Basic Authentication, is not meant to be used for exchanging user credentials with each request. Therefore Search Guard trades the heavy-weight SAML response for a light-weight JSON web token that stores the validated user attributes. This token is signed by an exchange key that you can choose freely. Note that when you change this key, all tokens signed with it will become invalid immediately.

| Name | Description |
|---|---|
| exchange_key | The key to sign the token. The algorithm is HMAC256, so it should have at least 32 characters. |

### Token expiration

**TBD**

## TLS settings

If you are loading the IdP metadata from a URL, it is recommended to use SSL/TLS. If you use an external IdP like Okta or Auth0 that uses a trusted certificate, you usually do not need to configure anything. If you host the IdP yourself and use your own root CA, you can customize the TLS settings as follows. These settings are only used for loading SAML metadata over https.

| Name | Description |
|---|---|
| idp.enable_ssl | Whether to enable the custom TLS configuration or not. Default: false (JDK settings are used)|
| idp.verify\_hostnames | Whether to verify the hostnames of the server's TLS certificate or not  |

Example:

```yaml
authc:
  saml:
    enabled: true
    order: 1
    http_authenticator:
      type: saml
      challenge: true
      config:
        idp:
          enable_ssl: true
          verify_hostnames: true
          ...
    authentication_backend:
      type: noop
```


### Certificate validation

Configure the root CA used for validating the IdP TLS certificate by setting **one of** the following configuration options:

```yaml
config:
  idp:
    pemtrustedcas_filepath: path/to/trusted_cas.pem
```

or

```yaml
config:
  idp:
    pemtrustedcas_content: |-
      MIID/jCCAuagAwIBAgIBATANBgkqhkiG9w0BAQUFADCBjzETMBEGCgmSJomT8ixk
      ARkWA2NvbTEXMBUGCgmSJomT8ixkARkWB2V4YW1wbGUxGTAXBgNVBAoMEEV4YW1w
      bGUgQ29tIEluYy4xITAfBgNVBAsMGEV4YW1wbGUgQ29tIEluYy4gUm9vdCBDQTEh
      ...
```

| Name | Description |
|---|---|
| idp.pemtrustedcas\_filepath | Path to the PEM file containing the root CA(s) of your IdP. The files must be placed under the Elasticsearch `config` directory and the path must be specified relative to the `config` directory. |
| idp.pemtrustedcas\_content | The root CA content of your IdP server. Cannot be used when `pemtrustedcas_filepath` is set. |

### Client authentication

Search Guard can use TLS client authentication when fetching the IdP metadata. If enabled, Search Guard sends a TLS client certificate to the IdP for each metadata request. Use the following keys to configure client authentication:

| Name | Description |
|---|---|
| idp.enable\_ssl\_client\_auth | Whether to send a client certificate to the IdP server or not. Default: false |
| idp.pemcert_filepath | Path to the PEM file containing the client certificate. The file must be placed under the Elasticsearch `config` directory and the path must be specified relative to the `config` directory. |
| idp.pemcert_content | The content of the client certificate. Cannot be used when `pemcert_filepath` is set. |
| idp.pemkey\_filepath | Path to the private key of the client certificate. The file must be placed under the Elasticsearch `config` directory and the path must be specified relative to the `config` directory. |
| idp.pemkey\_content | The content of the private key of your certificate. Cannot be used when `pemkey_filepath` is set. |
| idp.pemkey\_password | The password of your private key, if any. |

### Enabled ciphers and protocols

You can limit the allowed ciphers and TLS protocols for the IdP connection. For example, you can only enable strong ciphers and limit the TLS versions to the most recent ones.

| Name | Description |
|---|---|
| idp.enabled\_ssl\_ciphers | Array, enabled TLS ciphers. Only Java format is supported. |
| idp.enabled\_ssl\_protocols | Array, enabled TLS protocols. Only Java format is supported. |


**Note: By default, Search Guard disables `TLSv1` because it is insecure. If you need to use `TLSv1` and you know what you  are doing, you can re-enable it like:**

```yaml
enabled_ssl_protocols:
  - "TLSv1"
  - "TLSv1.1"
  - "TLSv1.2"
```

## Minimal configuration example

```yaml
authc:
  saml:
    enabled: true
    order: 1
    http_authenticator:
      type: saml
      challenge: true
      config:
        idp:
          metadata_file: metadata.xml
          entity_id: http://idp.example.com/
        sp:
          entity_id: https://kibana.example.com
        kibana_url: https://kibana.example.com:5601/
        roles_key: Role
        exchange_key: 'peuvgOLrjzuhXf ...'
    authentication_backend:
      type: noop
```

## Kibana configuration

**For Kibana SAML authentication to work you need at least v14-beta-1 and above. This is beta software. Configuration keys and other values are subject to change.**

Since most of the SAML specific configuration is done in Search Guard, just activate SAML in your `kibana.yml` by adding:

```
searchguard.auth.type: "saml"
```

In addition the Kibana endpoint for validating the SAML assertions must be whitelisted:

```
server.xsrf.whitelist: [/sg/saml/acs]
```