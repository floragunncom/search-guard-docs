---
title: Upgrading to Elasticsearch 6.5.x
slug: upgrading-560
category: installation
order: 410
layout: docs
description: Upgrade instructions from Search Guard 6.4.x to Search Guard 6.5.x
---
<!---
Copryight 2017 floragunn GmbH
-->

# Upgrading to Search Guard 6.5.x and above
{: .no_toc}

{% include_relative _includes/toc.md %}

If you are upgrading from Elasticsearch / Search Guard <= 6.5.0 to an Elasticsearch / Search Guard version >= 6.5.0 please read the following instructions.

## Kibana roles changes

Due to changes in the Elastic stack, the permissions for the built-in `sg_kibana_server` and `sg_kibana_user` have changed.

Please update your role definitions accordingly by comparing your permissions for the `sg_kibana_server` and `sg_kibana_user` with either:

* the `sg_roles.yml` file in the `plugins/search-guard-6/sgconfig` folder
* the [sg_roles.yml on GitHub](https://github.com/floragunncom/search-guard/blob/13e90b17509e95413e85ea67d2cf105935204dac/sgconfig/sg_roles.yml){:target="_blank"}

## Kibana Spaces

At the moment Search Guard is not compatible with Kibana Spaces. In your `kibana.yml`, disable Spaces by setting

```
xpack.spaces.enabled: false
```

## Kibana saved objects migration

From 6.5.0 onwards, Kibana will check if all saved objects like visualization or dashboards need to be migrated to a newer version. Please read the official article about saved objects migration on the official Kibana docs:

* [Saved objects migration](https://www.elastic.co/guide/en/kibana/current/upgrade-migrations.html){:target="_blank"}  

### Search Guard multi tenancy: index migration

On startup, Search Guard will migrate all tenant indices automatically by applying the saved objects migration to all tenand indices. Search Guard will perform the exact same steps as Kibana. All instructions in the [Saved objects migration](https://www.elastic.co/guide/en/kibana/current/upgrade-migrations.html){:target="_blank"} documentation apply for the Search Guard tenant indices as well. 

### Manual index migration

In case you need to migrate a tenant index manually, Search Guard provides an API for it. Example:

```
curl -k -u kibanaserver:kibanaserver \
  -H "kbn-xsrf: true" \
  -XPOST 'https://kibana.example.com:5601/api/v1/multitenancy/migrate/.kibana_1592542611_humanresources?force=false'
```

Notes:

* The API endpoint must be called with the Kibana server user. Other users and roles do not have permission to use this endpoint
* You need to provide the original **tenant index name**, not the tenant name. 
* Search Guard will check if the provided index name is indeed a tenant index. If this is not the case, the migration will not be executed
* You can disable these checks by adding `force=false`.

## X-Pack: Kibana optimize bug

Kibana currently has a bug in the optimization step if you use X-Pack, but disable reporting:

* [Kibana not starting if reporting is disabled](https://github.com/elastic/kibana/issues/25728)

Please check if your Kibana version is affected and correct your `kibana.yml` accordingly.




