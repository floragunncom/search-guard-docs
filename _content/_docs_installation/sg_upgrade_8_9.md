---
title: Upgrade to Search Guard FLX for Elasticsearch 9
html_title: Upgrade Search Guard FLX to Elasticsearch 9
permalink: sg-upgrade-8-9
layout: docs
section: security
edition: community
description: Upgrade Search Guard FLX to Elasticsearch 9
---
<!---
Copyright 2026 floragunn GmbH
-->

# Upgrade from Search Guard 8 to 9
{: .no_toc}

{% include toc.md %}

Upgrading Search Guard from 8.19.x to 9.x.x can be done while you upgrade Elasticsearch from 8.19.x to 9.x.x . You can do this by performing a full cluster restart, or by doing a rolling restart: 

Search Guard supports running a mixed cluster of 8.19.x and 9.x.x nodes and is thus compatible with the Elasticsearch upgrade path.

If you have not already done so, make yourself familiar with Elastic's own upgrade instruction for the Elastic stack:

* [Upgrading the Elastic Stack](https://www.elastic.co/docs/deploy-manage/upgrade){:target="_blank"}

## Review breaking changes

* [Breaking Changes in Elasticsearch 9](https://www.elastic.co/guide/en/elastic-stack/9.0/elasticsearch-breaking-changes.html)
* No breaking changes in Search Guard FLX for Elasticsearch 9 but please refer to the `Notes and Troubleshooting` section below
  
## Prerequisites

To perform an upgrade from 8.x to 9.x, you need to run at least:

* Elasticsearch 8.19.x (Elasticsearch requirement)
* Search Guard FLX 3.1.2 (Search Guard requirement)
* Upgrading directly from Search Guard classic (i.e., Search Guard versions 53 and before) is not supported

If you run older versions of Elasticsearch and/or Search Guard, please upgrade first.

## Upgrading Search Guard

Upgrading from Search Guard 7 classic (i.e., Search Guard versions 53 and before) is not supported. You need first to [migrate Search Guard classic to Search Guard FLX](sg-classic-config-migration-overview).
{: .note .js-note .note-warning}

After upgrading a node from ES 8 to 9, simply [install](search-guard-installation) the [correct version of Search Guard](search-guard-versions) on this node.

No changes in `elasticsearch.yml` are required

## Reindex Search Guard Indices

This tool can be used to reindex Search Guard indices. It is experimental and should only be used as advised by your support engineer.

- [Download here](https://maven.search-guard.com/search-guard-flx-release/com/floragunn/sg-upgrade-tool/{{ site.sg-upgrade-tool }}/sg-upgrade-tool-{{ site.sg-upgrade-tool }}.sh)
- [Read the Documentation](https://git.floragunn.com/search-guard/sg-upgrade-tool/-/blob/main/README.md)
