---
title: Search Guard Documentation
html_title: Documentation
slug: index
layout: docs
description: Official documentation for Search Guard 7, the enterprise security and alerting suite for Elasticsearch.
showsearch: true
isroot: true
---
<!---
Copryight 2020 floragunn GmbH
-->


<p align="center">
<img src="img/logos/search-guard-frontmatter.png" alt="Search Guard - Security for Elasticsearch" style="width: 40%" />
</p>

<h2 align="center">Security and Alerting for Elasticsearch</h2>

<h1 align="center">Search Guard Tech Preview Documentation</h1>

Welcome to the preview of the next generation of Search Guard! We provide you this preview in order to give you an impression of the changes and an opportunity to test it and give feedback.

Please note that this preview is not yet ready for use in production systems. It might have bugs. Also, we might decide to introduce further breaking changes before the release.

## What's New

This technical preview brings a number of fundamental improvements and updates to Search Guard. These require breaking changes in the configuration format.

Major changes include:

- The first version of Search Guard which brings support for **OpenSearch** and **OpenSearch Dashboards**.
- Completely new approach for logging into Dashboards/Kibana. **Logged in users now get an actual server-side session.** This fixes a number of issues, such as:
  - Issues with cookies exceeding the browser size limit.
  - The "logout" menu item is able to invalidate the session. Thus, session cookies cannot be re-used any more.
  - Configuration of SSO using OIDC or SAML for Dashboards/Kibana no longer interfers with backend authentication configuration. Thus, you can now have challenging basic authentication on the backend while using OIDC or SAML for Dashboards/Kibana.
  - The configuration format is now more streamlined and consistent.  
  - Dashboards/Kibana authentication configuration can be changed without having to restart the node.
- **New administration tool** `sgctl` which shall replace `sgadmin`.  `sgctl` is stateful; that means, you can define connection profiles once and use these later. Thus, you don't have to specify all connection configuration on each invocation. The interface of `sgctl` is more streamlined and offers you improved configuration validation functionality.



## Download

You can get the current snapshot of the Search Guard Tech Preview here:

|Target Environment|Backend Plugin|Frontend Plugin|
|---|---|---|---|
|OpenSearch 1.0.0|[Tech Preview 1](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/)|[Tech Preview 1]()|
|Elasticsearch 7.14.1|[Tech Preview 1](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/)|[Tech Preview 1]()|
|Elasticsearch 7.10.2|[Tech Preview 1](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/)|[Tech Preview 1]()|

## Getting Started

You have several options to try the Search Guard Tech Preview:

- If you want to start with a quick test of a fresh installation on your local system, you can use the [Search Guard Demo Installer](demo-installer).

- If you have an existing Search Guard setup and what to test its configuration with the Search Guard Tech Preview, you can use the [migrate-config command](kibana-authentication-migration-quick) of `sgctl`. Please also review the list of breaking changes below.

See the documentation on [Dashboards/Kibana Authentication](kibana-authentication-types) for an comprehensive overview over the new possibilities Search Guard offers.

Documentation on how to use the `sgctl` command can be found in the [README](https://git.floragunn.com/search-guard/sgctl/-/blob/main/README.md).

## Breaking Changes

There has been a number of breaking changes to the Search Guard configuration. Some don't require config changes, some can be automatically migrated by using the `sgctl migrate` command, still some need manual intervention.

The breaking changes include so far:

- The old style user attributes (`attr.ldap....`, `attr.jwt...`, etc) are not supported any more for users logging in via Kibana. You need to use new style user attributes (`user.attrs....`)  instead. See the chapters on [DLS](document-level-security) and [Roles](roles-permissions) for details.

- Support for OpenSSL was removed from Search Guard already quite a while a go. Now, also the configuration options - which were just ignored in the meantime - have been also removed. Thus, if you have any `searchguard` settings in `elasticsearch.yml` mentioning `openssl`, you need to remove these.

- The `do_not_fail_on_forbidden` setting in `sg_config` is now active by default.

- Search Guard no longer warns about filtered alias settings.

## Feedback

Your feedback is welcome! You can use the [Search Guard Forum](https://forum.search-guard.com/) for questions and general feedback. You can also report issues at the Search Guard Gitlab repository.

 



