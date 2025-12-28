---
title: Configuring Features
html_title: Configuring Features
permalink: anomaly-detection-features
layout: docs
section: anomaly_detection
edition: enterprise
description: Learn how to configure features for anomaly detection
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

# Configuring Features

{: .no_toc}

{% include toc.md %}

A *feature* tells your detector what to monitor. Each feature aggregates a field or runs a Painless script, and your detector checks these features for anomalous behavior.

## What Are Features?

Features define the specific metrics you want to monitor, with each feature representing one measurement. Common examples include:

**Average CPU usage.** Track typical CPU consumption over time.

**Total error count.** Monitor how many errors occur.

**Maximum response time.** Watch for slow responses.

**Minimum available memory.** Catch low memory situations.

You can configure up to 5 features per detector. To adjust this limit, use the `anomaly_detection.max_anomaly_features` setting.

## Adding a Feature

To add a feature to your detector, navigate to the **Model configuration** section and select **Add another feature**. Enter a descriptive **Feature name**, select the **Enable feature** checkbox, and then configure the feature using one of the methods described below.

Good feature names describe what you're monitoring. Use names like `avg_cpu_usage` or `error_count` instead of generic names like `feature1`.

## Choosing an Aggregation Method

Every feature needs an aggregation method that determines how the detector processes your data. Your choice of aggregation shapes how the model learns normal patterns and what the detector focuses on.

### Available Methods

| Method | Description | Example Use Case |
|:--- |:--- |:--- |
| `average()` | Detects anomalies in the average value of a field. Use this when you care about mean values. | Average response time per interval |
| `count()` | Detects anomalies in the number of documents. Use this for event frequency monitoring. | Number of error logs per interval |
| `sum()` | Detects anomalies in the total sum of a field. Use this for cumulative metrics. | Total bytes transferred per interval |
| `min()` | Detects anomalies in the minimum value of a field. Use this for monitoring resource minimums. | Lowest available memory per interval |
| `max()` | Detects anomalies in the maximum value of a field. Use this for monitoring spikes or peak values. | Peak CPU usage per interval |
{: .config-table}

## Configuring a Field-Based Feature

The simplest way to create a feature uses field values directly. Select **Field value** from the **Find anomalies based on** dropdown, then choose your **Aggregation method** from the list. Select the **Field** you want to monitor, optionally set anomaly criteria (explained below), and then select **Save changes**.

### Example Configuration

Here's a typical CPU monitoring feature:

```
Feature name: avg_cpu_usage
Find anomalies based on: Field value
Aggregation method: average()
Field: cpu_percent
```

This feature monitors the average CPU percentage. The detector learns normal CPU patterns and flags unusual spikes or dips.

## Configuring a Custom JSON Feature

For complex aggregations, use custom JSON queries. Select **Custom expression** from the **Find anomalies based on** dropdown to open the JSON editor window. Enter your JSON aggregation query and select **Save changes**.

**Note:** Your JSON query must follow Elasticsearch's Query DSL syntax. See the Elasticsearch documentation for acceptable query formats.
{: .note}

### Example: Percentile Aggregation

The following example monitors the 95th percentile of response times:

```json
{
  "percentile_95": {
    "percentiles": {
      "field": "response_time",
      "percents": [95]
    }
  }
}
```

The detector learns normal 95th percentile values and flags intervals where the 95th percentile is unusually high or low.

## Setting Anomaly Criteria

By default, the detector flags both increases and decreases as anomalies. You can customize this behavior to reduce false positives.

### Available Criteria

**Detect all anomalies (default).** Flags both increases and decreases as anomalies. Use this when both directions matter.

**Detect only spikes.** Flags only when the actual value is higher than expected. Use this when increases are problems but decreases are not.

**Detect only dips.** Flags only when the actual value is lower than expected. Use this when decreases are problems but increases are not.

### When to Customize Criteria

Consider a CPU utilization feature: high CPU usage indicates a problem, while low CPU usage is normal and even desirable. By setting the criteria to "spikes only," the detector ignores low CPU readings and you receive alerts only for high CPU usage. This reduces alert fatigue.

### Applying Custom Criteria

To configure anomaly criteria, expand the feature settings, select your desired anomaly criteria, and save your changes. The detector immediately applies the new criteria.

{% comment %}
## Suppress Minor Anomalies

You can suppress minor anomalies by defining acceptable differences between expected and actual values.

### Relative Thresholds

Set thresholds as a percentage difference:

Ignore anomalies when the actual value is no more than X% above expected.

Ignore anomalies when the actual value is no more than X% below expected.

**Example**: For log volume, ignore anomalies with less than 30% deviation. The detector ignores spikes up to 30% above expected and dips up to 30% below expected.

### Absolute Thresholds

Set thresholds as absolute value differences:

Ignore anomalies when the actual value is no more than X units above expected.

Ignore anomalies when the actual value is no more than X units below expected.

**Example**: For log volume, ignore deviations smaller than 10,000. The detector ignores spikes up to 10,000 above expected and dips up to 10,000 below expected.

### Default Suppression

If you don't set custom suppression rules, the system defaults to ignoring anomalies with deviations of less than 20% from the expected value for each enabled feature.
{% endcomment %}

## Feature Selection Best Practices

Follow these guidelines to create effective features.

### Start Simple

Begin with one or two features and add more only if needed. Single features are easier to understand because you immediately know which metric triggered an anomaly. Simple configurations also train faster, so the model reaches stability sooner. You can always add features later as you learn what matters for your use case.

### Choose Meaningful Features

Select features that represent important metrics. Ask yourself: Does this metric indicate a real problem when it's anomalous? Does this field have enough variation to detect meaningful patterns? Does this feature align with your monitoring goals? Avoid monitoring metrics just because you can—focus on what matters.

### Watch Feature Count

Multi-feature models correlate anomalies across all features, giving you a more complete picture. However, more features can reduce accuracy due to the [curse of dimensionality](https://en.wikipedia.org/wiki/Curse_of_dimensionality), and higher noise levels amplify this effect.

The default maximum is 5 features, which you can adjust with the `anomaly_detection.max_anomaly_features` setting. Use an iterative approach: start with one feature, add more if you need better detection, and remove features that don't help.

### Avoid Redundancy

Don't add features that measure the same thing in different ways. For example, don't include both `sum(bytes)` and `average(bytes)` unless they serve truly different purposes. Redundant features confuse the model and can reduce accuracy while making results harder to interpret. Each feature should provide unique information.

## Editing Features

You can modify features after creating your detector by navigating to the detector details page. Select **Actions** > **Edit model configuration**, edit the features as needed, and select **Save changes**. You can enable or disable features, change aggregation methods, update field selections, and modify anomaly criteria.

**Note:** You must stop real-time and historical analysis before editing features. Stop any running jobs first.
{: .note}

## Next Steps

Now that you've configured your features, you can run your detector. See [Configure advanced settings](anomaly-detection-advanced-config) for high-cardinality detection or custom result indices, [Run your detector](anomaly-detection-running-detectors) to start generating results, or [Review results](anomaly-detection-running-detectors#understanding-results) to validate your feature configuration.