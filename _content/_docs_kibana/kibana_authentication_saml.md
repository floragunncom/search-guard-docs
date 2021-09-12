---
title: Quick Start
html_title: Kibana SAML Quick Start
slug: kibana-authentication-saml
category: kibana-authentication-saml-overview
order: 100
layout: docs
edition: enterprise
description: How to configure Kibana for SAML Single Sign On authentication and IdP integrations.
resources:
  - "https://search-guard.com/kibana-elasticsearch-saml/|Using SAML for Kibana Single Sign-On (blogpost)"


---
<!---
Copyright 2020 floragunn GmbH
-->

# Kibana SAML Quick Start
{: .no_toc}

{% include toc.md %}

Search Guard supports user authentication via SAML Single Sign-On. Search Guard implements the Web Browser SSO profile of the SAML 2.0 protocol.

This chapter describes the basic setup of SAML with Search Guard. This will work in many cases; some setups however require special configurations for TLS, proxies or similar things. Please refer to the section [Advanced Configuration](kibana_authentication_saml_advanced_config.md) for this.

## Prerequisites

In order to use SAML, you need to have an Identity Provider (IdP) supporting SAML.

Furthermore, it is necessary that HTTPS is configured for Kibana.

## IdP Setup

First, create a new application integration representing your Kibana installation in your Identity Provider. The exact procedure for this is specific to the IdP. When configuring the integration, you must make sure that the following settings are configured like this:

* Assertion Consumer Service URL or Single Sign On URL: The IdP will send authentication information to this URL. This must be the publicly visible URL of Kibana followed by the path `/searchguard/saml/acs`. For example, `https://kibana.example.com:5601/searchguard/saml/acs`

* Make sure that the roles of a user are mapped to a SAML assertion.

* All users which are supposed to be able to log in to Kibana, must have certain privileges. If you are using the default `sg_roles_mapping.yml` configuration, just make sure that the IdP assigns the role `kibanauser` to all wanted users. The default `sg_roles_mapping.yml` then maps this to the Search Guard role `SGS_KIBANA_USER`. If you are not using the default `sg_roles_mapping` you need to make sure that it maps  `SGS_KIBANA_USER` to a suitable backend role provided by the IdP.  

You need to keep a couple of values from the IdP setup ready for the next step. These values are:

* The SP Entity Id
* The name of the SAML assertion to which you mapped the roles
* The URL of the SAML metadata endpoint at your IdP or a metadata file.
* The IdP Entity Id. You can get this Id by looking into the metadata file for an `IDOSSODescriptor` element and using the `entityID` of its parent element. 

## Search Guard Setup

Now you need to edit the `sg_frontend_config.yml` file. 

The default version of this file contains an entry for password-based authentication:

```yaml
default:
  authcz:
  - type: basic
```

If you don't want to use password-based authentication, replace the entry`- type: basic` by the new configuration. If you want to continue to use password-based authentication besides SAML, just add the new configuration below. The following examples assume that you have removed the password-based authentication.

The minimal `sg_frontend_config.yml` configuration for SAML looks like this:

```yaml
default:
  authcz:
  - type: saml
    idp.metadata_url: "http://your.idp/auth/realms/master/protocol/saml/descriptor"
    idp.entity_id: "IdP entity id from the IdP"
    sp.entity_id: "SP entity id from the IdP"
    user_mapping.roles: roles
```

You need to replace the values for `idp.metadata_url`, `idp.entity_id`, `sp.entity_id` and `user_mapping.roles` by the values configured in the IdP. 

If your IdP does not provide the metadata by an URL, you can to download the metadata from the IdP and specify it inline in the configuration:

```yaml
default:
  authcz:
  - type: saml
    idp.metadata_xml: |
            <EntityDescriptor entityID="IdP entity id from the IdP" xmlns="urn:oasis:names:tc:SAML:2.0:metadata">
              <IDPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
                 ...
              </IDPSSODescriptor>
            </EntityDescriptor>  
    idp.entity_id: "IdP entity id from the IdP"
    sp.entity_id: "SP entity id from the IdP"
    user_mapping.roles: roles
```
 
## Kibana Setup

In order to use SAML with Kibana, it is necessary to configure the external URL of Kibana in the file `config/kibana.yml` in your Kibana installation. 

For Kibana 7.11 and newer versions, you can use the built-in setting `server.publicBaseUrl`:

```yaml
server.publicBaseUrl: "https://kibana.example.com:5601"
```

For older versions of Kibaba, please use the setting `searchguard.frontend_base_url`: 

```yaml
searchguard.frontend_base_url: "https://kibana.example.com:5601"
```

Furthermore, the OIDC protocol requires special settings for the cookies used by Search Guard (For background information on this, see for example [this blog post at auth0.com](https://auth0.com/blog/browser-behavior-changes-what-developers-need-to-know/). To achieve this, you need to add this to `kibana.yml`:

```yaml
searchguard.cookie.isSameSite: None
searchguard.cookie.secure: true
```

Finally, you need to excempt the Kibana endpoints with which the IdP interacts from the Kibana XSRF protection. If your `kibana.yml` does not contain yet the key
`server.xsrf.whitelist`, please add this:

```yaml
server.xsrf.whitelist: ["/searchguard/saml/acs", "/searchguard/saml/logout"]
```

If `kibana.yml`  already contains the key, make sure that the array contains the values `"/searchguard/saml/acs", "/searchguard/saml/logout"`. 

## Activate the Setup

In order to activate the setup, do the following:

- If you needed to edit `kibana.yml`, make sure that you restart the Kibana instance. 
- Use `sgadmin` to upload the new `sg_frontend_config.yml` file to Search Guard.

That's it. If you navigate in a browser to your Kibana instance, you should be directed to the IdP login page.

