---
title: Overview
html_title: Authentication Types
permalink: kibana-authentication-types
category: kibana-authentication
order: 100
layout: docs
edition: community
description: A list of all Kibana authentication types supported by Search Guard. Protect Kibana from any unauthorized access.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Kibana Authentication Types
{: .no_toc}

With Search Guard, you can choose from several different modes of authenticating users in Kibana.

There are a number of general authentication approaches:

**Username/password-based authentication:** When using this approach, Search Guard displays a login form where the user enters a username and a password. These credentials are then validated against all Search Guard authentication domains (configured in `sg_authc.yml` or `sg_config.yml`). Thus, you can both use the [Search Guard internal user database](../_docs_roles_permissions/configuration_internalusers.md) and [LDAP](../_docs_auth_auth/auth_auth_ldap.md) to authenticate such users.  
[More details](kibana_authentication_basicauth.md)

**Browser-based Single-Sign-On authentication:** In this mode, the user is authenticated by a third-party website, like an Identity Provider (IdP) supporting the OIDC or SAML protocol. When an unauthenticated user tries to open Kibana in the web browser, Search Guard will redirect the user to the Identity Provider website, where the user is requested to log in. After successful authentication, the IdP will direct the user back to Kibana and provide cryptographically protected authorization information to Search Guard. As this approach requires web browser interactions, it is only available for Kibana, but not for direct connections to Elasticsearch.  

More details: [OIDC](kibana_authentication_openid.md), [SAML](kibana_authentication_saml.md)

**Header-based authentication:** This approach is only applicable in very special setups where authentication information is provided as HTTP headers in requests to Kibana. This requires special browser configurations or an additional proxy in front of the Kibana application.  
More details: [Proxy Authentication](kibana_authentication_proxy.md) (including authentication via JWT Authorization headers), [Kerberos](kibana_authentication_kerberos.md)

**Combining several approaches:** All of the approaches can also be used in combination. If several ways of authentication are configured, the Search Guard Kibana plugin will present the user a form to choose the desired authentication mode. It is also possible to run several Kibana instances in front of one Elasticsearch/Search Guard setup using different authentication configurations. [More details](kibana_authentication_multi_auth.md)

## Advanced Topics

Search Guard offers several advanced authentication mechanisms for special setups and requirements:

**Anonymous Authentication:** Allowing access to Kibana without having to provide credentials.  
[More details](kibana_authentication_anonymous.md)

**Customized Login Page:** Add your own branding to the Search Guard login page.
[More details](kibana_customize_login.md)

**JWT URL parameters:** For embedding read-only Kibana views in dashboard websites, Search Guard provides authentication via JWT URL parameters.   
[More details](kibana_authentication_jwt.md)
