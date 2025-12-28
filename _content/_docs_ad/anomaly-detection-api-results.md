---
title: Anomaly Detection API - Result Operations
html_title: Anomaly Detection API - Result Operations
permalink: anomaly-detection-api-results
layout: docs
section: anomaly_detection
edition: enterprise
description: API reference for anomaly detection result operations
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

# Anomaly Detection API - Result Operations

{: .no_toc}

{% include toc.md %}

These API operations let you search and manage anomaly detection results. You can query results from real-time detection or historical analysis, find top anomalies across entities, and delete results that are no longer needed.

## Search Detector Results

Use this endpoint to search for anomaly results that match your query criteria.

### Choosing Your Search Scope

You can control which result indices to search by selecting one of three approaches.

**Search only the default result index.** Use this option when you haven't configured any custom result indices:

```
POST _anomaly_detection/api/detectors/results/_search/
```

**Search both default and custom result indices.** Use this option to search across all results regardless of where they're stored:

```
POST _anomaly_detection/api/detectors/results/_search/<CUSTOM_RESULT_INDEX>
```

You can also set the parameter explicitly to `false`:

```
POST _anomaly_detection/api/detectors/results/_search/<CUSTOM_RESULT_INDEX>?only_query_custom_result_index=false
```

**Search only your custom result index.** Use this option when you want results exclusively from your custom index:

```
POST _anomaly_detection/api/detectors/results/_search/<CUSTOM_RESULT_INDEX>?only_query_custom_result_index=true
```

Replace `<CUSTOM_RESULT_INDEX>` with the name of your custom result index.

### Searching Real-Time Detection Results

Real-time detection results are stored without a `task_id` field. To retrieve only real-time results, exclude documents that have a `task_id` by using a `must_not` clause.

The following example searches for anomaly results where the `anomaly_grade` is greater than 0:

#### Request

```json
POST _anomaly_detection/api/detectors/results/_search/searchguard-ad-result-test
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "detector_id": "<DETECTOR_ID>"
          }
        },
        {
          "range": {
            "anomaly_grade": {
              "gt": 0
            }
          }
        }
      ],
      "must_not": [
        {
          "exists": {
            "field": "task_id"
          }
        }
      ]
    }
  }
}
```

Replace `<DETECTOR_ID>` with your detector ID (for example, `EWy02nwBm38sXcF2AiFJ`).

For details about the fields returned in the response, see [Anomaly result mapping](anomaly-detection-result-mapping#response-body-fields).

#### Example Response

```json
{
  "took": 4,
  "timed_out": false,
  "_shards": {
    "total": 3,
    "successful": 3,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 90,
      "relation": "eq"
    },
    "max_score": 0,
    "hits": [
      {
        "_index": ".searchguard-ad-results-history-2021.10.04-1",
        "_id": "686KTXwB6HknB84SMr6G",
        "_version": 1,
        "_seq_no": 103622,
        "_primary_term": 1,
        "_score": 0,
        "_source": {
          "detector_id": "EWy02nwBm38sXcF2AiFJ",
          "confidence": 0.918886275269358,
          "model_id": "EWy02nwBm38sXcF2AiFJ_entity_error16",
          "schema_version": 4,
          "anomaly_score": 1.1093755891885446,
          "execution_start_time": 1633388475001,
          "data_end_time": 1633388414989,
          "data_start_time": 1633388114989,
          "feature_data": [
            {
              "feature_id": "ZS5zTXwBwf_U8gjUTfIn",
              "feature_name": "test_feature",
              "data": 0.532
            }
          ],
          "relevant_attribution": [
            {
              "feature_id": "ZS5zTXwBwf_U8gjUTfIn",
              "data": 1.0
            }
          ],
          "expected_values": [
            {
              "likelihood": 1,
              "value_list": [
                {
                  "feature_id": "ZS5zTXwBwf_U8gjUTfIn",
                  "data": 2
                }
              ]
            }
          ],
          "execution_end_time": 1633388475014,
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
          "anomaly_grade": 0.031023547546561225,
          "entity": [
            {
              "name": "error_type",
              "value": "error16"
            }
          ]
        }
      }
    ]
  }
}
```

This response shows 90 total matching results. Each result includes the anomaly grade, confidence score, feature data, and entity information.

### Searching Historical Analysis Results

You can run historical analysis multiple times on the same detector, which creates multiple tasks. To get results from a specific historical run, first find the task ID you want, then include that `task_id` in your search query.

The following example searches for results with `anomaly_grade` greater than 0 for a specific historical analysis task:

#### Request

```json
POST _anomaly_detection/api/detectors/results/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "detector_id": "<DETECTOR_ID>"
          }
        },
        {
          "range": {
            "anomaly_grade": {
              "gt": 0
            }
          }
        },
        {
          "term": {
            "task_id": "<TASK_ID>"
          }
        }
      ]
    }
  }
}
```

Replace `<DETECTOR_ID>` with your detector ID and `<TASK_ID>` with your task ID.

#### Example Response

```json
{
  "took": 915,
  "timed_out": false,
  "_shards": {
    "total": 3,
    "successful": 3,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 4115,
      "relation": "eq"
    },
    "max_score": 0,
    "hits": [
      {
        "_index": ".searchguard-ad-results-history-2021.10.04-1",
        "_id": "VRyRTXwBDx7vzPBV8jYC",
        "_version": 1,
        "_seq_no": 149657,
        "_primary_term": 1,
        "_score": 0,
        "_source": {
          "detector_id": "Zi5zTXwBwf_U8gjUTfJG",
          "confidence": 0.9642989263957601,
          "task_id": "fm-RTXwBYwCbWecgB753",
          "model_id": "Zi5zTXwBwf_U8gjUTfJG_entity_error24",
          "schema_version": 4,
          "anomaly_score": 1.2260712437521946,
          "execution_start_time": 1633388982692,
          "data_end_time": 1631721300000,
          "data_start_time": 1631721000000,
          "feature_data": [
            {
              "feature_id": "ZS5zTXwBwf_U8gjUTfIn",
              "feature_name": "test_feature",
              "data": 10
            }
          ],
          "execution_end_time": 1633388982709,
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
          "anomaly_grade": 0.14249628345655782,
          "entity": [
            {
              "name": "error_type",
              "value": "error1"
            }
          ]
        }
      }
    ]
  }
}
```

This historical analysis found 4,115 anomaly results with a grade greater than 0.

---

## Search Top Anomalies

This endpoint returns the top anomaly results for a high-cardinality detector, grouped by categorical field values. Use it to identify which entities have the most severe or frequent anomalies.

Set the `historical` parameter to `true` to analyze historical results or `false` for real-time results.

#### Request

```json
GET _anomaly_detection/api/detectors/<DETECTOR_ID>/results/_topAnomalies?historical=false
{
  "size": 3,
  "category_field": [
    "ip"
  ],
  "order": "severity",
  "task_id": "<TASK_ID>",
  "start_time_ms": 123456789000,
  "end_time_ms": 987654321000
}
```

Replace `<DETECTOR_ID>` with your detector ID and `<TASK_ID>` with your task ID (if querying historical results).

#### Example Response

```json
{
  "buckets": [
    {
      "key": {
        "ip": "1.2.3.4"
      },
      "doc_count": 10,
      "max_anomaly_grade": 0.8
    },
    {
      "key": {
        "ip": "5.6.7.8"
      },
      "doc_count": 12,
      "max_anomaly_grade": 0.6
    },
    {
      "key": {
        "ip": "9.10.11.12"
      },
      "doc_count": 3,
      "max_anomaly_grade": 0.5
    }
  ]
}
```

This response shows the top 3 IP addresses ranked by severity. The IP address `1.2.3.4` has the highest maximum anomaly grade at 0.8.

### Request Parameters

| Parameter | Description | Type | Required |
|:--- |:--- |:--- |:--- |
| `size` | Number of top buckets to return. Default is 10. Maximum is 10,000. | integer | No |
| `category_field` | Category fields to aggregate on. Defaults to all category fields configured for the detector. | list | No |
| `order` | Sort results by `severity` (anomaly grade) or `occurrence` (number of anomalies). Default is `severity`. | string | No |
| `task_id` | Historical task ID for viewing results from a specific task. Only applies when `historical=true`. | string | No |
| `start_time_ms` | Start of the time range to analyze, in epoch milliseconds. | long | Yes |
| `end_time_ms` | End of the time range to analyze, in epoch milliseconds. | long | Yes |
{: .config-table}

---

## Delete Detector Results

Use this endpoint to delete anomaly results based on a query.

**Note:** This API only deletes documents from the default result index. To delete results stored in custom result indices, you need to delete those documents manually.
{: .note}

#### Request

The following example deletes results for a specific detector and task where the `data_start_time` is before a given timestamp:

```json
DELETE _anomaly_detection/api/detectors/results
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "detector_id": {
              "value": "<DETECTOR_ID>"
            }
          }
        },
        {
          "term": {
            "task_id": {
              "value": "<TASK_ID>"
            }
          }
        },
        {
          "range": {
            "data_start_time": {
              "lte": 1632441600000
            }
          }
        }
      ]
    }
  }
}
```

Replace `<DETECTOR_ID>` with your detector ID and `<TASK_ID>` with your task ID.

#### Example Response

```json
{
  "took": 48,
  "timed_out": false,
  "total": 28,
  "updated": 0,
  "created": 0,
  "deleted": 28,
  "batches": 1,
  "version_conflicts": 0,
  "noops": 0,
  "retries": {
    "bulk": 0,
    "search": 0
  },
  "throttled_millis": 0,
  "requests_per_second": -1,
  "throttled_until_millis": 0,
  "failures": []
}
```

The `deleted` field shows that 28 anomaly result documents were removed successfully.

---