---
title: Search Guard 7.x-38.0.0
permalink: changelog-searchguard-7x-38_0_0
layout: changelogs
description: Changelog for Search Guard 7.x-38.0.0
---
<!--- Copyright 2020 floragunn GmbH -->

# Changelog for Search Guard 7.x-38.0.0

**Release Date: 24.12.2019**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7)

## Security Fixes 

n/a

## Features

* Add Proxy2 auth module which provides support for client cert trust and additional attributes
  
## Fixes

* Trigger AuditLog when immutable index access attempted
* [BREAKING] HTTP return code changed from 409 to 403 when access to immutable index is attempted



