---
title: Kibana 6.x-12
slug: changelog-kibana-6.x-12
category: changelogs-kibana
order: 800
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 6.x-12
---

<!---
Copryight 2010 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-12

**Release Date: 12.04.2018**

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
