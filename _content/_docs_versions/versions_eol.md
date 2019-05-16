---
title: Search Guard end of life policy
html_title: End of life
slug: eol-policy
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

## EOL Examples

### Assume 7.0.0 is the current Elasticsearch Version 

* Which Elasticsearch versions receive new Search Guard features and bugfixes: 6.7.1, 7.0.0
* Which Elasticsearch versions receive critical bugfixes (but no new features): n/a
* Which Elasticsearch versions receive no updates at all any longer: all other (1.x.x-6.7.0)


### Assume 6.7.1 is the current Elasticsearch Version

* Which Elasticsearch versions receive new Search Guard features and bugfixes: 5.6.16, 6.6.2, 6.7.1
* Which Elasticsearch versions receive critical bugfixes (but no new features): 6.4.3, 6.5.4
* Which Elasticsearch versions receive no updates at all any longer: all other (1.x.x-5.6.15, 6.0.x-6.4.2, 6.5.0-6.5.3, 6.6.0-6.6.1, 6.7.0)

### Assume 6.5.4 is the current Elasticsearch Version

* Which Elasticsearch versions receive new Search Guard features and bugfixes: 5.6.16, 6.4.3, 6.5.4
* Which Elasticsearch versions receive critical bugfixes (but no new features): 6.2.4, 6.3.2
* Which Elasticsearch versions receive no updates at all any longer: all other (1.x.x-5.6.15, 6.0.x-6.2.3, 6.3.0-6.3.1, 6.4.0-6.4.2, 6.5.0-6.5.3)