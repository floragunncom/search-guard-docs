---
title: Kibana new platform plugin beta
html_title: Kibana new platform plugin
slug: kibana-new-platform-plugin-beta
category: kibana
order: 150
layout: docs
edition: community
description: This is the first beta version of the Search Guard Kibana plugin running on the Kibana New Platform architecture.
---

<!---
Copyright 2020 floragunn GmbH
-->

# Kibana new platform plugin beta
{: .no_toc}

Starting from version 7.9.0, Kibana migrated to a new core architecture (called "New Platform"). It may not be visible from the end-user perspective, but the [core architecture](https://www.elastic.co/blog/introducing-a-new-architecture-for-kibana) is very different. Kibana will remove the legacy core in the 7.11 version.

This is the first beta version of the Search Guard Kibana plugin based on the new Kibana architecture. 

The current Search Guard Kibana plugin version still uses the legacy core API. We are working on converting our plugin to use the new core and are publishing beta versions for you to try. If you find any issue or bug, please provide your feedback on the [Search Guard forum](https://forum.search-guard.com/). 

Downloads:

* [7.9.0-43.0.0-beta-new-platform](https://maven.search-guard.co/search-guard-kibana-plugin-release/com/floragunn/search-guard-kibana-plugin/7.9.0-43.0.0-beta-new-platform/search-guard-kibana-plugin-7.9.0-43.0.0-beta-new-platform.zip)

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
