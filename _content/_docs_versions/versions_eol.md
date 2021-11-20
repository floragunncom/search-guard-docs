---
title: Search Guard end of life policy
html_title: End of life
permalink: eol-policy
category: versions
order: 700
layout: docs
description: The Search Guard End Of Life policy. Use this list to make sure you do not run any unsupported Search Guard or Elasticsearch version in production.
---

# Search Guard end of life policy
{: .no_toc}

{% include toc.md %}

## Summary

The Search Guard End of Life policy defines 

* which Elasticsearch versions receive new Search Guard features and bugfixes
* which Elasticsearch version receive critical bugfixes for Search Guard (but no new features)
* which Elasticsearch version is End of Life (EOL) and will not receive any Search Guard updates

**The Search Guard EOL policy follows the Elasticsearch update policy.**

Please also refer to [Elasticsearch end of life policy](https://www.elastic.co/de/support/eol) to check whether your Elasticsearch version
has reached End of Life in general. 

## Versioning schema

The Search Guard versioning scheme is: 

* e1.e2.e3-s1.s2.s3
* Example: 6.7.1-25.0.0
 
where 

* e1: Elasticsearch Major Version
* e2: Elasticsearch Minor Version
* e3: Elasticsearch Fix Version
* s1: Search Guard Major Version (Incremented when new features are added)
* s2: Search Guard Minor Version (Incremented when bugfixes are applied)
* s3: Search Guard Fix Version (Incremented when trivial changes, like fixing typos, are applied

## Which Elasticsearch versions receive new Search Guard features and bugfixes

* All releases of the current minor version of the current Elasticsearch major version

## Which Elasticsearch versions receive critical bugfixes only (but no new features)

* All releases of the current minor version of the current Elasticsearch major version
* All releases of the previous minor version of the current Elasticsearch major version
* Current version of the last Elasticsearch major version

## Which Elasticsearch versions receive no updates at all any longer

* All other Elasticsearch versions not mentioned above
* All Elasticsearch versions which are EOL according to [Elasticsearch end of life policy](https://www.elastic.co/de/support/eol)

## Recommended upgrade Strategy

* Upgrade Elasticsearch always to the latest fix version or your Elasticsearch minor version
* Make sure your Elasticsearch minor version is not older than six month 
* When the first beta version of a new Elasticsearch major version is released prepare to upgrade to the latest release of the current major version of Elasticsearch.