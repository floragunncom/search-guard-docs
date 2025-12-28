---
title: Anomaly Detection Overview
html_title: Anomaly Detection Overview
permalink: anomaly-detection-overview
layout: docs
section: anomaly_detection
edition: enterprise
description: Overview of Search Guard Anomaly Detection capabilities and concepts
---

<!---
Copyright (c) 2025 floragunn GmbH

This file contains content originally licensed under Apache-2.0.
Original license header and notices preserved below.

Additional modifications by floragunn GmbH, 2025.
Modifications Copyright floragunn GmbH

---

SPDX-License-Identifier: Apache-2.0
http://www.apache.org/licenses/LICENSE-2.0

The OpenSearch Contributors require contributions made to
this file be licensed under the Apache-2.0 license or a
compatible open source license.

Modifications Copyright OpenSearch Contributors. See
GitHub history for details.
-->

# Search Guard Anomaly Detection Overview

{: .no_toc}

{% include toc.md %}

## What is Anomaly Detection?

An anomaly is any unusual change in your time-series data. These unusual patterns give you valuable insights. For example, a sudden spike in memory usage might signal an impending system failure.

Anomaly Detection finds these patterns automatically in your Elasticsearch data. The system uses the Random Cut Forest (RCF) algorithm, a machine learning technique that needs no training data (unsupervised learning). RCF builds a model of your data stream and calculates an `anomaly grade` and `confidence score` for each data point. These scores help you tell real anomalies from normal variations.

## Key Concepts

### Detectors

A `detector` is a single anomaly detection task. You can create multiple detectors that run at the same time, each watching different data sources.

You can configure detectors in two ways. **Single-entity detectors** analyze all your data together without grouping. **High-cardinality detectors** group data by `category fields` like IP addresses or error types.

### Features

A `feature` aggregates a field or runs a Painless script. Each detector can check one or more features for anomalies. You choose an aggregation method for each feature: `average()`, `count()`, `sum()`, `min()`, or `max()`. This tells the detector what to look for.

### Anomaly Scores and Grades

When the system finds unusual data, it assigns scores that help you understand the severity.

The `anomaly score` shows how unusual a data point is. Higher scores mean more severe anomalies. The `anomaly grade` normalizes this score to a 0-1 scale for easier comparison. The `confidence` score shows how certain the system is about the anomaly. Values closer to 1 mean higher certainty.

### Shingling

Shingling creates better detection by looking at multiple data points together. The `shingle size` controls how many consecutive intervals the detector examines at once. This helps the system spot patterns that span multiple time periods.

## How It Works

Here's what happens when you run a detector:

1. The system collects data points at the intervals you configure
2. Your `feature` definitions aggregate the raw data
3. The shingling process creates samples for the statistical model
4. The RCF algorithm compares new data points to the model
5. When scores exceed dynamic thresholds, the system generates alerts

For technical details about RCF, see [Robust Random Cut Forest Based Anomaly Detection on Streams](https://www.semanticscholar.org/paper/Robust-Random-Cut-Forest-Based-Anomaly-Detection-on-Guha-Mishra/ecb365ef9b67cd5540cc4c53035a6a7bd88678f9).

## Use Cases

You can use Anomaly Detection in many scenarios.

**IT Infrastructure Monitoring:** Catch unusual CPU, memory, or disk usage before problems affect users.

**Security:** Spot suspicious network traffic or unusual login patterns that might indicate an attack.

**Application Performance:** Find slow response times or high error rates before they impact your service.

**Business Metrics:** Detect unexpected changes in transaction volume or user behavior.

## Real-time vs. Historical Detection

You can run detection in two modes depending on your needs.

**Real-time Detection** watches your data continuously as it arrives. You get alerts in near real time when anomalies occur. This mode creates ongoing `detection jobs` that run at your specified intervals. Use this for immediate responses to problems.

**Historical Analysis** examines past data over a date range you specify. This helps you establish baselines and find patterns you missed. You can test detector configurations before enabling real-time monitoring. Historical analysis runs as a batch task with defined start and end times.

## Benefits

Anomaly Detection gives you several advantages over traditional monitoring.

You don't need to set static thresholds manually. The system adapts automatically to seasonal trends and data growth. No training data is required (unsupervised learning). You can monitor thousands of entities with high-cardinality detectors. The system integrates seamlessly with [Signals Alerting](elasticsearch-alerting-getting-started) to notify you when problems occur.

## Challenges Addressed

Traditional dashboards and visualizations make anomaly discovery difficult. You can configure static threshold alerts, but these need domain knowledge and can't adapt to changing patterns. Growing data and seasonal trends quickly make fixed thresholds unreliable.

Anomaly Detection solves these problems with machine learning. The system learns what's normal and adjusts thresholds dynamically as your data evolves.

## Next Steps

Ready to get started? Here's what to do next.

[Getting Started](anomaly-detection-getting-started): Install the plugins and create your first detector.

[Creating Detectors](anomaly-detection-creating-detectors): Learn how to configure detectors for your data.

[API Reference](anomaly-detection-api-detectors): Manage detectors programmatically using the REST API.
