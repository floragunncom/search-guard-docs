---
title: Multi-Tenancy
html_title: Kibana Multi-Tenancy
permalink: kibana-multi-tenancy
layout: docs
edition: enterprise
description: Search Guard adds true Multi-Tenancy to Kibana. Separate your dashboards
  and visualizations by users and roles.
resources:
- https://search-guard.com/kibana-multi-tenancy-search-guard/|Kibana Multi Tenancy
  with Search Guard (blog post)
- https://sematext.com/blog/elasticsearch-kibana-security-search-guard/|Securing Elasticsearch
  and Kibana with Search Guard for free (blog post, external)
- troubleshooting-Multi-Tenancy|Multitenancy Troubleshooting (documentation)
---
# Kibana Multi-Tenancy
{: .no_toc}

{% include toc.md %}

> ### Important note for SearchGuard in versions 2.x.x
> 
> Any data created before implementing the
> `multi-tenancy` module may be lost, necessitating a secure backup.

<span style="color:red">If you're upgrading to SG FLX 2.0.0, please review [the upgrade guide](../_docs_installation/sg200_upgrade.md).
This version introduces backwards-incompatible changes.</span>
{: .note .js-note .note-warning}

## Tenants: Definition

A Kibana tenant is a named container for storing saved objects. A tenant can be assigned to one or more Search Guard roles.  The role can have read-write or read-only access to the tenant and thus the saved objects in it. 
A Kibana user selects the tenant that he or she wants to work with. Search Guard ensures that the saved objects are placed in the selected tenant.

The Global tenant serves as a shared platform for all users, acting as the default 
when no specific tenant is designated. It's crucial to 
grant users access to the global tenant. Write access to Global tenant can be achieved by assigning
role `SGS_KIBANA_USER`.

The Private tenant is not shared.  It is only accessible for the currently logged-in user.


## Elasticsearch: Configuration

### Multi-Tenancy configuration
Multi-Tenancy is configured in `sg_frontend_multi_tenancy.yml`.

The following configuration keys are available:

#### For FLX v2.0.0 and higher

| Name                   | Description                                                                                                                                        |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| server_user            | String, the name of the Kibana server user as configured in your kibana.yml. The names must match in both configurations. Default: `kibanaserver`. |
| index                  | String, the name of the Kibana index as configured in your kibana.yml. The index name must match in both configurations. Default: `.kibana`.       |
| global_tenant_enabled  | boolean, enable or disable the SGS_GLOBAL_TENANT. Default: true.                                                                                   |
| preferred_tenants      | List, a list of tenants to try to use if the user has not requested a tenant yet. Default empty.                                                   |
{: .config-table}

##### Enabling / Disabling MT

Please keep in mind that due to some technical limitations **once you enable MT, it cannot be easily disabled.** In such case please contact the support team. 

1. Run the following command:
```bash
./sgctl.sh special enable-mt
```
2. Header `sgtenant` needs to be forwarded to Elasticsearch, which can be achieved by adding the header name to the property `elasticsearch.requestHeadersWhitelist` in the `kibana.yml` file.
3. Check roles assigned to users. Users with the role `SGS_KIBANA_USER_NO_MT` are not able to access the Kibana user interface when multitenacy is enabled. Therefore, an administrator should consider assigning to users the following build-in roles:
   - `SGS_KIBANA_USER`
   - `SGS_KIBANA_USER_NO_GLOBAL_TENANT`

It is also possible to use custom roles. However, it is important to ensure each user has access to at least one tenant. Otherwise, the user is unable to log into Kibana.

#### For versions prior to FLX v2.0.0

| Name | Description |
|---|---|
| enabled  |  boolean, enable or disable Multi-Tenancy. Default: true.|
| server_user |  String, the name of the Kibana server user as configured in your kibana.yml. The names must match in both configurations. Default: `kibanaserver`.|
| index  | String, the name of the Kibana index as configured in your kibana.yml. The index name must match in both configurations. Default: `.kibana`. |
{: .config-table}

### Defining tenants

#### For FLX v2.0.0 and higher

If you do not configure anything special, every user has access to the Global tenant by default, with read/write access.

Private tenants are no longer supported.

You can define an arbitrary number of additional tenants in `sg_tenants.yml`, for example:

```yaml
admin_tenant:
  description: "The admin tenant"

human_resources:
  description: "The human resources tenant"
```

#### For versions prior to FLX v2.0.0

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

### Setting preferred / default tenants

#### For FLX v2.0.0 and higher

In order to choose user's preferred / default tenant Search Guard will:

* return first tenant to which user has write access or user has read access and tenant exists
* Search Guard checks tenants in the following order:
  * list of preferred tenants 
  * Global tenant
  * tenants available to the user
* Global tenant is not taken into account if it's disabled

  
#### For versions prior to FLX v2.0.0

In older versions, configuration and selection of the preferred / default tenant is done on the Kibana plugin side as described below.

## Kibana: Plugin Configuration

Kibana requires you to whitelist all HTTP headers that should be passed from Kibana to Elasticsearch. The Multi-Tenancy feature uses one specific header, named `sgtenant`. Add this header and also the standard `Authorization` header to the white list. If the `sgtenant` header is not whitelisted, an error message is logged on startup and the status of Kibana will be red.

```yaml
elasticsearch.requestHeadersWhitelist: ["sgtenant", "Authorization", ...]
```

Also, please check that the Kibana server user and the Kibana index name matches in both kibana.yml and sg_frontend_multi_tenancy.yml. The contents of the following keys must match:

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

### Enable Multi-Tenancy

#### For FLX v2.0.0 and higher
As of Search Guard FLX v2.0.0, the Multi-Tenancy configuration has been removed from the Kibana plugin.
Instead, Multi-Tenancy is configured in the Elasticsearch plugin, as described in the [Elasticsearch: Configuration section](#elasticsearch-configuration) above.

#### For versions prior to FLX v2.0.0
Enable the Multi-Tenancy feature in `kibana.yml` by adding:

```yaml
searchguard.multitenancy.enabled: true
```

### Kibana: Tenant Configuration

#### For FLX v2.0.0 and higher

As of Search Guard FLX v2.0.0, the Multi-Tenancy configuration has been removed from the Kibana plugin.
Instead, Multi-Tenancy is configured in the Elasticsearch plugin, as described in the [Elasticsearch: Configuration section](#elasticsearch-configuration) above.

#### For versions prior to FLX v2.0.0

By default, Search Guard offers two default tenants for each user, Global and Private. The Global tenant is shared between all users and uses the Kibana index as configured in `kibana.yml`. Thus, all dashboards and visualizations that have been created prior to installing Multi-Tenancy can be found in this tenant.

The Private tenant is meant as a user's private space, thus is not shared.

You can enable and disable these tenants by the following `kibana.yml` configuration keys:

| Name | Description |
|---|---|
| searchguard.multitenancy.tenants.enable_global  |  boolean, enable or disable the global tenant. Default: true.|
| searchguard.multitenancy.tenants.enable_private  |  boolean, enable or disable the private tenant. Default: true.|
{: .config-table}

**Note that each user needs to have at least one tenant configured, otherwise Search Guard does not know which tenant to use. If you disable both the Global and Private tenant, and the user does not have any other tenants configured, login will not be possible.**

### Kibana: Setting preferred / default tenants

#### For FLX v2.0.0 and higher
As of Search Guard FLX v2.0.0, the Multi-Tenancy configuration has been removed from the Kibana plugin.
Instead, Multi-Tenancy is configured in the Elasticsearch plugin, as described in the [Elasticsearch: Configuration section](#elasticsearch-configuration) above.

#### For versions prior to FLX v2.0.0

If a user logs in the first time and has not chosen a tenant yet, Search Guard will

* collect all available tenants for the logged in user
* sort them alphabetically
* if enabled, add the global and private tenant on top 
* choose the first tenant from this list  

#### For FLX v2.0.0 and higher
Please see the configuration section for ElasticSearch above.
If you want to change the way Search Guard selects the default tenant, configure the preferred tenants in `kibana.yml`:

#### For versions prior to FLX v2.0.0

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



## Under the hood
### For FLX v2.0.0 and higher
When the Multi-Tenancy is enabled, then all Kibana saved objects which does not belong to the global tenant are modified in the following way on the storiage level.
- The ID of the saved object is extended with the tenant ID.
- Attribute `sg_tenant`, which contains tenant ID, is added to each saved object. Please keep in mind that this is only an implementation detail and can be changed without warning in the future. Therefore, software integrated with Search Guard and Elasticsearch should not rely on this behaviour.

The procedure described above applies only to the following indices
* `.kibana`
* `.kibana_analytics`
* `.kibana_ingest`
* `.kibana_security_solution`
* `.kibana_alerting_cases.`

When an HTTP request with header `sgtenant` or `sg_tenant` or proper query parameter is sent to Elasticsearch, the Search Guard imposes additional filtering on saved objects. Thus, saved objects that only belong to the tenant specified in the header (or query parameter) are processed. Therefore, when Multi-Tenancy is enabled, the user authorized to use Kibana should not have assigned any permissions related to the above indices. Such index permissions allow users to circumvent checks imposed by the Multi-Tenancy module. An example of the role which grants such permission to users is `SGS_KIBANA_USER_NO_MT`. Thus, users should not be assigned the role in environments where Multi-Tenancy is enabled. Furthermore, the Search Guard removes a part of the saved object ID related to Multi-Tenancy before returning responses. On the other hand, the attribute `sg_tenant` is not removed from responses.

Search Guard treats the global tenant exceptionally. The tenant's saved object IDs are not extended, and the attribute `sg _tenant` is not added.

### For versions prior to FLX v2.0.0: Index rewriting, Snapshot & Restore
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

## Limitations of multi-tenancy implementation in FLX v2.0.0 and higher
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
- Multi-tenancy cannot be switched off without data lost.
- Legacy Multi-Tenancy configuration should not be used with Search Guard FLX 2.0.0 or newer.
- Private tenants are not supported; data associated with private tenants will not be migrated to version 2.0.0. 

The system administration before usage multi-tenancy implementation provided with SearchGuard 2.x.x should consider if the above limitations are acceptable.


## Fixing curl issues

If you experience problems with curl commands see [Fixing curl](../_troubleshooting/tls_troubleshooting.md#fixing-curl) first before reporting any issues.