---
title: Anomaly Detection
html_title: Anomaly Detection
permalink: anomaly-detection
layout: docs
section: anomaly_detection
edition: enterprise
description: Introduction to Search Guard Anomaly Detection - automatically detect anomalies in your Elasticsearch data
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

# Anomaly Detection

{: .no_toc}

{% include toc.md %}

Anomaly Detection uses machine learning to find unusual patterns in your Elasticsearch data automatically. Rather than setting static thresholds manually, the Random Cut Forest (RCF) algorithm learns what's normal in your data and detects deviations in real time.

## Why You Need Anomaly Detection

Traditional monitoring approaches have significant limitations. Static thresholds require prior knowledge of your data and cannot adapt when patterns change. Manual dashboard monitoring takes too much time and inevitably misses problems. Seasonal trends and organic growth make threshold-based alerts unreliable. And tracking many unique entities—known as high-cardinality data—becomes nearly impossible with conventional methods.

Search Guard Anomaly Detection solves these problems by learning normal patterns automatically and adapting as your data evolves. The system can detect anomalies across thousands of entities simultaneously, and each result includes a confidence score along with details showing which features contributed to the anomaly.

## Common Use Cases

You can use Anomaly Detection to monitor your infrastructure, catch security threats, track application performance, and analyze business metrics.

**IT Infrastructure Monitoring:** Catch unusual CPU, memory, or disk usage before systems fail. Spot network traffic anomalies and degraded performance early, giving your team time to respond before outages occur.

**Security and Threat Detection:** Find suspicious login patterns, abnormal network traffic, data exfiltration attempts, and privilege escalation. Machine learning can identify threats that rule-based systems miss.

**Application Performance:** Detect slow response times, unusual error rates, and degraded throughput before users complain. Proactive detection helps you maintain service level agreements.

**Business Analytics:** Spot unusual transactions, abnormal user behavior, revenue anomalies, and inventory problems. Early detection of business metric anomalies helps you respond quickly to emerging issues.

## Key Features

**Machine Learning Detection:** The system requires no training data because it uses unsupervised learning. The RCF algorithm detects anomalies as data arrives, and you can also analyze historical data to establish baselines before enabling real-time detection.

**High-Cardinality Support:** Group your data by dimensions like IP addresses or user IDs using `category_fields`. The system handles thousands of unique entities automatically and prioritizes the most frequent and recent ones for analysis.

**Flexible Configuration:** Monitor up to five metrics per `detector` using any Elasticsearch aggregation you need. Filter data to focus on what matters most, and set detection intervals that match your data frequency.

**Integration and Alerting:** Connect to Search Guard Signals for automated alerts, store results in custom indices for long-term analysis, use the REST API for automation, and create detectors visually in Kibana.

## How It Works

Here's the typical workflow when you use Anomaly Detection:

1. Define a `detector` and specify which data to analyze.
2. Configure `features` to track specific metrics, such as CPU average or error count.
3. Set how often the system should check your data by specifying a `detection_interval`.
4. Start the detector for real-time monitoring or run historical analysis.
5. Review `anomaly_score`, `anomaly_grade`, and feature contributions in the results.
6. Set up alerts to notify you when anomalies occur.

The RCF algorithm builds a statistical model from your data over time. When new data points deviate significantly from expected patterns, the system flags them as anomalies and provides confidence scores to help you prioritize your response.

## Getting Started

Ready to detect anomalies in your data? Follow these steps to get up and running.

### Install the Plugins

Download and install the Anomaly Detection plugins for both Elasticsearch and Kibana. The plugins are currently available as a technical preview for Elasticsearch 8.17.0. See [Getting Started](anomaly-detection-getting-started) for installation instructions.

### Learn the Concepts

Before creating detectors, take time to understand what `detectors`, `features`, `anomaly_score`, and the RCF algorithm do. See [Overview](anomaly-detection-overview) for a detailed explanation of these concepts.

### Create Your First Detector

Set up a simple detector to see how anomaly detection works with your data. The [Getting Started Guide](anomaly-detection-getting-started#your-first-detector-quick-start) walks you through creating and running your first detector step by step.

### Configure Advanced Features

Once you're comfortable with basic detection, explore high-cardinality detection, custom result indices, and performance tuning. See [Advanced Configuration](anomaly-detection-advanced-config) for details on these capabilities.

### Set Up Alerts

Connect to Signals Alerting so you receive notifications when the system finds anomalies. See [Alerts and Integration](anomaly-detection-alerts) to configure automated alerting.

## Documentation Sections

Find the documentation you need based on what you're trying to accomplish.

**For Beginners:**

- [Overview](anomaly-detection-overview) – Key concepts and how anomaly detection works
- [Getting Started](anomaly-detection-getting-started) – Plugin installation and your first detector
- [Creating Detectors](anomaly-detection-creating-detectors) – Detector configuration basics

**For Configuration:**

- [Configuring Features](anomaly-detection-features) – Define which metrics to monitor
- [Advanced Configuration](anomaly-detection-advanced-config) – High-cardinality, shingling, imputation, and custom indices
- [Running Detectors](anomaly-detection-running-detectors) – Start detection and view results

**For Integration:**

- [Alerts and Integration](anomaly-detection-alerts) – Set up Signals alerting for anomalies

**For API Users:**

- [Detector Operations API](anomaly-detection-api-detectors) – Create, update, and delete detectors programmatically
- [Job Operations API](anomaly-detection-api-jobs) – Start, stop, and manage detector jobs
- [Result Operations API](anomaly-detection-api-results) – Search and manage anomaly results

**For Reference:**

- [Settings](anomaly-detection-settings) – Complete list of cluster settings
- [Security](anomaly-detection-security) – Configure permissions and access control
- [Result Mapping](anomaly-detection-result-mapping) – Result structure and field descriptions

## Support and Feedback

Anomaly Detection is currently available as a technical preview for Elasticsearch 8.17.0. We welcome your feedback as we continue developing this feature. For questions, issues, or feature requests, contact Search Guard support.

## Next Steps

Choose your path based on what you need:

- **New to Anomaly Detection?** Start with [Overview](anomaly-detection-overview) to understand the concepts.
- **Ready to try it?** Jump to [Getting Started](anomaly-detection-getting-started) to install and create your first detector.
- **Need to configure detectors?** See [Creating Detectors](anomaly-detection-creating-detectors) for configuration details.
- **Want to use the API?** Explore [Detector Operations API](anomaly-detection-api-detectors) for programmatic access.
- **Setting up alerts?** Check out [Alerts and Integration](anomaly-detection-alerts) for Signals integration.