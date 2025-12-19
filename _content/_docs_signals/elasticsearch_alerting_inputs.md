---
title: Inputs
html_title: Alerting Data Input
permalink: elasticsearch-alerting-inputs
layout: docs
section: alerting
edition: community
canonical: elasticsearch-alerting-inputs-overview
description: Signals Alerting for Elasticsearch offers multiple data inputs like Elasticsearch
  queries and HTTP endpoints.
---
<!--- Copyright 2022 floragunn GmbH -->

# Inputs
{: .no_toc}

Each watch can have one or more inputs. Inputs can be freely defined anywhere in the execution chain.

Each input will fetch data from a data source, and place it in the runtime data context under a configurable key for later usage.

At the moment, Signals supports the following input types:

* [Constants](elasticsearch-alerting-inputs-static)
  * Define constants you can then use at multiple places in the execution chain
* [Elasticsearch](elasticsearch-alerting-inputs-elasticsearch)
  * Use the full power of Elasticsearch queries and aggregations
* [HTTP](elasticsearch-alerting-inputs-http)
  * Pull in data from a REST endpoint

All data from all inputs can be combined by using [Transformation](elasticsearch-alerting-transformations) and [Calculations](elasticsearch-alerting-calculations), used in [Conditions](elasticsearch-alerting-conditions) and pushed to [action endpoints](elasticsearch-alerting-actions-overview).
 
