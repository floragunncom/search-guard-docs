---
title: Authentication
html_title: Dashboards/Kibana Authentication
permalink: kibana-authentication
category: kibana
subcategory: kibana-authentication
order: 200
layout: docs
edition: community
description: Use the Search Guard Dashboards/Kibana plugin to add authentication and session management to Dashboards/Kibana.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Dashboards/Kibana authentication

Search Guard protects Dashboards/Kibana by adding authentication and authorization. You can use nearly all features that Search Guard provides for OpenSearch/Elasticsearch also for Dashboards/Kibana.

In addition, Search Guard adds multi-tenancy to Dashboards/Kibana which makes it prossible to store saved objects like dashboards and visualizations by tenant. Tenants can be configured per role.

## Installation

Please refer to the [Dashboards/Kibana plugin installation](kibana_installation.md) guide.

## Authentication

The Search Guard Dashboards/Kibana plugin supports the following authentication types:

* [HTTP Basic Authentication](kibana_authentication_basicauth.md)
* [Proxy Authentication](kibana_authentication_proxy.md)
* [JSON web tokens](kibana_authentication_jwt.md)
* [OpenID Connect](kibana_authentication_openid.md)
* [SAML](kibana_authentication_saml.md)
* [Kerberos](kibana_authentication_kerberos.md)
* [Anonymous Authentication](kibana_authentication_anonymous.md)

## Multi Tenancy

Please refer to the [Multi Tenancy](kibana_multitenancy.md) guide.