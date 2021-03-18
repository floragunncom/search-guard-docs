---
title: Kibana 7.x-50.0.0
slug: changelog-kibana-7.x-50_0_0
category: changelogs-kibana
order: -300
layout: changelogs
description: Changelog for Kibana 7.x-50.0.0	
---

<!--- Copyright 2021 floragunn GmbH -->


# Search Guard Kibana Plugin 50.0

**Release Date: 2021-03-18**

The new release of Search Guard brings support for Elasticsearch 7.11. Please note that we can only support Elasticsearch 7.11.1 and 7.11.2. Elasticsearch 7.11.0 is unsupported due to a [problem in the artifacts publication](https://github.com/elastic/elasticsearch/pull/68926) at Elastic.

For Kibana, this is primarily a maintenance release which brings a number of bugfixes and small improvements.

See below for details.

## Breaking Changes

The default value for the Kibana session cookie timeout was changed; originally, the session would have a fixed timeout after 1 hour. Now, it defaults to the browser session, which means that the session is closed as soon as the browser window is closed. See [below](#kibana-session-cookie-settings) for details.

## `kibana.yml` Configuration 

We fixed multiple issues with the Kibana configuration which were introduced in ES 49.0. They are:

- Read the config if the path is declared in the environment variable.
- Read the config if the path is declared in the CLI arguments (-c/--config)
- Resolve environment variables declared in the config.

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/685)

## Kibana Session Cookie Settings

Fixed a regression where `searchguard.cookie.ttl: 0` in `kibana.yml` would invalidate the cookie immediately instead of setting the lifetime to the entire browser session.

Additionally, the default cookie lifetime was changed from one hour to the browser session. This is a more expected default value.

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