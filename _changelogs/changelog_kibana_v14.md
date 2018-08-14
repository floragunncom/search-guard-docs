---
title: Kibana 6.x-14
slug: changelog-kibana-6.x-14
category: changelogs-kibana
order: 700
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-14
---

<!---
Copryight 2010 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-14

**Release Date: 13.08.2018**

## Features
* Add full support for SAML Single Sign On
  * [Documentation](/latest/kibana-authentication-saml){:target="_blank"} 
* Add full support for OpenID Single Sign On
  * [Documentation](/latest/kibana-authentication-openid){:target="_blank"}  
* Add full support for Kerberos
  * [Documentation](/latest/kibana-authentication-kerberos){:target="_blank"}  
* Make it possible to redirect to an URL when a JWT expires
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/116](https://github.com/floragunncom/search-guard-kibana-plugin/pull/116){:target="_blank"} 
* Check that X-Pack security is disabled if it is installed
  * [Documentation](/latest/kibana-authentication-jwt#login-url){:target="_blank"} 
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/107](https://github.com/floragunncom/search-guard-kibana-plugin/pull/107){:target="_blank"}
 
## Fixes

* Fix erroneous redirect after logout
  * The telemetry opt-out popup would sometimes cause a erroneous redirect on the logout page
  *  [https://github.com/floragunncom/search-guard-kibana-plugin/pull/126](https://github.com/floragunncom/search-guard-kibana-plugin/pull/126){:target="_blank"}
* Improve handling of non-existing indices or wildcards
  * If users would enter a non-existing index, they had to click on the entry in the dropdown for the value to be accepted
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/125](https://github.com/floragunncom/search-guard-kibana-plugin/pull/125){:target="_blank"}
* Fix an issue where the plugin would crash while checking for session timeout    
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/121] (https://github.com/floragunncom/search-guard-kibana-plugin/pull/121){:target="_blank"}
  * [https://github.com/floragunncom/search-guard/issues/535](https://github.com/floragunncom/search-guard/issues/535)
* Fix links that have a regex as one of the parameters
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/119](https://github.com/floragunncom/search-guard-kibana-plugin/pull/119){:target="_blank"}
* Setting private tenant as preferred
  * Under some circumstances it was not possible to set private tenant as preferred tenant
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/118](https://github.com/floragunncom/search-guard-kibana-plugin/pull/118){:target="_blank"}
* Select global tenant when preferred tenant is set
  * When a preferred tenant was used, under some circumstances the global tenant could not be selected
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/118](https://github.com/floragunncom/search-guard-kibana-plugin/pull/118){:target="_blank"}
* Fix session timeout
  * This PR fixes a regression where the session would not be extended as configured.
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/117](https://github.com/floragunncom/search-guard-kibana-plugin/pull/117){:target="_blank"}
* Fix case sensitivity for JWTs in URLs
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/115](https://github.com/floragunncom/search-guard-kibana-plugin/pull/115){:target="_blank"}
* Fix short links in share URLs
  * Fixes an issue where converting a snapshot URL wouldn't work anymore
  * Also fixes an issue where the iframe embed code was broken
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/100](https://github.com/floragunncom/search-guard-kibana-plugin/pull/100){:target="_blank"}   
