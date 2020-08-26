---
title: Kibana new platform plugin beta
slug: kibana-new-platform-plugin-beta
category: kibana
order: 150
layout: docs
edition: community
description: How to enable the account overview page with the Search Guard Kibana.
---

<!---
Copyright 2020 floragunn GmbH
-->

# Kibana new platform plugin beta
{: .no_toc}

Starting from version 7.9.0, Kibana migrated to a new core. It maybe not visible from the end-user perspective, but the [core architecture](https://www.elastic.co/blog/introducing-a-new-architecture-for-kibana) is very different. The legacy core will be eradicated in the 7.11 version.

The current SG Kibana plugin version still uses the legacy core API. We work to convert our plugin to use the new core. And we are ready to present the beta version of the plugin. Look for it in our [maven repository](https://maven.search-guard.com/artifactory/webapp/#/artifacts/browse/tree/General/search-guard-kibana-plugin-release/com/floragunn/search-guard-kibana-plugin).

Notice, to make the plugin work in Kibana; one must execute a patch after the installation.

Linux and macOS:
```
cd kibana/plugins/searchguard
./patches/patch_kibana.sh
```

Windows
```
cd kibana\plugins\searchguard
powershell -ExecutionPolicy Bypass -File .\patches\patch_kibana.ps1
```