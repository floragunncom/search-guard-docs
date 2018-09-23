---
title: Search Guard 6.x-23.0
slug: changelog-searchguard-6-x-23_0
category: changelogs-searchguard
order: 600
layout: changelogs
description: Changelog for Search Guard 6.x-23.0
---

<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard 6.x-23.0

Release Date: 14.08.2018

[Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)

## Fixes 

### Search Guard

* Corrected log statement for Basic Authenticator and 401 replies
  * [https://github.com/floragunncom/search-guard/pull/520](https://github.com/floragunncom/search-guard/pull/520){:target="_blank"}  


## Features

### Search Guard

* Added full support for SAML
  * [SAML documentation](/latest/saml-authentication){:target="_blank"}  
* Use internal user database as authorizer
  * [Documentation](/latest/internal-users-database#authorization){:target="_blank"}
  * [https://github.com/floragunncom/search-guard/pull/475](https://github.com/floragunncom/search-guard/pull/475){:target="_blank"}
* Add logged in user to log4j thread context
  * Makes it possible to add the user name to each log statement for improved debugging
  * Makes it possible to filter log statements by user name, which makes debugging Kibana permission issues easier by filtering the Kibana server user
  * [Documentation](/latest/troubleshooting-setting-log-level){:target="_blank"}
  * [https://github.com/floragunncom/search-guard/pull/534](https://github.com/floragunncom/search-guard/pull/534){:target="_blank"}

### Proxy authentication
* Make the role separator configurable
  * addresses [https://github.com/floragunncom/search-guard/issues/456](https://github.com/floragunncom/search-guard/issues/456){:target="_blank"} 
   