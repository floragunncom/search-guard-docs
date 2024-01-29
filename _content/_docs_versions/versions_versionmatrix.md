---
title: Latest Releases
permalink: search-guard-versions
category: versions
order: 100
layout: docs
description: A list of the current Search Guard releases for all Elasticsearch 7 and Kibana 7 versions.
index_algolia: false
---

<!--- Copyright 2022 floragunn GmbH -->

# Search Guard Versions

This page lists all available versions of Search Guard.

<b>Note:</b> The Kibana Multi Tenancy feature is not available in Search Guard 1.5.0. If you are using Multi Tenancy, please
do not upgrade to this version. The feature will be available again in the next upcoming Search Guard version. If you are not using
Multi Tenancy, you can upgrade to 1.5.0 safely.     
{: .note .js-note .note-warning}

## Search Guard FLX

<table>
  <tr><th colspan=2 style="text-align:center; font-weight:400">Platform Independent</th></tr>
  <tr><td colspan=2 style="text-align:center"><a href="https://maven.search-guard.com//search-guard-flx-release/com/floragunn/sgctl/{{ site.sgversions.sgctl }}/sgctl-{{ site.sgversions.sgctl }}.sh">Search Guard control tool sgctl {{ site.sgversions.sgctl }}</a></td></tr>
</table>

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