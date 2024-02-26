---
title: Multitenancy
html_title: Kibana Multitenancy
permalink: kibana-multi-tenancy
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

> ### Important note for SearchGuard in versions 2.x.x
> 
> Any data created before implementing the
> `multi-tenancy` module may be lost, necessitating a secure backup.


## Tenants: Definition

A Kibana tenant is a named container for storing saved objects. A tenant can be assigned to one or more Search Guard roles.  The role can have read-write or read-only access to the tenant and thus the saved objects in it. 
A Kibana user selects the tenant that he or she wants to work with. Search Guard ensures that the saved objects are placed in the selected tenant.

The Global tenant serves as a shared platform for all users, acting as the default 
when no specific tenant is designated. It's crucial to 
grant users access to the global tenant. Write access to Global tenant can be achieved by assigning
role `SGS_KIBANA_MT_USER`.

The Private tenant is not shared.  It is only accessible for the currently logged-in user.


### Elasticsearch: Configuration

Multi tenancy is configured in `sg_frontend_multi_tenancy.yml`.

The following configuration keys are available:

| Name | Description |
|---|---|
| enabled  |  boolean, enable or disable multi tenancy. Default: true.|
| server_user |  String, the name of the Kibana server user as configured in your kibana.yml. The names must match in both configurations. Default: `kibanaserver`.|
| index  | String, the name of the Kibana index as configured in your kibana.yml. The index name must match in both configurations. Default: `.kibana`. |
{: .config-table}

### Defining tenants

If you do not configure anything special, every user has access to the Global and Private tenant by default, with read/write access.

You can define an arbitrary number of additional tenants in `sg_tenants.yml`, for example:

```yaml
admin_tenant:
  description: "The admin tenant"

human_resources:
  description: "The human resources tenant"
```

### Assigning tenants to Search Guard roles

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

### Widcards and regular expressions in tenant patterns

You can use wildcards and regular expression in tenant names to make them more dynamic.

* An asterisk (`*`) will match any character sequence (or an empty sequence)
  * `*my*index` will match `my_first_index` as well as `myindex` but not `myindex1`. 
* A question mark (`?`) will match any single character (but NOT empty character)
  * `?kibana` will match `.kibana` but not `kibana` 
* Regular expressions have to be enclosed in `/`: `'/<java regex>/'`
  * `'/\S*/'` will match any non whitespace characters

Example: 

```yaml
sg_own_index:
  cluster_permissions:
    - ...
  index_permissions:
    - ... 
  tenant_permissions:
    - tenant_patterns:
      - 'dept_*'
      - '/logstash-[1-9]{2}/'
      allowed_actions:
      - "SGS_KIBANA_ALL_WRITE"
```      

### User attributes in tenant patterns
{: #user-attributes }

You can use [user attributes](../_docs_roles_permissions/configuration_roles_permissions.md#user-attributes) when defining tenant patterns to make them more dynamic.

For example, if the user has an attribute `department`, you can define a tenant pattern like:

```yaml
sg_own_index:
  cluster_permissions:
    - ...
  index_permissions:
    - ... 
  tenant_permissions:
    - tenant_patterns:
      - 'dept_${user.attrs.department}'
      allowed_actions:
      - "SGS_KIBANA_ALL_WRITE"
```



### Kibana: Plugin Configuration

Enable the multi tenancy feature in `kibana.yml` by adding:

```yaml
searchguard.multitenancy.enabled: true
```

In addition, Kibana requires you to whitelist all HTTP headers that should be passed from Kibana to Elasticsearch. The multi tenancy feature uses one specific header, named `sgtenant`. Add this header and also the standard `Authorization` header to the white list. If the `sgtenant` header is not whitelisted, an error message is logged on startup and the status of Kibana will be red.

```yaml
elasticsearch.requestHeadersWhitelist: ["sgtenant", "Authorization", ...]
```

Check that the Kibana server user and the Kibana index name matches in both kibana.yml and sg_frontend_multi_tenancy.yml. The contents of the following keys must match:

Kibana server user:

```yaml
kibana.yml: elasticsearch.username
sg_frontend_multi_tenancy.yml: server_user
```

Kibana index name:

```yaml
kibana.yml: kibana.index
sg_frontend_multi_tenancy.yml: index
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

## Limitations of multi-tenancy implementation in SearchGuard 2.x.x
Most of the limitations are related to how saved object IDs are modified by SearchGuard to map saved objects to tenants. SearchGuard appends to each saved object's ID a tenant ID. SearchGuard also replaces an extended version of the saved object ID with the genuine one before returning saved objects via API. The genuine version of the saved object ID is returned only when a tenant is selected via the appropriate HTTP header. However, this is not always possible. The inability to restore genuine saved object IDs results in the following limitations
- Cannot use document ID in query. Such a query may not gain the desired result or gain incorrect results. Example of such a query:
```
GET /.kibana/_search
{
    "query": {
       "ids": {
          "values": [
             "space:custom"
          ]
       }
    }
}
```
- Scripts (e.g. painless scripts) may receive document ID in an extended version. An example of such a script is visible below. The below script will set an extended version of ID in the `description` attribute.
```
POST /.kibana/_update/space:myspace
{
    "script": {
       "source": "ctx._source.space.description = ctx['_id']",
       "lang": "painless"
    }
}
```
- Error responses and error messages can contain ID with tenant scope. An example of such a response with extended ID `space:nonspace__sg_ten__-152937574_admintenant` is visible below. The genuine saved object ID is `space:nonspace`.
```json
{
  "error": {
    "root_cause": [
      {
        "type": "document_missing_exception",
        "reason": "[space:nonspace__sg_ten__-152937574_admintenant]: document missing",
        "index_uuid": "P-DqhmPUQQO8zzSt19nF7g",
        "shard": "0",
        "index": ".kibana_8.12.0_001"
      }
    ],
    "type": "document_missing_exception",
    "reason": "[space:nonspace__sg_ten__-152937574_admintenant]: document missing",
    "index_uuid": "P-DqhmPUQQO8zzSt19nF7g",
    "shard": "0",
    "index": ".kibana_8.12.0_001"
  },
  "status": 404
}
```
Additionally, limitations not related to ID extensions are
- Saved objects contain an additional attribute `sg_tenant` which contains tenant identification.
- An extended version of the document ID may be returned in the query result if the query reads the content of Kibana-related indices and the tenant is not selected via the appropriate HTTP header.
  - Furthermore, the attribute should not be used and can be removed without warning in future versions of SearchGuard.
- Multi-tenancy cannot be switched on or switched off without data lost.

The system administration before usage multi-tenancy implementation provided with SearchGuard 2.x.x should consider if the above limitations are acceptable.


## Fixing curl issues

If you experience problems with curl commands see [Fixing curl](../_troubleshooting/tls_troubleshooting.md#fixing-curl) first before reporting any issues.