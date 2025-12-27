---
title: Search Guard 7.x-53.4.0
permalink: changelog-searchguard-7x-53_4_0
layout: docs
section: security
description: Changelog for Search Guard 7.x-53.4.0
---
<!--- Copyright 2022 floragunn GmbH -->

# Search Guard Suite 53.4

**Release Date: 2022-07-15**

This is a bug fix release for two issues with Signals.

## Bug Fixes

### Issue with Node failover

When nodes are leaving the cluster it could happen that watches are no logger executed.

This update fixes this issue. 

**Details:**

* [Commit](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/commit/bada1cab5202003b6ae8ac46ecd68120d9ea7089){:target="_blank"}


### NPE when (re-)starting a node

When using signals the following error message occurred occasionally:

```
java.lang.NullPointerException: Cannot invoke "org.quartz.spi.OperableTrigger.getKey()" because "this.delegate" is null
```

This is now fixed.

**Details:**

* [Commit](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/commit/af2651a4eb382e8bb88b2be3940ddb58b6b01be5){:target="_blank"}