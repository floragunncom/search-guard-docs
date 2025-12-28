---
title: Anomaly Detection Versions
html_title: Anomaly Detection Versions
permalink: anomaly-detection-versions
layout: docs
section: anomaly_detection
edition: enterprise
description: A list of available Anomaly Detection plugin releases for Elasticsearch
index_algolia: false
---

<!---
Copyright (c) 2025 floragunn GmbH
-->

# Anomaly Detection Versions

This page lists all available versions of the Search Guard Anomaly Detection plugins.

## Components

Anomaly Detection consists of three plugins that work together:

- **Job Scheduler Plugin**: Manages scheduled tasks for anomaly detection jobs
- **Anomaly Detection Elasticsearch Plugin**: Provides the core anomaly detection functionality
- **Anomaly Detection Kibana Plugin**: Provides the user interface in Kibana

All three plugins share the same version number and are released together. You must install all three plugins for Anomaly Detection to work properly.

## Available Versions

Each Anomaly Detection release is compatible with a specific Elasticsearch version. Download all three plugins for your Elasticsearch version.

{% include ad_versions.html versions="anomaly-detection"%}

## Installation

To install Anomaly Detection:

1. Download all three plugins for your Elasticsearch version from the table above
2. Install each plugin on your Elasticsearch nodes
3. Install the Kibana plugin on your Kibana instance
4. Follow the [Getting Started guide](anomaly-detection-getting-started) for configuration instructions

## Support and Updates

For information about support policies and end-of-life dates, contact Search Guard support or visit the [Search Guard website](https://search-guard.com).
