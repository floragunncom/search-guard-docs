---
title: Kibana 6.x-16
slug: changelog-kibana-6.x-16
category: changelogs-kibana
order: 660
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-16
---

<!---
Copryight 2010 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-16

**Release Date: 20.11.2018**

## Security Fixes

* Fixed possible URL injection on login page when basePath is set
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/140](https://github.com/floragunncom/search-guard-kibana-plugin/pull/140){:target="_blank"} 

## Fixes

* Fix infinite redirect by introducing a loadbalancer URL
  * If a basepath is set, but Kibana was accessed directly (i.e. not using a proxy), the login page would end up in an infinite redirect loop
  * If a loadbalancer URL is set in kibana.yml, Search Guard wouls redirect to this URL, avoiding the infinite redirect
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/142](https://github.com/floragunncom/search-guard-kibana-plugin/pull/142){:target="_blank"}

* Fixed "could not locate index pattern" when GLOBAL tenant is disabled
  * Search Guard would falsely return a security exception for certain calls to the .kibana index
  * Prerequisites: The GLOBAL tenant is disabled, there is no .kibana index present and do not fail on forbidden is enabled
  * [https://github.com/floragunncom/search-guard/commit/bc858dcf16aed828b073d31d8f3a6744e5cf6e85](https://github.com/floragunncom/search-guard/commit/bc858dcf16aed828b073d31d8f3a6744e5cf6e85){:target="_blank"} 

* Improved check for AJAX requests when session has expired 
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/143](https://github.com/floragunncom/search-guard-kibana-plugin/pull/143){:target="_blank"} 
  
## Features

* Support anonymous access
  * If anonymous access is enabled in Search Guard, users can use Kibana without entering credentials
  * A "login" button is displayed to perform a regular login 
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/139](https://github.com/floragunncom/search-guard-kibana-plugin/pull/139){:target="_blank"}

* Add username to logout button
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/139](https://github.com/floragunncom/search-guard-kibana-plugin/pull/139){:target="_blank"} 
  * closes [https://github.com/floragunncom/search-guard/issues/563](https://github.com/floragunncom/search-guard/issues/563){:target="_blank"}

* Account info overview
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/146](https://github.com/floragunncom/search-guard-kibana-plugin/pull/146){:target="_blank"}  

* Secondary login button for third party IdPs
  * This feature makes it possible to use Basic Authentication alongside a third party IdPs
  * If enabled, a secondary login button is displayed on the login page which can be used to redirect to the third party IdP
  * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/145](https://github.com/floragunncom/search-guard-kibana-plugin/pull/145){:target="_blank"}

* Support for IdP-initated SAML SSO
   * [https://github.com/floragunncom/search-guard-kibana-plugin/pull/144](https://github.com/floragunncom/search-guard-kibana-plugin/pull/144){:target="_blank"}   
