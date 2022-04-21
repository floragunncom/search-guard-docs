---
title: Search Guard 7.x-53.2.0
permalink: changelog-searchguard-7x-53_2_0
category: changelogs-searchguard
order: -420
layout: changelogs
description: Changelog for Search Guard 7.x-53.2.0
---

<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 53.2

**Release Date: 2022-04-21**

This is a bug fix for the multi-tenancy implementation of Search Guard 53.0 and 53.1 for Elasticsearch 7.10.2.

If you are not using Elasticsearch 7.10.2 or Search Guard 53.x, you do not need this update.

## Bug Fixes

### Issues with index templates for the Kibana index

Search Guard 53.0 for Elasticsearch 7.10.2 introduced an issue where switching to newly created tenants failed with various error messages.

This update fixes this issue. 

**Note:** You need to restart Kibana in order to finalize the update.