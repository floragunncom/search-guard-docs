---
title: Search Guard 7.x-42.0.0
slug: changelog-searchguard-7.x-42_0_0
category: changelogs-searchguard
order: 500
layout: changelogs
description: Changelog for Search Guard 7.x-42.0.0	
---

<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 30.05.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## New Features



### Signals

* Block support for slack actions
  * Slack actions can now send messages with rich formatting and functionality using Slack blocks and attachments.
  * Note: This feature is currently only available when configuring watches via REST API. It is not available in the config UI.
  * Issue number SGD-441
<p />
* Attachment support for email actions
  * E-mail actions can be configured to add attachments to mails. Sources for the attachments can be HTTP endpoints or the Signals runtime data. 
  * Note: This feature is currently only available when configuring watches via REST API. It is not available in the config UI.
  * Issue number SGD-440
<p />
* Support HTML body format for email actions
  * E-mail actions support now a new attribute `html_body` in order to send HTML formatted mails.  
  * Issue number SGD-439
<p />


### Document- and Field-Level-Security

* Field anonymization: Make it possble to prefix anon fields
  * This feature makes it possible to add a static prefix to anonymized fields
  * This can be set in elasticsearch.yml via `searchguard.compliance.mask_prefix: "<prefix>"`
  * Issue number SGD-531
<p />
* DLS / FLS / AF: Make it possible for a role without filters to overwrite other roles
  * The default setting for DLS, FLS and Field Anonymization (FA) is that for each role a user has the settings are combined
  * For example, if a user has two roles with DLS restrictions and one role without, the DLS restrictions would still apply
  * You can now change this so that a role that has no restriction for DLS, FLS or FA removes any restrictions from other roles
  * This can be enabled in elasticsearch.yml via: `searchguard.dfm_empty_overrides_all: true`
  * Issue number SGD-530
<p />
* Field anonymization: Make it possible to change the salt at runtime
  * Until this release the salt for field anonymization had to be set in elasticsearch.yml and was not changeable at runtime
  * You can now specify a salt also in sg_config.yml which is changeable at runtime
  * The salt can be set via the key `sg_config.dynamic.field_anonymization_salt2: "<salt>"`
  * To enable this feature, add the following line to elasticsearch.yml: `searchguard.compliance.local_hashing_enabled: true` 
  * Issue number SGD-529
<p />


## Improvements



### Search Guard Core

* Rewrite LDAP2 implementation to use UnboundID LDAP SDK only
  * The new ldap2 module now uses the Unbound SDK directly, omitting ldaptive altogether
  * This module will become the default LDAP implementation in Search Guard 8
  * Issue number SGD-398
<p />


## Bug Fixes



### Signals

* Integration test failures for Slack Action
  * Fixed an issue where the integration tests would fail for Slack actions due to the 'text' attribute being empty
  * **BREAKING:** The 'text' attribute is now mandatory for Slack actions
  * Issue number SGD-518
<p />
* SG CCS authz does not work for search requests executed from scheduled Signals watches
  * Performing a cross cluster search from a Signals watch would not propagate authentication information to the remote cluster. Thus, if the remote cluster requires authentication, the search would fail.
  * Note: Right now, this is only supported if the remote cluster is running Search Guard 7 as well.
  * Issue number SGD-489
<p />
* Consolidate available attributes in Mustache between Frontend and Backend
  * The preview of rendered Mustache templates in the Signals UI would sometimes not match the actual result.
  * Issue number SGD-438
<p />


### Search Guard Core

* Log spamming from SearchGuardSSLNettyHttpServerTransport for connection reset exceptions
  * ES logs would be sometimes spammed with "connection reset" errors even if they are uncritical.
  * Issue number SGD-498
<p />


### Multi Tenancy

* Multitenancy page regression - should not check for access to the config ui, only license warning
  * Page for selecting the active tenant would show a bogus warning if the user does not have administration privileges.
  * Issue number SGD-499
<p />


## Security Fixes



### Search Guard Core

* Internal User: Don't log sensitive information to the console upon bad user input
  * In some cases the REST API would print a password hash on the command line when the user updates his/her password and input was faulty
  * This would only be visible to the user actually changing the password
  * Issue number SGD-414
<p />


### Multi Tenancy

* Possible security leak with current static role configuration for SGS_KIBANA_USER
  * The default permissions for Kibana users no longer grant access to indexes matching the pattern `.kibana_*`, as this would allow users to access the configuration indexes of Kibana tenants they don't have permission to access. 
  * This affects only the definition of saved objects, actual data is not leaked
  * Issue number SGD-468
<p />


## Documentation



### Search Guard Core

* Document heap settings when running Docker Demo
  * In some cases it is necessary to increase the heap for Kibana for the Docker Demo to start
  * Issue number SGD-437
<p />


