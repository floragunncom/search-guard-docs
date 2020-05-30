---
title: Kibana 7.x-42.0.0
slug: changelog-kibana-7.x-42_0_0
category: changelogs-kibana
order: 500
layout: changelogs
description: Changelog for Kibana 7.x-42.0.0	
---

<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 30.05.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## New Features



### Signals UI

* Add checks execution and checks templates
  * Issue number SGD-311
<p />
* Add code editor to set checks in each action
  * Issue number SGD-310
<p />


### Kibana Core

* Broken side navigation
  * Fixed an issue where the side navigation displays the Search Guard icons too large
  * Issue number SGD-475
<p />


## Improvements



### Search Guard UI

* Introduce debug switches for all our sub-modules
  * We introduced debug switches for all authentication modules which help to pinpoint issues with SAML, OpenID or JWT
  * **WARNING**: If debug mode is enabled, sensitive information may be added to the Kibana log
  * **WARNING**: Do not use this in production
  * Issue number SGD-35
<p />


### Kibana Core

* SAML: Remove cookies on IdP-Initiated logout
  * * Fixed an issue where the Search Guard session cookie was not deleted while performing an IdP initiated logout
  * Issue number SGD-502
<p />


## Bug Fixes



### Search Guard UI

* LDAP domain with a name different than "ldap" is not displayed in the Search Guard UI
  * When a user configures an LDAP authentication domain with a different name than 'ldap', it was not displayed in the Search Guard configuration UI
  * This was a display-only problem
  * Issue number SGD-456
<p />


### Kibana Core

* Spaces selector is stuck in loading state
  * Fixed an issue where the Spaces selector gets stuck in loading state
  * This happens when a user selects a named tenant (i.e not the global tenant) and afterwards creates a new Space
  * Issue number SGD-495
<p />
* Deprecated ui/registry/feature_catalogue
  * Fixed an issue where Kibana sometimes would not start due to the now deprecated ui/registry/feature_catalogue
  * Issue number SGD-474
<p />
* Deprecated dashboard_config 
  * Fixed an issue where Kibana would not start due to the deprecated dashboard_config settings
  * Issue number SGD-473
<p />


