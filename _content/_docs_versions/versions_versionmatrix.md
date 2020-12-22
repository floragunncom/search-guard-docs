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

This page lists all available versions of Search Guard. If you are upgrading from Elasticsearch 6.8.x to Elasticsearch 7, please read the [upgrade instructions to Elasticsearch 7.x](../_docs_installation/installation_upgrading_6_7.md). 

Please also refer to [Search Guard End of Life policy](../_docs_versions/versions_eol.md) to make sure that you are not running an outdated Search Guard version.

**Feature Preview:**<br>We are offering beta versions of important new features.<br><br>**[Search Guard Auth Tokens:](../_docs_auth_auth/auth_auth_sg_auth_token.md)**<br>This new feature allows Search Guard users to create auth tokens. Such tokens can be used to give authentication credentials to external applications, scripts, etc., without having to use a password. Auth tokens can have a limited set of permissions, a limited lifetime and can be revoked by the user.<br>Download: [Search Guard Plugin for ES 7.10.1 (Beta 2)](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.10.1-authtoken.beta2/)<br>Docs: [Search Guard Auth Tokens](../_docs_auth_auth/auth_auth_sg_auth_token.md)
{: .note .js-note .note-warning}


{% include sgversions.html versions="search-guard-suite-7" majorversion="7" issuite=true title="Search Guard Suite 7, including Security and Alerting"%}

{% include sgversions.html versions="search-guard-7" majorversion="7" issuite=false title="Search Guard 7"%}

{% include sgversions.html versions="search-guard-6" majorversion="6" issuite=false title="Search Guard 6"%}

## Older Releases

For previous releases please refer to:

* [Search Guard 5 for Elasticsearch 5.x](/v5/search-guard-versions)

All versions are available on the Search Guard Maven repository:

* [Search Guard Maven Repository](https://maven.search-guard.com){:target="_blank"}