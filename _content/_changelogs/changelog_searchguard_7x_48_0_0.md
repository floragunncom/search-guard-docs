---
title: Search Guard 7.x-48.0.0
permalink: changelog-searchguard-7x-48_0_0
layout: changelogs
description: Changelog for Search Guard 7.x-48.0.0
---
<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 04.12.2020**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7)

## Improvements



### Search Guard Core

This release brings support for Elasticsearch 7.10.0. The DLS/FLS functionality of Search Guard has been adapted to the new reader infrastructure of Elasticsearch. No configuration changes are necessary, though.

The point in time feature of Elasticsearch is however not yet completely supported by Search Guard. If you add the necessary permissions `indices:data/read/open_point_in_time` and `indices:data/read/close_point_in_time` as cluster permissions to a role, you can use the feature. However, the context IDs won't be owned by the current user, but can be used by any user.
<p />


