---
title: Anomaly Detection settings
html_title: Anomaly Detection settings
permalink: anomaly-detection-settings
layout: docs
edition: enterprise
description: Anomaly Detection settings
---

<!---  
Copyright (c) 2025 floragunn GmH

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

{% include beta_warning.html %}


# Search Guard Anomaly Detection settings

{: .no_toc}

{% include toc.md %}

The Anomaly Detection plugin adds several settings to the standard Elasticsearch cluster settings.
The settings are dynamic, so you can change the default behavior of the plugin without restarting your cluster. 

You can mark settings as `persistent` or `transient`.

For example, to update the retention period of the result index:

```json
PUT _cluster/settings
{
  "transient": {
    "anomaly_detection.ad_result_history_retention_period": "5m"
  }
}
```

Setting | Default | Description
:--- | :--- | :---
anomaly_detection.enabled | True | Whether the anomaly detection plugin is enabled or not. If disabled, all detectors immediately stop running.
anomaly_detection.max_anomaly_detectors | 1,000 | The maximum number of non-high cardinality detectors (no category field) users can create.
anomaly_detection.max_multi_entity_anomaly_detectors | 10 | The maximum number of high cardinality detectors (with category field) in a cluster.
anomaly_detection.max_anomaly_features | 5 | The maximum number of features for a detector.
anomaly_detection.ad_result_history_rollover_period | 12h | How often the rollover condition is checked. If `true`, the anomaly detection plugin rolls over the result index to a new index.
anomaly_detection.ad_result_history_max_docs_per_shard | 1,350,000,000 | The maximum number of documents in a single shard of the result index. The anomaly detection plugin only counts the refreshed documents in the primary shards.
anomaly_detection.max_entities_per_query | 1,000,000 | The maximum unique values per detection interval for high cardinality detectors. By default, if the category field(s) have more than the configured unique values in a detector interval, the anomaly detection plugin orders them by the natural ordering of categorical values (for example, entity `ab` comes before `bc`) and then selects the top values.
anomaly_detection.max_entities_for_preview | 5 | The maximum unique category field values displayed with the preview operation for high cardinality detectors. By default, if the category field(s) have more than the configured unique values in a detector interval, the anomaly detection plugin orders them by the natural ordering of categorical values (for example, entity `ab` comes before `bc`) and then selects the top values.
anomaly_detection.max_primary_shards | 10 | The maximum number of primary shards an anomaly detection index can have.
anomaly_detection.max_batch_task_per_node | 10 | Starting a historical analysis triggers a batch task. This setting is the number of batch tasks that you can run per data node. You can tune this setting from 1 to 1,000. If the data nodes can’t support all batch tasks and you’re not sure if the data nodes are capable of running more historical analysis, add more data nodes instead of changing this setting to a higher value. Increasing this value might bring more load on each data node.
anomaly_detection.max_old_ad_task_docs_per_detector | 1 | You can run historical analysis for the same detector many times. For each run, the anomaly detection plugin creates a new task. This setting is the number of previous tasks the plugin keeps. Set this value to at least 1 to track its last run. You can keep a maximum of 1,000 old tasks to avoid overwhelming the cluster.
anomaly_detection.batch_task_piece_size | 1,000 | The date range for a historical task is split into smaller pieces and the anomaly detection plugin runs the task piece by piece. Each piece contains 1,000 detection intervals by default. For example, if detector interval is 1 minute and one piece is 1,000 minutes, the feature data is queried every 1,000 minutes. You can change this setting from 1 to 10,000.
anomaly_detection.batch_task_piece_interval_seconds | 5 | Add a time interval between two pieces of the same historical analysis task. This interval prevents the task from consuming too much of the available resources and starving other operations like search and bulk index. You can change this setting from 1 to 600 seconds.
anomaly_detection.max_top_entities_for_historical_analysis | 1,000 | The maximum number of top entities that you run for a high cardinality detector historical analysis. The range is from 1 to 10,000.
anomaly_detection.max_running_entities_per_detector_for_historical_analysis | 10 | The number of entity tasks that you can run in parallel for a high cardinality detector analysis. The task slots available on your cluster also impact how many entities run in parallel. If a cluster has 3 data nodes, each data node has 10 task slots by default. Say you already have two high cardinality detectors and each of them run 10 entities. If you start a single-entity detector that takes 1 task slot, the number of task slots available is 10 * 3 - 10 * 2 - 1 = 9. If you now start a new high cardinality detector, the detector can only run 9 entities in parallel and not 10. You can tune this value from 1 to 1,000 based on your cluster's capability. If you set a higher value, the anomaly detection plugin runs historical analysis faster but also consumes more resources.
anomaly_detection.timeseries.max_cached_deleted_tasks | 1,000 | You can rerun historical analysis for a single detector as many times as you like. The anomaly detection plugin only keeps a limited number of old tasks, by default 1 old task. If you run historical analysis three times for a detector, the oldest task is deleted. Because historical analysis generates a number of anomaly results in a short span of time, it's necessary to clean up anomaly results for a deleted task. With this field, you can configure how many deleted tasks you can cache at most. The plugin cleans up a task's results when it's deleted. If the plugin fails to do this cleanup, it adds the task's results into a cache and an hourly cron job performs the cleanup. You can use this setting to limit how many old tasks are put into cache to avoid a DDoS attack. After an hour, if still you find an old task result in the cache, use the [delete detector results API](anomaly-detection-api#delete-detector-results) to delete the task result manually. You can tune this setting from 1 to 10,000.
anomaly_detection.delete_anomaly_result_when_delete_detector | False | Whether the anomaly detection plugin deletes the anomaly result when you delete a detector. If you want to save some disk space, especially if you've high cardinality detectors generating a lot of results, set this field to true. Alternatively, you can use the [delete detector results API](anomaly-detection-api#delete-detector-results) to manually delete the results.
anomaly_detection.dedicated_cache_size | 10 | If the real-time analysis of a high cardinality detector starts successfully, the anomaly detection plugin guarantees keeping 10 (dynamically adjustable via this setting) entities' models in memory per node. If the number of entities exceeds this limit, the plugin puts the extra entities' models in a memory space shared by all detectors. The actual number of entities varies based on the memory that you've available and the frequencies of the entities. If you'd like the plugin to guarantee keeping more entities' models in memory and if you're cluster has sufficient memory, you can increase this setting value.
anomaly_detection.max_concurrent_preview | 2 | The maximum number of concurrent previews. You can use this setting to limit resource usage.
anomaly_detection.model_max_size_percent | 0.1 | The upper bound of the memory percentage for a model.
anomaly_detection.door_keeper_in_cache.enabled | False | When set to `true`, Search Guard places a bloom filter in front of an inactive entity cache to filter out items that are not likely to appear more than once.
anomaly_detection.hcad_cold_start_interpolation.enabled | False | When set to true, enables interpolation for high-cardinality anomaly detection (HCAD) during the initial cold start period.
anomaly_detection.jvm_heap_usage_threshold | 95 | Specifies the JVM memory usage threshold, as a percentage, at which anomaly detectors will be disabled. The default value is 95%, meaning that detectors will be disabled when JVM heap usage reaches 95%.
{% comment %}
anomaly_detection.filter_by_backend_roles | False | When you enable the Security plugin and set this to `true`, the anomaly detection plugin filters results based on the user's backend role(s).
{% endcomment %}