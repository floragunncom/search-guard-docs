---
title: Kibana 7.x-42.0.0
permalink: changelog-kibana-7x-42_0_0
layout: docs
section: security
description: Changelog for Kibana 7.x-42.0.0
---
<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 01.06.2020**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7)

## New Features



### Signals UI

* Added checks execution and checks templates
<p />
<p />


## Improvements



### Search Guard UI

* We introduced debug switches for all authentication modules which help to pinpoint issues with SAML, OpenID or JWT
  * **WARNING**: If debug mode is enabled, sensitive information may be added to the Kibana log
  * **WARNING**: Do not use this in production
<p />


### Search Guard Kibana Plugin Core

* Remove cookie on IdP initiated logout
  * Fixed an issue where the Search Guard session cookie was not deleted properly while performing an IdP initiated logout
<p />


## Bug Fixes



### Signals UI

* Fix preview of Mustache templates
  * The preview of rendered Mustache templates in the Signals UI would sometimes not match the actual result
  * This was due to a mismatch of available attributes between backend and frontend
<p />


### Search Guard UI

* LDAP authentication domain not displayed
  * When a user configures an LDAP authentication domain with a different name than 'ldap', it was not displayed in the Search Guard configuration UI
  * This was a display-only problem
<p />


### Kibana Authentication and Multi-Tenancy

* Fix incorrect warning on tenant page
  * The page for selecting the active tenant would show a bogus warning if the user does not have administration privileges.
<p />


### Search Guard Kibana Plugin Core

* Fixed an issue where the Spaces selector gets stuck in loading state
  * This happens when a user selects a named tenant (i.e not the global tenant) and afterwards creates a new Space
<p />


