---
title: Search Guard 7.x-42.0.0
permalink: changelog-searchguard-7x-42_0_0
category: changelogs-searchguard
order: 500
layout: changelogs
description: Changelog for Search Guard 7.x-42.0.0	
---

# Changelog for Search Guard 7.x-42.0.0

<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 01.06.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## New Features



### Signals

* [Block support for Slack actions](elasticsearch-alerting-actions-slack#slack-blocks)
  * Slack actions can now send messages with rich formatting and functionality using Slack blocks and attachments.
  * Note: This feature is currently only available when configuring watches via REST API. It is not available in the config UI.
<p />
* [Attachement support fo email actions](elasticsearch-alerting-actions-email)
  * E-mail actions can be configured to add attachments to mails. Sources for the attachments can be HTTP endpoints or the Signals runtime data. 
  * Note: This feature is currently only available when configuring watches via REST API. It is not available in the config UI.
<p />
* [Support for HTML body format in email actions](elasticsearch-alerting-actions-email)
  * E-mail actions support now a new attribute `html_body` in order to send HTML formatted mails.  
<p />


### Document- and Field-Level-Security

* [Add a static prefix to anonymized fields](field-anonymization#prefixing-anonymized-fields)
  * This can be set in elasticsearch.yml via `searchguard.compliance.mask_prefix: "<prefix>"`
<p />
* Make it possible for a role without filters to overwrite other roles
  * If a role has no DLS / FLS or FA filters, you can choose that this role overwrites restrictions from other roles
  * This can be enabled in elasticsearch.yml via: `searchguard.dfm_empty_overrides_all: true`
  * [Effects on DLS](document-level-security#multiple-roles-and-document-level-security)
  * [Effects on FLS](field-level-security#multiple-roles-and-field-level-security)
  * [Effects on Field Anonymization](field-anonymization#multiple-roles-and-field-anonymization)
<p />
* [Field anonymization: Configure salt dynamically](field-anonymization#setting-a-dynamic-salt)
  * Until this release the salt for field anonymization had to be set in elasticsearch.yml and was not changeable at runtime
  * You can now specify a salt also in sg_config.yml which is changeable at runtime
  * The salt can be set via the key `sg_config.dynamic.field_anonymization_salt2: "<salt>"`
  * To enable this feature, add the following line to elasticsearch.yml: `searchguard.compliance.local_hashing_enabled: true` 
<p />


## Improvements



### Search Guard Core

* LDAP2: Use Unbound SDK only
  * The new ldap2 module now uses the Unbound SDK directly, omitting ldaptive altogether
  * This module will become the default LDAP implementation in Search Guard 8
<p />


## Bug Fixes



### Signals

* Fix CCS authentication for Signals watches
  * Performing a cross cluster search from a Signals watch would not propagate authentication information to the remote cluster correctly. Thus, if the remote cluster requires authentication, the search would fail.
  * **Note: Right now, this is only supported if the remote cluster is running Search Guard 7 as well.**
<p />


### Search Guard Core

* Fix SSL log file entries
  * Elasticsearch logs would be sometimes spammed with "connection reset" errors even if they are uncritical.
<p />


## Security Fixes



### Search Guard Core

* REST API: Don't log sensitive information to the console
  * In some cases the REST API would print a password hash on the command line when the user updates his/her password and input was faulty
  * This would only be visible to the user actually changing the password
<p />


### Multi-Tenancy

* Prevent access to saved objects definitions
  * The default permissions for Kibana users no longer grant access to indexes matching the pattern `.kibana_*`, as this would allow users to access the configuration indexes of Kibana tenants they don't have permission to access. 
  * This affects only the definition of saved objects, actual data is not leaked
<p />


