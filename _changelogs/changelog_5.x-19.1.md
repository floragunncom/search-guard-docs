---
title: Search Guard 5.x-19.1
slug: changelog-5-x-19.1
category: changelogs
order: 80
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v19.1

Release Date: 21.06.2018

## Features

* Update Guava to 25.1
* Do not serialize inner LdapEntry in LDAPUser
  * Fixes performance problems with huge LDAP entries
* DLS/FLS performance improvements
  * [https://github.com/floragunncom/search-guard-module-dlsfls/pull/5](https://github.com/floragunncom/search-guard-module-dlsfls/pull/5){:target="_blank"} 
  * Contributed by [salyh](https://github.com/salyh){:target="_blank"}   
* Turn off query node cache for fls requests
  *  [https://github.com/floragunncom/search-guard/commit/285ac0d100d3fc2b21907fbfa7314d16c5f7bb86](https://github.com/floragunncom/search-guard/commit/285ac0d100d3fc2b21907fbfa7314d16c5f7bb86){:target="_blank"}   
* Add `searchguard.dynamic.multi_rolespan_enabled`
  * If set to true permissions on the same index that are defined in different roles are evaluated
  * Default is `false` (for backwards compatibility)

### sgadmin
* Allow disable of auto-expand and setting of replica count in single run
  * [https://github.com/floragunncom/search-guard/issues/500](https://github.com/floragunncom/search-guard/issues/500){:target="_blank"}
  * [https://github.com/floragunncom/search-guard/pull/503](https://github.com/floragunncom/search-guard/pull/503){:target="_blank"}

