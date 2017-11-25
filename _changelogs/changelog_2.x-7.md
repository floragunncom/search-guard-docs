---
title: Search Guard 2.x
slug: changelog-2-x
category: changelogs
order: 190
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v7

Release Date: October 04, 2016

* Add support for ES 2.4.1
* Fix [Error with _upgrade API #208](https://github.com/floragunncom/search-guard/issues/208) 
* Revised [Using aliases allow access to all index data #190](https://github.com/floragunncom/search-guard/issues/190) 
* Fix [Setting an Authorization header in transport client requests #207](https://github.com/floragunncom/search-guard/issues/207) 
* Merged PR [Feature/rest api #210](https://github.com/floragunncom/search-guard/pull/210)
* Merged PR [Use username variable at indices sections in sg_roles.yml #169](https://github.com/floragunncom/search-guard/pull/169) - Thx @wtakase

# Search Guard v6

Release Date: September 16, 2016

* Add support for ES 2.4.0
* Make search guard initialization and sgadmin more verbose and more robust
 * Fix [#178](https://github.com/floragunncom/search-guard/issues/178)
 * Fix [#182](https://github.com/floragunncom/search-guard/issues/182)
 * Fix [#199](https://github.com/floragunncom/search-guard/issues/199)
 * Fix [#203](https://github.com/floragunncom/search-guard/issues/203)
* Fixed an LDAP serialization issue
 * Fix [#206](https://github.com/floragunncom/search-guard/issues/206)
* Added tribe node support
 * [Tribe nodes](https://github.com/floragunncom/search-guard-docs/blob/master/tribenodes.md)
* Snapshot/restore now possible with admin certificate
 * Fix [#147](https://github.com/floragunncom/search-guard/issues/147)
* Manual and automatic [replica shard management](https://floragunn.com/search-guard-index-replica-shards/)
 * Fix [204](https://github.com/floragunncom/search-guard/issues/204)
* Configurable Search Guard index name
 * Fix [176](https://github.com/floragunncom/search-guard/issues/176)
* [Restructured Search Guard Documentation](https://github.com/floragunncom/search-guard-docs)

# Search Guard v5

Release Date: August 10, 2016

* Make search guard initialization and sgadmin more verbose and more robust. Related to [#178](https://github.com/floragunncom/search-guard/issues/178) [#182](https://github.com/floragunncom/search-guard/issues/182)
 * Catch "No Master Exception", This makes sure that Search Guard keeps on trying to initialize itself.
 * Makes sure that sgadmin does not quit if there is no master.
 * Make sgadmin more verbose and messages more consistent.

# Search Guard v4

Release Date: July 31, 2016

* Make sgadmin more verbose and make it checking if updates succeed
* Do not set a default HTTP authenticator. This can lead to unintended configuration behaviour where the http authentication gets mixed with transport layer authentication.
* Replace unsafe Arrays.hash() method with SHA-256 hash to cope with [#186](https://github.com/floragunncom/search-guard/issues/186)
* Fix possible deserialization vulnerability

# Search Guard v3

Release Date: July 16, 2016

* Fix [Searchguard doens't fail over with Multiple authc defined #166](https://github.com/floragunncom/search-guard/issues/166)
* Allow node client to connect. This is needed for full tribe node support (related to [#128](https://github.com/floragunncom/search-guard/issues/128) and [#47](https://github.com/floragunncom/search-guard/issues/47)).
* Support configurable OID ([PR #168](https://github.com/floragunncom/search-guard/pull/168), thx @wtakase)
* Fixed [sgadmin.sh requires truststore and keystore to have file extention .jks to be parsed as JKS type #152](https://github.com/floragunncom/search-guard/issues/152)
* Improve reliability of sgadmin config updates ([#113](https://github.com/floragunncom/search-guard/issues/113) [#144](https://github.com/floragunncom/search-guard/issues/144))
* Fixed [indices:admin/create requires a wildcard #155](https://github.com/floragunncom/search-guard/issues/155)
* Do not authenticate request with HTTP method == OPTIONS
* Fixed [Can't delete templates #163](https://github.com/floragunncom/search-guard/issues/163)

# Search Guard v2

Release Date: June 30, 2016

* sgadmin: fix export format to be yaml (instead of json)
* Fixed [ElasticSearch failed to list shard for shard_store after restarting nodes. #164](https://github.com/floragunncom/search-guard/issues/164)
* Fixed [Roles from proxy role header are ignored #150](https://github.com/floragunncom/search-guard/issues/150)
* HTTPHostAuthenticator added
* make initalization of a node more stable
* sgadmin: config reload option added
* sgadmin: change replica count for the searchguard index now possible

# Search Guard v1

Release Date: June 17, 2016

## Version 1 (17 JUN 16)

* First release