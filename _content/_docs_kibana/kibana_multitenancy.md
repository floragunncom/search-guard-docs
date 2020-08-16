---
title: Multitenancy
html_title: Kibana Multitenancy
slug: kibana-multi-tenancy
category: kibana
order: 300
layout: docs
edition: enterprise
description: Search Guard adds true multi tenancy to Kibana. Separate your dashboards and visualizations by users and roles.
resources:
  - "https://search-guard.com/kibana-multi-tenancy-search-guard/|Kibana Multi Tenancy with Search Guard (blog post)"
  - "https://sematext.com/blog/elasticsearch-kibana-security-search-guard/|Securing Elasticsearch and Kibana with Search Guard for free (blog post, external)"
  - "troubleshooting-multitenancy|Multitenancy Troubleshooting (documentation)"

---

# Kibana Multitenancy
{: .no_toc}

{% include toc.md %}

## Tenants: Definition

A Kibana tenant is a named container for storing saved objects ("space"). A tenant can be assigned to one or more Search Guard roles.  The role can have read-write or read-only access to the tenant and thus the saved objects in it. 
A Kibana user selects the tenant that he or she wants to work with. Search Guard ensures that the saved objects are placed in the selected tenant.

Any Kibana user always has access to two preconfigured tenants: Global and Private.

The Global tenant is shared with every user. This is the default tenant if no other tenant is selected.  You'll find objects that you have created before installing the multi tenancy module there.

The Private tenant is not shared.  It is only accessible for the currently logged in user.

## Installation and configuration

In order for multi tenancy to work, you need to configure:

* Elasticsearch: Search Guard and the Kibana multitenancy enterprise module (automatically installed).
* Kibana: the Search Guard Kibana plugin.

Multi tenancy will not work properly if the configuration does not match in Elasticsearch and Kibana.


### Elasticsearch: Configuration

Multi tenancy is configured in sg_config.yml:

```yaml
---
_sg_meta:
  type: "config"
  config_version: 2

sg_config:
  dynamic:
    do_not_fail_on_forbidden: true 
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

| Name | Description |
|---|---|
| searchguard.dynamic.kibana.multitenancy_enabled  |  boolean, enable or disable multi tenancy. Default: true.|
| searchguard.dynamic.kibana.server_username |  String, the name of the Kibana server user as configured in your kibana.yml. The names must match in both configurations. Default: `kibanaserver`.|
| searchguard.dynamic.kibana.index  | String, the name of the Kibana index as configured in your kibana.yml. The index name must match in both configurations. Default: `.kibana`. |
| searchguard.dynamic.do\_not\_fail\_on\_forbidden  | boolean, if enabled Search Guard will remove content from the search result a user is not allowed to see. If disabled, a security exceptions is returned. Should be set to true if you use Kibana. Default: false.  |
{: .config-table}

### Defining tenants

If you do not configure anything special, every user has access to the Global and Private tenant by default, with read/write access.

You can define an arbitrary number of additional tenants in `sg_tenants.yml`, for example:

```yaml
_sg_meta:
  type: "tenants"
  config_version: 2

admin_tenant:
  description: "The admin tenant"

human_resources:
  description: "The human resources tenant"
```

### Assigning tenants to Search Guard roles:

You can assign one or more tenants to Search Guard roles in `sg_roles.yml`, for example:

```
sg_human_resources:
  cluster_permissions:
    - ...
  index_permissions:
    - ...
  tenant_permissions:
    - tenant_patterns:
      - human_resources
      allowed_actions:
        - SGS_KIBANA_ALL_WRITE
    - tenant_patterns:
      - admin_tenant
      allowed_actions:
        - SGS_KIBANA_ALL_READ
```
In this example, a user that has the role `sg_human_resources` has access to the tenant human_resources with read/write access, and read-only access to the tenant `admin_tenant`.

At the moment the only allowed values for `allowed_actions` are `SGS_KIBANA_ALL_WRITE` and `SGS_KIBANA_ALL_READ`. The option to assign finer-grained permissions will follow soon.
{: .note .js-note .note-info}


### Kibana: Plugin Configuration

Enable the multi tenancy feature in `kibana.yml` by adding:

```yaml
searchguard.multitenancy.enabled: true
```

In addition, Kibana requires you to whitelist all HTTP headers that should be passed from Kibana to Elasticsearch. The multi tenancy feature uses one specific header, named `sgtenant`. Add this header and also the standard `Authorization` header to the white list. If the `sgtenant` header is not whitelisted, an error message is logged on startup and the status of Kibana will be red.

```yaml
elasticsearch.requestHeadersWhitelist: ["sgtenant", "Authorization", ...]
```

Check that the Kibana server user and the Kibana index name matches in both kibana.yml and sg_config. The contents of the following keys must match:

Kibana server user:

```yaml
kibana.yml: elasticsearch.username
sg_config: searchguard.dynamic.kibana.server_username
```

Kibana index name:

```yaml
kibana.yml: kibana.index
sg_config: searchguard.dynamic.kibana.index
```

### Kibana: Tenant Configuration

By default, Search Guard offers two default tenants for each user, Global and Private. The Global tenant is shared between all users and uses the Kibana index as configured in `kibana.yml`. Thus, all dashboards and visualizations that have been created prior to installing multi tenancy can be found in this tenant.

The Private tenant is meant as a user's private space, thus is not shared.

You can enable and disable these tenants by the following `kibana.yml` configuration keys:

| Name | Description |
|---|---|
| searchguard.multitenancy.tenants.enable_global  |  boolean, enable or disable the global tenant. Default: true.|
| searchguard.multitenancy.tenants.enable_private  |  boolean, enable or disable the private tenant. Default: true.|
{: .config-table}

**Note that each user needs to have at least one tenant configured, otherwise Search Guard does not know which tenant to use. If you disable both the Global and Private tenant, and the user does not have any other tenants configured, login will not be possible.**

### Kibana: Setting preferred / default tenants

If a user logs in the first time and has not chosen a tenant yet, Search Guard will

* collect all available tenants for the logged in user
* sort them alphabetically
* if enabled, add the global and private tenant on top 
* choose the first tenant from this list  

If you want to change the way Search Guard selects the default tenant, configure the preferred tenants in `kibana.yml`:

```yaml
searchguard.multitenancy.tenants.preferred: ["tenant1","tenant2",...]
```

Search Guard will compare the list of preferred tenants with the list of available tenants for the logged in user, and chose the first matching tenant.

### Kibana: Selecting tenants by query parameter

Tenants can also be switched by adding a query parameter to the URL. This is especially handy if you want to share a visualization or dashboard.

For any Kibana URL, you can add a query param `sgtenant` which will overwrite the currently selected tenant.

```
http://localhost:5601/app/kibana?sgtenant=mytenant#/visualize/edit/919f5810-55ff-11e7-a198-5f6d82ac1c15?_g=()
```

Make sure to add the the query parameter before the hash sign.

### Using the Kibana API

Kibana offers an API for saved objects like index patterns, dashboards and visualizations. In order to use this API in conjunction with tenants, specify the tenant by adding the `sgtenant` HTTP header:

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-bash">
<code class=" js-code language-markup">
curl \
   -u hr_employee:hr_employee \
   <b>-H "sgtenant: management" \</b>
   -H 'Content-Type: application/json' \
   -H "kbn-xsrf: true" \
   -XGET "http://localhost:5601/api/saved_objects"
</code>
</pre>
</div>


### Filter bar for tenants

If you have a huge amount of tenants, the tenant list can get long. You can use a filter bar to quickly filter the tenants list. Enable it in `kibana.yml`:

```yaml
searchguard.multitenancy.enable_filter: true
```

Which will display a filter bar in the top navigation of the page:

<p align="center">
<img src="
kibana_filter_roles.png" style="width: 90%" class="md_image"/>
</p>

## Selecting tenants in Kibana

If the plugin is installed correctly, you will see a new entry in the left navigation panel called "Tenants":

<p align="center">
<img src="
kibana_mt_nav.png" style="width: 20%" class="md_image"/>
</p>

After clicking it, you will see all available tenants for the currently logged in user. Select the tenant you want to work with:

<p align="center">
<img src="
kibana_select_tenants.png" style="width: 100%" class="md_image"/>
</p>


All saved objects will be placed in the selected tenant. Search Guard remembers the last selected tenant per user.  So you do not need to change it every time you log in.


## Under the hood: Index rewriting, Snapshot & Restore

In a plain vanilla Kibana installation, all saved objects are stored in one global index.  Search Guard maintains separate indices for each tenant.

For example, if your Kibana index is called ".kibana", and the currently selected tenant is "human_resources", Search Guard will create a new index called something like ".kibana\_1592542611\_humanresources", and places saved objects will in this index.

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

Search Guard automatically makes sure that the index names do not contain any illegal characters. Search Guard also checks the user's permissions for the selected tenant index. You do not need to configure anything special in `sg_roles.yml`, apart from the standard permissions for the Kibana index. See [Using Search Guard with Kibana](../_docs_kibana/kibana_installation.md) for further information.

**If you use snapshot / restore, you need to include all tenant indices, otherwise you will loose data!**

In order to include all Kibana indices in your backup / snapshot, the easiest way is to simply use wildcards:

```
<kibana index name>*
```

## Fixing curl issues

If you experience problems with curl commands see [Fixing curl](../_troubleshooting/tls_troubleshooting.md#fixing-curl) first before reporting any issues.