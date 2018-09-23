---
title: Search Guard 6.x-23.1
slug: changelog-searchguard-6-x-23_1
category: changelogs-searchguard
order: 550
layout: changelogs
description: Changelog for Search Guard 6.x-23.1
---

<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard 6.x-23.1

Release Date: 25.09.2018

[Upgrade Guide from 5.x to 6.x](../_docs/upgrading_5_6.md)

## Security Fixes 

### Search Guard

* Field anonymization: Fixed an issue where fields could leak when using aggregations
  * [https://github.com/floragunncom/search-guard-enterprise-modules/tree/ITT-1563](https://github.com/floragunncom/search-guard-enterprise-modules/tree/ITT-1563){:target="_blank"}  
* **BREAKING**: Removed password hashes from REST API users endpoint
  * Reporter: Thorsten Lutz, [SySS GmbH](https://www.syss.de/){:target="_blank"}  
  * Advisory ID: SYSS-2018-025
  * Risk Level: Low

## Fixes 

### Search Guard

* Added additional permissions to sg_logstash role
  * Reporter: [Matej Zerovnik](https://github.com/matejzero){:target="_blank"} 
  * [https://github.com/floragunncom/search-guard/pull/542](https://github.com/floragunncom/search-guard/pull/542){:target="_blank"}
* Regression: Snapshot restore against client nodes not working
  * [https://github.com/floragunncom/search-guard/issues/476](https://github.com/floragunncom/search-guard/issues/476){:target="_blank"}  
* Regression: Reducing indices to only allowed indices not working with multiple roles
  * When using multiple roles that grant access to different indices, the "do not fail on forbidden" feature would not work correctly when using aliases with wildcards on these indices. This affects mainly Kibana users.
  * This was fixed in the compliance edition code tree and is now working consistently in the new merged code trees as well
* Reducing aliases to only allowed indices not working with multiple roles
  * When using aliases with wildcards, Search Guard would not always reduce the indices to the allowed indices correctly when using the "do not fail on forbidden" feature. This affects mainly Kibana users.
* License keys generated with new code signing key not working
* SAML module would not be listed as enterprise module on _searchguard/license HTTP endpoint  

### JWT
* **BREAKING**: The JWT module now requires a minimum shared secret length of 32 characters
  * This is mandated by the JWT specification, so it should only affect non-spec conformant use cases