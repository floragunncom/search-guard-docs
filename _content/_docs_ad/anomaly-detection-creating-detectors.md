---
title: Creating Anomaly Detectors
html_title: Creating Anomaly Detectors
permalink: anomaly-detection-creating-detectors
layout: docs
section: anomaly_detection
edition: enterprise
description: Learn how to create and configure anomaly detectors
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

# Creating Anomaly Detectors

{: .no_toc}

{% include toc.md %}

A *detector* is an individual anomaly detection task. You can create multiple detectors that run at the same time, with each one analyzing a different data source.

## Naming Your Detector

Every detector needs a unique name and description. Choose a name that clearly identifies what you're monitoring, such as `production-api-error-rate` or `database-cpu-usage`. The name must be unique within your cluster.

Add a description that explains what the detector monitors. For example: "Monitors error rate on production API endpoints to detect service degradation." Good descriptions help you and your team understand each detector's purpose at a glance.

## Selecting Your Data Source

Configure the detector to specify which data it should analyze.

### Choosing an Index

Select your data source from the **Index** dropdown menu. You have three options:

**Single index.** Select a specific index like `server_log`.

**Index pattern.** Use wildcards to match multiple indices, such as `server_log*`. This monitors all matching indices together.

**Alias.** Select an index alias that points to one or more indices. This gives you flexibility to change underlying indices without updating your detector.

{% comment %}
**Remote indexes**: You can use indexes from other clusters. Access them using the `cluster-name:index-name` pattern. Alternatively, select clusters and indexes from the interface. See [Anomaly detection security](anomaly-detection-security#selecting-remote-indexes-with-fine-grained-access-control) for configuration details with fine-grained access control enabled.

To create a cross-cluster detector in Kibana, you need the following permissions: `indices:data/read/field_caps`, `indices:admin/resolve/index`, and `cluster:monitor/remote/info`.
{: .note}
{% endcomment %}

### Choosing a Timestamp Field

Select the field that contains your timestamp information from the **Timestamp** dropdown. This field must be a valid date/time field type. The detector uses this field to organize data into time intervals, so make sure the field exists in all documents you want to analyze.

## Filtering Your Data

You can narrow down which data the detector analyzes, helping you focus on specific subsets of your data.

### Using the Visual Filter Builder

The visual builder makes filtering easy. Select **Add data filter**, then choose the **Field** you want to filter on. Next, select an **Operator** like "is", "is not", or "is one of", and enter the **Value** for the filter. You can add more filter conditions if needed—each filter narrows your data further.

### Using Query DSL for Complex Filters

For more complex filtering, select **Use query DSL** to get full control over filter logic. Enter your filter query in JSON format. Only `bool` queries are supported.

The following example retrieves documents where the `urlPath.keyword` field matches any of the specified values:

```json
{
  "bool": {
    "should": [
      {
        "term": {
          "urlPath.keyword": "/domain/{id}/short"
        }
      },
      {
        "term": {
          "urlPath.keyword": "/sub_dir/{id}/short"
        }
      },
      {
        "term": {
          "urlPath.keyword": "/abcd/123/{id}/xyz"
        }
      }
    ]
  }
}
```

The `should` clause acts like an OR condition, so documents matching any term pass the filter.

## Setting the Detection Interval

The *detector interval* controls how often your detector checks for anomalies. This setting is crucial for accurate detection.

### How the Interval Works

The detector aggregates your data at this interval. For example, with a 10-minute interval, the detector combines all data from each 10-minute window into a single data point. These aggregated results feed into the anomaly detection model, which uses a shingling process that requires consecutive data points to spot patterns.

### Choosing the Right Interval

Your interval affects both detection accuracy and speed. When selecting an interval, consider these factors:

**Match your data frequency.** If your data arrives every 5 minutes, use a 5-minute interval.

**Consider detection speed.** Shorter intervals detect anomalies faster but need more frequent data.

**Ensure sufficient data.** Each interval needs enough data points for meaningful aggregation.

**Account for patterns.** If your data has 10-minute cycles, don't use a 1-minute interval—you'll see normal variations as anomalies.

### Recommended Intervals by Data Type

| Data Type | Typical Interval |
|:--- |:--- |
| High-frequency data (log events) | 1–5 minutes |
| Moderate-frequency data (application metrics) | 5–10 minutes |
| Low-frequency data (daily summaries) | 1–24 hours |
{: .config-table}

### Avoiding Common Interval Mistakes

**Intervals that are too long** delay anomaly detection. You might miss short-lived problems—a 1-hour interval won't catch a 5-minute spike.

**Intervals that are too short** don't aggregate enough data. This produces false positives from normal variations, and the shingling process might not get enough consecutive points.

**Recommended approach:** Start with an interval matching your data's natural frequency. Test with historical analysis and adjust based on results.

## Configuring Window Delay

The *window delay* parameter accounts for data ingestion delays. Use this setting when your data doesn't arrive in Elasticsearch immediately.

### When You Need Window Delay

You need window delay if your data takes time to reach Elasticsearch due to processing pipelines (where data goes through transformations before indexing), batch loading (where external systems send data in batches instead of real-time), or network delays (ingestion lag from network latency or queuing).

### How Window Delay Works

Here's what happens without window delay: Your detector runs at 2:00 PM with a 10-minute interval. It tries to get data from 1:50 PM to 2:00 PM. But your data has a 1-minute ingestion delay, so the detector only gets data from 1:50 PM to 1:59 PM—you miss the last minute of data.

With a 1-minute window delay, the detector shifts the interval to 1:49 PM to 1:59 PM. It gets all 10 minutes of complete data with no missing information.

### Setting Your Window Delay

To configure window delay, first determine your maximum expected ingestion delay. Then set the **Window delay** value to match this delay. Monitor your data pipeline to understand typical delays over time.

**Trade-offs to consider:** Longer window delays capture all your data but increase detection lag, meaning you detect anomalies later. Shorter window delays give faster detection but risk missing data, which can produce incomplete results. Find the right balance for your use case—accuracy matters more for some scenarios, while speed matters more for others.

## Previewing Your Detector

Before finalizing your configuration, preview how the detector performs by selecting **Preview sample anomalies**. The plugin samples your data by taking one data point every 30 minutes and uses interpolation to estimate the remaining data points. You'll see a preview of potential anomalies, which helps you validate your configuration before enabling real-time detection.

### Troubleshooting Empty Previews

If no anomalies appear in the preview, check the following:

**Data volume.** You need at least 400 data points in the preview date range.

**Interval setting.** Your detector interval might not match your data density.

**Feature configuration.** Your features might need adjustment.

Previews work best with sufficient historical data.

## Creating Your Detector

Once you've configured all settings, review them for accuracy and correct any validation errors that appear. Validation errors show you exactly what needs fixing. After resolving any errors, select **Create detector** to save your configuration.

## Next Steps

Now that you've created your detector, you need to configure what it monitors. See [Configure features](anomaly-detection-features) to define which metrics to track, [Run the detector](anomaly-detection-running-detectors) to start generating results, and [Set up alerts](anomaly-detection-alerts) to get notified when anomalies occur.

For high-cardinality detection, custom result indices, and performance tuning, see [Advanced Configuration](anomaly-detection-advanced-config).