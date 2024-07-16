---
title: Latest Releases
permalink: search-guard-versions
category: versions
order: 100
layout: docs
description: A list of the current Search Guard releases for all Elasticsearch 7 and Kibana 7 versions.
index_algolia: false
---

<!--- Copyright 2020 floragunn GmbH -->

# Search Guard Versions

This page lists all Search Guard releases for Elasticsearch 7. We highly recommend to switch to [Search Guard FLX](https://search-guard.com/docs/latest/search-guard-versions).

{: .note .js-note}

If you are upgrading from Elasticsearch 6.8.x to Elasticsearch 7, please read the [upgrade instructions to Elasticsearch 7.x](../_docs_installation/installation_upgrading_6_7.md). 

Please also refer to [Search Guard End of Life policy](../_docs_versions/versions_eol.md) to make sure that you are not running an outdated Search Guard version.

{% include sgversions.html versions="search-guard-suite-7" majorversion="7" issuite=true title="Search Guard Suite 7, including Security and Alerting"%}

{% include sgversions.html versions="search-guard-7" majorversion="7" issuite=false title="Search Guard 7"%}

{% include sgversions.html versions="search-guard-6" majorversion="6" issuite=false title="Search Guard 6"%}

## Older Releases

For previous releases please refer to:

* [Search Guard 5 for Elasticsearch 5.x](/v5/search-guard-versions)

All versions are available on the Search Guard Maven repository:

* [Search Guard Maven Repository](https://maven.search-guard.com){:target="_blank"}