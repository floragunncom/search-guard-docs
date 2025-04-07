---
title: Search Guard 7.x-43.0.0
permalink: changelog-searchguard-7x-43_0_0
layout: changelogs
description: Changelog for Search Guard 7.x-43.0.0
---
# Changelog for Search Guard 7.x-43.0.0

<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 06.07.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## New Features



### Search Guard Core

* Search Guard now provides functionality which allows reloading the used TLS certificates without restarting ES. This API is not enabled by default, but it can be enabled with a configuration setting. See [TLS Hot Reload](tls_hot_reload) for details.
<p />


## Improvements



### sgadmin

* The `sgadmin` and `hash` tools now write error messages to stderr instead of stdout. 
  * Contributed by [Fabien Wernli](https://github.com/faxm0dem)
<p />


## Bug Fixes



### Search Guard Core

* Fixed a bug which caused Search Guard to log many error messages during the first startup after installation.
<p />
* Added support for `indices:data/read/async_search/*` actions. This allows especially Kibana to use the async search API. The SG Kibana Plugin 42.0.0 contained a workaround which disabled the usage of the async search API. This however caused the number of hits of a search to be missing in some cases. As Search Guard now supports async search, this workaround is removed again. The number of hits is thus restored as well.
<p />


### Authentication / Authorisation

* Fixed permission problem where LDAP authentication could fail with `java.security.AccessControlException: access denied ("java.lang.RuntimePermission" "accessClassInPackage.com.sun.jndi.ldap.ext")`. 
<p />


## Other



### Authentication / Authorisation

* The permissions required for using SQL in ES are now cluster permissions, i.e., these permissions need to be configured in the `cluster_permission` section of the Search Guard configuaration. The permissions have been also added to the static action group `SGS_CLUSTER_COMPOSITE_OPS_RO`. *If you are already using SQL for ES with Search Guard, you might need to add the action group `SGS_CLUSTER_COMPOSITE_OPS_RO` to the corresponding roles of your Search Guard configuration.*
<p />


