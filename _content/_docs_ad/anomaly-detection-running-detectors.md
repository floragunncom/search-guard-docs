---
title: Running Detectors
html_title: Running Detectors
permalink: anomaly-detection-running-detectors
layout: docs
section: anomaly_detection
edition: enterprise
description: Learn how to run detectors and view anomaly detection results
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

# Running Detectors

{: .no_toc}

{% include toc.md %}

Now that you have created and configured your detector, you can run it to start detecting anomalies in your data. This guide walks you through starting detection, viewing results, and managing your detectors.

## Start Real-Time Detection

Real-time detection continuously monitors your data as it arrives, giving you anomaly detection in near real time.

### How to Start

To begin real-time detection, go to the detector details page and select **Start real-time detector automatically (recommended)**. Alternatively, you can use the [Start detector job](anomaly-detection-api-jobs#start-detector-job) API endpoint. The detector enters its initialization phase immediately after you start it.

### Understand Initialization

Before the detector can identify anomalies, it needs to collect enough data to train its model. This initialization phase typically requires 128–256 detection intervals, depending on your `shingle_size` configuration. You can monitor initialization progress by checking the detector status in the UI or by using the [Profile Detector API](anomaly-detection-api-detectors#profile-detector).

For example, if your detector has a 10-minute interval and a `shingle_size` of 8, the detector may take approximately 80 minutes to initialize (10 minutes × 8 intervals = 80 minutes). Shorter intervals result in faster initialization.

### Troubleshoot Slow Initialization

If your detector remains in the "Initializing" state for longer than one day, check for missing data points. Start by aggregating your existing data to verify data availability. Then confirm the detector interval aligns with how frequently new data arrives. Check for gaps in the timestamp field, and if many data points are missing, consider increasing the detector interval.

Missing data prevents the detector from collecting enough consecutive intervals to complete initialization.
{: .note}

## Run Historical Analysis

Historical analysis examines data over a specified date range in the past. This feature helps you test detector configurations and investigate past incidents.

### When to Use Historical Analysis

Historical analysis is useful in several scenarios. You can use it to **test detector configurations** by validating your settings before deploying real-time detection. It also helps you **analyze past data** to establish baselines from historical patterns, or **investigate past incidents** to understand anomalies that already occurred. Finally, you can use historical analysis to **fine-tune features** by adjusting your settings based on how the detector performs on known data.

### How to Run Historical Analysis

To start a historical analysis, navigate to the detector setup page or details page and select **Run historical analysis detection**. Then select a date range that covers at least 128 detection intervals based on your `shingle_size`, and select **Start**.

The longer the date range, the more comprehensive your analysis. You can run historical analysis multiple times for the same detector—each run creates a new batch task.
{: .note}

### Compare Detection Modes

The following table summarizes the key differences between real-time detection and historical analysis:

Feature | Real-Time Detection | Historical Analysis
:--- | :--- | :---
**Purpose** | Ongoing monitoring | Batch analysis of past data
**Duration** | Continuous until stopped | Runs once for specified date range
**Use case** | Live alerting and intervention | Testing, investigation, baseline establishment
**Task type** | Creates a real-time job | Creates a batch task
**Results** | Generated continuously | Generated for specified time range
{: .config-table}

## View Results

After the detector has initialized and run for a while, you can view the anomaly detection results.

### Access Results

To view results, navigate to the detector details page and select the appropriate tab. Choose the **Real-time results** tab for ongoing detection results, or the **Historical analysis** tab for batch analysis results.

### Real-Time Results

For real-time detection, results take time to appear because the detector needs sufficient data to complete the shingle process. Initial results typically appear after one to two hours, depending on your interval setting. You can use the [Profile Detector](anomaly-detection-api-detectors#profile-detector) operation to verify the detector has collected sufficient data points.

### Live Anomalies

The live anomalies view displays anomaly results for the last 60 intervals. For example, if your interval is 10 minutes, the view shows the last 600 minutes of results. The chart refreshes automatically every 30 seconds.

## Understand Results

Your results include several key components that help you interpret detected anomalies.

### Anomaly Overview

The overview provides key metrics about detected anomalies:

- **Number of anomaly occurrences**: The total anomalies in the selected time range.
- **Average anomaly grade**: A number between 0 and 1 indicating severity. A value of `0` means no anomaly, while non-zero values indicate the relative severity of the anomaly.
- **Confidence**: An estimate of the probability that the reported anomaly grade matches the expected anomaly grade. Confidence increases as the model observes more data. Note that confidence is distinct from model accuracy.
- **Last anomaly occurrence**: The timestamp of the most recent anomaly.

### Feature Breakdown

The Feature Breakdown chart displays three pieces of information: the **feature output** (the actual value of the feature aggregation), the **expected value** (what the model predicted for the feature output), and a **comparison** of the two. When there is no anomaly, the output and expected values are equal.

You can adjust the date-time range to explore different periods. Select a point on the feature line chart to see detailed information about that specific moment.

### Anomaly Occurrences

This section lists all detected anomalies with the following details:

- **Start time**: When the anomaly began.
- **End time**: When the anomaly ended.
- **Data confidence**: The confidence level for this specific detection.
- **Anomaly grade**: The severity on a 0–1 scale.

### Feature Contribution

When you select a point on the anomaly line chart, you see the percentage each feature contributed to the anomaly. This breakdown helps you identify which metrics are driving the anomalous behavior.

## View High-Cardinality Results

If you configured category fields for your detector, you see additional visualizations that help you analyze anomalies across different entities.

### Heat Map

The heat map correlates results for anomalous entities. Select an anomalous entity to see its time-series anomaly and feature charts. The heat map displays only time periods where `anomaly_grade` is greater than 0.

### Entity Selection

For detectors with multiple category fields, you can drill down into specific entities. Use the **View by** dropdown to select a subset of fields to filter and sort, then select a specific cell to overlay the top 20 values of another field. You can view a maximum of five individual time-series values simultaneously.

For example, suppose your detector has category fields `ip` and `endpoint`. If you select `endpoint` in the **View by** dropdown and then select a specific endpoint cell, you see the top 20 `ip` addresses for that endpoint overlaid on the charts.

## Interact with Charts

You can explore results using several interactions:

- **Zoom in**: Click and drag over the anomaly line chart to see a detailed view.
- **Change time range**: Adjust the date-time range controls to explore different periods.
- **View point details**: Click individual points to see specific values and feature contributions.

## Manage Detectors

You can adjust and control your detectors after creating them.

### Adjust the Model

If you need to fine-tune your detector configuration, go to the **Detector configuration** tab and select **Edit** in the section you want to modify. Make your changes, then review the updated configuration and select **Save and start detector**. The detector reinitializes with the new settings.

You must stop both real-time detection and historical analysis before making configuration changes.
{: .note}

### Common Adjustments

You can make several types of adjustments to improve detector performance. Modify the **detector interval** to minimize false positives or improve detection speed. Enable, disable, or modify **feature configurations** to focus on the most relevant metrics. Adjust **window delay** to account for data ingestion timing. Fine-tune **shingle size** to better match your data patterns.

### Stop and Start Detectors

From the detector details page, you can control detector operation by selecting the **Actions** button. Choose **Start real-time detector** to begin ongoing monitoring, **Stop real-time detector** to pause ongoing monitoring, or **Stop historical analysis** to cancel a running historical batch task.

To manage multiple detectors at once, navigate to the **Detectors** page, select the checkbox next to one or more detectors, then select **Actions** and choose either **Start real-time detectors** or **Stop real-time detectors**.

### Delete Detectors

Before deleting a detector, stop all associated jobs by stopping real-time detection and any running historical analysis. Then, from the detector details page, select **Actions** > **Delete detector**. Alternatively, from the **Detectors** page, select the detector and choose **Actions** > **Delete detectors**.

If you delete a detector, remember to also delete any watches you created for alerting.
{: .note}

## Troubleshoot Common Issues

Here are solutions to common problems you might encounter when running detectors.

### No Results Appearing

If no results appear, the detector may still be initializing—check the initialization progress in the detector status. Other causes include insufficient data points in the time range, a data filter that is too restrictive, or an index with no data in the specified time range.

To resolve this issue, wait for initialization to complete and check the detector status. Use the [Profile Detector](anomaly-detection-api-detectors#profile-detector) API to check data availability, review your data filter settings, and try removing filters temporarily to test. Finally, verify that the timestamp field values in your index fall within the expected range.

### High False Positive Rate

A high false positive rate can occur when the detector interval is too short for your data patterns, when features are not aligned with actual anomalies, or when the `shingle_size` is inappropriate for your data.

To reduce false positives, increase the detector interval to better match your data frequency and adjust feature configurations to focus on meaningful metrics. You can also use anomaly criteria settings to detect only spikes or only dips, rather than both. Tuning the `shingle_size` based on your data patterns can also help.

### Low Confidence Scores

Low confidence is normal during certain situations: during the **initial probation period** when the model is still learning your data patterns, **after restarting a detector** when the model needs to re-establish patterns, and **when data patterns change significantly** because major shifts in your data require the model to relearn.

Confidence improves over time as the model observes more data. Stable data patterns help the model establish a stronger baseline with each interval.

## Next Steps

Now that you know how to run detectors and view results, explore these related topics:

- [Set up alerts](anomaly-detection-alerts) to get notified when anomalies occur.
- [Use the API](anomaly-detection-api-jobs) to automate detector management.
- [Review settings](anomaly-detection-settings) for performance tuning options.