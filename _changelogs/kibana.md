---
title: Kibana Plugin
slug: changelog-5-kibana-plugin
category: changelogs
order: 500
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Kibana Plugin

## v5 (13 DEC 2017)
### Bugfixes
* X-Pack monitoring broken
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/43](https://github.com/floragunncom/search-guard-kibana-plugin/issues/43)

## v4 (3 AUG 2017)

### Bugfixes
* Errors at login page show password
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/39](https://github.com/floragunncom/search-guard-kibana-plugin/issues/39)
* Timeout on login / Private tenant auto-selected when disabled
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/34](https://github.com/floragunncom/search-guard-kibana-plugin/issues/34)
* Endless loading when using JWT and multitenancy in some cases
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/33](https://github.com/floragunncom/search-guard-kibana-plugin/issues/33)
* Kibana Status Endpoint not reachable 
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/31](https://github.com/floragunncom/search-guard-kibana-plugin/issues/31)

## v3 (20 JUN 2017)

### Features
* Proxy Authentication support 
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/23](https://github.com/floragunncom/search-guard-kibana-plugin/issues/23)
* Auto-select tenant by request parameter
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/24](https://github.com/floragunncom/search-guard-kibana-plugin/issues/24)
* Add preferred tenant to kibana.yml
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/27](https://github.com/floragunncom/search-guard-kibana-plugin/issues/27)

### Bugfixes
* Logout Button displayed when using SSO for authentication
  * [https://github.com/floragunncom/search-guard/issues/342](https://github.com/floragunncom/search-guard/issues/342)
* Global tenant selected as default even if disabled in config
  * [https://github.com/floragunncom/search-guard/issues/351](https://github.com/floragunncom/search-guard/issues/351)
* sg_tenant query param only works when user has RW perms
  * [https://github.com/floragunncom/search-guard/issues/353](https://github.com/floragunncom/search-guard/issues/353) 