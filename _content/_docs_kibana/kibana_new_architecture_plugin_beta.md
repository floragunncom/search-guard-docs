---
title: Kibana new architecture plugin beta
slug: kibana-new-architecture-plugin-beta
category: kibana
order: 90
layout: docs
edition: community
description: How to enable the account overview page with the Search Guard Kibana.
---

<!---
Copyright 2020 floragunn GmbH
-->

# Kibana new architecture plugin beta
{: .no_toc}

It is the first beta version of the SG Kibana plugin based on the new Kibana architecture. Starting from version 7.9.0, Kibana migrated to a new core. It may not be visible from the end-user perspective, but the [core architecture](https://www.elastic.co/blog/introducing-a-new-architecture-for-kibana) is very different. Kibana removes the legacy core in the 7.11 version.

The current SG Kibana plugin version still uses the legacy core API. We work to convert our plugin to use the new core. And we are ready to present the beta version of the plugin. Look for it in our [maven repository](https://maven.search-guard.com/artifactory/webapp/#/artifacts/browse/tree/General/search-guard-kibana-plugin-release/com/floragunn/search-guard-kibana-plugin).

**Important:** To make the plugin work in Kibana, you must execute a patch after the installation.

## Patch

Linux and macOS
```
cd kibana/plugins/searchguard
./patches/patch_kibana.sh
```

Windows
```
cd kibana\plugins\searchguard
powershell -ExecutionPolicy Bypass -File .\patches\patch_kibana.ps1
```
