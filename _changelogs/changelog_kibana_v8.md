---
title: Kibana 6.x-8
slug: changelog-kibana-6.x-8
category: changelogs-kibana
order: 1000
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin
---

<!---
Copryight 2010 floragunn GmbH
-->

# Search Guard Kibana Plugin 6.x-8

**Release Date: 22.12.2017**

## Kibana Configuration GUI

* Completely new [Kibana based configuration GUI](../_docs/kibana_config_gui.md)
  * Roles, Role Mappings, Action Groups and Internal Users
* Can be used in conjunction or as an alternative to `sgadmin`
* Configure index- and document-type level permissions
* Configure Document- and Field-Level-Security
* Configure Multi Tenancy
* Display configured authentication and authorization modules
* Display system status, installed modules and license information
* Auto-detection of available modules
  * No configuration in `kibana.yml` necessary  
* Based on the role-based access feature of the REST-API