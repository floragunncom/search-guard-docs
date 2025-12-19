---
title: Search Guard 7.x-42.1.0
permalink: changelog-searchguard-7x-42_1_0
layout: docs
section: security
description: Changelog for Search Guard 7.x-42.1.0
---
# Changelog for Search Guard 7.x-42.1.0

<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 06.07.2020**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7)

## Bug Fixes



### Authentication / Authorisation

* Fixed permission problem where LDAP authentication could fail with `java.security.AccessControlException: access denied ("java.lang.RuntimePermission" "accessClassInPackage.com.sun.jndi.ldap.ext")`. 
<p />


### Multi-Tenancy

* Since SG 42, using Kibana with a non-default tenant could show the error `No index-level perm match for User ... Action [indices:data/read/mget[shard]]`. This would only happen if the corresponding `.kibana` index went through migration at least once.
<p />


