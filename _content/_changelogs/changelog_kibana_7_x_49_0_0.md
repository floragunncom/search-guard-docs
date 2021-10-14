---
title: Kibana 7.x-49.0.0
permalink: changelog-kibana-7x-49_0_0
category: changelogs-kibana
order: -200
layout: changelogs
description: Changelog for Kibana 7.x-49.0.0	
---

<!--- Copyright 2021 floragunn GmbH -->

**Release Date: 02.02.2021**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)


## Improvements



### Search Guard UI

#### Dynamic DLS Queries in Role configuration

We added support for the [dynamic DLS queries](https://docs.search-guard.com/latest/document-level-security#dynamic-queries-variable-substitution) on the Search Guard configuration Create Role page. With this feature, you can write dynamic queries based on the current users' attributes.

```
{"query": {"term": {"manager": ${user.name|toJson }}}}
```

#### Search Guard roles for internal user database

In addition to backend roles, it is now possible to specify Search Guard roles when adding or editing internal users in the configuration UI.


### OIDC Configuration

With the new [backend improvements for OIDC](https://docs.search-guard.com/latest/changelog-searchguard-7.x-48_0_0), the following settings for Kibana are not necessary any more and have been deprecated. As the Search Guard backend should already have the necessary configuration, the options can and should be removed from `kibana.yml` without an explicit replacement.
* `searchguard.openid.connect_url`
* `searchguard.openid.root_ca`
* `searchguard.openid.verify_hostnames`
Please remember to remove the settings from removed from `kibana.yml`. Future versions of Search Guard will conside the presence of these options as a configuration error. 
<p />


## Bug Fixes



### Search Guard UI

* Basic auth login page: support for HTML tags when customising the title and the subtitle was broken. Fixed.
* Basic auth login page: custom CSS styling for the login button was broken. Fixed.
* We fixed the advanced switch in the Kibana Search Guard configuration plugin on the Create Action Group page.
* We improved the Kibana plugin toast error details. Now the error toast doesn't explode beyond the screen if there is a large amount of metadata. You can click the Details button to explore the error metadata in a modal.  
* OIDC-based authentication: Unauthenticated users trying to access specific Kibana pages are now returned again to the particular page after login. Before the fix, such users would be directed to an overview page
<p />


