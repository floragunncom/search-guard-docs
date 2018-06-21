---
title: Kibana 6.x-10
slug: changelogs-kibana-6.x-10
category: changelog-details
order: 900
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-10
---

<!---
Copryight 2010 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-10

**Release Date: 07.02.2018**

### Fixes

* Input fields on the login screen were marked errourness when page loads for the first time
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/55](https://github.com/floragunncom/search-guard-kibana-plugin/issues/55){:target="_blank"}
* Config GUI not usable if base path is set
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/57](https://github.com/floragunncom/search-guard-kibana-plugin/issues/57){:target="_blank"}
* Use HTTP Basic Authentication credentials if already present in request
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/58](https://github.com/floragunncom/search-guard-kibana-plugin/issues/58){:target="_blank"}
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/45](https://github.com/floragunncom/search-guard-kibana-plugin/issues/45){:target="_blank"}
  * * Kibana: [Login not redirecting when global tenant is disabled](https://github.com/floragunncom/search-guard/issues/411){:target="_blank"}
* Unknown handler async in SG6-beta1 plugin when disabling basicauth
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/49](https://github.com/floragunncom/search-guard-kibana-plugin/issues/49){:target="_blank"}
* SG GUI management panel overlaps
  * [https://github.com/floragunncom/search-guard-kibana-plugin/issues/54](https://github.com/floragunncom/search-guard-kibana-plugin/issues/54){:target="_blank"}