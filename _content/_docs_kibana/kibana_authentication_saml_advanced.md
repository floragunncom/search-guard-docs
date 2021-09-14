---
title: Advanced Configuration
html_title: Dashboards/Kibana SAML Advanced Configuration
slug: kibana-authentication-saml-advanced
category: kibana-authentication-saml-overview
order: 200
layout: docs
edition: enterprise
description: How to configure Dashboards/Kibana for SAML Single Sign On authentication and IdP integrations.


---
<!---
Copyright 2020 floragunn GmbH
-->

# Dashboards/Kibana SAML Advanced Configuration
{: .no_toc}

{% include toc.md %}



This chapter lists all advanced configuration options for SAML. Most of them are only needed for special setups.


## Mapping of SAML Assertions to User Data

The name of the users and their roles are determined by so called assertions stored in the SAML responses which are provided by the IdP to Search Guard. You can control the mapping of these assertions to user data using the following options:

**user_mapping.subject:** The name of the SAML assertion that stores the user's name. Optional. If not configured, the `NameID` attribute is used.

**user_mapping.roles:**  The name of the SAML assertion that stores the user's roles. If this assertion is multi-valued, Search Guard interprets each value as single role. Required.

**user_mapping.roles_separator:** For the case that some IdPs do not support multi-valued assertions for roles, Search Guard can also split a single value at a certain separator. Use this option to specify the separator to split the roles.

**user_mapping.subject_pattern:**  A regular expression that defines the structure of an expected user name. You can use capturing groups to use only a certain part of the subject supplied by the SAML Response as the Search Guard user name. If the pattern does not match, login will fail. See [below](#using-only-certain-sections-of-a-jwt-subject-claim-as-user-name) for details. Optional, defaults to no pattern. 

## TLS Settings

If you need special TLS settings to create connections from Search Guard to the IdP, you can configure them with the options listed below. Such configuration might become necessary for example if your IdP uses TLS certificates which are signed by non-public certificate authorities.

**idp.tls.trusted_cas:** The root certificates to trust when connecting to the IdP. You can specify the certificates in PEM format inline or specify an absolute path name using the syntax `${file:/path/to/certificate.pem}`.

**idp.tls.enabled_protocols:** The enabled TLS protocols. Defaults to `["TLSv1.2", "TLSv1.1"]`. 

**idp.tls.enabled_ciphers:** The enabled TLS cipher suites. 

**idp.tls.verify_hostnames:** Whether to verify the hostnames of the IdP’s TLS certificate or not. Default: true.

**idp.tls.trust_all:** Disable all certificate checks. You should only use this for quick tests. *Never use this for production systems.*


### Example

```yaml
default:
  authcz:
  - type: saml
    idp.metadata_url: "http://your.idp/auth/realms/master/protocol/saml/descriptor"
    idp.entity_id: "IdP entity id from the IdP"
    idp.tls.trusted_cas: |
      -----BEGIN CERTIFICATE-----
      MIIEZjCCA06gAwIBAgIGAWTBHiXPMA0GCSqGSIb3DQEBCwUAMHgxEzARBgoJkiaJ
      [...]
      1k4enV7iJWXE8009a6Z0Ouwm2Bg68Wj7TAQ=
      -----END CERTIFICATE-----
    sp.entity_id: "SP entity id from the IdP"      
    user_mapping.roles: roles
```

## TLS Client Authentication

If you need to use TLS client authentication to connect from Search Guard to the IdP, you can configure it using the following options:

**idp.tls.client_auth.certificate:** The client certificate. You can specify the certificate in PEM format inline or specify an absolute path name using the syntax `${file:/path/to/certificate.pem}`. You can also specify several certificates to specify a certificate chain.

**idp.tls.client_auth.private_key:** The private key belonging to the client certificate. You can specify the key in PEM format inline or specify an absolute path name using the syntax `${file:/path/to/private-key.pem}`. 

**idp.tls.client_auth.private_key_password:** If the private key is encrypted, you need to specify the key password using this option. 



## Using only certain sections of a JWT subject claim as user name

In some cases, the subject claim in a JWT might be more complex than needed or wanted. For example, a JWT subject claim could be specified as an email address like `exampleuser@example.com`. The `user_mapping.subject_pattern` option gives you the possibility to only use the local part (i.e., `exampleuser`) as the user name inside Search Guard.

With `subject_pattern` you specify a regular expression that defines the structure of an expected user name. You can then use capturing groups (i.e., sections enclosed in round parentheses; `(...)`) to use only a certain part of the subject supplied by the JWT as the Search Guard user name.

For example:

```yaml
default:
  authcz:
    idp.metadata_url: "http://your.idp/auth/realms/master/protocol/saml/descriptor"
    idp.entity_id: "IdP entity id from the IdP"
    sp.entity_id: "SP entity id from the IdP"
    user_mapping.roles: roles
    user_mapping.subject_pattern: "^(.+)@example\.com$"
```

In this example, `(.+)` is the capturing group, i.e., at least one character. This group must be followed by the string `@example.com`, which must be present, but will not be part of the resulting user name in Search Guard. If you try to login with a subject that does not match this pattern (e.g. `foo@bar`), login will fail.

You can use all the pattern features which the Java `Pattern` class supports. See the [official documentation](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html) for details. 

Keep in mind that all capturing groups are used for constructing the user name. If you need grouping only because you want to apply a pattern quantifier or operator, you should use non-capturing groups: `(?:...)`. 

Example for using capturing groups and non-capturing groups:

```yaml
      user_mapping.subject_pattern: "^(.+)@example\.(?:com|org)$"
```

In this example, the group around `com` and `org` is required to use the alternative operator `|`. But it must be non-capturing, because otherwise it would show up in the user name.

You can however also use several capturing groups if you want to use these groups for the user name:

```yaml
      user_mapping.subject_pattern: "^(.+)@example\.com|(.+)@foo\.bar$"
```

## Force a re-login even if the user has an active session with the IdP

TODO

```yaml
default:
  authcz:
    idp.metadata_url: "http://your.idp/auth/realms/master/protocol/saml/descriptor"
    idp.entity_id: "IdP entity id from the IdP"
    sp.entity_id: "SP entity id from the IdP"
    sp.forceAuthn: false
    user_mapping.roles: "roles"
    user_mapping.subject_pattern: "^(.+)@example\.com$"
```

## IdP initated SSO

IdP initiated SSO allows you to open Dashboards/Kibana directly from your IdP, without having navigated to Dashboards/Kibana first.

To use IdP initiated SSO, you need to complete the following steps:

* Edit the application settings in your IdP and set the *Assertion Consumer Service* endpoint to `/searchguard/saml/acs/idpinitiated
`.

Then add this endpoint to the xsrf whitelist in `opensearch_dashboards.yml`/`kibana.yml`:

```yaml
server.xsrf.whitelist: ["/searchguard/saml/acs/idpinitiated", "/searchguard/saml/acs", "/searchguard/saml/logout"]
```


## Request signing

Requests from Search Guard to the IdP can optionally be signed. Use the following settings to configure request signing:

**sp.signature\_private\_key:** The private key used to sign the requests. Optional. If not provided, requests are not signed.

**sp.signature\_algorithm:** The algorithm used to sign the requests. See below for possible values. 

Search Guard supports the following signature algorithms:

| Algorithm | Value |
|---|---|
| DSA\_SHA1 | http://www.w3.org/2000/09/xmldsig#dsa-sha1;|
| RSA\_SHA1 | http://www.w3.org/2000/09/xmldsig#rsa-sha1;|
| RSA\_SHA256 | http://www.w3.org/2001/04/xmldsig-more#rsa-sha256;|
| RSA\_SHA384 | http://www.w3.org/2001/04/xmldsig-more#rsa-sha384;|
| RSA\_SHA512 | http://www.w3.org/2001/04/xmldsig-more#rsa-sha512;|
{: .config-table}
