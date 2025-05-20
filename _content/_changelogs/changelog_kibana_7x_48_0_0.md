---
title: Kibana 7.x-48.0.0
permalink: changelog-kibana-7x-48_0_0
layout: changelogs
description: Changelog for Kibana 7.x-48.0.0
---
<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 04.12.2020**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7)

## Improvements

### Kibana New Platform support

The Search Guard Kibana plugin is now based on Kibana's [New Platform Architecture](https://www.elastic.co/blog/introducing-a-new-architecture-for-kibana).

The New Platform especially allows for a tighter integration of Kibana plugins. While this meant fundamental changes to the Search Guard plugin under the hood, not many changes are visible from a user's point of view for now. Most prominently, the loading screen when switching to and from the Search Guard configuration UI is gone.

In the future, this might allow tighter integration between Search Guard or Signals and other plugins.

#### Breaking Changes
* The previously deprecated `kibana.yml` configuration options `searchguard.basicauth.enabled` and `searchguard.jwt.enabled` have been removed now. If you are still using these options, you need to remove them from `kibana.yml`. The options are replaced by `searchguard.auth.type: basicauth` or `searchguard.auth.type: jwt` respectively. 
* If you are using Kerberos, you must set `searchguard.auth.type` to  `kerberos` explicitly.

**Note for users of the beta version:**  While the beta version required applying a patch to Kibana, this is no longer necessary for the release version.
<p />


### Search Guard UI

* The role editing page and the action group editing page in the Search Guard configuration UI now allows the specification of any permission. Before these pages would only allow using action groups known to the plugin.
<p />
* The Create Role page of the Search Guard configuration UI now supports the [permission exclusion feature](https://docs.search-guard.com/latest/roles-permissions#permission-exclusions).
<p />
* The internal user database editor now supports [complex user attributes](https://docs.search-guard.com/latest/changelog-searchguard-7x-46_0_0#multi-valued-attributes-for-internal-user-database).
<p />


## Bug Fixes



### Search Guard UI

* For the authentication types Kerberos and Proxy, the "Logout" link is no longer rendered in the user menu, as these authentication types don't support actual logout.
<p />
* Properly escape white space and other special characters in a resource id in the SG configuration plugin UI and Signals.
<p />
* Fix DLS query removal on the Create Role page in the Kibana plugin. 
<p />
* Read-only mode was broken. Fixed.
<p />

