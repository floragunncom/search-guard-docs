---
title: Kibana 7.x-35.0.0
permalink: changelog-kibana-7x-35_0_0
category: changelogs-kibana
order: 950
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 7.x-35.0.0
---

<!---
Copyright 2020 floragunn GmbH
-->

# Search Guard Kibana Plugin 7.x-35.0.0

**Release Date: 07.05.2019**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Changes

* This is a compatibility release for 7.0.1 and Search Guard 7.x-35.0.0 which does not add new features

### Fix

Fix an issue with regards to Kibana multitenancy when upgrading from Elasticsearch 6. After upgrading the cluster the first attempt to start Kibana 7 may have failed with an "index template missing exception" error message.