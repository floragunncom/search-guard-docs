---
title: Anomaly Detection API - Job Operations
html_title: Anomaly Detection API - Job Operations
permalink: anomaly-detection-api-jobs
layout: docs
section: anomaly_detection
edition: enterprise
description: API reference for anomaly detector job operations
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

# Anomaly Detection API - Job Operations

{: .no_toc}

{% include toc.md %}

Use these API operations to start, stop, and monitor anomaly detector jobs and tasks.

## Start Detector Job

Starts a real-time or historical anomaly detector job.

### Start Real-Time Detection

Starts continuous monitoring of your data. The detector analyzes incoming data at the configured detection interval and generates anomaly results.

#### Request

```json
POST _anomaly_detection/api/detectors/<DETECTOR_ID>/_start
```

Replace `<DETECTOR_ID>` with the ID of the detector you want to start.

#### Example Response

```json
{
  "_id": "VEHKTXwBwf_U8gjUXY2s",
  "_version": 3,
  "_seq_no": 6,
  "_primary_term": 1
}
```

The `_id` field contains the real-time job ID, which matches the detector ID.

### Start Historical Analysis

Starts a one-time analysis of data within a specific date range. Use historical analysis to find anomalies in past data or to test a detector configuration before enabling real-time detection.

#### Request

```json
POST _anomaly_detection/api/detectors/<DETECTOR_ID>/_start
{
  "start_time": 1633048868000,
  "end_time": 1633394468000
}
```

Replace `<DETECTOR_ID>` with your detector ID. Specify `start_time` and `end_time` as epoch timestamps in milliseconds.

#### Example Response

```json
{
  "_id": "f9DsTXwB6HknB84SoRTY",
  "_version": 1,
  "_seq_no": 958,
  "_primary_term": 1
}
```

The `_id` field contains the historical batch task ID, which is a randomly generated universally unique identifier (UUID).

---

## Stop Detector Job

Stops a running real-time or historical anomaly detector job.

### Stop Real-Time Detection

Stops continuous monitoring. The detector stops analyzing new data but preserves existing anomaly results.

#### Request

```json
POST _anomaly_detection/api/detectors/<DETECTOR_ID>/_stop
```

Replace `<DETECTOR_ID>` with the ID of the detector you want to stop.

#### Example Response

```json
{
  "_id": "VEHKTXwBwf_U8gjUXY2s",
  "_version": 0,
  "_seq_no": 0,
  "_primary_term": 0
}
```

### Stop Historical Analysis

Stops a running historical analysis task before it completes.

#### Request

```json
POST _anomaly_detection/api/detectors/<DETECTOR_ID>/_stop?historical=true
```

Add the `historical=true` query parameter to stop historical analysis instead of real-time detection.

#### Example Response

```json
{
  "_id": "f9DsTXwB6HknB84SoRTY",
  "_version": 0,
  "_seq_no": 0,
  "_primary_term": 0
}
```

---

## Search Detector Tasks

Searches for detector tasks to retrieve task information, status, and progress. This API is useful for monitoring long-running historical analysis tasks and troubleshooting issues.

### Search for Detector-Level Historical Tasks

The following example finds the latest historical analysis task for a high-cardinality detector:

#### Request

```json
GET _anomaly_detection/api/detectors/tasks/_search
POST _anomaly_detection/api/detectors/tasks/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "detector_id": "Zi5zTXwBwf_U8gjUTfJG"
          }
        },
        {
          "term": {
            "task_type": "HISTORICAL_HC_DETECTOR"
          }
        },
        {
          "term": {
            "is_latest": "true"
          }
        }
      ]
    }
  }
}
```

Replace `Zi5zTXwBwf_U8gjUTfJG` with your detector ID.

#### Example Response

```json
{
  "took": 1,
  "timed_out": false,
  "_shards": {
    "total": 1,
    "successful": 1,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 1,
      "relation": "eq"
    },
    "max_score": 0,
    "hits": [
      {
        "_index": ".searchguard-ad-state",
        "_id": "fm-RTXwBYwCbWecgB753",
        "_version": 34,
        "_seq_no": 928,
        "_primary_term": 1,
        "_score": 0,
        "_source": {
          "detector_id": "Zi5zTXwBwf_U8gjUTfJG",
          "error": "",
          "detection_date_range": {
            "start_time": 1630794960000,
            "end_time": 1633386960000
          },
          "task_progress": 1,
          "last_update_time": 1633389090738,
          "execution_start_time": 1633388922742,
          "state": "FINISHED",
          "coordinating_node": "2Z4q22BySEyzakYt_A0A2A",
          "task_type": "HISTORICAL_HC_DETECTOR",
          "execution_end_time": 1633389090738,
          "started_by": "admin",
          "init_progress": 0,
          "is_latest": true,
          "detector": {
            "category_field": [
              "error_type"
            ],
            "description": "test",
            "ui_metadata": {
              "features": {
                "test_feature": {
                  "aggregationBy": "sum",
                  "aggregationOf": "value",
                  "featureType": "simple_aggs"
                }
              },
              "filters": []
            },
            "feature_attributes": [
              {
                "feature_id": "ZS5zTXwBwf_U8gjUTfIn",
                "feature_enabled": true,
                "feature_name": "test_feature",
                "aggregation_query": {
                  "test_feature": {
                    "sum": {
                      "field": "value"
                    }
                  }
                }
              }
            ],
            "schema_version": 0,
            "time_field": "timestamp",
            "last_update_time": 1633386974533,
            "indices": [
              "server_log"
            ],
            "window_delay": {
              "period": {
                "unit": "Minutes",
                "interval": 1
              }
            },
            "detection_interval": {
              "period": {
                "unit": "Minutes",
                "interval": 5
              }
            },
            "name": "testhc",
            "filter_query": {
              "match_all": {
                "boost": 1
              }
            },
            "shingle_size": 8,
            "user": {
              "backend_roles": [
                "admin"
              ],
              "custom_attribute_names": [],
              "roles": [
                "own_index",
                "all_access"
              ],
              "name": "admin",
              "user_requested_tenant": "__user__"
            },
            "detector_type": "MULTI_ENTITY"
          },
          "user": {
            "backend_roles": [
              "admin"
            ],
            "custom_attribute_names": [],
            "roles": [
              "own_index",
              "all_access"
            ],
            "name": "admin",
            "user_requested_tenant": "__user__"
          }
        }
      }
    ]
  }
}
```

The response includes task details such as `state`, `task_progress`, `execution_start_time`, and `execution_end_time`.

### Search for Entity-Level Historical Tasks

For high-cardinality detectors, historical analysis creates separate tasks for each entity. The following example finds the latest entity-level tasks, sorted by most recent execution:

#### Request

```json
GET _anomaly_detection/api/detectors/tasks/_search
POST _anomaly_detection/api/detectors/tasks/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "detector_id": "Zi5zTXwBwf_U8gjUTfJG"
          }
        },
        {
          "term": {
            "task_type": "HISTORICAL_HC_ENTITY"
          }
        },
        {
          "term": {
            "is_latest": "true"
          }
        }
      ]
    }
  },
  "sort": [
    {
      "execution_start_time": {
        "order": "desc"
      }
    }
  ],
  "size": 100
}
```

This request returns up to 100 entity tasks sorted by most recent execution start time.

### Aggregate Task States

To get a summary of task states across all entities, use an aggregation query. This is useful for monitoring the overall progress of a historical analysis job.

**Note:** The `parent_task_id` matches the task ID returned by the profile detector API: `GET _anomaly_detection/api/detectors/<DETECTOR_ID>/_profile/ad_task`.
{: .note }

The following example aggregates states for all entity-level historical tasks:

#### Request

```json
GET _anomaly_detection/api/detectors/tasks/_search
POST _anomaly_detection/api/detectors/tasks/_search
{
  "size": 0,
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "detector_id": {
              "value": "Zi5zTXwBwf_U8gjUTfJG",
              "boost": 1
            }
          }
        },
        {
          "term": {
            "parent_task_id": {
              "value": "fm-RTXwBYwCbWecgB753",
              "boost": 1
            }
          }
        },
        {
          "terms": {
            "task_type": [
              "HISTORICAL_HC_ENTITY"
            ],
            "boost": 1
          }
        }
      ]
    }
  },
  "aggs": {
    "test": {
      "terms": {
        "field": "state",
        "size": 100
      }
    }
  }
}
```

Replace `Zi5zTXwBwf_U8gjUTfJG` with your detector ID and `fm-RTXwBYwCbWecgB753` with your parent task ID.

#### Example Response

```json
{
  "took": 2,
  "timed_out": false,
  "_shards": {
    "total": 1,
    "successful": 1,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 32,
      "relation": "eq"
    },
    "max_score": null,
    "hits": []
  },
  "aggregations": {
    "test": {
      "doc_count_error_upper_bound": 0,
      "sum_other_doc_count": 0,
      "buckets": [
        {
          "key": "FINISHED",
          "doc_count": 32
        }
      ]
    }
  }
}
```

This response shows that all 32 entity tasks finished successfully.

---

## Get Detector Stats

Returns statistics about how the anomaly detection plugin is performing across your cluster. Use this API to monitor resource usage, identify performance issues, and track batch task execution.

### Get All Stats

Returns statistics for all nodes in the cluster, including cluster-level index health and per-node execution metrics.

#### Request

```json
GET _anomaly_detection/api/stats
```

#### Example Response

```json
{
  "anomaly_detectors_index_status": "green",
  "anomaly_detection_state_status": "green",
  "single_entity_detector_count": 2,
  "detector_count": 5,
  "multi_entity_detector_count": 3,
  "anomaly_detection_job_index_status": "green",
  "models_checkpoint_index_status": "green",
  "anomaly_results_index_status": "green",
  "nodes": {
    "2Z4q22BySEyzakYt_A0A2A": {
      "ad_execute_request_count": 95,
      "models": [
        {
          "detector_id": "WTBnTXwBjd8s6RK4b1Sz",
          "model_type": "rcf",
          "last_used_time": 1633398197185,
          "model_id": "WTBnTXwBjd8s6RK4b1Sz_model_rcf_0",
          "last_checkpoint_time": 1633396573679
        }
      ],
      "ad_canceled_batch_task_count": 0,
      "ad_hc_execute_request_count": 75,
      "ad_hc_execute_failure_count": 0,
      "model_count": 28,
      "ad_execute_failure_count": 1,
      "ad_batch_task_failure_count": 0,
      "ad_total_batch_task_execution_count": 27,
      "ad_executing_batch_task_count": 3
    },
    "SWD7ihu9TaaW1zKwFZNVNg": {
      "ad_execute_request_count": 12,
      "models": [
        {
          "detector_id": "Zi5zTXwBwf_U8gjUTfJG",
          "model_type": "entity",
          "last_used_time": 1633398375008,
          "model_id": "Zi5zTXwBwf_U8gjUTfJG_entity_error13",
          "last_checkpoint_time": 1633392973682,
          "entity": [
            {
              "name": "error_type",
              "value": "error13"
            }
          ]
        }
      ],
      "ad_canceled_batch_task_count": 1,
      "ad_hc_execute_request_count": 0,
      "ad_hc_execute_failure_count": 0,
      "model_count": 15,
      "ad_execute_failure_count": 2,
      "ad_batch_task_failure_count": 0,
      "ad_total_batch_task_execution_count": 27,
      "ad_executing_batch_task_count": 4
    },
    "TQDUXEzyTJyV0H6_T4hYUw": {
      "ad_execute_request_count": 0,
      "models": [
        {
          "detector_id": "Zi5zTXwBwf_U8gjUTfJG",
          "model_type": "entity",
          "last_used_time": 1633398375004,
          "model_id": "Zi5zTXwBwf_U8gjUTfJG_entity_error24",
          "last_checkpoint_time": 1633388177359,
          "entity": [
            {
              "name": "error_type",
              "value": "error24"
            }
          ]
        }
      ],
      "ad_canceled_batch_task_count": 0,
      "ad_hc_execute_request_count": 0,
      "ad_hc_execute_failure_count": 0,
      "model_count": 22,
      "ad_execute_failure_count": 0,
      "ad_batch_task_failure_count": 0,
      "ad_total_batch_task_execution_count": 28,
      "ad_executing_batch_task_count": 3
    }
  }
}
```

### Understanding the Response

The response includes cluster-level statistics and per-node metrics.

**Cluster-level statistics** include index health status for anomaly detection indices and detector counts by type.

**Per-node statistics** include the following metrics:

| Metric | Description |
|:--- |:--- |
| `model_count` | Total number of models running in this node's memory. |
| `ad_execute_request_count` | Number of anomaly detection requests executed. |
| `ad_execute_failure_count` | Number of anomaly detection requests that failed. |
| `ad_hc_execute_request_count` | Number of high-cardinality detector requests executed. |
| `ad_hc_execute_failure_count` | Number of high-cardinality detector requests that failed. |
{: .config-table}

**Historical analysis metrics** track batch task execution:

| Metric | Description |
|:--- |:--- |
| `ad_total_batch_task_execution_count` | Total number of historical analysis tasks executed on this node. |
| `ad_executing_batch_task_count` | Number of historical analysis tasks currently running on this node. |
| `ad_canceled_batch_task_count` | Number of historical analysis tasks that were canceled. |
| `ad_batch_task_failure_count` | Number of historical analysis tasks that failed. |
{: .config-table}

If you haven't run any historical analysis, these values show as 0.

### Get Stats for a Specific Node

Returns all statistics for a single node.

#### Request

```json
GET _anomaly_detection/api/<NODE_ID>/stats
```

Replace `<NODE_ID>` with the ID of the node you want to query.

### Get Specific Stats for a Node

Returns a specific statistic for a single node.

#### Request

```json
GET _anomaly_detection/api/<NODE_ID>/stats/<STAT>
```

Replace `<NODE_ID>` with your node ID and `<STAT>` with the statistic name.

The following example retrieves the `ad_execute_request_count` for node `SWD7ihu9TaaW1zKwFZNVNg`:

```json
GET _anomaly_detection/api/SWD7ihu9TaaW1zKwFZNVNg/stats/ad_execute_request_count
```

#### Example Response

```json
{
  "nodes": {
    "SWD7ihu9TaaW1zKwFZNVNg": {
      "ad_execute_request_count": 12
    }
  }
}
```

### Get Specific Stats for All Nodes

Returns a specific statistic across all nodes in the cluster.

#### Request

```json
GET _anomaly_detection/api/stats/<STAT>
```

Replace `<STAT>` with the statistic name you want to retrieve.

The following example retrieves the `ad_executing_batch_task_count` for all nodes:

```json
GET _anomaly_detection/api/stats/ad_executing_batch_task_count
```

#### Example Response

```json
{
  "nodes": {
    "2Z4q22BySEyzakYt_A0A2A": {
      "ad_executing_batch_task_count": 3
    },
    "SWD7ihu9TaaW1zKwFZNVNg": {
      "ad_executing_batch_task_count": 3
    },
    "TQDUXEzyTJyV0H6_T4hYUw": {
      "ad_executing_batch_task_count": 4
    }
  }
}
```

This response shows that each node is running 3–4 historical analysis tasks.
