---
title: Overview
html_title: Signals Alerting
slug: alerting-signals
category: signals
order: 100
layout: docs
edition: community
description: Basic overview about the Elasticsearch alerting capabilities of Search Guard Signals.
---
<!---
Copyright 2019 floragunn GmbH
-->

# Signals Notes

- No longer loses triggers when there is more than one trigger active at the same time.
- Merged most recent SG master, so it requires now ES 7.0.1
- Support for ack REST API

---

Permissions

All REST endpoints are now requiring proper permissions to be callable. If the current user does not have proper permissions, a 403 error will be returned.
For now, only the sg_all_access role in the default config allows access to the Signals functionality. For other roles, the permissions need to be configured manually.
These permissions (resp. actions) are available:
- searchguard:tenant:signals:watch/ack
- searchguard:tenant:signals:watch/activate_deactivate
- searchguard:tenant:signals:watch/delete
- searchguard:tenant:signals:watch/execute (Only for executing watches with ID. For executing watches without ID, no special permission is required right now)
- searchguard:tenant:signals:watch/get
- searchguard:tenant:signals:watch/put
- searchguard:tenant:signals:watch/search
In the role config, the permissions have to be defined in the tenant_permissions section. If you don't use multi tenancy, or you want to configure the default tenant, you need to specify them for the tenant SGS_GLOBAL_TENANT.
Example:
sg_signals_admin:
  tenant_permissions: 
  - tenant_patterns:
    - SGS_GLOBAL_TENANT
    allowed_actions:
      - "searchguard:tenant:signals:*"

Tenant Selection in the REST API

Selecting the tenant to be used works just like it works for the existing ES APIs. You need to specify the sg_tenant HTTP header and set it to the name of the tenant to be used.

Retrieving Watches

The watch config index is not openly accessible anymore. To retrieve a list of available watches, you need to use the REST API /_signals/watch/_search.
It works mostly the same like the ES search API documented at https://www.elastic.co/guide/en/elasticsearch/reference/current/search.html.
So, just GET /_signals/watch/_search yields a list of all watches defined for the current tenant. You can use the query params from, size and scroll. Other URL query params are however not supported yet. However, it is also possible to POST a whole search request to the endpoint.

User Authentication for Watch Execution

Watches are now executed in an authentication context that recreates the permissions the user had when he created the watch. For this, an auth token is saved along the watch. This means that watches that have been created before will cease to work.
Note: Right now, the tokens are signed with a hardcoded key and are not encrypted. This is still to do.

Watch Log Index

The name of the watch log index has changed. It is now .signals_log_{now/d} (i.e., the current date is appended at the end).
The name is configurable via the setting signals.index_names.log in elasticsearch.yml.
Also, every tenant will write its logs to the same index. For this, the name of the tenant which created the log entry, is stored in the attribute tenant. This also means that the attribute watch_id no longer uniquely identifies the entries of a specific watch. You will need to use a combination of the attributes tenant and watch_id for a proper identification.
For restricting access to logs of foreign tenants, one can use Document Level Security. For now, however, this needs to be manually configured.

---

HTTP Endpoint:
- Webhook Action
- HTTP Input
- Mail Action: Attachment source (special case: reporting)
- Slack Action: Slack Webservice URL
- Jira Action: Jira Webservice URL

SMTP Endpoint:
- EMail Action
 
---

Important Changes

- Calcs and Transforms without params attribute would cause NPE
- Transforms were not property serialized
- Runtime data is now available in both Painless and Mustache scripts under the prefix "{{data....}}". I did not use the prefix "ctx" because in ES this naming seems to be a rather legacy prefix which used to contain any external variables in scripts. Thus also the very generic name. The old prefixes are still also supported, but we should the watches to the new format.
- The parse error with templates used for numeric attributes in search bodies is however not yet fixed. I'm still researching this one. (edited)

---

Important Changes

- Support for schedule types daily, weekly, monthly. Compare https://www.elastic.co/guide/en/elastic-stack-overview/7.x/trigger-schedule.html#schedule-daily
 Note: So far times can be only specified using strings in the format "HH:MM". The specification of times using objects like "hour" : [ 0, 12, 17 ], "minute" : [0, 30] is not supported yet. If we don't need it, I'd like to skip that for now.
- The scheduled and actual trigger time can be now accessed from within scripts. Use trigger.triggered_time and trigger.scheduled_time (without ctx prefix). These attributes are only available if the watch was actually triggered by a schedule. If it was executed via REST API, the trigger attribute is unset.
- Watches have now an attribute called _ui which can be arbitrarily used by the UI.
- Index mapping is disabled for the attribute request.body of search inputs in watches. This way, it is possible to specify arbitrary types for the attributes of search bodies. Especially, this enables templating using mustache. However, watches cannot be searched based on the content of request.body any more.


