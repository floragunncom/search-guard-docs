---
title: Quick Start
html_title: Dashboards/Kibana OIDC Quick Start
permalink: kibana-authentication-openid
category: kibana-authentication-openid-overview
order: 100
layout: docs
edition: enterprise
description: How to use OpenID Connect and your favorite identity provider to implement Dashboards/Kibana Single Sign-On.
resources:
- "https://search-guard.com/kibana-openid-keycloak/|Dashboards/Kibana Single Sign-On with OpenID and Keycloak"

---
<!---
Copyright 2020 floragunn GmbH 
-->

# OpenID Connect Quick Start
{: .no_toc}

{% include toc.md %}

You can use the OpenID Connect (OIDC) protocol to authenticate users in Dashboards/Kibana using external Identity Providers (IdP).

This chapter describes the basic setup of OIDC with Search Guard. This will work in most cases. Some setups require special configurations for TLS, proxies, or similar things. Please refer to the section [Advanced Configuration](kibana_authentication_openid_advanced_config.md) for this.

## Prerequisites

To use OIDC, you need to have an Identity Provider (IdP) supporting OIDC. Furthermore, HTTPS must be configured for Dashboards/Kibana.

## IdP Setup

First, create a new client representing your Dashboards/Kibana installation in your Identity Provider. The exact procedure for this is specific to the IdP. When configuring the client, you must make sure that the following settings are configured like this:

* Root URL: The base URL of the Dashboards/Kibana instance. For example, `https://kibana.example.com:5601/`
* Valid Redirect URLs: The base URL of Dashboards/Kibana plus a `*` wildcard for paths. For example, `https://kibana.example.com:5601/*`

* Also, you need to make sure that a user's roles are mapped to a JWT claim.

* All users who are supposed to log in to Dashboards/Kibana must have certain privileges. If you use the default `sg_roles_mapping.yml` configuration, just make sure that the IdP assigns the role `kibanauser` to all users. The default `sg_roles_mapping.yml` then maps this to the Search Guard role `SGS_KIBANA_USER`. If you are not using the default `sg_roles_mapping` you need to make sure that it maps  `SGS_KIBANA_USER` to a suitable backend role provided by the IdP.

You need to keep a couple of values from the IdP setup ready for the next step. These values are:

* The client id
* The client secret
* The name of the JWT claim to which you mapped the roles
* The URL of the OIDC configuration endpoint. This URL generally looks like this: `https://your.idp/.../.well-known/openid-configuration`

## Search Guard Setup

You need to edit the `sg_frontend_config.yml` file for OIDC support.

The default version of this file contains an entry for password-based authentication:

```yaml
default:
  authcz:
  - type: basic
```

If you don't want to use password-based authentication, replace the new configuration's entry`- type: basic`. If you want to continue to use password-based authentication besides OIDC, just add the new configuration below. The following examples assume that you have removed the password-based authentication.

The minimal `sg_frontend_config.yml` configuration for OIDC looks like this:

```yaml
default:
  authcz:
  - type: oidc
    client_id: "my-kibana-client"
    client_secret: "client-secret-from-idp"
    idp.openid_configuration_url: "https://your.idp/.../.well-known/openid-configuration"
    user_mapping.roles: "roles"
```

You need to replace the values for `client_id`, `client_secret`, `idp.openid_configuration_url` and `user_mapping.roles` by the values configured in the IdP.


## Dashboards/Kibana Setup

To use OIDC with Dashboards/Kibana it is necessary to configure the external URL of Dashboards/Kibana in the file `config/kibana.yml` in your Dashboards/Kibana installation.

For Dashboards/Kibana 7.11 and newer versions, you can use the built-in setting `server.publicBaseUrl`:

```yaml
server.publicBaseUrl: "https://kibana.example.com:5601"
```

For older versions of Kibaba, please use the setting `searchguard.frontend_base_url`:

```yaml
searchguard.frontend_base_url: "https://kibana.example.com:5601"
```

Furthermore, the OIDC protocol requires specific settings for the cookies used by Search Guard (For background information on this, see, for example, [this blog post at auth0.com](https://auth0.com/blog/browser-behavior-changes-what-developers-need-to-know/). To do so,  add the following settings to `opensearch_dashboards.yml`/`kibana.yml`:

```yaml
searchguard.cookie.isSameSite: None
searchguard.cookie.secure: true
```

## Activate the Setup

To activate the setup, do the following:

- If you edited `opensearch_dashboards.yml`/`kibana.yml`, ensure that you restart the Dashboards/Kibana instance.
- Use `sgadmin` to upload the new `sg_frontend_config.yml` file to Search Guard.

That's it. If you navigate your Dashboards/Kibana instance in a browser, you should be directed to the IdP login page.
