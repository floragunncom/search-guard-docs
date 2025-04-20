---
title: Kibana 7.x-53.0.0
permalink: changelog-kibana-7x-53_0_0
layout: changelogs
description: Changelog for the Search Guard Kibana Plugin 7.x-53.0.0
---
<!--- Copyright 2021 floragunn GmbH -->


# Search Guard Kibana Plugin 53.0

**Release Date: 2022-02-22**

This is a bugfix release for the Search Guard Kibana plugin. It fixes issues with OIDC authentication and Signals watch editors.

## Bug Fixes

### OIDC Login

The new OIDC redirect handling implemented in Search Guard 51.0 caused issues with many Identity Providers, as it required the specification of a wildcard for the OIDC redirect URI. This is not supported by the OIDC standard. This release reverts these changes; thus, login with the affected Identity Providers will work again. 

**Note:** However, this also means that deeplinks to dashboards will be only preserved upon logging in if these have been created as "short URLs". 

This fix also fixes issues with Kibana instances running on a non-empty base URL.

**Details:**

* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/760)

### Signals: Allow 0 as valid threshold value for Signal severity thresholds

The Signals watch editor did not properly support the value 0 for Signals severity thresholds. This has been fixed.

**Details:**

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/392)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/762)

### Signals: Changes for Transforms in Index Actions were mirrored between Alert actions and Resolve actions.

If editing watches with transforms inside index actions using the Signals GUI, settings on these transforms were mirrored between alert actions and resolve actions. This has been fixed.

**Details:**

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/391)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/761)