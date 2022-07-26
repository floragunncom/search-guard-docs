---
title: Advanced Configuration
html_title: Kibana SAML Advanced Configuration
permalink: kibana-authentication-saml-advanced
category: kibana-authentication-saml-overview
order: 200
layout: docs
edition: enterprise
description: How to configure Kibana for SAML Single Sign On authentication and IdP integrations.


---
<!--- Copyright 2021 floragunn GmbH-->

# Kibana SAML Advanced Configuration
{: .no_toc}

{% include toc.md %}

This chapter lists all advanced configuration options for SAML. Most of them are only needed for specific setups.


## TLS Settings

If you need special TLS settings to create connections from Search Guard to the IdP, you can configure them with the options listed below. Such configuration might become necessary if your IdP uses TLS certificates signed by non-public certificate authorities.

**saml.idp.tls.trusted_cas:** The root certificates to trust when connecting to the IdP. You can specify the certificates in PEM format inline or specify an absolute pathname using the syntax `${file:/path/to/certificate.pem}`.

**saml.idp.tls.enabled_protocols:** The enabled TLS protocols. Defaults to `["TLSv1.2", "TLSv1.1"]`.

**saml.idp.tls.enabled_ciphers:** The enabled TLS cipher suites.

**saml.idp.tls.verify_hostnames:** Whether to verify the hostnames of the IdP’s TLS certificate or not. Default: true.

**saml.idp.tls.trust_all:** Disable all certificate checks. You should only use this for quick tests. *Never use this for production systems.*


### Example

```yaml
default:
  auth_domains:
  - type: saml
    saml.idp.metadata_url: "http://your.idp/auth/realms/master/protocol/saml/descriptor"
    saml.idp.entity_id: "IdP entity id from the IdP"
    saml.idp.tls.trusted_cas: |
      -----BEGIN CERTIFICATE-----
      MIIEZjCCA06gAwIBAgIGAWTBHiXPMA0GCSqGSIb3DQEBCwUAMHgxEzARBgoJkiaJ
      [...]
      1k4enV7iJWXE8009a6Z0Ouwm2Bg68Wj7TAQ=
      -----END CERTIFICATE-----
    saml.sp.entity_id: "SP entity id from the IdP"      
    user_mapping.roles.from: saml_response.roles
```

## TLS Client Authentication

If you need to use TLS client authentication to connect from Search Guard to the IdP, you can configure it using the following options:

**saml.idp.tls.client_auth.certificate:** The client certificate. You can specify the certificate in PEM format inline or specify an absolute pathname using the syntax `${file:/path/to/certificate.pem}`. You can also specify several certificates to specify a certificate chain.

**saml.idp.tls.client_auth.private_key:** The private key belonging to the client certificate. You can specify the key in PEM format inline or specify an absolute path name using the syntax `${file:/path/to/private-key.pem}`.

**saml.idp.tls.client_auth.private_key_password:** If the private key is encrypted, you must specify the key password using this option.



## IdP initated SSO

IdP initiated SSO allows you to open Kibana directly from your IdP without navigating to Kibana first.

To use IdP initiated SSO, you need to complete the following steps:

* Edit the application settings in your IdP and set the *Assertion Consumer Service* endpoint to `/searchguard/saml/acs/idpinitiated`.

Then add this endpoint to the xsrf whitelist in `kibana.yml`:

```yaml
server.xsrf.whitelist: ["/searchguard/saml/acs/idpinitiated", "/searchguard/saml/acs", "/searchguard/saml/logout"]
```

## Request signing

Requests from Search Guard to the IdP can optionally be signed. Use the following settings to configure request signing:

**saml.sp.signature\_private\_key:** The private key used to sign the requests. Optional. If not provided, requests are not signed.

**saml.sp.signature\_algorithm:** The algorithm used to sign the requests. See below for possible values.

Search Guard supports the following signature algorithms:

| Algorithm | Value |
|---|---|
| DSA\_SHA1 | http://www.w3.org/2000/09/xmldsig#dsa-sha1;|
| RSA\_SHA1 | http://www.w3.org/2000/09/xmldsig#rsa-sha1;|
| RSA\_SHA256 | http://www.w3.org/2001/04/xmldsig-more#rsa-sha256;|
| RSA\_SHA384 | http://www.w3.org/2001/04/xmldsig-more#rsa-sha384;|
| RSA\_SHA512 | http://www.w3.org/2001/04/xmldsig-more#rsa-sha512;|
{: .config-table}
