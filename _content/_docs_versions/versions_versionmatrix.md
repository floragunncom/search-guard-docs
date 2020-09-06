---
title: Latest Releases
slug: search-guard-versions
category: versions
order: 100
layout: docs
description: A list of the current Search Guard releases for all Elasticsearch 7 and Kibana 7 versions.
index_algolia: false
---

<!--- Copyright 2020 floragunn GmbH -->

# Search Guard Versions

This page lists all available versions for Elasticsearch >= 6.0.0. For previous releases please refer to:

* [Search Guard 5 for Elasticsearch 5.x](/v5/search-guard-versions)

All versions are available on the Search Guard Maven repository:

* [Search Guard Maven Repository](https://maven.search-guard.com){:target="_blank"}

If you are upgrading from Elasticsearch 6.8.x to Elasticsearch >= 7.0.0, please read the [upgrade instructions to Elasticsearch 7.x](../_docs_installation/installation_upgrading_6_7.md). 

Please also refer to [Search Guard End of Life policy](../_docs_versions/versions_eol.md) to make sure that you are not running an outdated Search Guard version.

We need your help: We started to release the first beta versions of our  refactored Kibana plugin that is compatible with the Kibana "New Platform" architecture. [Give it a spin](kibana-new-platform-plugin-beta) and tell us what you think.
{: .note .js-note .note-warning}

{% include sgversions.html versions="search-guard-suite-7" majorversion="7" issuite=true title="Search Guard Suite 7, including Security and Alerting"%}

{% include sgversions.html versions="search-guard-7" majorversion="7" issuite=false title="Search Guard 7"%}

{% include sgversions.html versions="search-guard-6" majorversion="6" issuite=false title="Search Guard 6"%}