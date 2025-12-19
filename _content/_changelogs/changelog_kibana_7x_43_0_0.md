---
title: Kibana 7.x-43.0.0
permalink: changelog-kibana-7x-43_0_0
layout: docs
section: security
description: Changelog for Kibana 7.x-43.0.0
---
<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 06.07.2020**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7)

## Improvements



### Signals UI

* Improved the watch Blocks mode UI.
<p />
* Added Blocks UI for action checks for a watch in the Blocks mode.
<p />


### Search Guard UI

* Improved error message when uploading a license that isn't valid.
<p />


## Bug Fixes



### Kibana Authentication and Multi-Tenancy

* Added a configuration option `searchguard.auth.disable_authinfo_cache` to disable caching of the current user's auth info. Useful when the size of the authinfo response is too large to store in a cookie.
<p />
* Since SG 42, using Kibana with a non-default tenant could show the error `No index-level perm match for User ... Action [indices:data/read/mget[shard]]`. This would only happen if the corresponding `.kibana` index went through migration at least once.
<p />
* Fixed a regression where the tenant query parameter wasn't always respected, for example when using a short link generated in Kibana.
<p />


