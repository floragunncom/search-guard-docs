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
- Improved way of handling unauthorized indices. You no longer have to worry that your wildcard query breaks because it might pick up an index you don't have permissions for.
- More speed. Many components of Search Guard underwent major optimizations. Thus, Search Guard FLX can now handle more throughput with a lower CPU footprint.


## Download

You can get the current snapshot of the Search Guard Tech Preview at the following locations. If you chose to use the demo installer, you just need to download the script. The script will take care of downloading all further components.

|Target Platform|Backend Plugin|Frontend Plugin|Demo Installer|
|---|---|---|---|
|**OpenSearch 1.2.4**|[Search Guard OpenSearch Plugin TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-opensearch-plugin/tp3-os-1.2.4/search-guard-opensearch-plugin-tp3-os-1.2.4.zip)|[Search Guard OpenSearch Dashboards Plugin TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-opensearch-dashboards-plugin/tp3-os-1.2.0/search-guard-opensearch-dashboards-plugin-tp3-os-1.2.0.zip)|[Demo Installer TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-opensearch-plugin/tp3-os-1.2.4/search-guard-opensearch-plugin-tp3-os-1.2.4-demo-installer.sh)|
|**Elasticsearch 7.10.2**|[Search Guard Elasticsearch Plugin TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-elasticsearch-plugin/tp3-es-7.10.2/search-guard-elasticsearch-plugin-tp3-es-7.10.2.zip)|[Search Guard Kibana Plugin TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-kibana-plugin/tp3-es-7.10.2/search-guard-kibana-plugin-tp3-es-7.10.2.zip)|[Demo Installer TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-elasticsearch-plugin/tp3-es-7.10.2/search-guard-elasticsearch-plugin-tp3-es-7.10.2-demo-installer.sh)|
|**Elasticsearch 7.16.3**|[Search Guard Elasticsearch Plugin TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-elasticsearch-plugin/tp3-es-7.16.3/search-guard-elasticsearch-plugin-tp3-es-7.16.3.zip)|[Search Guard Kibana Plugin TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-kibana-plugin/tp3-es-7.16.3/search-guard-kibana-plugin-tp3-es-7.16.3.zip)|[Demo Installer TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-elasticsearch-plugin/tp3-es-7.16.3/search-guard-elasticsearch-plugin-tp3-es-7.16.3-demo-installer.sh)|
|**Elasticsearch 7.17.1**|[Search Guard Elasticsearch Plugin TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-elasticsearch-plugin/tp3-es-7.17.1/search-guard-elasticsearch-plugin-tp3-es-7.17.1.zip)|[Search Guard Kibana Plugin TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-kibana-plugin/tp3-es-7.17.1/search-guard-kibana-plugin-tp3-es-7.17.1.zip)|[Demo Installer TP3](https://maven.search-guard.com/search-guard-suite-alpha/com/floragunn/search-guard-elasticsearch-plugin/tp3-es-7.17.1/search-guard-elasticsearch-plugin-tp3-es-7.17.1-demo-installer.sh)|

<table>
<tr><th colspan=2 style="text-align:center; font-weight:bold">Platform Independent</th></tr>
<tr><td colspan=2 style="text-align:center"><a href="https://maven.search-guard.com/search-guard-suite-release/com/floragunn/sgctl/0.2.4/">Search Guard Control Tool sgctl 0.2.4</a></td></tr>
</table>


## Getting Started

You have several options to try the Search Guard FLX:

- If you want to start with a quick test of a fresh installation on your local system, you can use the [Search Guard Demo Installer](demo-installer).

- If you have an existing Search Guard setup and what to test its configuration with the Search Guard Tech Preview, you can use the [migrate-config command](kibana-authentication-migration-quick) of `sgctl`. Please also review the list of breaking changes below.

You might want to read the following sections of the documentation to get a comprehensive overview over the new possibilities of Search Guard:

* [Using sgctl](sgctl) (See also the [repository README](https://git.floragunn.com/search-guard/sgctl/)). 
* [Using configuration variables](configuration-password-handling)
* [Configuring authentication](authentication-authorization)
* [Configuring Dashboards/Kibana authentication](kibana-authentication-types) 
* [Migrating from Search Guard 53 and before](sg-classic-config-migration)

## Breaking Changes

There has been a number of breaking changes to the Search Guard configuration. Some don't require config changes, some can be automatically migrated by using the `sgctl migrate-config` command, still some need manual intervention.

The breaking changes include so far:

- The file `sg_config.yml` is being replaced by a number of more specialized files. This allows for a clearer and more concise configuration.

- The old style user attributes (`attr.ldap....`, `attr.jwt...`, etc) are not supported any more for users logging in via Kibana. You need to use new style user attributes (`user.attrs....`)  instead. See the chapters on [DLS](document-level-security) and [Roles](roles-permissions) for details.

- Support for OpenSSL was removed from Search Guard already quite a while a go. Now, also the configuration options - which were just ignored in the meantime - have been also removed. Thus, if you have any `searchguard` settings in `elasticsearch.yml` mentioning `openssl`, you need to remove these.

- The `do_not_fail_on_forbidden` mode has been replaced by `ignore_unauthorized` mode with refined semantics. This mode is now active by default. 

- Search Guard no longer warns about filtered alias settings.

- More about the configuration migration can be found [here](sg-classic-config-migration).

- A comprehensive overview over the configuration format changes can be found [here](config-migration-feature-map).


## Feedback

Your feedback is welcome! You can use the [Search Guard Forum](https://forum.search-guard.com/) for questions and general feedback. You can also report issues at the Search Guard Gitlab repository.

 



