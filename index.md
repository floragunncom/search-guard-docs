---
title: Search Guard Documentation
html_title: Documentation
slug: index
layout: docs
description: Official documentation for Search Guard FLX, the enterprise security and alerting suite for Elasticsearch.
showsearch: true
isroot: true
---
<!---
Copryight 2020 floragunn GmbH
-->


<p align="center">
<img src="img/logos/search-guard-frontmatter.png" alt="Search Guard - Security for Elasticsearch" style="width: 40%" />
</p>

<h2 align="center">Security and Alerting for Elasticsearch and OpenSearch</h2>

<h1 align="center">Search Guard FLX Documentation</h1>

Welcome to Search Guard FLX, the next generation of Search Guard! 

Please note that Search Guard FLX is a beta version, which might be not yet ready for use in production systems. It might have bugs. 

## What's New

Search Guard FLX brings a number of fundamental improvements and updates to Search Guard. These require breaking changes in the configuration format.

Major changes include:

- The first version of Search Guard which brings support for **OpenSearch** and **OpenSearch Dashboards**.
- Completely new approach for configuring authentication. **The new configuration format is more coherent, more predictable and much more powerful.** Simple setups require very little configuration; very complex setups are possible by straight-forward configuration. If something goes wrong, Search Guard provides extensive error messages and diagnostic information.
- Completely new approach for logging into Dashboards/Kibana. **Logged in users now get an actual server-side session.** This fixes a number of issues, such as:
  - Issues with cookies exceeding the browser size limit.
  - The "logout" menu item is able to invalidate the session. Thus, session cookies cannot be re-used any more.
  - Configuration of SSO using OIDC or SAML for Dashboards/Kibana no longer interfers with backend authentication configuration. Thus, you can now have challenging basic authentication on the backend while using OIDC or SAML for Dashboards/Kibana.
  - The configuration format is now more streamlined and consistent.  
  - Dashboards/Kibana authentication configuration can be changed without having to restart the node.
- **New administration tool** `sgctl` which shall replace `sgadmin`.  `sgctl` is stateful; that means, you can define connection profiles once and use these later. Thus, you don't have to specify all connection configuration on each invocation. The interface of `sgctl` is more streamlined and offers you improved configuration validation functionality.
- **Wildcard queries without hassle** made possible by an improved method for handling unauthorized indices. You no longer have to worry that your wildcard query breaks because it might pick up an index you don't have permissions for.
- **More speed.** Many components of Search Guard underwent major optimizations. Thus, Search Guard FLX can now handle more throughput with a lower CPU footprint.
- **Easily reachable diagnostics and metrics;** most modules of Search Guard FLX offer debug modes which deliver diagnostic information right at the place where you operate. You no longer have to grep through logfiles to find out why your OIDC authentication is not working.

## Download

You can get the current snapshot of the Search Guard Tech Preview at the following locations. If you chose to use the demo installer, you just need to download the script. The script will take care of downloading all further components.

|Target Platform|Backend Plugin|Frontend Plugin|Demo Installer|
|---|---|---|---|
|**OpenSearch 1.3.2**|[Search Guard OpenSearch Plugin Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-opensearch-plugin/1.0.0-beta-2-os-1.3.2/search-guard-flx-opensearch-plugin-1.0.0-beta-2-os-1.3.2.zip)|[Search Guard OpenSearch Dashboards Plugin Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-opensearch-dashboards-plugin/1.0.0-beta-2-os-1.3.2/search-guard-flx-opensearch-dashboards-plugin-1.0.0-beta-2-os-1.3.2.zip)|[Demo Installer Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-opensearch-plugin/1.0.0-beta-2-os-1.3.2/search-guard-flx-opensearch-plugin-1.0.0-beta-2-os-1.3.2-demo-installer.sh)|
|**OpenSearch 2.0.0**|[Search Guard OpenSearch Plugin Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-opensearch-plugin/1.0.0-beta-2-os-2.0.0/search-guard-flx-opensearch-plugin-1.0.0-beta-2-os-2.0.0.zip)|[Search Guard OpenSearch Dashboards Plugin Beta 2](https://maven.search-guard.com/search-guard-flx-release/com/floragunn/search-guard-flx-opensearch-dashboards-plugin/1.0.0-beta-2-os-2.0.0/search-guard-flx-opensearch-dashboards-plugin-1.0.0-beta-2-os-2.0.0.zip)|[Demo Installer Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-opensearch-plugin/1.0.0-beta-2-os-2.0.0/search-guard-flx-opensearch-plugin-1.0.0-beta-2-os-2.0.0-demo-installer.sh)|
|**Elasticsearch 7.10.2**|[Search Guard Elasticsearch Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-elasticsearch-plugin/1.0.0-beta-2-es-7.10.2/search-guard-flx-elasticsearch-plugin-1.0.0-beta-2-es-7.10.2.zip)|[Search Guard Kibana Plugin Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-kibana-plugin/1.0.0-beta-2-es-7.10.2/search-guard-flx-kibana-plugin-1.0.0-beta-2-es-7.10.2.zip)|[Demo Installer Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-elasticsearch-plugin/1.0.0-beta-2-es-7.10.2/search-guard-flx-elasticsearch-plugin-1.0.0-beta-2-es-7.10.2-demo-installer.sh)|
|**Elasticsearch 7.16.3**|[Search Guard Elasticsearch Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-elasticsearch-plugin/1.0.0-beta-2-es-7.16.3/search-guard-flx-elasticsearch-plugin-1.0.0-beta-2-es-7.16.3.zip)|[Search Guard Kibana Plugin Beta 2](https://maven.search-guard.com/search-guard-flx-release/com/floragunn/search-guard-flx-kibana-plugin/1.0.0-beta-2-es-7.16.3/search-guard-flx-kibana-plugin-1.0.0-beta-2-es-7.16.3.zip)|[Demo Installer Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-elasticsearch-plugin/1.0.0-beta-2-es-7.16.3/search-guard-flx-elasticsearch-plugin-1.0.0-beta-2-es-7.16.3-demo-installer.sh)|
|**Elasticsearch 7.17.3**|[Search Guard Elasticsearch Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-elasticsearch-plugin/1.0.0-beta-2-es-7.17.3/search-guard-flx-elasticsearch-plugin-1.0.0-beta-2-es-7.17.3.zip)|[Search Guard Kibana Plugin Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-kibana-plugin/1.0.0-beta-2-es-7.17.3/search-guard-flx-kibana-plugin-1.0.0-beta-2-es-7.17.3.zip)|[Demo Installer Beta 2](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-elasticsearch-plugin/1.0.0-beta-2-es-7.17.3/search-guard-flx-elasticsearch-plugin-1.0.0-beta-2-es-7.17.3-demo-installer.sh)|

<table>
<tr><th colspan=2 style="text-align:center; font-weight:bold">Platform Independent</th></tr>
<tr><td colspan=2 style="text-align:center"><a href="https://maven.search-guard.com//search-guard-flx-release/com/floragunn/sgctl/1.0.0-beta-2/sgctl-1.0.0-beta-2.sh">Search Guard Control Tool sgctl 1.0.0 Beta 2</a></td></tr>
</table>


## Getting Started

You have several options to try the Search Guard FLX:

- If you want to start with a quick test of a fresh installation on your local system, you can use the [Search Guard Demo Installer](demo-installer).

- If you have an existing Search Guard setup and what to test its configuration with the Search Guard Tech Preview, you can use the [migrate-config command](sg-classic-config-migration) of `sgctl`. Please also review the list of [release notes](sg-flx-release-notes).

You might want to read the following sections of the documentation to get a comprehensive overview over the new possibilities of Search Guard:

* [Using sgctl](sgctl) (See also the [repository README](https://git.floragunn.com/search-guard/sgctl/)). 
* [Using configuration variables](configuration-password-handling)
* [Configuring authentication](authentication-authorization)
* [Configuring Dashboards/Kibana authentication](kibana-authentication-types) 
* [Search Guard FLX release notes](sg-flx-release-notes)
* [Migrating from Search Guard 53 and before](sg-classic-config-migration)
* [SG 53 to FLX feature map](config-migration-feature-map)


## Feedback

Your feedback is welcome! You can use the [Search Guard Forum](https://forum.search-guard.com/) for questions and general feedback. You can also report issues at the Search Guard Gitlab repository.

 



