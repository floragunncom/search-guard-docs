---
title: Search Guard 6.x-22
slug: changelog-6-x-22
category: changelogs
order: 700
layout: changelogs
description: Changelog for Search Guard 6.x-22
---

<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard 6.2.x-22.1 and Search Guard 6.1.x-22.2

Release Date: 27.04.2018

## Features

* Search Guard demo certificates rollover
  * [https://groups.google.com/forum/#!topic/search-guard/VJQqzxQXYFE](https://github.com/floragunncom/search-guard/issues/457https://groups.google.com/forum/#!topic/search-guard/VJQqzxQXYFE){:target="_blank"}

## Fixes

* Fixed permissions in Search Guard demo roles
  * [Insufficient permissions for Kibana Short Urls ](https://github.com/floragunncom/search-guard/issues/451)
* Fixed an issue where the Webhook Audit Log fails due to insufficient plugin permissions
  * (internally tracked)
* Fixed an issue where the JWKS/OpenID module fails when the JWT does not contain a `keyid`
  * (internally tracked)
* Fixed in issue in the Audit Log module where `audit_request_origin` is not logged for SSL Exceptions on Transport layer
  * (internally tracked)

# Kibana Plugin 6.x-12

Release Date: 12.04.2018

## Critical security fixes

See also: [Search Guard Security Issues](https://github.com/floragunncom/search-guard/wiki/Security-Issues){:target="_blank"}

### SISG 9
* A Kibana user could impersonate as _kibanaserver_ user when providing wrong credentials
* Conditions:
  * Kibana is configured to use Single-Sign-On as authentication method, one of Kerberos, JWT, Proxy, Client certificate
  * The _kibanaserver_ user is configured to use HTTP Basic as the authentication method
  * Search Guard is configured to use an SSO authentication domain and HTTP Basic at the same time
* Reported by Guy Moller
* Affected: Kibana Plugin >= 5.2.x  and Kibana plugin 6.x 
* Fixed with: Kibana Plugin 5.6.8-7 and Kibana Plugin 6.x-12

### SISG 8
* Redirect and XSS vulnerability in Kibana plugin
  * An attacker can redirect the user to a potentially malicious site upon Kibana login
* Reported by Vineet Kumar
* Affected: Kibana plugin 5.x and 6.x
* Fixed with: Kibana Plugin 5.6.8-7 and Kibana Plugin 6.x-12

## Fixes

* Fixed redirect-after-login when `basePath` is set
* Fixed license warning when using the Search Guard Community Edition

# Search Guard 6.x-22.0

Release Date: 27.03.2018

[Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)

## Fixes 
* DLS causing dashboards to fail for users that use DLS
  * [https://github.com/floragunncom/search-guard/issues/457](https://github.com/floragunncom/search-guard/issues/457){:target="_blank"}
  * DLS performance regression
* Search-guard failed to parse admin DN 
  * [https://github.com/floragunncom/search-guard/issues/454](https://github.com/floragunncom/search-guard/issues/454){:target="_blank"}
* Set trial license to 60 days, not 61
  * (internally tracked) 

## Features

* Added OpenID and JWKS support 
  * [https://docs.search-guard.com/latest/openid-json-web-keys](https://docs.search-guard.com/latest/openid-json-web-keys){:target="_blank"}

# Kibana Plugin 6.x-11

## Fixes 
* Disable password autocomplete on login form
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/82](https://github.com/floragunncom/search-guard-kibana-plugin/issues/82){:target="_blank"}
* Kibana error log "[index\_not\_found\_exception] no such index"
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/66](https://github.com/floragunncom/search-guard-kibana-plugin/issues/66){:target="_blank"}
* Session timeout leads to exception / dead links
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/53](https://github.com/floragunncom/search-guard-kibana-plugin/issues/53){:target="_blank"}
* After deleting an index from a role, auto-select the next existing
  * This fixes a minor GUI glitch when deleting the last index for a role
  * (internally tracked)
* LoginController: no this context when no tenants available 
  * If a user that tries to log in to Kibana has no available tenant, no error message was displayed 
  * (internally tracked)
* 6.2.x: Adapt to css changes 
  * Minor CSS fixes for the 6.2.x line  
  * (internally tracked)
* Search Guard configuration GUI enabled when is not
  * Made log statements more clear about the Config GUI being an enterprise feature 
  * [https://github.com/floragunncom/search-guard/issues/461](https://github.com/floragunncom/search-guard/issues/461){:target="_blank"}  

## Features

* Block system users from logging in to Kibana
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/81](https://github.com/floragunncom/search-guard-kibana-plugin/issues/81){:target="_blank"}  
* Support "View Dashboards Only mode"
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/48](https://github.com/floragunncom/search-guard-kibana-plugin/issues/48){:target="_blank"}
* Make it possible to select tenant by adding an HTTP header
  * This fix makes it possible to select the tenant when using the Kibana saved objects API 
  
  
# TLS Tool 1.2

## Fixes 
* Fix intermediate/root selection logic bug
  * [https://github.com/floragunncom/search-guard-tlstool/pull/1](https://github.com/floragunncom/search-guard-tlstool/pull/1){:target="_blank"}
  * Contributed by [Bas Smit](https://github.com/fbs){:target="_blank"} 