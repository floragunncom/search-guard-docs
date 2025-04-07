---
title: Search Guard FLX 1.3.0
permalink: changelog-searchguard-flx-1_3_0
layout: changelogs
description: Changelog for Search Guard FLX 1.3.0
---
<!--- Copyright 2022 floragunn GmbH -->

# Search Guard FLX 1.3.0

**Release Date: 2023-08-28**

This is a new minor release of Search Guard FLX. 

It brings some new features especially for the Audit Log, some bug fixes and updates a number of dependencies.

## New features

### Audit Log: New categories for Kibana login and logout

If a users logs in into Kibana a `KIBANA_LOGIN` event is generated and when the user logs out a `KIBANA_LOGOUT` event is generated.

* [Documentation](../_docs_audit_logging/auditlogging.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/228)

### Audit Log: Custom fields

You can now add custom fields with static values, that should be stored in Audit Logs.

* [Documentation](../_docs_audit_logging/auditlogging_storage.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/220)

### Audit Log: New field in the Audit Logs containing the Elasticsearch version 

A new field `audit_node_elasticsearch_version`, which contains the Elasticsearch version when the event was created, is now logged.

* [Documentation](../_docs_audit_logging/auditlogging_fields.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/221)

### Audit Log: New events in Audit Logs for index template creation/update/deletion

Add new category `COMPLIANCE_INDEX_TEMPLATE_WRITE` to track modification on index templates.

* [Documentation](../_docs_audit_logging/auditlogging.md)
* [Documentation](../_docs_audit_logging/auditlogging_fields.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/190)

### Audit Log: New events in Audit Logs for operations on indices (create, delete, update settings/mappings)

Add new category `INDEX_WRITE` to track modification on indices (created index, updated index settings/mappings or deleted index).

* [Documentation](../_docs_audit_logging/auditlogging.md)
* [Documentation](../_docs_audit_logging/auditlogging_fields.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/189)

## Improvements

### Authentication: Renamed OIDC Endpoint

Search Guard implements OIDC which is not the same as OpenID. To avoid confusion, the endpoint were renamed from `/auth/openid/login` to `/auth/oidc/login`. In order to keep backwards compatibility `/auth/openid/login` is kept, but usage is not recommended.

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/455)


### Signals: Global config for trusted certs of external HTTP interfaces 

Simplify the management for trusted certificates with Webhook action and HTTP input and Jira actions. It is now possible to manage truststores via an API and then reference them in watches.

* [Documentation](../_docs_signals/truststores.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/46)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/37)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/355)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/355)


### Signals: Convert runtime data to JSON in Webhook action and HTTP input

Make it possible to directly convert runtime data to JSON in Webhook action and HTTP input.

* [Documentation](../_docs_signals/actions_webhook.md)
* [Documentation](../_docs_signals/inputs_http.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/179)

### Signals: Global setting to configure a lower bound for throttling

Introduces a configurable lower bound for throttling. This can serve as a rate limiting feature for watches.

* [Documentation](../_docs_signals/administration.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/171)

## Bug fixes

### sgctl: sg_action_groups.yml

Fix handling of `sg_action_groups.yml` files.

* [Issue](https://git.floragunn.com/search-guard/sgctl/-/issues/49)

### Kibana: Fails to edit a user created with API call and no backend_roles

Fix Kibana when edit a user created with an API call and no backend_roles.

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/468)

### LDAP: connection pool min and max values are not respected

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/208)

### Kibana: Missing privilege for kibanaserver user on Kibana 8.6

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/459)

### Signals: Slack's attachment is sent as a string instead of an array

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/225)

### Signals: Painless script execution fails when endpoint /_scripts/painless/_execute is used 

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/209)

## More

* See the complete changes in the [Gitlab Milestone](https://git.floragunn.com/groups/search-guard/-/milestones/10)
