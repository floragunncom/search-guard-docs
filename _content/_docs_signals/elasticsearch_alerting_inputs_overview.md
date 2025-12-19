---
title: Inputs Overview
html_title: Inputs Overview
permalink: elasticsearch-alerting-inputs-overview
layout: docs
section: alerting
edition: community
description: In Signals Alerting for Elasticsearch, each watch can have one or more
  data inputs that collect data for further processing.
---
<!--- Copyright 2022 floragunn GmbH -->

# Inputs
{: .no_toc}

Each watch can have one or more inputs. Inputs can be freely defined anywhere in the execution chain.

Each input will fetch data from a data source, and place it in the runtime data context under a configurable key for later usage.

At the moment, Signals supports the following input types:

* [Static](elasticsearch-alerting-inputs-static)
  * Define constants you can then use at multiple places in the execution chain
* [Elasticsearch](elasticsearch-alerting-inputs-elasticsearch)
  * Use the full power of Elasticsearch queries and aggregations
* [HTTP](elasticsearch-alerting-inputs-http)
  * Pull in data from a REST endpoint

All data from all inputs can be combined by using [Transformation](elasticsearch-alerting-transformations) and [Calculations](elasticsearch-alerting-calculations), used in [Conditions](elasticsearch-alerting-conditions) and pushed to [action endpoints](elasticsearch-alerting-actions-overview).
 
