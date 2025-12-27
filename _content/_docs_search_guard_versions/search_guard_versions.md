---
title: Latest Releases
permalink: search-guard-versions
layout: docs
section: security
description: A list of the current Search Guard releases for all Elasticsearch 7 and
  Kibana 7 versions.
index_algolia: false
---
<!--- Copyright 2022 floragunn GmbH -->

# Search Guard Versions

This page lists all available versions of Search Guard.

<span style="color:red">If you are upgrading from older SG FLX versions to SG FLX 2.0.0 or higher, please review the [the upgrade guide](sg-200-upgrade). If you're using Helm Charts make sure to follow the [Helm upgrade guide](https://git.floragunn.com/search-guard/search-guard-flx-helm-charts/-/blob/main/docs/sg-2x-upgrade.md?ref_type=heads)</span>
{: .note .js-note .note-warning}

## Search Guard FLX

<table>
  <tr><th colspan=2 style="text-align:center; font-weight:400">Platform Independent</th></tr>
  <tr><td colspan=2 style="text-align:center"><a href="https://maven.search-guard.com//search-guard-flx-release/com/floragunn/sgctl/{{ site.sgversions.sgctl }}/sgctl-{{ site.sgversions.sgctl }}.sh">Search Guard control tool sgctl {{ site.sgversions.sgctl }}</a></td></tr>
</table>

### Search Guard FLX for Elasticsearch 9

{% include sgversions.html versions="search-guard-flx-9"%}

### Search Guard FLX for Elasticsearch 8

{% include sgversions.html versions="search-guard-flx-8"%}

### Search Guard FLX for Elasticsearch 7

{% include sgversions.html versions="search-guard-flx-7"%}

## Search Guard Classic

Non-FLX releases of Search Guard do not receive new features. Whenever possible, you should choose Search Guard FLX.

### Search Guard Suite 7

{% include sgversions_classic.html versions="search-guard-suite-7" majorversion="7" issuite=true title="Search Guard Suite 7, including Security and Alerting"%}

### Search Guard 7

{% include sgversions_classic.html versions="search-guard-7" majorversion="7" issuite=false title="Search Guard 7"%}

### Search Guard 6

{% include sgversions_classic.html versions="search-guard-6" majorversion="6" issuite=false title="Search Guard 6"%}