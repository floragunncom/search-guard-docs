---
title: Search Guard 7.x-53.4.0
permalink: changelog-searchguard-7x-53_4_0
category: changelogs-searchguard
order: -420
layout: changelogs
description: Changelog for Search Guard 7.x-53.4.0
---

<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 53.4

**Release Date: 2022-07-15**

This is a bug fix release for two issues with Signals.

## Bug Fixes

### Issue with Node failover

When nodes are leaving the cluster it could happen that watches are no logger executed.

This update fixes this issue. 

### NPE when (re-)starting a node

When using signals the following error message occurred occasionally:

```
java.lang.NullPointerException: Cannot invoke "org.quartz.spi.OperableTrigger.getKey()" because "this.delegate" is null
```

This is now fixed.