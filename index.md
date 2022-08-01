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

<h2 align="center">Security and Alerting for Elasticsearch</h2>

<h1 align="center">Search Guard FLX Documentation</h1>

Welcome to Search Guard FLX, the next generation of Search Guard! 

Please note that Search Guard FLX is a beta version, which might be not yet ready for use in production systems. It might have bugs. 

## What's New

Search Guard FLX brings a number of fundamental improvements and updates to Search Guard. These require breaking changes in the configuration format.

Major changes include:

- Completely new approach for configuring authentication. **The new configuration format is more coherent, more predictable and much more powerful.** Simple setups require very little configuration; very complex setups are possible by straight-forward configuration. If something goes wrong, Search Guard provides extensive error messages and diagnostic information.
- Completely new approach for logging into Kibana. **Logged in users now get an actual server-side session.** This fixes a number of issues, such as:
  - Issues with cookies exceeding the browser size limit.
  - The "logout" menu item is able to invalidate the session. Thus, session cookies cannot be re-used any more.
  - Configuration of SSO using OIDC or SAML for Kibana no longer interfers with backend authentication configuration. Thus, you can now have challenging basic authentication on the backend while using OIDC or SAML for Kibana.
  - The configuration format is now more streamlined and consistent.  
  - Kibana authentication configuration can be changed without having to restart the node.
- **New administration tool** `sgctl` which replaces `sgadmin`.  `sgctl` is stateful; that means, you can define connection profiles once and use these later. Thus, you don't have to specify all connection configuration on each invocation. The interface of `sgctl` is more streamlined and offers you improved configuration validation functionality.
- **Wildcard queries without hassle** made possible by an improved method for handling unauthorized indices. You no longer have to worry that your wildcard query breaks because it might pick up an index you don't have permissions for.
- **More speed.** Many components of Search Guard underwent major optimizations. Thus, Search Guard FLX can now handle more throughput with a lower CPU footprint.
- **Easily reachable diagnostics and metrics;** most modules of Search Guard FLX offer debug modes which deliver diagnostic information right at the place where you operate. You no longer have to grep through logfiles to find out why your OIDC authentication is not working.

## Getting Started

You have several options to try the Search Guard FLX:

- If you want to start with a quick test of a fresh installation on your local system, you can use the [Search Guard Demo Installer](demo-installer).

- If you have docker installed you can just simply run `docker run -it --rm -p 5601:5601 floragunncom/flx-7-demo` and point your Browser to `http://localhost:5601` and login with Username: `admin` and Password: `admin`

- If you have an existing Search Guard setup and what to test its configuration with the Search Guard Tech Preview, you can use the [migrate-config command](sg-classic-config-migration) of `sgctl`. Please also review the list of [release notes](sg-flx-release-notes).

You might want to read the following sections of the documentation to get a comprehensive overview over the new possibilities of Search Guard:

* [Using sgctl](sgctl) (See also the [repository README](https://git.floragunn.com/search-guard/sgctl/)). 
* [Using configuration variables](configuration-password-handling)
* [Configuring authentication](authentication-authorization)
* [Configuring Kibana authentication](kibana-authentication-types) 
* [Search Guard FLX release notes](sg-flx-release-notes)
* [Migrating from Search Guard 53 and before](sg-classic-config-migration)
* [SG 53 to FLX feature map](config-migration-feature-map)


## Feedback

Your feedback is welcome! You can use the [Search Guard Forum](https://forum.search-guard.com/) for questions and general feedback. You can also report issues at the Search Guard Gitlab repository.

 



