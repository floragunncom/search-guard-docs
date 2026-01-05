---
title: Authentication
html_title: Kibana Authentication
permalink: kibana-authentication
layout: docs
section: security
edition: community
description: Use the Search Guard Kibana plugin to add authentication and session management to Kibana.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Kibana authentication

Search Guard protects Kibana by adding authentication and authorization. You can use nearly all features that Search Guard provides for Elasticsearch also for Kibana.

In addition, Search Guard adds Multi-Tenancy to Kibana which makes it possible to store saved objects like dashboards and visualizations by tenant. Tenants can be configured per role.

## Installation

Please refer to the [Kibana plugin installation](kibana-plugin-installation) guide.

## Authentication

The Search Guard Kibana plugin supports the following authentication types:

* [HTTP Basic Authentication](kibana-authentication-http-basic)
* [Proxy Authentication](kibana-authentication-anonymous)
* [JSON web tokens](kibana-authentication-jwt)
* [OpenID Connect](kibana-authentication-openid)
* [SAML](kibana-authentication-saml)
* [Kerberos](kibana-authentication-kerberos)
* [Anonymous Authentication](kibana-authentication-anonymous)

## Multi-Tenancy

Please refer to the [Multi-Tenancy](kibana-multi-tenancy) guide.