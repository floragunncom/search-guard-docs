---
title: Transformations Overview
html_title: Transformations / Calculations
permalink: elasticsearch-alerting-transformations-calculations-overview
layout: docs
section: alerting
edition: community
description:
index: false
---
<!--- Copyright 2022 floragunn GmbH -->

# Transformations and Calculations
{: .no_toc}

In many cases, you will want to run transformations and calculations on the raw data pulled in by [inputs](elasticsearch-alerting-inputs-overview).

For example, you may want to calculate an average value over some fields, or clean up data before [storing it back to Elasticsearch](elasticsearch-alerting-actions-index).

You can use painless scripts to either

* [transform](elasticsearch-alerting-transformations) your data in any execution context
* [calculate](elasticsearch-alerting-calculations) values and store them in a new execution context

Both transformations and calculations are implemented as inline or stored painless scripts that operate on the execution runtime data. You can use the full power of painless to massage the data any way you want.