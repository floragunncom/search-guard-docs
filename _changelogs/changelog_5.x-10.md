---
title: Search Guard 5.x-10
slug: changelog-5-x-10
category: changelogs
order: 160
layout: changelogs
---
<!---
Copryight 2017 floragunn GmbH
-->

# Search Guard v10

Release Date: January 09, 2017

* Add missing auditlog hooks and configuration properties
* Fix possible class cast exception when logging on TRACE level
* Fix [XFF Proxies - documentation, default values and implementation inconsistention #255 ](https://github.com/floragunncom/search-guard/issues/255)
* Fix [Bug in XFFResolver.java - bad type of request #256 ](https://github.com/floragunncom/search-guard/issues/256)
* Fix Kerberos configuration examples
* Add username_attribute for http client cert authenticator
* Mark http host authenticator deprecated. Host based authentication is supported via roles_mapping.yml (and was always), [#214](https://github.com/floragunncom/search-guard/issues/214)
* Resolve index patterns correctly for DLS and FLS, changed default indices options to lenientExpandOpen, [#266](https://github.com/floragunncom/search-guard/issues/266)
* Add `--diagnose, --delete-config-index and --enable-shard-allocation` options to sgadmin
* Fix duplicated authorizers (clear authorizers on change)
* Fix [?pretty=true does not work #259](https://github.com/floragunncom/search-guard/issues/259)
* Fix default permissions in templates
 * [Kibana RO users need cluster indices:data/read* permissions #262](https://github.com/floragunncom/search-guard/issues/262)
 * [Kibana needs CLUSTER_MONITOR permission to #263](https://github.com/floragunncom/search-guard/issues/263)
 * [Logstash needs cluster:monitor/main permissions #267](https://github.com/floragunncom/search-guard/pull/267)
* Fix a problem with `authinfo` endpoint if an exception were raised (builder object was left in a dirty state) 
* Add missing searchguard.config_index_name property
* Add support for webhooks as auditlog destination