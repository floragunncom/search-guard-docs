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

# Search Guard v19

Release Date: 21.06.2018

## Features

* Update Guava to 25.1
* Do not serialize inner LdapEntry in LDAPUser
  * Fixes performance problems with huge LDAP entries
* DLS/FLS performance improvements
  * [https://github.com/floragunncom/search-guard-module-dlsfls/pull/5](https://github.com/floragunncom/search-guard-module-dlsfls/pull/5){:target="_blank"} 
  * Contributed by [salyh](https://github.com/salyh){:target="_blank"}   

