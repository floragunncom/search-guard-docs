---
title: Anomaly Detection API - Detector Operations
html_title: Anomaly Detection API - Detector Operations
permalink: anomaly-detection-api-detectors
layout: docs
section: anomaly_detection
edition: enterprise
description: API reference for anomaly detector operations
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

# Anomaly Detection API - Detector Operations

{: .no_toc}

{% include toc.md %}

Use these API operations to create and manage anomaly detectors programmatically.

## Create Anomaly Detector

Creates an anomaly detector.

The following example creates a single-entity detector named `test-detector`. This detector identifies anomalies based on the sum of the `value` field and stores results in a custom index called `searchguard-ad-result-test`.

#### Request

```json
POST _anomaly_detection/api/detectors
{
  "name": "test-detector",
  "description": "Test detector",
  "time_field": "timestamp",
  "indices": [
    "server_log*"
  ],
  "feature_attributes": [
    {
      "feature_name": "test",
      "feature_enabled": true,
      "aggregation_query": {
        "test": {
          "sum": {
            "field": "value"
          }
        }
      }
    }
  ],
  "filter_query": {
    "bool": {
      "filter": [
        {
          "range": {
            "value": {
              "gt": 1
            }
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  },
  "detection_interval": {
    "period": {
      "interval": 1,
      "unit": "Minutes"
    }
  },
  "window_delay": {
    "period": {
      "interval": 1,
      "unit": "Minutes"
    }
  },
  "result_index" : "searchguard-ad-result-test"
}
```

#### Example Response

```json
{
  "_id": "VEHKTXwBwf_U8gjUXY2s",
  "_version": 1,
  "_seq_no": 5,
  "anomaly_detector": {
    "name": "test-detector",
    "description": "Test detector",
    "time_field": "timestamp",
    "indices": [
      "server_log*"
    ],
    "filter_query": {
      "bool": {
        "filter": [
          {
            "range": {
              "value": {
                "from": 1,
                "to": null,
                "include_lower": false,
                "include_upper": true,
                "boost": 1
              }
            }
          }
        ],
        "adjust_pure_negative": true,
        "boost": 1
      }
    },
    "detection_interval": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "window_delay": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "shingle_size": 8,
    "schema_version": 0,
    "feature_attributes": [
      {
        "feature_id": "U0HKTXwBwf_U8gjUXY2m",
        "feature_name": "test",
        "feature_enabled": true,
        "aggregation_query": {
          "test": {
            "sum": {
              "field": "value"
            }
          }
        }
      }
    ],
    "last_update_time": 1633392680364,
    "user": {
      "name": "admin",
      "backend_roles": [
        "admin"
      ],
      "roles": [
        "own_index",
        "all_access"
      ],
      "custom_attribute_names": [],
      "user_requested_tenant": "__user__"
    },
    "detector_type": "SINGLE_ENTITY"
  },
  "_primary_term": 1
}
```

### Creating a High-Cardinality Detector

To create a high-cardinality detector that groups anomalies by a specific field, include the `category_field` parameter. The following example creates a detector that tracks anomalies separately for each unique IP address.

#### Request

```json
POST _anomaly_detection/api/detectors
{
  "name": "test-hc-detector",
  "description": "Test detector",
  "time_field": "timestamp",
  "indices": [
    "server_log*"
  ],
  "feature_attributes": [
    {
      "feature_name": "test",
      "feature_enabled": true,
      "aggregation_query": {
        "test": {
          "sum": {
            "field": "value"
          }
        }
      }
    }
  ],
  "filter_query": {
    "bool": {
      "filter": [
        {
          "range": {
            "value": {
              "gt": 1
            }
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  },
  "detection_interval": {
    "period": {
      "interval": 1,
      "unit": "Minutes"
    }
  },
  "window_delay": {
    "period": {
      "interval": 1,
      "unit": "Minutes"
    }
  },
  "category_field": [
    "ip"
  ]
}
```

#### Example Response

```json
{
  "_id": "b0HRTXwBwf_U8gjUw43R",
  "_version": 1,
  "_seq_no": 6,
  "anomaly_detector": {
    "name": "test-hc-detector",
    "description": "Test detector",
    "time_field": "timestamp",
    "indices": [
      "server_log*"
    ],
    "filter_query": {
      "bool": {
        "filter": [
          {
            "range": {
              "value": {
                "from": 1,
                "to": null,
                "include_lower": false,
                "include_upper": true,
                "boost": 1
              }
            }
          }
        ],
        "adjust_pure_negative": true,
        "boost": 1
      }
    },
    "detection_interval": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "window_delay": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "shingle_size": 8,
    "schema_version": 0,
    "feature_attributes": [
      {
        "feature_id": "bkHRTXwBwf_U8gjUw43K",
        "feature_name": "test",
        "feature_enabled": true,
        "aggregation_query": {
          "test": {
            "sum": {
              "field": "value"
            }
          }
        }
      }
    ],
    "last_update_time": 1633393165265,
    "category_field": [
      "ip"
    ],
    "user": {
      "name": "admin",
      "backend_roles": [
        "admin"
      ],
      "roles": [
        "own_index",
        "all_access"
      ],
      "custom_attribute_names": [],
      "user_requested_tenant": "__user__"
    },
    "detector_type": "MULTI_ENTITY"
  },
  "_primary_term": 1
}
```

You can specify up to two category fields. A single category field groups data by one dimension (such as IP address), while two category fields allow grouping by multiple dimensions (such as IP address and error type).

**Single category field:**

```json
"category_field": [
  "ip"
]
```

**Two category fields:**

```json
"category_field": [
  "ip", "error_type"
]
```

### Request Parameters

The following table describes the parameters for creating an anomaly detector.

| Parameter | Description | Type | Required |
|:--- |:--- |:--- |:--- |
| `name` | A unique name for the detector. | `string` | Yes |
| `description` | A description of what the detector monitors. | `string` | No |
| `time_field` | The timestamp field in your data source. | `string` | Yes |
| `indices` | The indices to use as the data source. Supports wildcards. | `list` | Yes |
| `feature_attributes` | The features to monitor. Each feature needs a `feature_name`, `enabled` set to `true`, and an aggregation query. | `list` | Yes |
| `filter_query` | An optional query to filter the data before analysis. | `object` | No |
| `detection_interval` | How often the detector runs. | `object` | Yes |
| `window_delay` | Extra processing time for delayed data ingestion. | `object` | No |
| `category_field` | Fields to group data by, similar to SQL `GROUP BY`. Supports up to two fields. | `list` | No |
{: .config-table}

---

## Validate Detector

Checks whether a detector configuration has issues that might prevent Search Guard from creating it. Use this API to identify problems before creating a detector.

The request body follows the same format as the [Create Detector API](#create-anomaly-detector).

### Validation Options

You can validate at two levels:

**Configuration validation** checks for issues that would block detector creation entirely:

```
POST _anomaly_detection/api/detectors/_validate
POST _anomaly_detection/api/detectors/_validate/detector
```

**Model validation** checks whether the detector is likely to complete training successfully:

```
POST _anomaly_detection/api/detectors/_validate/model
```

The API returns blocking issues or suggestions for improving model training success. Model-related issues won't prevent detector creation, but addressing them increases the likelihood of successful training.

### Configuration Validation Example

The following request validates a detector configuration:

#### Request

```json
POST _anomaly_detection/api/detectors/_validate
{
  "name": "test-detector",
  "description": "Test detector",
  "time_field": "timestamp",
  "indices": [
    "server_log*"
  ],
  "feature_attributes": [
    {
      "feature_name": "test",
      "feature_enabled": true,
      "aggregation_query": {
        "test": {
          "sum": {
            "field": "value"
          }
        }
      }
    }
  ],
  "filter_query": {
    "bool": {
      "filter": [
        {
          "range": {
            "value": {
              "gt": 1
            }
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  },
  "detection_interval": {
    "period": {
      "interval": 1,
      "unit": "Minutes"
    }
  },
  "window_delay": {
    "period": {
      "interval": 1,
      "unit": "Minutes"
    }
  }
}
```

If validation passes with no issues, the API returns an empty response:

#### Example Response

```json
{}
```

If the API finds an issue, it returns a message explaining the problem. The following example shows what happens when a feature query references a field that doesn't exist in the data source:

#### Example Response

```json
{
  "detector": {
    "feature_attributes": {
      "message": "Feature has invalid query returning empty aggregated data: average_total_rev",
      "sub_issues": {
        "average_total_rev": "Feature has invalid query returning empty aggregated data"
      }
    }
  }
}
```

### Model Validation Example

The following request validates whether the detector configuration will train successfully. In this example, data arrives every 5 minutes, but the detector interval is set to 1 minute—a potential mismatch.

#### Request

```json
POST _anomaly_detection/api/detectors/_validate/model
{
  "name": "test-detector",
  "description": "Test detector",
  "time_field": "timestamp",
  "indices": [
    "server_log*"
  ],
  "feature_attributes": [
    {
      "feature_name": "test",
      "feature_enabled": true,
      "aggregation_query": {
        "test": {
          "sum": {
            "field": "value"
          }
        }
      }
    }
  ],
  "filter_query": {
    "bool": {
      "filter": [
        {
          "range": {
            "value": {
              "gt": 1
            }
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  },
  "detection_interval": {
    "period": {
      "interval": 1,
      "unit": "Minutes"
    }
  },
  "window_delay": {
    "period": {
      "interval": 1,
      "unit": "Minutes"
    }
  }
}
```

If the API finds potential issues, it returns suggestions for improving model training. The following example suggests increasing the detector interval to at least 4 minutes:

#### Example Response

```json
{
  "model": {
    "detection_interval": {
      "message": "The selected detector interval might collect sparse data. Consider changing interval length to: 4",
      "suggested_value": {
        "period": {
          "interval": 4,
          "unit": "Minutes"
        }
      }
    }
  }
}
```

Another common response suggests adjusting the `filter_query` because the filtered data is too sparse for effective model training:

```json
{
  "model": {
    "filter_query": {
      "message": "Data is too sparse after data filter is applied. Consider changing the data filter"
    }
  }
}
```

---

## Get Detector

Retrieves all information about a detector.

#### Request

```json
GET _anomaly_detection/api/detectors/<DETECTOR_ID>
```

Replace `<DETECTOR_ID>` with the ID of the detector you want to retrieve.

#### Example Response

```json
{
  "_id": "VEHKTXwBwf_U8gjUXY2s",
  "_version": 1,
  "_primary_term": 1,
  "_seq_no": 5,
  "anomaly_detector": {
    "name": "test-detector",
    "description": "Test detector",
    "time_field": "timestamp",
    "indices": [
      "server_log*"
    ],
    "filter_query": {
      "bool": {
        "filter": [
          {
            "range": {
              "value": {
                "from": 1,
                "to": null,
                "include_lower": false,
                "include_upper": true,
                "boost": 1
              }
            }
          }
        ],
        "adjust_pure_negative": true,
        "boost": 1
      }
    },
    "detection_interval": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "window_delay": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "shingle_size": 8,
    "schema_version": 0,
    "feature_attributes": [
      {
        "feature_id": "U0HKTXwBwf_U8gjUXY2m",
        "feature_name": "test",
        "feature_enabled": true,
        "aggregation_query": {
          "test": {
            "sum": {
              "field": "value"
            }
          }
        }
      }
    ],
    "last_update_time": 1633392680364,
    "user": {
      "name": "admin",
      "backend_roles": [
        "admin"
      ],
      "roles": [
        "own_index",
        "all_access"
      ],
      "custom_attribute_names": [],
      "user_requested_tenant": "__user__"
    },
    "detector_type": "SINGLE_ENTITY"
  }
}
```

### Understanding Jobs and Tasks

A *job* runs periodically for real-time anomaly detection. Jobs don't apply to one-time historical analysis.

When you start a real-time detector, the plugin creates a job (or updates an existing one). Each time you start or restart a real-time detector, the plugin also creates a new *real-time task* that records runtime information such as the detector configuration snapshot, job states (initializing, running, or stopped), and initialization progress.

A single detector can have only one real-time job (the job ID matches the detector ID), but it can have multiple real-time tasks because each restart creates a new task. You can limit the number of stored real-time tasks using the `anomaly_detection.max_old_ad_task_docs_per_detector` setting.

Historical analysis doesn't use jobs. When you start or rerun historical analysis, the plugin creates a new *historical batch task* that tracks runtime information like state, coordinating node, worker node, and task progress. You can limit historical task storage with the same `anomaly_detection.max_old_ad_task_docs_per_detector` setting.

### Getting Real-Time Job Information

Add `job=true` to retrieve real-time analysis task information:

#### Request

```json
GET _anomaly_detection/api/detectors/<DETECTOR_ID>?job=true
```

#### Example Response

```json
{
  "_id": "VEHKTXwBwf_U8gjUXY2s",
  "_version": 1,
  "_primary_term": 1,
  "_seq_no": 5,
  "anomaly_detector": {
    "name": "test-detector",
    "description": "Test detector",
    "time_field": "timestamp",
    "indices": [
      "server_log*"
    ],
    "filter_query": {
      "bool": {
        "filter": [
          {
            "range": {
              "value": {
                "from": 1,
                "to": null,
                "include_lower": false,
                "include_upper": true,
                "boost": 1
              }
            }
          }
        ],
        "adjust_pure_negative": true,
        "boost": 1
      }
    },
    "detection_interval": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "window_delay": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "shingle_size": 8,
    "schema_version": 0,
    "feature_attributes": [
      {
        "feature_id": "U0HKTXwBwf_U8gjUXY2m",
        "feature_name": "test",
        "feature_enabled": true,
        "aggregation_query": {
          "test": {
            "sum": {
              "field": "value"
            }
          }
        }
      }
    ],
    "last_update_time": 1633392680364,
    "user": {
      "name": "admin",
      "backend_roles": [
        "admin"
      ],
      "roles": [
        "own_index",
        "all_access"
      ],
      "custom_attribute_names": [],
      "user_requested_tenant": "__user__"
    },
    "detector_type": "SINGLE_ENTITY"
  },
  "anomaly_detector_job": {
    "name": "VEHKTXwBwf_U8gjUXY2s",
    "schedule": {
      "interval": {
        "start_time": 1633393656357,
        "period": 1,
        "unit": "Minutes"
      }
    },
    "window_delay": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "enabled": true,
    "enabled_time": 1633393656357,
    "last_update_time": 1633393656357,
    "lock_duration_seconds": 60,
    "user": {
      "name": "admin",
      "backend_roles": [
        "admin"
      ],
      "roles": [
        "own_index",
        "all_access"
      ],
      "custom_attribute_names": [],
      "user_requested_tenant": "__user__"
    }
  }
}
```

### Getting Task Information

Add `task=true` to retrieve information for both real-time and historical analysis tasks:

#### Request

```json
GET _anomaly_detection/api/detectors/<DETECTOR_ID>?task=true
```

The response includes `realtime_detection_task` and `historical_analysis_task` objects with detailed task information.

---

## Update Detector

Updates a detector's configuration, including the description, features, or other settings. Before updating, you must stop both real-time detection and historical analysis.

**Note:** You cannot update the `category_field` parameter after creating a detector.
{: .note }

#### Request

```json
PUT _anomaly_detection/api/detectors/<DETECTOR_ID>
{
  "name": "test-detector",
  "description": "Test update detector",
  "time_field": "timestamp",
  "indices": [
    "server_log*"
  ],
  "feature_attributes": [
    {
      "feature_name": "test",
      "feature_enabled": true,
      "aggregation_query": {
        "test": {
          "sum": {
            "field": "value"
          }
        }
      }
    }
  ],
  "filter_query": {
    "bool": {
      "filter": [
        {
          "range": {
            "value": {
              "gt": 1
            }
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  },
  "detection_interval": {
    "period": {
      "interval": 1,
      "unit": "Minutes"
    }
  },
  "window_delay": {
    "period": {
      "interval": 1,
      "unit": "Minutes"
    }
  }
}
```

Replace `<DETECTOR_ID>` with the ID of the detector you want to update.

#### Example Response

```json
{
  "_id": "VEHKTXwBwf_U8gjUXY2s",
  "_version": 2,
  "_seq_no": 7,
  "anomaly_detector": {
    "name": "test-detector",
    "description": "Test update detector",
    "time_field": "timestamp",
    "indices": [
      "server_log*"
    ],
    "filter_query": {
      "bool": {
        "filter": [
          {
            "range": {
              "value": {
                "from": 1,
                "to": null,
                "include_lower": false,
                "include_upper": true,
                "boost": 1
              }
            }
          }
        ],
        "adjust_pure_negative": true,
        "boost": 1
      }
    },
    "detection_interval": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "window_delay": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "shingle_size": 8,
    "schema_version": 0,
    "feature_attributes": [
      {
        "feature_id": "3kHiTXwBwf_U8gjUlY15",
        "feature_name": "test",
        "feature_enabled": true,
        "aggregation_query": {
          "test": {
            "sum": {
              "field": "value"
            }
          }
        }
      }
    ],
    "last_update_time": 1633394267522,
    "user": {
      "name": "admin",
      "backend_roles": [
        "admin"
      ],
      "roles": [
        "own_index",
        "all_access"
      ],
      "custom_attribute_names": [],
      "user_requested_tenant": "__user__"
    },
    "detector_type": "SINGLE_ENTITY"
  },
  "_primary_term": 1
}
```

---

## Delete Detector

Deletes a detector. Before deleting, you must stop both real-time detection and historical analysis.

#### Request

```json
DELETE _anomaly_detection/api/detectors/<DETECTOR_ID>
```

Replace `<DETECTOR_ID>` with the ID of the detector you want to delete.

#### Example Response

```json
{
  "_index": ".searchguard-ad-anomaly-detectors",
  "_id": "70TxTXwBjd8s6RK4j1Pj",
  "_version": 2,
  "result": "deleted",
  "forced_refresh": true,
  "_shards": {
    "total": 2,
    "successful": 2,
    "failed": 0
  },
  "_seq_no": 9,
  "_primary_term": 1
}
```

---

## Preview Detector

Runs the anomaly detector against a specific date range and returns any anomalies found. Use this API to test a detector configuration before enabling real-time detection.

### Previewing a Single-Entity Detector

The following example previews a detector configuration against historical data:

#### Request

```json
POST _anomaly_detection/api/detectors/_preview
{
  "period_start": 1633048868000,
  "period_end": 1633394468000,
  "detector": {
    "name": "test-detector",
    "description": "Test update detector",
    "time_field": "timestamp",
    "indices": [
      "server_log*"
    ],
    "feature_attributes": [
      {
        "feature_name": "test",
        "feature_enabled": true,
        "aggregation_query": {
          "test": {
            "sum": {
              "field": "value"
            }
          }
        }
      }
    ],
    "filter_query": {
      "bool": {
        "filter": [
          {
            "range": {
              "value": {
                "gt": 1
              }
            }
          }
        ],
        "adjust_pure_negative": true,
        "boost": 1
      }
    },
    "detection_interval": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "window_delay": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    }
  }
}
```

#### Example Response

```json
{
  "anomaly_result": [
    {
      "detector_id": null,
      "data_start_time": 1633049280000,
      "data_end_time": 1633049340000,
      "schema_version": 0,
      "feature_data": [
        {
          "feature_id": "8EHmTXwBwf_U8gjU0Y0u",
          "feature_name": "test",
          "data": 0
        }
      ],
      "anomaly_grade": 0,
      "confidence": 0
    }
  ],
  "anomaly_detector": {
    "name": "test-detector",
    "description": "Test update detector",
    "time_field": "timestamp",
    "indices": [
      "server_log*"
    ],
    "filter_query": {
      "bool": {
        "filter": [
          {
            "range": {
              "value": {
                "from": 1,
                "to": null,
                "include_lower": false,
                "include_upper": true,
                "boost": 1
              }
            }
          }
        ],
        "adjust_pure_negative": true,
        "boost": 1
      }
    },
    "detection_interval": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "window_delay": {
      "period": {
        "interval": 1,
        "unit": "Minutes"
      }
    },
    "shingle_size": 8,
    "schema_version": 0,
    "feature_attributes": [
      {
        "feature_id": "8EHmTXwBwf_U8gjU0Y0u",
        "feature_name": "test",
        "feature_enabled": true,
        "aggregation_query": {
          "test": {
            "sum": {
              "field": "value"
            }
          }
        }
      }
    ],
    "detector_type": "SINGLE_ENTITY"
  }
}
```

### Previewing with Category Fields

If you include a `category_field` in your detector configuration, each result is associated with an entity. The response includes an `entity` array showing the category field values for each anomaly.

### Previewing an Existing Detector

You can preview an existing detector by providing only the detector ID and date range. Use either of these formats:

**Option 1: Detector ID in the request body**

```json
POST _anomaly_detection/api/detectors/_preview
{
  "detector_id": "VEHKTXwBwf_U8gjUXY2s",
  "period_start": 1633048868000,
  "period_end": 1633394468000
}
```

**Option 2: Detector ID in the URL path**

```json
POST _anomaly_detection/api/detectors/VEHKTXwBwf_U8gjUXY2s/_preview
{
  "period_start": 1633048868000,
  "period_end": 1633394468000
}
```

---

## Search Detector

Searches for anomaly detectors that match a query.

The following example finds all detectors that use indices matching `server_log*`:

#### Request

```json
GET _anomaly_detection/api/detectors/_search
POST _anomaly_detection/api/detectors/_search
{
  "query": {
    "wildcard": {
      "indices": {
        "value": "server_log*"
      }
    }
  }
}
```

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
      "value": 4,
      "relation": "eq"
    },
    "max_score": 1,
    "hits": [
      {
        "_index": ".searchguard-ad-anomaly-detectors",
        "_id": "Zi5zTXwBwf_U8gjUTfJG",
        "_version": 1,
        "_seq_no": 1,
        "_primary_term": 1,
        "_score": 1,
        "_source": {
          "name": "test",
          "description": "test",
          "time_field": "timestamp",
          "indices": [
            "server_log"
          ],
          "filter_query": {
            "match_all": {
              "boost": 1
            }
          },
          "detection_interval": {
            "period": {
              "interval": 5,
              "unit": "Minutes"
            }
          },
          "window_delay": {
            "period": {
              "interval": 1,
              "unit": "Minutes"
            }
          },
          "shingle_size": 8,
          "schema_version": 0,
          "feature_attributes": [
            {
              "feature_id": "ZS5zTXwBwf_U8gjUTfIn",
              "feature_name": "test_feature",
              "feature_enabled": true,
              "aggregation_query": {
                "test_feature": {
                  "sum": {
                    "field": "value"
                  }
                }
              }
            }
          ],
          "last_update_time": 1633386974533,
          "category_field": [
            "error_type"
          ],
          "user": {
            "name": "admin",
            "backend_roles": [
              "admin"
            ],
            "roles": [
              "own_index",
              "all_access"
            ],
            "custom_attribute_names": [],
            "user_requested_tenant": "__user__"
          },
          "detector_type": "MULTI_ENTITY"
        }
      }
    ]
  }
}
```

---

## Profile Detector

Returns information about a detector's current state, memory usage, errors, and other runtime details. Use this API to troubleshoot detector issues and monitor resource consumption.

This API helps you identify which nodes run the anomaly detector job, track initialization progress, view required shingles, and estimate time remaining for initialization.

#### Request

```json
GET _anomaly_detection/api/detectors/<DETECTOR_ID>/_profile/
GET _anomaly_detection/api/detectors/<DETECTOR_ID>/_profile?_all=true
GET _anomaly_detection/api/detectors/<DETECTOR_ID>/_profile/<TYPE>
GET _anomaly_detection/api/detectors/<DETECTOR_ID>/_profile/<TYPE1>,<TYPE2>
```

Replace `<DETECTOR_ID>` with your detector's ID and `<TYPE>` with the profile type you want to retrieve.

### Basic Profile

The basic profile returns the detector's current state and any errors:

#### Request

```json
GET _anomaly_detection/api/detectors/<DETECTOR_ID>/_profile
```

#### Example Response

```json
{
  "state": "DISABLED",
  "error": "Stopped detector: AD models memory usage exceeds our limit."
}
```

### Full Profile

Add `?_all=true` to retrieve comprehensive profile information, including model details, memory usage, initialization progress, entity counts, and task information.

**Note:** The full profile request can be resource-intensive for high-cardinality detectors.

The `model_count` parameter shows how many models the detector runs on each node. This helps you estimate memory requirements when running multiple detectors.

For detectors with a `category_field`, the response includes the number of unique values in the field and all active entities with models in memory. You can use this data to determine whether you need to scale your cluster. For example, if a detector has one million entities but only 10 are active in memory, you may need to increase cluster resources.

### Single-Entity Detector Profile

The following example shows the full profile for a single-entity detector:

#### Example Response

```json
{
  "state": "INIT",
  "total_size_in_bytes": 0,
  "init_progress": {
    "percentage": "0%",
    "needed_shingles": 128
  },
  "ad_task": {
    "ad_task": {
      "task_id": "cfUNOXwBFLNqSEcxAlde",
      "last_update_time": 1633044731640,
      "started_by": "admin",
      "state": "RUNNING",
      "detector_id": "qL4NOXwB__6eNorTAKtJ",
      "task_progress": 0.49603173,
      "init_progress": 1,
      "current_piece": 1632739800000,
      "execution_start_time": 1633044726365,
      "is_latest": true,
      "task_type": "HISTORICAL_SINGLE_ENTITY",
      "coordinating_node": "bCtWtxWPThq0BIn5P5I4Xw",
      "worker_node": "dIyavWhmSYWGz65b4u-lpQ",
      "detector": {
        "name": "detector1",
        "description": "test",
        "time_field": "timestamp",
        "indices": [
          "server_log"
        ],
        "filter_query": {
          "match_all": {
            "boost": 1
          }
        },
        "detection_interval": {
          "period": {
            "interval": 5,
            "unit": "Minutes"
          }
        },
        "window_delay": {
          "period": {
            "interval": 1,
            "unit": "Minutes"
          }
        },
        "shingle_size": 8,
        "schema_version": 0,
        "feature_attributes": [
          {
            "feature_id": "p74NOXwB__6eNorTAKss",
            "feature_name": "test-feature",
            "feature_enabled": true,
            "aggregation_query": {
              "test_feature": {
                "sum": {
                  "field": "value"
                }
              }
            }
          }
        ],
        "ui_metadata": {
          "features": {
            "test-feature": {
              "aggregationBy": "sum",
              "aggregationOf": "value",
              "featureType": "simple_aggs"
            }
          },
          "filters": []
        },
        "last_update_time": 1633044725832,
        "user": {
          "name": "admin",
          "backend_roles": [
            "admin"
          ],
          "roles": [
            "own_index",
            "all_access"
          ],
          "custom_attribute_names": [],
          "user_requested_tenant": "__user__"
        },
        "detector_type": "SINGLE_ENTITY"
      },
      "detection_date_range": {
        "start_time": 1632439925885,
        "end_time": 1633044725885
      },
      "user": {
        "name": "admin",
        "backend_roles": [
          "admin"
        ],
        "roles": [
          "own_index",
          "all_access"
        ],
        "custom_attribute_names": [],
        "user_requested_tenant": "__user__"
      }
    },
    "shingle_size": 8,
    "rcf_total_updates": 1994,
    "threshold_model_trained": true,
    "threshold_model_training_data_size": 0,
    "model_size_in_bytes": 1593240,
    "node_id": "dIyavWhmSYWGz65b4u-lpQ",
    "detector_task_slots": 1
  }
}
```

The `ad_task` field appears only for historical analysis.

### Entity Counts

The `total_entities` parameter shows the total number of entities, including the count of category field values.

For real-time detection with more than one category field, counting entities is resource-intensive. By default, the detector counts up to 10,000 entities for real-time detection profiles. For historical analysis, the plugin detects the top 1,000 entities by default and caches them in memory, making entity counting less expensive.

### Entity-Level Profile

The profile API also provides information about individual entities, including `last_sample_timestamp` (when the entity last appeared in the data source) and `last_active_timestamp` (when the entity's model was last used in the model cache).

If an entity has no anomaly results, either the entity has no sample data or cluster resources (such as memory or disk I/O) are constrained relative to the number of entities.

The following example retrieves profile information for a specific entity:

#### Request

```json
GET _anomaly_detection/api/detectors/<DETECTOR_ID>/_profile?_all=true
{
  "entity": [
    {
      "name": "host",
      "value": "i-00f28ec1eb8997686"
    }
  ]
}
```

#### Example Response

```json
{
  "is_active": true,
  "last_active_timestamp": 1604026394879,
  "last_sample_timestamp": 1604026394879,
  "init_progress": {
    "percentage": "100%"
  },
  "model": {
    "model_id": "TFUdd3UBBwIAGQeRh5IS_entity_i-00f28ec1eb8997686",
    "model_size_in_bytes": 712480,
    "node_id": "MQ-bTBW3Q2uU_2zX3pyEQg"
  },
  "state": "RUNNING"
}
```

### Historical Analysis Profile

To retrieve profile information for only historical analysis, specify `ad_task` as the profile type. Using `_all=true` can be resource-intensive for multi-category high-cardinality detectors.

#### Request

```json
GET _anomaly_detection/api/detectors/<DETECTOR_ID>/_profile?_all
GET _anomaly_detection/api/detectors/<DETECTOR_ID>/_profile/ad_task
```

The response includes detailed information about the historical analysis task, including task state, progress, coordinating node, worker node, and entity task profiles.

---