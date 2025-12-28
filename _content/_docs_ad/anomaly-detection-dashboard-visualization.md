---
published: false
title: Anomaly Detection dashboards and visualizations
html_title: Anomaly Detection dashboards and visualizations
permalink: anomaly-detection-dashboard-visualization
layout: docs
section: anomaly_detection
edition: enterprise
description: Anomaly Detection dashboards and visualizations
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

# Search Guard Anomaly Detection Dashboards and Visualizations

{: .no_toc}

{% include toc.md %}

Anomaly detection helps you automatically identify harmful outliers and protect your data. When applied to metrics, the system uses algorithms to continuously analyze systems and applications, determine normal baselines, and surface anomalies.

You can connect data visualizations to OpenSearch datasets and then create, run, and view real-time anomaly results directly from the **Dashboard** interface. With just a few steps, you can bring together traces, metrics, and logs to make your applications and infrastructure fully observable.

## Getting Started

Before you begin, make sure you have the following components installed:

- OpenSearch and OpenSearch Dashboards version 2.9 or later. See [Installing OpenSearch]({{site.url}}{{site.baseurl}}/install-and-configure/install-opensearch/index/).
- Anomaly Detection plugin version 2.9 or later. See [Installing OpenSearch plugins]({{site.url}}{{site.baseurl}}/install-and-configure/plugins/).
- Anomaly Detection Dashboards plugin version 2.9 or later. See [Managing OpenSearch Dashboards plugins]({{site.url}}{{site.baseurl}}/install-and-configure/install-dashboards/plugins/).

## Requirements for Anomaly Detection Visualizations

Anomaly detection visualizations display as time-series charts that show you when anomalies occurred across the detectors you've configured. You can display up to 10 metrics on your chart, with each series shown as a separate line. Note that only real-time anomalies appear on the chart. For more information about real-time and historical anomaly detection, see [Anomaly detection, Step 3: Set up detector jobs]({{site.url}}{{site.baseurl}}/observing-your-data/ad/index/#step-3-setting-up-detector-jobs).

Your visualization must meet the following requirements:

- Uses a [Vizlib line chart](https://community.vizlib.com/support/solutions/articles/35000107262-vizlib-line-chart-introduction)
- Contains at least one Y-axis metric aggregation
- Does not include non-Y-axis metric aggregation types
- Uses the date histogram aggregation type for the X-axis bucket
- Positions the X-axis on the bottom
- Defines exactly one X-axis aggregation bucket
- Has a valid time-based X-axis

## Configuring Admin Settings

Users can only access, create, or manage anomaly detectors for resources they have permissions to use. OpenSearch and OpenSearch Dashboards permissions control access to anomaly detection dashboards and visualizations.

The feature is enabled by default and appears under **Dashboards Management** > **Advanced Settings** > **Visualization**. When disabled, it doesn't appear under **Dashboards Management**. To disable the setting at the cluster level, update the `opensearch-dashboards.yml` file.

## Creating Anomaly Detectors

Follow these steps to create an anomaly detector from the Dashboard interface:

1. Select **Dashboard** from the OpenSearch Dashboards main menu.
2. From the **Dashboards** window, select **Create** and then choose **Dashboard**.
3. Select **Add an existing**, then choose the appropriate visualization from the **Add panels** list. The visualization is added to the dashboard.
4. From the visualization panel, select the ellipsis icon ({::nomarkdown}<img src="{{site.url}}{{site.baseurl}}/images/ellipsis-icon.png" class="inline-icon" alt="ellipsis icon"/>{:/}).
5. From the **Options** menu, select **Anomaly Detection** > **Add anomaly detector**.
6. Select **Create new detector**.
7. Enter information for **Detector details** and **Model features**. You can configure up to five model features.
8. To preview the visualization within the flyout, toggle the **Show visualization** button.
9. Select **Create detector**.

Once you create the detector, it appears in your visualization as shown in the following image.

<img src="{{site.url}}{{site.baseurl}}/images/dashboards/add-detector.png" alt="Interface of adding a detector" width="800" height="800">

## Adding Existing Detectors to Visualizations

You can use a single interface to add, view, and edit anomaly detectors associated with a visualization. To associate an existing detector with a visualization:

1. From the visualization panel, select the ellipsis icon ({::nomarkdown}<img src="{{site.url}}{{site.baseurl}}/images/ellipsis-icon.png" class="inline-icon" alt="ellipsis icon"/>{:/}), then select **Anomaly Detection**.
2. Select **Associate a detector**.
3. From the **Select detector to associate** dropdown menu, choose the detector you want to use. Only eligible detectors appear in the dropdown menu.
4. Review the basic detector information. To see comprehensive details, select **View detector page** to open the Anomaly Detection plugin page.
5. Select **Associate detector**.

The detector is now associated with your visualization, as shown in the following image.

<img src="{{site.url}}{{site.baseurl}}/images/dashboards/anomaly-detect-dashboard.png" alt="Interface and confirmation message of associating a detector" width="800" height="800">

## Refreshing the Visualization

The visualization refreshes automatically at the interval you specify in your threshold settings. To manually refresh the visualization, select the **Refresh** button on the Dashboard page.

## Next Steps

- [Learn more about the Dashboard application]({{site.url}}{{site.baseurl}}/dashboards/dashboard/index/)
- [Learn more about anomaly detection]({{site.url}}{{site.baseurl}}/observing-your-data/ad/index/)