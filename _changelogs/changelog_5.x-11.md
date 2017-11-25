---
title: Search Guard 5.x-11
slug: changelog-5-x-11
category: changelogs
order: 150
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v11

Release Date: February 16, 2017

* Fix dls/fls regex patterns ([SISG 6](https://github.com/floragunncom/search-guard/wiki/SecurityIssues))
* Changed default ldap configuration to match Active Directory setup
* Speed improvements for wildcard matcher
* Fix [msearch with multiple indices not allowed #243](https://github.com/floragunncom/search-guard/issues/243) by introducting "and_backendroles" [PR 247](https://github.com/floragunncom/search-guard/pull/247) by Wataru Takase
* [Use environment variables for sgadmin secrets #288](https://github.com/floragunncom/search-guard/pull/288) by Fabien Wernli
* Add options to hash.sh to read password from environment variable as well as interactively from the console
* [Provide mechanism to override the default interclusterrequest evaluation PR #269](https://github.com/floragunncom/search-guard/pull/269) by Jeff Cantrill
* [Proxy auth generates xff messages when used with basic auth #292](https://github.com/floragunncom/search-guard/issues/292) by adjusting loglevel 
* Add infrastructure for multi tenant capability
* Add write permissions to security policy for krb debug properties
* Fix [Reindexing fails on version 5.2](https://github.com/floragunncom/search-guard/issues/295)