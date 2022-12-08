---
title: Search Guard FLX 1.1.0
permalink: changelog-searchguard-flx-1_1_0
category: changelogs-searchguard
order: -460
layout: changelogs
description: Changelog for Search Guard FLX 1.1.0
---

<!--- Copyright 2022 floragunn GmbH -->

# Search Guard FLX 1.1.0

**Release Date: 2022-12-08**

This is a minor update release for Search Guard FLX. It brings improvements for Signals and a number of bug fixes.

## Enhancements for Signals Alerting

### Unacknowledgeable actions

In some cases, you might want certain actions of a watch to execute every time - even if the watch got acknowledged before. Signals now supports a new boolean attribute for actions: `ack_enabled`. By default, the attribute is `true`. If you set the attribute to `false`, this action will be no longer acknowledged when you acknowledge a watch. You can also not directly acknowledge the action.

##### Related:

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/288)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/121)


### Landing page for acknowledging actions

You can now add a direct link for acknowledging an action to any notification sent by Signals. You just have to add the expression `{{ack_watch_link}}` or `{{ack_action_link}}` to any notification message template used in Signals actions. `{{ack_watch_link}}` lets you acknowledge the whole watch; `{{ack_action_link}}` lets you acknowledge just the action which triggered the notification.

##### Related:

* [Merge Request: Deeplink for acknowledging actions](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/789)
* [Issue: Deeplink for acknowledging actions](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/120)
* [Merge Request: Introduced ack page links as template vars](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/307)
* [Issue: Make link to acknowledge page available in templates for notification actions](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/122)

### Watch overview page: URL parameter control

The filter, sorting and pagination of the watch overview page can be now controlled with URL params. Additionally, filters and pagination are preserved when navigating away from the page and returning to it.

Example: `?query=ticket&pageIndex=0&pageSize=10&sortField=status&sortDirection=asc`

- `query`: The filter expression
- `pageIndex`: Pagination position
- `pageSize`: The number of displayed watches
- `sortField`: The attribute to sort by
- `sortDirection`: Well, the sort direction

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/789)
* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/414)

## Bug fixes

### Privilege issues with index `.search_guard_resource_owner_service`

The index `.search_guard_resource_owner_service` is internally used by Search Guard. Users usually do not need access to it. However, the index was not marked as hidden and would be thus matched by the `*` wildcard. This change automatically changes the index to hidden; thus these issues are avoided.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/305)
* [Issue: .searchguard_resource_owner index should be hidden](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/136)
* [Issue: ResourceOwnerService index fails to be created if action.auto_create_index is restricted](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/33)

### LDAP: Error while using `#{file:...}` in TLS config.

When using the `#{file:...}` config var in TLS settings of LDAP auth modules, you would always get an error. This is fixed.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/299)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/133)


### Kibana login did not properly determine the user's originating IP

When logging in with Kibana, the user's originating IP was not properly evaluated by the authentication backend. Thus, this IP was not available for evaluation for IP blocks or the `accept.originating_ips` and `skip.originating_ips` options.

**Note:** For this to work, you need to configure Search Guard to trust the Kibana IP. For this, add the IP to the config option `network.trusted_proxies` in `sg_authc.yml`.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/297)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/106)

### Auto-generated session signing keys were not stored in an encrypted form.

Search Guard automatically generates signing keys for the session feature upon startup and saves these as a config variable. Config variables with such sensitive content should be marked as secret. Even though not marking these as secret will not leak these in any way, secret variables will be not readable as plaintext in backups.

However, Search Guard FLX 1.0.0 did not save these keys as encrypted variables. FLX 1.1.0 will now save newly created keys as encrypted variables.

If you are updating from Search Guard FLX 1.0.0 and want to have your session signing keys encrypted, you need to follow the following procedure:

- Read the session signing key:

```
$ ./sgctl.sh rest get /_searchguard/config/vars/sessions_signing_key
```

- This gives an output similar to this:

```
{
  "status" : 200,
  "data" : {
    "value" : "zRyBtR5BPoiGlDwF29/3i2ifpjW4TUfAwBfRvstb+2Y2m7DxpGm3lw3RQU+tMveyj9DaIO6504zoj0A3/n29QIOwF2k8m4mq2PliV2fKDjttMzlyKlsQMwFyfmaO33dd",
    "scope" : "authc",
    "updated" : "2022-11-17T10:40:00.874038847Z"
  }
}
```

- Make the session signing key encrypted. Take the value of the `value` attribute of the response above and insert it after `sessions_signing_key` in the command shown below:

```
$ ./sgctl.sh update-var sessions_signing_key "value from response above" --encrypt
```

- You can check with `./sgctl.sh rest get /_searchguard/config/vars/sessions_signing_key` that the value is now stored encrypted.

##### Related:

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/290)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/105)

### Fixed wrongly named static role

Search Guard FLX 1.0.0 introduced the role `SGS_KIBANA_USER_NO_DEFAULT_TENANT`. However, this name is wrong. The tenant in question is the global tenant. This version also introduced the static role `SGS_KIBANA_USER_NO_GLOBAL_TENANT`. The old role will be kept for a while. Still, you should update your configuration to use the new role.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/296)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/107)

### FLX DLS implementation fixes

The new Search Guard FLX DLS implementation (which is inactive by default and needs to be activated with `use_impl: flx` in `sg_authz_dlsfls.yml`) made issues with operations on non-existing indices - such as create index operations. This was fixed.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/292)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/129)
 
### `sgctl set` did not work for config type `frontend_multi_tenancy`

The command `sgctl set` did not work for theconfig type `frontend_multi_tenancy`. This was fixed.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/295)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/131)

### Tenant selection fixes

There were a number of bug fixes in regard to the automatic selection of tenants in Kibana, especially if the global tenant is disabled.

##### Related:

* [Merge Request: Do not fall back to SGS_GLOBAL_TENANT if it is not enabled](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/792)
* [Merge Request: Also treat `sg_tenant` = `SGS_GLOBAL_TENANT` as global tenant](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/303)


### Audit Logging: Fix for early startup phases

Sometimes, early during initialization, we already generate audit logs even though no cluster state is avaiable yet. This can lead the assertion errors.
This fix properly handles situations where no cluster state is available.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/302)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/138)

### Removed invalid log messages

Search Guard would sometimes complain too early about error states, even though initialization was not finished yet. This fixes those cases.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/301)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/300)

### Updating configuration of type `sg_auth_token_service` was broken

Users who have tried to update the auth_token_service config in FLX 1.0.0 just get a service which is disabled due to an invalid configuration. This should be fixed with just updating the config on a version containing this fix.

* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/277)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/115)

### More fixes

This update includes a number of further minor fixes. See [the Gitlab milestone](https://git.floragunn.com/groups/search-guard/-/milestones/8) for all details.
