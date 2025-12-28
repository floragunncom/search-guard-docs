---
title: Getting Started with Anomaly Detection
html_title: Getting Started with Anomaly Detection
permalink: anomaly-detection-getting-started
layout: docs
section: anomaly_detection
edition: enterprise
description: Get started with Search Guard Anomaly Detection installation and your first detector
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

# Getting Started with Anomaly Detection

{: .no_toc}

{% include toc.md %}

This guide walks you through installing the Anomaly Detection plugins and creating your first detector. By the end, you'll have a working anomaly detector monitoring your data in real time.

## Downloading the Technical Preview

The Anomaly Detection technical preview is currently available for Elasticsearch 8.17.0. You need to download three plugins:

- [Anomaly Detection Elasticsearch plugin](https://maven.search-guard.com//search-guard-anomaly-detection-release/com/floragunn/search-guard-anomaly-detection/1.0.0-tp1-es-8.17.0/search-guard-anomaly-detection-1.0.0-tp1-es-8.17.0.zip)
- [Anomaly Detection Kibana plugin](https://maven.search-guard.com/search-guard-anomaly-detection-release/com/floragunn/search-guard-kibana-anomaly-detection/1.0.0-tp1-es-8.17.0/search-guard-kibana-anomaly-detection-1.0.0-tp1-es-8.17.0.zip)
- [Anomaly Detection scheduler plugin](https://maven.search-guard.com//search-guard-anomaly-detection-release/com/floragunn/jobscheduler/search-guard-ad-scheduler/1.0.0-tp1-es-8.17.0/search-guard-ad-scheduler-1.0.0-tp1-es-8.17.0-plugin.zip)

## Installing the Plugins

You install Search Guard Anomaly Detection like any other Elasticsearch plugin using the `elasticsearch-plugin` command.

**Important:** Install the scheduler plugin before the Anomaly Detection Elasticsearch plugin.
{: .note}

### Installing the Elasticsearch Plugins

Navigate to your Elasticsearch installation directory and run the following commands in order. Replace `<PATH_TO_PLUGIN>` with the actual path to your downloaded plugin files:

```bash
bin/elasticsearch-plugin install -b file:///<PATH_TO_PLUGIN>/anomaly-detection-scheduler-plugin.zip
bin/elasticsearch-plugin install -b file:///<PATH_TO_PLUGIN>/anomaly-detection-elasticsearch-plugin.zip
```

After installation completes, restart your Elasticsearch cluster.

### Installing the Kibana Plugin

Navigate to your Kibana installation directory and run the following command. Replace `<PATH_TO_PLUGIN>` with the actual path to your downloaded Kibana plugin file:

```bash
bin/kibana-plugin install file:///<PATH_TO_PLUGIN>/anomaly-detection-kibana-plugin.zip
```

After installation completes, restart Kibana.

## Accessing Anomaly Detection in Kibana

Once you've installed the plugins and restarted your services, open Kibana in your browser and navigate to **Search Guard** > **Anomaly Detection**.

## Your First Detector: Quick Start

This quick start shows you how to create a simple anomaly detector. Before you begin, make sure you have time-series data indexed in Elasticsearch with a timestamp field and at least one numeric field to analyze.

### Creating a New Detector

Open the Anomaly Detection page and select **Create detector**. Enter a unique name for your detector (for example, "CPU Usage Anomaly Detector") and add a brief description that explains what the detector monitors.

### Selecting Your Data Source

Choose which data to monitor from the **Index** dropdown—you can select an index, index pattern, or alias. Then select the timestamp field that exists in your data.

### Setting the Detection Interval

Choose how often the detector should check your data by setting the **Detector interval** to match your data frequency. For example, if your data arrives every 5 minutes, use a 5-minute interval. Shorter intervals provide faster detection but might miss patterns that need more data points, while longer intervals capture more context but delay detection.

If your data arrives with a delay, set a **Window delay** to shift the interval and account for ingestion lag. For example, if data typically arrives 1 minute late, set a 1-minute window delay.

### Configuring a Feature

Features tell the detector what to monitor for anomalies. Select **Add feature** and enter a descriptive feature name like `average_cpu_usage`. Choose an aggregation method from the dropdown (such as `average()`) and select the field to monitor (such as `cpu_percent`).

### Previewing and Creating

Select **Preview sample anomalies** to see how your detector performs on existing data. Review the preview results and check whether the detector finds anomalies where you expect them. When you're satisfied with the configuration, select **Create detector** to save it.

### Starting the Detector

After you create the detector, select **Start real-time detector** to begin monitoring your data. The detector needs time to initialize—typically several minutes. Once ready, it starts generating anomaly results.

## Understanding the Results

Once your detector runs, you can view results on the detector details page. The **Anomaly Overview** shows when anomalies occurred and their severity over time. The **Feature Breakdown** displays actual values versus expected values for your features. The **Anomaly Occurrences** section lists specific anomalies with timestamps and confidence scores.

For each anomaly, you see three key metrics:

| Metric | Description |
|:--- |:--- |
| Anomaly grade | Ranges from 0 to 1 and indicates severity. Higher values represent more significant anomalies. |
| Confidence | Shows how certain the model is about this anomaly. |
| Feature contribution | Shows which features contributed most to flagging this data point. |
{: .config-table}

## Next Steps

Now that you've created your first detector, you can expand your monitoring. See [Create more complex detectors](anomaly-detection-creating-detectors) with multiple features to get a fuller picture of your data, [Configure advanced settings](anomaly-detection-advanced-config) like high-cardinality detection for grouping by dimensions, [Set up alerts](anomaly-detection-alerts) to get notified immediately when anomalies occur, or [Use the API](anomaly-detection-api-detectors) to manage detectors programmatically and integrate with your workflows.

## Tips for Success

**Start simple.** Begin with a single-feature detector. Once you understand how it behaves, add more features.

**Match your interval to your data frequency.** Data collected every 5 minutes should use a 5-minute interval.

**Give your detector time to learn.** Detectors need several intervals to establish normal patterns.

**Don't worry about low confidence scores initially.** During the probation period, confidence below 0.9 is normal.

**Test with historical data first.** Run historical analysis to validate your configuration before enabling real-time detection.