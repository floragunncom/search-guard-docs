---
title: Sample Watches
html_title: Sample Watches
permalink: elasticsearch-alerting-watches-sample
category: signals
order: 210
layout: docs
edition: community
description: Signals Alerting for OpenSearch/Elasticsearch ships with several sample watches that you can use for a quickstart or proof of concept.
---

<!--- Copyright 2020 floragunn GmbH -->

# Sample Watches
{: .no_toc}

{% include toc.md %}

To start quickly with Signals, we have prepared sample watches that are based on the [Dashboards/Kibana sample data](https://www.elastic.co/guide/en/kibana/current/get-started.html).

All sample watches can be found on Gitlab. You can install them either manually via the [REST API](rest_api.md). Or, use the Signals Dashboards/Kibana plugin to install them.

## Average ticket price

The watch alerts if the average price among all flight tickets is less than the threshold N (default 800).

Based on the flights data sample index.

[Average ticket price](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/tree/master/common/examples/watches/avg_ticket_price)

## Bad weather alert

The watch alerts if there are any flights where certain weather problems (default to thunder or lightning) is occurring in the destination airport.

Based on the flights data sample index.

[Bad weather alert](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/tree/master/common/examples/watches/bad_weather)

## Change in memory consumption

The watch alerts if memory used by a host has decreased by more than N in the last X days.

Based on the log data sample index.

[Change in memory consumption](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/tree/master/common/examples/watches/change_in_memory)

## Max memory alert

The watch alerts if the maximum value of memory among all hosts is greater than the threshold N (default 10000).

Based on the log data sample index.

[Max memory alert](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/tree/master/common/examples/watches/max_memory)

## Memory usage

The watch alerts if memory usage for a host is greater than a configured threshold N (default 10000).

Based on the log data sample index.

[Memory usage](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/tree/master/common/examples/watches/memory_usage)

## Minimum Product Price

The watch alerts if the minimum price among all products is less than the threshold N (default 10).

Based on the eCommerce data sample index.

[Minimum Product Price](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/tree/master/common/examples/watches/min_product_price)
