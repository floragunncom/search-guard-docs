---
title: Kibana 6.x-17
slug: changelog-kibana-6.x-17
category: changelogs-kibana
order: 550
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-17
---

<!---
Copryight 2010 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-17

**Release Date: 20.12.2018**

[Upgrade Guide to 6.5.x](../_docs/upgrading-6_5_0.md)

## Security Fixes

n/a

## Fixes

* SAML: IdP initiated SSO throws an error in Kibana (requires Search Guard v24 or newer)
  * The acsEndpoint to the authtoken call used by SAML was added
  * [PR #159](https://github.com/floragunncom/search-guard-kibana-plugin/pull/159){:target="_blank"}
* Monitoring Tab Cyclically Failing 
  * [Issue #561](https://github.com/floragunncom/search-guard/issues/561){:target="_blank"} 
  * [PR #148](https://github.com/floragunncom/search-guard-kibana-plugin/pull/148){:target="_blank"}
* Show open, share and reporting controls for RO-tenants
  * [PR #149](https://github.com/floragunncom/search-guard-kibana-plugin/pull/149){:target="_blank"}
* Fixed tenant preselection after failed tenant validation #150
  * [PR #150](https://github.com/floragunncom/search-guard-kibana-plugin/pull/150){:target="_blank"}
* Basic Auth: Ignore auth header if we already have a session cookie
  * [PR #153](https://github.com/floragunncom/search-guard-kibana-plugin/pull/153){:target="_blank"}
* Dev Tools show now a proper warning when the user does not have enough privileges
* Fix OpenID over HTTPS with self signed certificates
  * [PR #156](https://github.com/floragunncom/search-guard-kibana-plugin/pull/156){:target="_blank"}

## Features

* Spaces support
  * Search Guard is now compatible with Kibana Spaces
  * But is not yet compatible with Search Guard multitenancy feature
  * [PR #160](https://github.com/floragunncom/search-guard-kibana-plugin/pull/160){:target="_blank"}
* Allow HTML in login dialogue
  * Now HTML can be used to customize the login dialogue (title and subtitle)
  * [PR #158](https://github.com/floragunncom/search-guard-kibana-plugin/pull/158){:target="_blank"}
