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

# Upgrade from Search Guard 8 to 9 (FLX only!)
{: .no_toc}

{% include toc.md %}

Upgrading Search Guard from 8.19.x to 9.x.x can be done while you upgrade Elasticsearch from 8.19.x to 9.x.x. You can do this by performing a full cluster restart, or by doing a rolling restart: 

Search Guard supports running a mixed cluster of 8.19.x and 9.x.x nodes and is thus compatible with the Elasticsearch upgrade path.

If you have not already done so, make yourself familiar with Elastic's own upgrade instructions for the Elastic Stack:

* [Upgrading the Elastic Stack](https://www.elastic.co/docs/deploy-manage/upgrade){:target="_blank"}

## Review breaking changes

* [Breaking Changes in Elasticsearch 9](https://www.elastic.co/guide/en/elastic-stack/9.0/elasticsearch-breaking-changes.html){:target="_blank"}
* No breaking changes in Search Guard FLX for Elasticsearch 9 but please refer to the `Notes and Troubleshooting` section below
  
## Prerequisites

To perform an upgrade from 8.x to 9.x, you need to run at least:

* Elasticsearch 8.19.x (Elasticsearch requirement)
* Search Guard FLX 3.1.2 (Search Guard requirement)
* Upgrading directly from Search Guard classic (i.e., Search Guard versions 53 and before) is not supported

If you run older versions of Elasticsearch and/or Search Guard, please upgrade first.

## Upgrading Search Guard

After upgrading a node from ES 8 to 9, simply [install](search-guard-installation) the [correct version of Search Guard](search-guard-versions) on this node.

No changes in `elasticsearch.yml` are required.

## Reindex Search Guard Indices

The Search Guard Upgrade Tool can be used to reindex Search Guard indices. It is experimental and should only be used as advised by your support engineer.

- [Download here](https://maven.search-guard.com/search-guard-flx-release/com/floragunn/sg-upgrade-tool/{{ site.sg-upgrade-tool }}/sg-upgrade-tool-{{ site.sg-upgrade-tool }}.sh){:target="_blank"}
- [Read the Documentation](https://git.floragunn.com/search-guard/sg-upgrade-tool/-/blob/main/README.md){:target="_blank"}

Please refer also to our Blog Post [Upgrading to Elasticsearch 9: Why your read-only 7.x indices still block the boot](https://search-guard.com/blog/upgrading-to-elasticsearch-9-why-your-read-only-7-x-indices-still-block-the-boot/){:target="_blank"}