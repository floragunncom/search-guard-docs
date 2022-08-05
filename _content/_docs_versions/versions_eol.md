---
title: Search Guard end of life policy
html_title: End of life
permalink: eol-policy
category: versions
order: 700
layout: docs
description: The Search Guard FLX End of Life policy. Use this list to make sure you do not run any unsupported Search Guard or Elasticsearch version in production.
---

# Search Guard FLX end of life policy
{: .no_toc}

{% include toc.md %}


Search Guard Non-FLX (sometimes referred to as Search Guard Classic) will be put in maintenance mode after FLX GA is released.
This means that Search Guard Classic only receives security fixes for the latest version of Elasticsearch (7.17.x) and 7.10.2 (LTS).
Please also note that Search Guard Classic will not be available for Elasticsearch 8. You must update to Search Guard FLX to use Search Guard for Elasticsearch 8. We strongly recommend to update to FLX also for Elasticsearch 7 so that you receive the latest features and improvements for your Elasticsearch cluster.
{: .note .js-note .note-warning}

Search Guard FLX GA will be available for Elasticsearch 7.10.2, 7.16.2, 7.17.x and Elasticsearch 8.
{: .note .js-note .note-warning}

## Summary

The Search Guard End of Life policy defines 

* which Elasticsearch versions receive new Search Guard features and bugfixes
* which Elasticsearch version receive critical bugfixes for Search Guard (but no new features)
* which Elasticsearch version is End of Life (EOL) and will not receive any Search Guard updates

**The Search Guard FLX EOL policy follows the Elasticsearch update policy.**

Please also refer to [Elasticsearch end of life policy](https://www.elastic.co/de/support/eol) to check whether your Elasticsearch version
has reached End of Life in general. 

## Versioning schema

The Search Guard FLX versioning scheme consists of the Search Guard FLX version (following the semantic versioning standard), followed by `-es-` and the version of Elasticsearch that is supported.

Example: 1.0.0-es-7.17.5
 
## Which Elasticsearch versions receive new Search Guard FLX features and bugfixes

* Current release of the current minor version of the current Elasticsearch major version
* Current release of the previous minor version of the current Elasticsearch major version
* Current release of the previous Elasticsearch major version (but not all features will be backported)


At the time of writing this is: {% for version in site.eol.features %}
* {{ version }}{% endfor %}


## Which Elasticsearch versions receive critical bugfixes only (but no new features)

* Current releases of the third and fourth from last Elasticsearch minor version of the current Elasticsearch major version


At the time of writing this is: {% for version in site.eol.updates %}
* {{ version }}{% endfor %}


## Which Elasticsearch versions receive no updates at all any longer

* All other Elasticsearch versions not mentioned above
* All Elasticsearch versions which are EOL according to [Elasticsearch end of life policy](https://www.elastic.co/de/support/eol)

## Recommended upgrade Strategy

* Upgrade Elasticsearch always to the latest fix version or your Elasticsearch minor version
* Make sure your Elasticsearch minor version is not older than six month 
* When the first beta version of a new Elasticsearch major version is released prepare to upgrade to the latest release of the current major version of Elasticsearch.

## LTS versions

Elasticsearch 7.10.2 receives long term support and does not adhere to the EOL rules mentioned here.

## EOL Examples

### Assume 8.3.3 is the current Elasticsearch Version 

* Which Elasticsearch versions receive new Search Guard features and bugfixes: 7.10.2, 7.17.5, 8.2.3, 8.3.3
* Which Elasticsearch versions receive critical bugfixes (but no new features): 8.0.1, 8.1.3
* Which Elasticsearch versions receive no updates at all any longer: all other (1.x.x-6.x.x)
