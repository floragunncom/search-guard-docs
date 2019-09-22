---
title: Getting started with Signals Alerting
html_title: Getting started with Signals Alerting
slug: elasticsearch-alerting-getting-started
category: signals
order: 100
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Getting started with Signals Alerting for Elasticsearch
{: .no_toc}

{% include toc.md %}

Signals Alerting for Elasticsearch is distributed as part of Search Guard. To use Signals, you just need to install the Search Guard plugin for Elasticsearch and Kibana.

*At the moment, the technical preview is available for Elasticsearch 7.3.1 only.*

The technical preview includes both Signals and Search Guard, and can be installed the same way you would install Search Guard and the Search Guard Kibana plugin.

## Signals technical preview - Elasticsearch

1. Download the plugin:

* [https://releases.floragunn.com/search-guard-7-7.3.1-SIGNALS-PREVIEW-0.2.zip](https://releases.floragunn.com/search-guard-7-7.3.1-SIGNALS-PREVIEW-0.2.zip)

2. Install the plugin

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-7-7.3.1-SIGNALS-PREVIEW-0.2.zip
```


## Signals technical preview - Kibana

1. Download the plugin:

* [https://releases.floragunn.com/search-guard-kibana-plugin-7.3.1-SIGNALS-PREVIEW-0.2.zip](https://releases.floragunn.com/search-guard-kibana-plugin-7.3.1-SIGNALS-PREVIEW-0.2.zip)

2. Install the plugin

```bash
bin/kibana-plugin install -b file:///path/to/search-guard-kibana-plugin-7.3.1-SIGNALS-PREVIEW-0.2.zip
```

## Sample watches

To start quickly with Signals, we have [prepared sample watches](sample_watches.md) that can be either installed by using the REST API, or the Kibana plugin.
