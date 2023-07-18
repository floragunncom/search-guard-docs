---
title: Quick Start
html_title: Kibana OIDC Quick Start
permalink: kibana-authentication-openid
category: kibana-authentication-openid-overview
order: 100
layout: docs
edition: enterprise
description: How to use OpenID Connect and your favorite identity provider to implement Kibana Single Sign-On.
resources:
  - "https://search-guard.com/kibana-openid-keycloak/|Kibana Single Sign-On with OpenID and Keycloak"

---
<!---
Copyright 2022 floragunn GmbH 
-->

# OpenID Connect Quick Start
{: .no_toc}

{% include toc.md %}

You can use the OpenID Connect (OIDC) protocol to authenticate users in Kibana using external Identity Providers (IdP).

This chapter describes the basic setup of OIDC with Search Guard. This will work in most cases. However, some setups require special configurations for TLS, proxies, or similar things. Please refer to the section [Advanced Configuration](kibana_authentication_openid_advanced_config.md) for this.

## Prerequisites

To use OIDC, you need to have an Identity Provider (IdP) supporting OIDC. Furthermore, HTTPS must be configured for Kibana.

## IdP Setup

First, create a new client representing your Kibana installation in your Identity Provider. The exact procedure for this is specific to the IdP. When configuring the client, you must make sure that the following settings are configured like this:

* Root URL: The base URL of the Kibana instance. For example, `https://kibana.example.com:5601/`
* Valid Redirect URLs. For example, `https://kibana.example.com:5601/auth/oidc/login`

* Also, you need to make sure that the roles of a user are mapped to a JWT claim.

* All users who are supposed to log in to Kibana must have certain privileges. If you use the default `sg_roles_mapping.yml` configuration, just make sure that the IdP assigns the role `kibanauser` to the users who shall be able to log in. The default `sg_roles_mapping.yml` then maps this to the Search Guard role `SGS_KIBANA_USER`. If you are not using the default `sg_roles_mapping` you need to make sure that it maps  `SGS_KIBANA_USER` to a suitable backend role provided by the IdP.

You need to keep a couple of values from the IdP setup ready for the next step. These values are:

* The client id
* The client secret
* The name of the OIDC ID token claim to which you mapped the roles
* The URL of the OIDC configuration endpoint. This URL generally looks like this: `https://your.idp/.../.well-known/openid-configuration`

## Search Guard Setup

Now you need to edit the `sg_frontend_authc.yml` file.

The default version of this file contains an entry for password-based authentication:

```yaml
default:
  auth_domains:
  - type: basic
```

If you don't want to use password-based authentication, replace the entry `- type: basic` by the new configuration. If you want to continue to use password-based authentication besides OIDC, just add the new configuration below. The following examples assume that you have removed the password-based authentication.

The minimal `sg_frontend_authc.yml` configuration for OIDC looks like this:

```yaml
default:
  auth_domains:
  - type: oidc
    oidc.client_id: "my-kibana-client"
    oidc.client_secret: "client-secret-from-idp"
    oidc.idp.openid_configuration_url: "https://your.idp/.../.well-known/openid-configuration"
    user_mapping.roles.from_comma_separated_string: "oidc_id_token.roles"
```

You need to replace the values for `client_id`, `client_secret` and `idp.openid_configuration_url`  by the values configured in the IdP. In the  `user_mapping.roles` config option, specify a JSON path expression to access the roles inside the OIDC ID token retrieved from the IdP. The attribute `oidc_id_token` is initialized with the claims retrieved from the ID token.

## Kibana Setup

To use OIDC with Kibana it is necessary to configure the external URL of Kibana in the file `config/kibana.yml` in your Kibana installation.

For Kibana 7.11 and newer versions, you can use the built-in setting `server.publicBaseUrl`:

```yaml
server.publicBaseUrl: "https://kibana.example.com:5601"
```

For older versions of Kibana, please use the setting `searchguard.frontend_base_url`:

```yaml
searchguard.frontend_base_url: "https://kibana.example.com:5601"
```

Furthermore, the OIDC protocol requires specific settings for the cookies used by Search Guard (For background information on this, see [this blog post at auth0.com](https://auth0.com/blog/browser-behavior-changes-what-developers-need-to-know/). To achieve this,  add the following settings to `kibana.yml`:

```yaml
searchguard.cookie.isSameSite: None
searchguard.cookie.secure: true
```

## Activate the Setup

To activate the setup, do the following:

- If you edited `kibana.yml`, ensure that you restart the Kibana instance.
- Use `sgctl` to upload the new `sg_frontend_authc.yml` file to Search Guard.

That's it. If you navigate in a browser to your Kibana instance, you should be directed to the IdP login page.
