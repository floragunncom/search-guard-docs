---
title: Search Guard 7.x-50.0.0
permalink: changelog-searchguard-7x-50_0_0
category: changelogs-searchguard
order: -300
layout: changelogs
description: Changelog for Search Guard 7.x-50.0.0	
---

<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 50.0

**Release Date: 2021-03-18**

The new release of Search Guard brings support for Elasticsearch 7.11. Please note that we can only support Elasticsearch 7.11.1 and 7.11.2. Elasticsearch 7.11.0 is unsupported due to a [problem in the artifacts publication](https://github.com/elastic/elasticsearch/pull/68926) at Elastic.

Other highlights in this release include:

* [Support for user attributes in tenant patterns](#support-for-user-attributes-in-tenant-patterns)
* [Additional details for audit logging](#audit-logging)
* [Improvements regarding Signals stability and footprint](#signals)
* A couple of further minor improvements and bugfixes

See below for details.

## Breaking Changes

This release brings one breaking change for users of [OCSP](#ocsp-configuration-changes) for TLS certificate revocation. See [below](#ocsp-configuration-changes) for details. 

Furthermore, with 7.11.x onwards, we won't build new versions of the `sgadmin-standalone` archive. This is because of Elastic license restrictions. It is however perfectly possible to use older versions of `sgadmin-standalone` with Search Guard on ES 7.11+.

## TLS

### OCSP Configuration Changes

Due to changes in Elasticsearch 7.11, the configuration format for OCSP (Online Certificate Status Protocol) needed to be changed. OCSP is no longer active by default, if CRL validation is enabled.

If you are not using CRL validation (`searchguard.ssl.http.crl.validate` is not set to true in `elasticsearch.yml`), you can skip this.

If you are using CRL validation and want to continue using OCSP for CRL validation, you additionally need to edit the file `jdk/conf/security` in your ES installation on every node and add:

```
ocsp.enable=true
```

If you have disabled OCSP using `searchguard.ssl.http.crl.disable_ocsp: true` in `elasticsearch.yml`, you must remove this option as it is no longer supported. OCSP support is now disabled by default.

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/103)

## Elasticsearch Privileges

### Support for User Attributes in Tenant Patterns

It is now possible to use user attributes in tenant pattern like this:

```
sg_tenant_user_attrs:
  tenant_permissions:
  - tenant_patterns:
    - "dept_${user.attrs.dept_no}"
    allowed_actions:
    - "SGS_KIBANA_ALL_WRITE"
```

Note: Only the "new style" user attributes are supported here; "old style" attributes (`attr.internal....`) are not supported here.

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/116)
* [Documentation](https://search-guard.com/docs/latest/roles-permissions)

### Support for Composable Templates

The [composable templates feature](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-template.html) introduced by Elastichsearch 7.8 was not yet supported by Search Guard. Now, the necessary privileges are included in the action group `SGS_CLUSTER_MANAGE_INDEX_TEMPLATES`. 

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/12)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/108)

## Signals

Search Guard 50 brings significant improvements regarding stability and the resource footprint of Signals Alerting.

### Inclusion of Responsible Node in Watch State API

The [watch state API](https://search-guard.com/docs/latest/elasticsearch-alerting-rest-api-watch-state) now always includes the name of the node that is responsible for executing the node. This can be useful for debugging watch execution problems. 

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/113)
* [Documentation](https://search-guard.com/docs/latest/elasticsearch-alerting-rest-api-watch-state)

### Signals Stability

A number of improvements and bug fixes regarding node fail-over and general stability of Signals watch execution have been implemented:

* [Recovery fails if a watch was executing while the executing node shut down](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/38)
* [When waiting for a yellow index state, don't give up after 1 hour](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/110)
* [Signals state update bugfixes](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/118)

### Signals Footprint

On Search Guard setups with lots of (100+) tenants, Signals could cause problems by starting a large number of threads. Search Guard 50 addresses this problem on several levels:

* Thread pools are no longer filled initially, but only on demand. Thus, active tenants without any watches will not initially use 4 threads, but only one thread - the scheduler thread. Also, idle threads are terminated after a timeout period.

* Originally, Signals would start a scheduler for every configured tenant. This might be however not necessary. Thus, Signals has now a second operation mode which makes explicit activation of a tenant within Signals necessary. This can be controlled with the config option `signals.all_tenants_active_by_default` in  `elasticsearch.yml`.

* Additionally, Signals provides now a number of additional [config options](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/109) for fine-tuning its thread pools.

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/109)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/10)


### Bugfix for E-Mail Action Runtime Data Attachments

Trying to use e-mail actions with attachments of `type: runtime` caused exceptions. This is now fixed.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/36)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/106)
* [Documentation](https://search-guard.com/docs/latest/elasticsearch-alerting-actions-email)

## Audit Logging

### Logging of Authentication Domain Used for Logging In
 
Audit Logging now also logs information about the ways a user used for logging in at Search Guard. This information is logged for every audit message which also logs the user name of the logged in user. The new information is now available in the attributes `audit_request_effective_user_auth_domain` and `audit_request_initiating_user_auth_domain`. The attributes contain a value like `basic/ldap` which indicates that the user used basic authentication and was authenticated by the LDAP authentication backend.

The new attributes are available by default.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/3)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/58)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/117)
* [Documentation](https://search-guard.com/docs/latest/audit-logging-reference)

### OutOfMemoryErrors when logging write history for large documents

The `zjsonpatch` library has an issue which could cause OutOfMemoryErrors  when logging write history for large documents.


Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/18)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/55)


## Search Guard Health API

Search Guard 50 also introduces a new health API which gives administrator a powerful tool to find out about issues in the setup of Search Guard and its components. 

The API is available by `GET` at `/_searchguard/component/_all/_health` and yields a large JSON document containing information about the state of various Search Guard components broken down by nodes.

In order to access the endpoint, users need to have the `cluster:admin/searchguard/components/state/get` privilege. Only admin users should have the privilege.

Details: 

* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/104)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/53)
 
## Auth Token Service

Revocation of auth tokens did not work where tokens were created with `freeze_privileges: false` and fully requested privileges (i.e. `cluster_permissions: *` and `index_permissions: */*`. This is a non-standard setup, which can be only achieved by modification of the default confguration in `sg_config.yml`: `exclude_cluster_permissions` in the `auth_token_provider` would need to be `[]` in order to introduce this issue. This is a non-recommended setup.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/16)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/60)

 
 
## sgadmin

With 7.11.x onwards, we won't build new versions of the `sgadmin-standalone` archive. This is because of ES license restrictions. It is however perfectly possible to use older versions of `sgadmin-standalone` with Search Guard on ES 7.11+

In the medium term, we will replace `sgadmin` by a new REST-based tool which makes distribution of `sgadmin-standalone` completely unnecessary.
 