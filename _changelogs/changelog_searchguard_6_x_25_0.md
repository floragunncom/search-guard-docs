---
title: Search Guard 6.x-25.0
slug: changelog-searchguard-6-x-25_0
category: changelogs-searchguard
order: 450
layout: changelogs
description: Changelog for Search Guard 6.x-25.0
---

<!---
Copryight 2019 floragunn GmbH
-->

# Search Guard 6.x-25.0

**Release Date: 24.04.2019**

* [Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)
* [Upgrade Guide to 6.5.x](../_docs/upgrading-6_5_0.md)

## Security Fixes 

n/a
  
## Fixes 

### Search Guard

* [BREAKING] Align transport impersonation with rest impersonation [#684](https://github.com/floragunncom/search-guard/issues/684){:target="_blank"}
* Fix an issue where user attributes are not populated in case of impersonation [Credits @turettn] [#678](https://github.com/floragunncom/search-guard/issues/678){:target="_blank"}  
* Fix "X-Opaque-Id header not propagated when using SearchGuard" [#669](https://github.com/floragunncom/search-guard/issues/669){:target="_blank"}
* Fix an issue where the CCS index patterns could to be created in Kibana [#675](https://github.com/floragunncom/search-guard/issues/675){:target="_blank"}
* Update Bouncy Castle dependency to 1.61 - For ES 6.5 and higher [#682](https://github.com/floragunncom/search-guard/issues/682){:target="_blank"}
* Don't allow anyone to freeze the searchguard index or update mapping, settings or aliases [#683](https://github.com/floragunncom/search-guard/issues/683){:target="_blank"}
* Also fix a bug where "searchguard.unsupported.restore.sgindex.enabled" was not working correctly [#683](https://github.com/floragunncom/search-guard/issues/683){:target="_blank"}

### sgadmin

* Fix sgadmin swallows stderr + show more details in case of config parse exceptions [#679](https://github.com/floragunncom/search-guard/issues/679){:target="_blank"}
  
### Kerberos

* Reduce loglevel of Kerberos GSSException [#43](https://github.com/floragunncom/search-guard-enterprise-modules/issues/43){:target="_blank"}

### JWT

* JWT signature validation adopted to JWK without alg header [#44](https://github.com/floragunncom/search-guard-enterprise-modules/issues/44){:target="_blank"}

### DLS

* Allow DLS query with date-math [#677](https://github.com/floragunncom/search-guard/issues/677){:target="_blank"}

### Snapshot/Restore 

* Better error message if 'rename_pattern' during snapshot restore is invalid [#663](https://github.com/floragunncom/search-guard/issues/663){:target="_blank"}

## Features

* Support environment variables in sg_*.yml files to make them passwordless [#676](https://github.com/floragunncom/search-guard/issues/676){:target="_blank"}
* Introduce authentication rate limiting feature to prevent brute force attacks [#685](https://github.com/floragunncom/search-guard/issues/685){:target="_blank"}
* Return empty result instead of 403 when no indices permitted an dnfof is enabled [#680](https://github.com/floragunncom/search-guard/issues/680){:target="_blank"}

