---
title: Authentication
html_title: Kibana Authentication
permalink: kibana-authentication
category: kibana
subcategory: kibana-authentication
order: 200
layout: docs
edition: community
description: Use the Search Guard Kibana plugin to add authentication and session management to Kibana.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Kibana authentication

Search Guard protects Kibana by adding authentication and authorization. You can use nearly all features that Search Guard provides for Elasticsearch also for Kibana.

In addition, Search Guard adds multi-tenancy to Kibana which makes it prossible to store saved objects like dashboards and visualizations by tenant. Tenants can be configured per role.

## Installation

Please refer to the [Kibana plugin installation](kibana_installation.md) guide.

## Authentication

The Search Guard Kibana plugin supports the following authentication types:

* [HTTP Basic Authentication](kibana_authentication_basicauth.md)
* [Proxy Authentication](kibana_authentication_proxy.md)
* [JSON web tokens](kibana_authentication_jwt.md)
* [OpenID Connect](kibana_authentication_openid.md)
* [SAML](kibana_authentication_saml.md)
* [Kerberos](kibana_authentication_kerberos.md)
* [Anonymous Authentication](kibana_authentication_anonymous.md)

## Multi Tenancy

Please refer to the [Multi Tenancy](kibana_multitenancy.md) guide.