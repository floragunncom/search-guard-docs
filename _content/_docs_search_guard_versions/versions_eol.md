---
title: Search Guard end of life policy
html_title: End of life
permalink: eol-policy
layout: docs
description: The Search Guard End Of Life policy. Use this list to make sure you do
  not run any unsupported Search Guard or Elasticsearch version in production.
---
# Search Guard end of life policy
{: .no_toc}

{% include toc.md %}

## Summary

The Search Guard End of Life policy defines 

* which Elasticsearch versions receive new Search Guard features and bugfixes
* which Elasticsearch version receive critical bugfixes for Search Guard
* which Elasticsearch version is End of Life (EOL) and will not receive any Search Guard updates

**The Search Guard EOL policy follows the Elasticsearch update policy.**

Please also refer to [Elasticsearch end of life policy](https://www.elastic.co/support/eol) to check whether your Elasticsearch version
has reached End of Life in general. 

## Which Elasticsearch versions receive new features and bugfixes

* All releases of the current minor version of the current Elasticsearch major version

**Example:** If the most recent version of Elasticsearch and Kibana is **{{site.elasticsearch.currentversion}}**, then
the following versions receive new Search Guard features and bugfixes:

* Elasticsearch and Kibana {{site.elasticsearch.minorversion}}.x

## Which Elasticsearch versions receive critical bugfixes

* All releases of the current minor version of the current Elasticsearch major version
* Current version of the last Elasticsearch major version

**Example:** If the most recent version of Elasticsearch and Kibana is **{{site.elasticsearch.currentversion}}**, then
the following versions receive critical bugfixes

* Elasticsearch and Kibana {{site.elasticsearch.minorversion}}.x
* Elasticsearch and Kibana {{site.elasticsearch.currentversionlastmajor}}

## Which Elasticsearch versions receive no updates at all any longer

* All other Elasticsearch versions not mentioned above
* All Elasticsearch versions which are EOL according to [Elasticsearch end of life policy](https://www.elastic.co/support/eol)