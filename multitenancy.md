<!---
Copryight 2017 floragunn GmbH
-->

# Kibana Multitenancy

**WARNING: Kibana multitenancy support is beta at the moment. Use it at your own risk, and do not use it in production yet!**

## Overview
Kibana does not support multi tenancy out of the box. This means that all stored objects, such as Dashboards, Visualizations and Saved Searches are stored in a global Kibana index.

This index is configured in `kibana.yml`:

```
kibana.index: ".kibana"
```

Kibana uses the Kibana server user to read and write from this index. The Kibana server user is also configured in `kibana.yml`:

```
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"
```

This means that regardless of the permissions an authenticated user has, he/she will always be able to see and modify all Dashboards and Visualizations.

In case the user does not have permissions to access the underlying index of a Visualization, the Visualization will simply be blank and a security exception is logged in Elasticsearch.

The Kibana multitenancy module brings true separation of stored objects based on the configured **tenants** of a users **role**.

## Tenants

### Definition

A Kibana tenant is

> a named container for storing saved objects. A tenant can be assigned to one or more Search Guard roles, and the role can have read-write or read-only access to the tenant and thus the saved objects in it. A Kibana user selects the tenant that he/she wants to work with, and Search Guard ensures that the saved objects are placed in the selected tenant.

Any Kibana user always has acces to two preconfigured tenants: Global and Private.

The Global tenant is shared with every user. This is the default tenant if no other tenenat is selected, and you'll find all saved objects that you have created before installing the multi tenancy module there.

The Private tenant is shared with no one, and only accessible for the currently logged in user.


## Installation and configuration

In order for multitenancy to work, you need to install and configure

* Elasticsearch: Search Guard > v11 and the Kibana multitenancy enterprise module
* Kibana: the Search Guard Kibana plugin

Multi tenancy will not work properly if you install only one of the modules / plugins, or if the configuration does not match on both Elasticsearch and Kibana side.

### Elasticsearch: Installation

Make sure you have a Search Guard version with multi tenancy support installed and configured. Search Guard supports multi tenancy from v12 onwards.

**At the time of writing, the only available version is a beta snapshot for Elasticsearch 5.2.2:** 

```
bin/elasticsearch-plugin install -b com.floragunn:search-guard-5:5.2.2-11-mtbeta2
```

Download the multi tenancy enterprise module, place it in the plugins/search-guard-5 folder of every node, and restart each node. 

**At the time of writing, the only available version is a beta snapshot for Elasticsearch 5.2.2:** 

[Kibana Multitenancy module 5.2-1-beta2](https://oss.sonatype.org/content/repositories/releases/com/floragunn/dlic-search-guard-module-kibana-multitenancy/5.2-1-beta2/dlic-search-guard-module-kibana-multitenancy-5.2-1-beta2-jar-with-dependencies.jar)

If everything is installed correctly, you should see the following entries in the elasticsearch logs on startup:

```
***************************************************
Search Guard Kibana Multitenancy module is not free
software for commercial use in production.
You have to obtain a license if you 
use it in production.
***************************************************
Search Guard Kibana Multitenancy module is BETA
software, do not use it in production
***************************************************
```

### Elasticsearch: Configuration

Multi tenancy is configured in sg_config.yml and is thus hot reloadable:

```
searchguard:
  dynamic:
    kibana:
      multitenancy_enabled: true
      server_username: 'xxx'
      ...
    http:
      anonymous_auth_enabled: false
      xff:
        enabled: false
        ...
```
The following configuration keys are available:

| Name  | Description  |
|---|---|
| searchguard.dynamic.kibana.multitenancy_enabled  |  boolean, enable or disable multi tenancy. Defaut: true|
|  searchguard.dynamic.kibana.server_username |  String, the name of the Kibana server user as configured in your kibana.yml. The names must match in both configurations, otherwise multi tenancy will not work. Default: 'kibanaserver'|
| searchguard.dynamic.kibana.index  | String, the name of the Kibana index as configured in your kibana.yml. The index name must match in both configurations, otherwise multi tenancy will not work. Default: '.kibana' |
| searchguard.dynamic.kibana.do\_not\_fail\_on\_forbidden  | boolean, if enabled Search Guard will remove content from the search result a user is not allowed to see silently. If disabled, a security exceptions is returned. Default: false  |
    
#### Adding tenants

If you do not configure anything special, every user has access to the Global and Private tenant by default, with read/write access.

You can define an arbitrary number of additional tenants per Search Guard role in `sg_roles.yml`, for example:

```
sg_human_resources:
  cluster:
    ...
  indices:
    ...
  tenants:
    human_resources: RW
    human_resources_readonly: RO
```

In this example, a user that has the role `sg_human_resources` has access to the tenant human_resources with read/write access, and read-only access to the tenant `human_resources_readonly`.

### Kibana: Installation

Download the latest [Search Guard Kibana plugin](https://github.com/floragunncom/search-guard-kibana-plugin/releases) matching your Kibana version from github. The plugin supports multi tenancy from v2 onwards:

[Search Guard Kibana plugin releases](https://github.com/floragunncom/search-guard-kibana-plugin/releases)

The installation procedure is the same as for any other Kibana plugin:

* cd into your Kibana installaton directory
* Execute: `bin/kibana-plugin install file:///path/to/searchguard-kibana-<version>.zip` 

**At the time of writing, the only available version is a beta snapshot for Kibana 5.2.2:** 

[Search Guard Kibana plugin 5.2.2-beta2](https://github.com/floragunncom/search-guard-kibana-plugin/releases/tag/v5.2.2-beta2)

### Kibana: Configuration

Enable the multi tenancy feature in `kibana.yml` by adding:

```
searchguard.multitenancy.enabled: true
```

In addition, Kibana requires you to whitelist all HTTP headers that should be passed from Kibana to Elasticsearch. The multi tenancy feature uses one specific header, named sg_tenant. Add this header to the white list:

```
elasticsearch.requestHeadersWhitelist: ["sg_tenant", ..., ...]
```

Check that both the Kibana server user and the Kibana index name matches in both kibana.yml and sg_config. The contents of the following keys must match:

Kibana server user:

```
kibana.yml: elasticsearch.username
sg_config: searchguard.dynamic.kibana.server_username
```

Kibana index name:

```
kibana.yml: kibana.index
sg_config: searchguard.dynamic.kibana.index 
```

## Selecting tenants in Kibana

If the plugin is installed correctly, you will see a new entry in the left navigation panel called "Tenants":

<img src="images/kibana_mt_nav.png" height="400" style="text-align:center">

After clicking on it, you will see all available tenants for the currently logged in user. Select the tenant you want to work with:

<img src="images/kibana_mt.png" >

All saved objects will be placed in the selected tenant.

## Under the hood: Index rewriting, Snapshot & Restore

While in a vanilla Kibana installation all saved objects are stored in one global index, Search Guard maintains separate indices for each tenant.

For example, if your Kibana index is called ".kibana", and the currently selected tenant is "human_resources", Search Guard will create a new index called something like ".kibana\_1592542611\_humanresources", and makes sure all saved objects will be placed in this index.

The structure of the index name for a regular tenant is:

```
<kibana index name>_<tenant hashcode>_<tenant name>
``` 

There are two default tenants in additions, Global and Private. The structure of the index name for the Private tenants is:

```
<kibana index name>_<username hashcode>_<username>
``` 

The structure of the index name for the Global tenants is:

```
<kibana index name>
``` 

Search Guard automatically makes sure that the index names do not contain any illegal characters. Search Guard also checks the users permissions for the selected tenant index. You do not need to configure anything special in `sg_roles.yml`, apart from the standard permissions for the Kibana index. See [Using Search Guard with Kibana](kibana.md) for further information.

**If you use snapshot / restore, you need to include all tenant indices, otherwise you will loose data!**

In order to include all Kibana indices in your backup / snapshot, the easiest way is to simply use wildcards:

```
<kibana index name>*
``` 
