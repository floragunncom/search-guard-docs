---
title: Anomaly Detection settings
html_title: Anomaly Detection settings
permalink: anomaly-detection-settings
layout: docs
section: anomaly_detection
edition: enterprise
description: Anomaly Detection settings
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

# Anomaly Detection Settings

{: .no_toc}

{% include toc.md %}

The Anomaly Detection plugin adds several settings to your Elasticsearch cluster configuration. All settings are dynamic, so you can change them without restarting your cluster.

You can mark each setting as `persistent` or `transient`. Persistent settings survive cluster restarts, while transient settings reset when you restart the cluster.

The following example shows how to update the result index retention period to 5 minutes using a transient setting:

```json
PUT _cluster/settings
{
  "transient": {
    "anomaly_detection.ad_result_history_retention_period": "5m"
  }
}
```

## Available Settings

The following table describes all available Anomaly Detection settings:

Setting | Default | Description
:--- | :--- | :---
`anomaly_detection.enabled` | `True` | Controls whether the plugin is enabled. When disabled, all detectors stop running immediately.
`anomaly_detection.max_anomaly_detectors` | `1,000` | The maximum number of single-entity detectors (without category fields) you can create.
`anomaly_detection.max_multi_entity_anomaly_detectors` | `10` | The maximum number of high-cardinality detectors (with category fields) allowed in the cluster.
`anomaly_detection.max_anomaly_features` | `5` | The maximum number of features you can configure per detector.
`anomaly_detection.ad_result_history_rollover_period` | `12h` | How often the system checks whether the result index should roll over to a new index.
`anomaly_detection.ad_result_history_max_docs_per_shard` | `1,350,000,000` | The maximum number of documents allowed in a single shard of the result index. Only refreshed documents in primary shards count toward this limit.
`anomaly_detection.max_entities_per_query` | `1,000,000` | The maximum unique category field values per detection interval for high-cardinality detectors. When category fields exceed this number, the system uses natural ordering and selects the top values.
`anomaly_detection.max_entities_for_preview` | `5` | The maximum unique category field values shown in preview operations for high-cardinality detectors.
`anomaly_detection.max_primary_shards` | `10` | The maximum number of primary shards an anomaly detection index can have.
`anomaly_detection.max_batch_task_per_node` | `10` | The number of historical analysis batch tasks each data node can run simultaneously. Valid range: 1–1,000. If nodes cannot support all tasks, add more data nodes instead of increasing this value.
`anomaly_detection.max_old_ad_task_docs_per_detector` | `1` | The number of previous historical analysis tasks to keep for each detector. Set to at least 1 to track the last run. Valid range: 1–1,000.
`anomaly_detection.batch_task_piece_size` | `1,000` | The number of detection intervals in each historical analysis task piece. The system splits historical tasks into smaller pieces and processes them sequentially. Valid range: 1–10,000.
`anomaly_detection.batch_task_piece_interval_seconds` | `5` | The time interval in seconds between processing pieces of the same historical analysis task. This setting prevents resource starvation. Valid range: 1–600.
`anomaly_detection.max_top_entities_for_historical_analysis` | `1,000` | The maximum number of top entities analyzed in high-cardinality detector historical analysis. Valid range: 1–10,000.
`anomaly_detection.max_running_entities_per_detector_for_historical_analysis` | `10` | The number of entity tasks that can run in parallel for high-cardinality detector historical analysis. Total parallel tasks also depend on available task slots across your cluster. Valid range: 1–1,000.
`anomaly_detection.timeseries.max_cached_deleted_tasks` | `1,000` | The maximum number of deleted task results to cache for cleanup. An hourly cron job cleans cached results. Use the [delete detector results API](anomaly-detection-api-results#delete-detector-results) for manual cleanup if needed. Valid range: 1–10,000.
`anomaly_detection.delete_anomaly_result_when_delete_detector` | `False` | When `true`, deletes all anomaly results when you delete a detector. This setting is useful for saving disk space with high-cardinality detectors.
`anomaly_detection.dedicated_cache_size` | `10` | The number of entity models guaranteed to stay in memory per node for each running high-cardinality detector. Exceeding this limit moves additional models to shared memory. Increase this value if your cluster has sufficient memory.
`anomaly_detection.max_concurrent_preview` | `2` | The maximum number of preview operations that can run simultaneously. This setting limits resource usage during preview.
`anomaly_detection.model_max_size_percent` | `0.1` | The maximum percentage of heap memory a single model can use. The default value of 0.1 represents 10%.
`anomaly_detection.door_keeper_in_cache.enabled` | `False` | When `true`, places a bloom filter in front of the inactive entity cache to filter unlikely items.
`anomaly_detection.hcad_cold_start_interpolation.enabled` | `False` | When `true`, enables interpolation for high-cardinality anomaly detection during the initial cold start period.
`anomaly_detection.jvm_heap_usage_threshold` | `95` | The JVM heap usage percentage at which all detectors are disabled.
{: .config-table}

{% comment %}
anomaly_detection.filter_by_backend_roles | False | When you enable the Security plugin and set this to `true`, the anomaly detection plugin filters results based on the user's backend role(s).
{% endcomment %}