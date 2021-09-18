---
title: Kibana 7.x-49.1.0
permalink: changelog-kibana-7.x-49_1_0
category: changelogs-kibana
order: -309
layout: changelogs
description: Changelog for Kibana 7.x-49.1.0	
---

<!--- Copyright 2021 floragunn GmbH -->


# Search Guard Kibana Plugin 49.1

**Release Date: 2021-03-26**

The this is a maintenance release for the Search Guard Kibana Plugin which fixes a number of bugs. These are only relevant for specific setups. If you are using such setups and experience problems, then upgrading is recommended.

See below for details.

## `kibana.yml` Configuration 

We fixed multiple issues with the Kibana configuration which were introduced in SG 49.0. They are:

- Read the config if the path is declared in the environment variable.
- Read the config if the path is declared in the CLI arguments (-c/--config)
- Resolve environment variables declared in the config.

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/685)

## Kibana Session Cookie Settings

Fixed a regression where `searchguard.cookie.ttl: 0` in `kibana.yml` would invalidate the cookie immediately instead of setting the lifetime to the entire browser session.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/336)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/690) 

## Anonymous Authentication

Support for anonymous auth was broken and it wasn't possible to authenticate with an anonymous user. Fixed. 

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/344)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/687)

## OIDC Authentication

Fixed an issue with OIDC which would sometimes require Kibana to be restarted once before the authentication flow could be started.

Details: 

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/316)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/673)

## Multi Tenancy Index Migration

Fixed a problem where multi tenancy index migration was unstable on setups with a large number of tenants. 

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/315)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/670)