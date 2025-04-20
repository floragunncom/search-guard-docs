---
title: Overview
html_title: Authentication
permalink: authentication-authorization
layout: docs
edition: community
description: How to configure, mix and chain authentication and authorization domains
  for Search Guard.
---
<!---
Copyright 2022 floragunn GmbH
-->
# Configuring authentication
{: .no_toc}


Search Guard offers you a great variety of different authentication modules and configuration options.

The basic configuration is often very simple; still, Search Guard offers powerful mechanisms to work with special use-cases and setups.

You can choose now:

- Do you want to jump directly to one of the "Quick Start" docs for a particular authentication mode?
  - [Password-based authentication](./auth_auth_httpbasic.md)
  - [LDAP and Active Directory](../_docs_auth_auth/auth_auth_ldap.md)
  - [JWT](../_docs_auth_auth/auth_auth_jwt.md)
- Or do you want to learn more about the [general configuration approach](../_docs_auth_auth/auth_auth_rest_config.md)?

**Note:** OIDC and SAML based authentication is only available for Kibana. See the documentation on [Kibana authentication](../docs_kibana/kibana_authentication.md) for details.


