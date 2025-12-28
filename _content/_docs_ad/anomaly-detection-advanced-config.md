---
title: Advanced Detector Configuration
html_title: Advanced Detector Configuration
permalink: anomaly-detection-advanced-config
layout: docs
section: anomaly_detection
edition: enterprise
description: Advanced configuration options for Search Guard Anomaly Detection
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

# Advanced Detector Configuration

{: .no_toc}

{% include toc.md %}

This page covers advanced configuration options for fine-tuning your anomaly detectors, including high-cardinality detection, shingling, imputation strategies, and custom result indices.

## High-Cardinality Detectors

High-cardinality detectors categorize anomalies based on keyword or IP field types, allowing you to analyze data across multiple entities simultaneously.

### What Are Category Fields?

Category fields let you "slice" your time-series data using dimensions. Think of this like `GROUP BY` in SQL—instead of detecting anomalies across all your data as a single stream, you detect anomalies separately for each unique value of the category field.

Common examples include IP addresses (detect anomalies per client IP to see which clients behave unusually), product IDs (detect anomalies per product to identify unusual sales patterns), country codes (detect anomalies per geographic region to spot regional issues quickly), and error types (detect anomalies per error category to find which errors spike unexpectedly).

### Configure Category Fields

To enable category fields:

1. In the detector configuration, select **Enable categorical fields**.
2. Choose a field from the dropdown.
3. Optionally select a second category field (maximum of two).

You cannot change category fields after creating the detector. Choose carefully before you save the detector configuration.
{: .note}

### Plan for Entity Capacity

Your cluster can only support a certain number of unique entities. Calculate your recommended capacity using this formula:

```
(data nodes × heap size × anomaly detection maximum memory percentage) / (entity model size)
```

The following example shows how to calculate capacity for a typical cluster. Assume your cluster has 3 data nodes, each with 8 GB of JVM heap (8096 MB). The default memory allocation is 10% (`anomaly_detection.model_max_size_percent`), and the entity model size is approximately 1 MB (use the [Profile Detector API](anomaly-detection-api-detectors#profile-detector) to get the actual size for your detector).

The calculation gives you:

```
(8096 MB × 0.1 / 1 MB) × 3 = 2,429 entities
```

This means your cluster can handle approximately 2,429 unique entities.

This formula provides a starting point. Test with representative workloads to validate capacity for your specific use case.
{: .note}

### When You Exceed Capacity

If the actual number of unique entities exceeds your calculated capacity, the detector prioritizes entities based on two criteria: entities that occur more frequently and entities that appear more recently. Less frequent or older entities may not be analyzed until capacity becomes available.

### Category Field Syntax

For a single category field, specify an array with one element:

```json
"category_field": ["ip"]
```

For two category fields, include both in the array:

```json
"category_field": ["ip", "error_type"]
```

The detector creates a separate model for each unique combination of category field values. For example, if you have 100 unique IP addresses and 5 error types, the detector could create up to 500 separate models.

## Shingle Size Configuration

The `shingle_size` setting determines how many consecutive data stream aggregation intervals to include in the detection window.

### Understanding Shingling

Shingling uses consecutive data points to create samples for the model. The detector needs a minimum number of consecutive data points before it can generate anomaly results. Think of shingling as looking at patterns over time—a `shingle_size` of 8 means the detector examines 8 consecutive intervals together to identify patterns and detect deviations.

### Configure Shingle Size

To set the shingle size:

1. In **Advanced settings**, select **Show**.
2. Enter the desired size in the **Shingle size** field.

### Shingle Size Guidelines

The default `shingle_size` is 8 intervals, with a valid range of 1 to 128 intervals. There is one special case to note: use `1` only if you have at least two features, because single-feature detectors need a `shingle_size` of at least 2.

### Choose the Right Shingle Size

Values below 8 may increase [recall](https://en.wikipedia.org/wiki/Precision_and_recall) but also increase false positives. You detect more anomalies, but some might not represent real problems.

Values above 8 help ignore noise in your signals. Use higher values when your data has many normal variations that you don't want flagged as anomalies.

Start with the default value of 8 and adjust based on your results. Increase the value if you receive too many false positives, or decrease it if you miss real anomalies.

## Imputation Options

Imputation determines how the detector handles missing data in your streams. By configuring imputation, you control how the detector treats gaps in your data.

### Available Imputation Methods

The following table describes each imputation method and when to use it:

Method | Behavior | When to Use
:--- | :--- | :---
**Ignore Missing Data** | The system continues without considering missing data points and maintains existing data flow. | Default option. Best for sporadic, non-critical gaps.
**Fill with Custom Values** | You specify a custom value for each feature to replace missing data. | When you know appropriate substitute values for your data.
**Fill with Zeros** | The system replaces missing values with zeros. | When absence of data indicates a significant event, such as a drop to zero in event counts. Useful for detecting both partial and complete drops.
**Use Previous Values** | The system fills gaps with the last observed value, maintaining continuity in time-series data. | When you want to treat missing data as non-anomalous and carry forward the previous trend.
{: .config-table}

### Configure Imputation

To set imputation options:

1. Navigate to **Advanced settings**.
2. Select the desired imputation method.
3. If using **Fill with Custom Values**, specify values for each feature.

### Consider Imputation Trade-offs

Imputation offers benefits but also comes with trade-offs to consider. On the positive side, imputation can improve recall in anomaly detection, helping you catch anomalies you would otherwise miss due to data gaps.

However, extensive missing data compromises model accuracy regardless of the imputation method you choose. Poor data quality leads to poor model performance.

The confidence score decreases when imputations occur, indicating the model is less certain about its results. You can check the `feature_imputed` field in anomaly results to see which features were imputed. See [Result Mapping](anomaly-detection-result-mapping) for details on this field.

## Custom Result Indices

By default, anomaly results are stored in system indices. You can specify a custom index for storing results to gain more control over your data.

### Why Use Custom Result Indices?

Custom indices give you more control over your results. You can build custom dashboards and visualizations using your results data. You can apply your own retention policies to manage data lifecycle. You can implement namespace-based permissions for fine-grained access control. And you can integrate results with other tools and processes in your environment.

### Enable Custom Result Indices

To use a custom results index:

1. In detector configuration, select **Enable custom results index**.
2. Provide an index name, such as `financial-anomalies`.
3. The plugin creates an alias with the prefix `searchguard-ad-result-` followed by your name.
4. The actual index includes a date and sequence number.

For example, if you provide `financial-anomalies`, the plugin creates an alias named `searchguard-ad-result-financial-anomalies` and an actual index named something like `searchguard-ad-result-financial-anomalies-history-2024.06.12-000002`.

### Manage Namespaces

Use hyphens to separate namespaces for granular permission management. For example, the index name `searchguard-ad-result-financial-us-group1` lets you create permission roles based on patterns like `searchguard-ad-result-financial-us-*`. This represents the `financial` department at a granular level for the `us` group.

### Index Creation Behavior

If the custom index doesn't exist, the plugin creates it automatically when you create the detector. The plugin also creates the index for both real-time and historical analysis when started.

If the index already exists, the plugin verifies that the index mapping matches the required structure. Ensure the custom index has a valid mapping as defined in [`anomaly-results.json`](https://git.floragunn.com/search-guard/search-guard-anomaly-detection/-/blob/main/src/main/resources/mappings/anomaly-results.json).

### Required Permissions

To use custom results indices, you need the following permissions:

Permission | Purpose
:--- | :---
`indices:admin/create` | Create and roll over the custom index
`indices:admin/aliases` and `indices:admin/aliases/get` | Create and manage aliases
`indices:data/write/index` | Write results into the custom index for single-entity detectors
`indices:data/read/search` | Search custom results to display them in the interface
`indices:data/write/delete` | Delete old data to save disk space
`indices:data/write/bulk*` | Use the Bulk API to write results
{: .config-table}

### Access Results

When the Search Guard Security plugin (fine-grained access control) is enabled, access to results changes. The default results index becomes a system index, which means you cannot access it through standard Index or Search APIs. Instead, use the Anomaly Detection RESTful API or dashboard to access results.

Custom results indices remain accessible through standard APIs, allowing you to build customized dashboards and integrate with other tools.

{% comment %}
## Flattening Nested Fields

Custom results index mappings with nested fields pose aggregation and visualization challenges. The **Enable flattened custom result index** option flattens nested fields.

### How Flattening Works

When you enable flattening:

The plugin creates a separate index with the detector name.

**Example**: For detector `Test` using custom index `abc`, the plugin creates alias `searchguard-ad-result-abc-flattened-test`.

The plugin sets up an ingest pipeline with a script processor.

The pipeline uses a Painless script to flatten all nested fields.

### Manage Flattened Indices

**Deactivating**: Removes the flattening ingest pipeline and stops using it as the default results index.

**Conflict handling**: The plugin constructs index names based on custom results index and detector name. Because detector names are editable, conflicts can occur. If a conflict occurs, the plugin reuses the index name.

### Best Practices

The plugin queries all detector results from all custom results indexes.

Too many custom results indexes can impact performance.

Use [Automated Index Management](automated-index-management) to roll over old results.

Manually delete or archive old results indexes.

Reuse custom results indexes for multiple detectors.

### Rollover Conditions

The plugin rolls over an alias to a new index when meeting any of these conditions:

Parameter | Description | Type | Unit | Example
:--- | :--- |:--- |:--- |:---
`result_index_min_size` | Minimum total primary shard size for rollover | integer | MB | 51200 (50 GB)
`result_index_min_age` | Minimum index age from creation time | integer | day | 7
`result_index_ttl` | Minimum age to delete rolled-over indexes | integer | day | 60
{: .config-table}
{% endcomment %}

## Performance Tuning

You can adjust settings to optimize performance for your workload.

### Memory Settings

The `anomaly_detection.model_max_size_percent` setting controls memory allocation for anomaly detection. The default is 10% of JVM heap. Increase this value if you need to support more high-cardinality entities, as more memory allows more entity models to stay in memory simultaneously.

### Dedicated Cache Size

The `anomaly_detection.dedicated_cache_size` setting controls how many entity models stay in memory. The default is 10 entities per node. Increase this value if your cluster has sufficient memory and you want more entities kept in memory. A larger cache improves performance for frequently accessed entities by reducing the need to reload models from disk.

See [Settings](anomaly-detection-settings) for the complete list of configuration options.

## Next Steps

Now that you've configured advanced settings for your detector, you're ready to put it into action.

- [Run your detector](anomaly-detection-running-detectors) to start generating results.
- [Set up alerts](anomaly-detection-alerts) to receive notifications when anomalies occur.
- [Use the API](anomaly-detection-api-detectors) for programmatic detector management.