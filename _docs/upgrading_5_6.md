---
title: Upgrading from 5.x to 6.x
slug: upgrading-5-6
category: installation
order: 400
layout: docs
description: Upgrade instructions from Search Guard 5 to Search Guard 6. 
---
<!---
Copryight 2017 floragunn GmbH
-->

# Upgrading from 5.x to 6.x

Upgrading Search Guard from 5.x to 6.x can be done while you upgrade Elasticsearch from 5.x to 6.x. You can do this by performing a full cluster restart, or by doing a rolling restart: 

**Search Guard supports running a mixed cluster of 5.6.x and 6.x nodes and is thus compatible with the Elasticsearch upgrade path.**

If you have not already done so, make yourself familiar with Elastic's own upgrade instruction for the Elastic stack:

* [Upgrading the Elastic Stack](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html){:target="_blank"}
* [Ugrade Guide](https://www.elastic.co/products/upgrade_guide){:target="_blank"}
* [Upgrade Assistant](https://www.elastic.co/guide/en/kibana/6.x/xpack-upgrade-assistant.html){:target="_blank"}
* [Rolling Upgrades](https://www.elastic.co/guide/en/elasticsearch/reference/6.0/rolling-upgrades.html){:target="_blank"}

## Prerequisites

In order to to perform a rolling restart and upgrade from 5.x to 6.x, you need to run at least:

* Elasticsearch 5.6.x (Elasticsearch requirement)
* Search Guard 5.6.x-18 (Search Guard requirement)

If you run older versions of Elasticsearch and/or Search Guard, please upgrade first.

## Upgrading Search Guard

After upgrading a node from ES 5.x to 6.x, simply [install](installation.md) the [correct version of Search Guard](https://github.com/floragunncom/search-guard/wiki){:target="_blank"} on this node. 

Search Guard 6 is compatible with Search Guard 5 in almost all cases. This means that you do not need to change any configuration settings and can re-use your settings from 5.x. The Search Guard internal configuration index is migrated to the new 6.x format automatically for you.

### Community Edition vs. Enterprise Edition

Search Guard 6 ships with all enterprise features included. If you used only the free Community Edition of Search Guard 5, you need to disable the enterprise features in Search Guard 6 explicitely in `elasticsearch.yml`:

```
searchguard.enterprise_modules_enabled: false
```

* [Enteprise Edition](license_enterprise.md)
* [Community Edition](license_community.md)

### If you use demo certificates

If you used the Search Guard demo installer and the generated certificates for your TLS setup (which of course you should never do on production), you need to explicitely allow the usage of these unsafe demo certificates by adding the following line to `elasticsearch.yml`:

```
searchguard.allow_unsafe_democertificates: true
```

### If you use audit logging

The audit log module has been completely revised and now comes with a much wider range of configuration options. These are especially useful for staying compliant with HIPAA, GDPR, ISO, PCI or SOX. 

The following configuration keys have been removed:

```
searchguard.audit.enable_request_details: true
searchguard.audit.config.disabled_categories: AUTHENTICATED
```

If you have used these options in 5.x, you need to **remove them from `elasticsearch.yml`.**

The `searchguard.audit.enable_request_details` option has been replaced with separate keys for each feature: 

```
searchguard.audit.log_request_body: <true|false>, defaut: true
searchguard.audit.resolve_indices: <true|false>, default: true
searchguard.audit.resolve_bulk_requests: <true|false>, default: false
```

You can now disable audit categories separately for the REST and transport layer, so the `searchguard.audit.config.disabled_categories` key has been replaced with the following keys:

```
searchguard.audit.config.disabled_rest_categories
searchguard.audit.config.disabled_transport_categories
```

The categories `AUTHENTICATED` and `GRANTED_PRIVILEGES` are disabled by default. You can completely omit any configuratin setting if you excluded the `AUTHENTICATED` category in Search Guard 5. In order to log everything, including `AUTHENTICATED` and `GRANTED_PRIVILEGES`, use:

```yaml
searchguard.audit.config.disabled_rest_categories: NONE
searchguard.audit.config.disabled_transport_categories: NONE
```

The default name of the audit log index has been changed, and also the format of the logged messages differs slightly. Please refer to the [Audit Logging](auditlogging.md) chapter for more information.

### If you use Kibana Multi Tenancy

The Elasticsearch [Upgrade Assistant](https://www.elastic.co/guide/en/kibana/6.x/xpack-upgrade-assistant.html) will migrate the .kibana index from 5.x to 6.x. 

However, this only applies to the original `.kibana` index, the tenant specific indices are not recognized. Migrating the tenant indices is a manual process, and you need to [follow the instructions from the Elasticsearch documentation for each index](https://www.elastic.co/guide/en/kibana/6.1/migrating-6.0-index.html){:target="_blank"}. 

Please refer to the [Kibana Multi Tenancy](kibana_multitenancy.md) chapter, section *Under the hood: Index rewriting, Snapshot & Restore*, to learn how to find these indices on your cluster.

## Running in mixed mode: Limitations

Elasticsearch and Search Guard support running your cluster in mixed mode, means with 5.6.x and 6.x nodes. This makes it possible to upgrade via rolling restart.

Running a cluster in mixed mode should only be done while upgrading from 5 to 6. It's not supposed to be a permanent situation and you should aim to minimize the  

While running in mixed mode, the following limitations apply:

### No configuration changes

Search Guard 6 uses a new layout for the Search Guard configuration index, and is also able to read and migrate indices created with Search Guard 5. 

**While running in mixed mode, do not perform changes to the Search Guard configuration index.**

This applies to sgadmin and the REST management API. Configuration changes are possible again after all nodes have been upgraded.

### Monitoring

While running in mixed mode, X-Pack monitoring might return incorrect values or throw Exceptions which you can safely ignore.




