---
title: Upgrade to SG 8
html_title: Upgrade Search Guard FLX to Elasticsearch 8
permalink: sg-upgrade-7-8
category: installation
#subcategory: kibana-authentication-migration-overview
order: 800
layout: docs
edition: community
description: Upgrade Search Guard FLX to Elasticsearch 8
---
<!---
Copyright 2023 floragunn GmbH
-->

# Upgrade from Search Guard 7 to 8
{: .no_toc}

{% include toc.md %}

Upgrading Search Guard from 7.7.x to 8.x.x can be done while you upgrade Elasticsearch from 7.17.x to 8.x.x . You can do this by performing a full cluster restart, or by doing a rolling restart: 

Search Guard supports running a mixed cluster of 7.7.x and 8.x.x nodes and is thus compatible with the Elasticsearch upgrade path.

If you have not already done so, make yourself familiar with Elastic's own upgrade instruction for the Elastic stack:

* [Upgrading the Elastic Stack](https://www.elastic.co/guide/en/elastic-stack/8.7/upgrading-elastic-stack.html){:target="_blank"}
* [Upgrade Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/8.7/setup-upgrade.html){:target="_blank"}
* [Upgrade Assistant](https://www.elastic.co/guide/en/kibana/7.17/upgrade-assistant.html){:target="_blank"}
* [Rolling Upgrades](https://www.elastic.co/guide/en/elastic-stack/8.7/upgrading-elasticsearch.html){:target="_blank"}

## Review breaking changes

* [Breaking Changes in Elasticsearch 8](https://www.elastic.co/guide/en/elastic-stack/8.0/elasticsearch-breaking-changes.html)
* No breaking changes in Search Guard FLX for Elasticsearch 8 but please refer to the `Notes and Troubleshooting` section below
  
## Prerequisites

In order to to perform a an upgrade from 7.x to 8.x, you need to run at least:

* Elasticsearch 7.17.x (Elasticsearch requirement)
* Search Guard FLX 1.0.0 (Search Guard requirement)
* Upgrading from Search Guard classic (i.e., Search Guard versions 53 and before) is not supported

If you run older versions of Elasticsearch and/or Search Guard, please upgrade first.

## Upgrading Search Guard

Upgrading from Search Guard 7 classic (i.e., Search Guard versions 53 and before) is not supported. You need first to ]migrate Search Guard classic to Search Guard FLX](sg-classic-config-migration-overview).
{: .note .js-note .note-warning}

After upgrading a node from ES 7 to 8, simply [install](installation.md) the [correct version of Search Guard](../_docs_versions/versions_versionmatrix.md) on this node.

No changes in `elasticsearch.yml` are required


## Upgrading Kibana

Kibana should be upgraded after the Elasticsearch / Search Guard upgrade is completed. Just [install](../_docs_versions/versions_versionmatrix.md) the correct version of the Search Guard plugin to Kibana.

The following changes in `kibana.yml` are required:

* Remove `xpack.security.enabled` property
* Remove `xpack.spaces.enabled` property if present
* Remove `xpack.ml.enabled` property if present
* Remove `xpack.apm.enabled` property if present
* Remove `xpack.graph.enabled` property if present
* Remove `xpack.monitoring.enabled` property if present
* Add `security.showInsecureClusterWarning: false` if not already present

## Important Notes and Troubleshooting

### Expected warnings or log messages

* In Kibana you can ignore all warnings and error in the logs which originates from `plugins.security.*` or `plugins.securitySolution` or `plugins.alerting` or `plugins.taskManager`.

### elasticsearch.keystore

* In case you get an `org.elasticsearch.ElasticsearchSecurityException` which complains about `invalid configuration for xpack.security ... is not set, but the following settings have been configured in elasticsearch.yml: ...` please remove the `elasticsearch.keystore` file in the `config/` folder and restart the node.

### Legacy ldap module removed

* The original implementation of the legacy `ldap` authentication and authorization backend was removed in Search Guard FLX for Elasticsearch 8. The implementation was replaced with another implementation which should exactly behave like the original one. In case you use the legacy `ldap` authentication or authorization backend and experience any issues please contact us via the support portal or through the [community support forum](https://forum.search-guard.com/).

## Running in mixed mode: Limitations

Elasticsearch and Search Guard support running your cluster in mixed mode, means with 7.17.x and 8.x nodes. This makes it possible to upgrade via rolling restart.

Running a cluster in mixed mode should only be done while upgrading from 7 to 8. It's not supposed to be a permanent situation and you should aim to minimize the duration where a mixed cluster exists.

While running in mixed mode, the following limitations apply:

### Monitoring

While running in mixed mode, X-Pack monitoring might return incorrect values or throw Exceptions which you can safely ignore.