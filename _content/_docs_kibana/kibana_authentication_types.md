---
title: Overview
html_title: Authentication Types
permalink: kibana-authentication-types
category: kibana-authentication
order: 100
layout: docs
edition: community
description: A list of all Dashboards/Kibana authentication types supported by Search Guard. Protect Dashboards/Kibana from any unauthorized access.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Dashboards/Kibana Authentication Types
{: .no_toc}

You can choose from several different modes of authenticating users in Dashboards/Kibana.

**Username/password-based authentication:** When using this approach, Search Guard displays a login form where the user enters a username and a password. These credentials are then validated against all Search Guard authentication domains (configured in `sg_config.yml`). Thus, you can both use the [Search Guard internal user database](../_docs_roles_permissions/configuration_internalusers.md) and [LDAP](../_docs_auth_auth/auth_auth_ldap.md) to authenticate such users.  
[More details](kibana_authentication_basicauth.md)

**Browser-based Single-Sign-On authentication:** In this mode, the user is authenticated by a third-party website, like an Identity Provider (IdP) supporting the OIDC or SAML protocol. When an unauthenticated user tries to open Dashboards/Kibana in the web browser, Search Guard will redirect the user to the Identity Provider website, where the user is requested to log in. After successful authentication, the IdP will direct the user back to Dashboards/Kibana and provide cryptographically protected authorization information to Search Guard. This approach requires web browser interactions. It is only available for Dashboards/Kibana, but not for direct connections to OpenSearch/Elasticsearch.  
More details: [OIDC](kibana_authentication_openid.md), [SAML](kibana_authentication_saml.md)

**Header-based authentication:** This approach is only applicable in very special setups where authentication information is provided as HTTP headers in requests to Dashboards/Kibana. This requires special browser configurations or an additional proxy in front of the Dashboards/Kibana application.  
More details: [Proxy Authentication](kibana_authentication_proxy.md) (including authentication via JWT Authorization headers), [Kerberos](kibana_authentication_kerberos.md)

**Combining several approaches:** All of the approaches can also be used in combination. If several ways of authentication are configured, the Search Guard Dashboards/Kibana plugin will present the user a form to choose the desired authentication mode. It is also possible to run several Dashboards/Kibana instances in front of one OpenSearch/Elasticsearch/Search Guard setup using different authentication configurations. [More details](kibana_authentication_multi_auth.md)

## Advanced Topics

Search Guard offers several advanced authentication mechanisms for unique setups and requirements:

**Anonymous Authentication:** Allowing access to Dashboards/Kibana without having to provide credentials.  
[More details](kibana_authentication_anonymous.md)

**Customized Login Page:** Add your own branding to the Search Guard login page.
[More details](kibana_customize_login.md)

**JWT URL parameters:** For embedding read-only Dashboards/Kibana views in dashboard websites, Search Guard provides authentication via JWT URL parameters.   
[More details](kibana_authentication_jwt.md)