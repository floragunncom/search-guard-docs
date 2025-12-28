---
title: Anomaly Detection Result Mapping
html_title: Anomaly Detection Result Mapping
permalink: anomaly-detection-result-mapping
layout: docs
section: anomaly_detection
edition: enterprise
description: Anomaly Detection result mapping reference
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

# Anomaly Detection Result Mapping

{: .no_toc}

{% include toc.md %}

When you enable custom result indices, the Anomaly Detection plugin saves results to your chosen index. This page explains the structure of those results and what each field means.

## Result Format Without Anomaly

When the detector analyzes data and finds no anomaly, it returns a result similar to the following example:

```json
{
  "detector_id": "kzcZ43wBgEQAbjDnhzGF",
  "schema_version": 5,
  "data_start_time": 1635898161367,
  "data_end_time": 1635898221367,
  "feature_data": [
    {
      "feature_id": "processing_bytes_max",
      "feature_name": "processing bytes max",
      "data": 2322
    },
    {
      "feature_id": "processing_bytes_avg",
      "feature_name": "processing bytes avg",
      "data": 1718.6666666666667
    },
    {
      "feature_id": "processing_bytes_min",
      "feature_name": "processing bytes min",
      "data": 1375
    },
    {
      "feature_id": "processing_bytes_sum",
      "feature_name": "processing bytes sum",
      "data": 5156
    },
    {
      "feature_id": "processing_time_max",
      "feature_name": "processing time max",
      "data": 31198
    }
  ],
  "execution_start_time": 1635898231577,
  "execution_end_time": 1635898231622,
  "anomaly_score": 1.8124904404395776,
  "anomaly_grade": 0,
  "confidence": 0.9802940756605277,
  "entity": [
    {
      "name": "process_name",
      "value": "process_3"
    }
  ],
  "model_id": "kzcZ43wBgEQAbjDnhzGF_entity_process_3",
  "threshold": 1.2368549346675202
}
```

## Response Body Fields

The following table describes each field in the result:

Field | Description
:--- | :---
`detector_id` | A unique identifier for the detector that produced this result.
`schema_version` | The mapping version of the result index.
`data_start_time` | The start of the detection range for aggregated data, in epoch milliseconds.
`data_end_time` | The end of the detection range for aggregated data, in epoch milliseconds.
`feature_data` | An array of aggregated data points collected between `data_start_time` and `data_end_time`.
`execution_start_time` | The actual start time of the detector run that produced this result, in epoch milliseconds. This value includes the window delay parameter. Window delay is the difference between `execution_start_time` and `data_start_time`.
`execution_end_time` | The actual end time of the detector run that produced this result, in epoch milliseconds.
`anomaly_score` | The relative severity of an anomaly. Higher scores indicate more anomalous data points.
`anomaly_grade` | A normalized version of `anomaly_score` on a scale from 0 to 1. A value of `0` means no anomaly was detected.
`confidence` | The probability that `anomaly_score` is accurate. Values closer to 1 indicate higher accuracy. During the probation period (when the detector is still learning), confidence remains low (below 0.9) because the detector has limited data exposure.
`entity` | A combination of category field values, including the name and value of each category field. For example, `process_name` is the category field and `process_3` is one of its values. This field appears only for high-cardinality detectors where you selected a category field.
`model_id` | A unique identifier for a model. Single-stream detectors (without a category field) have one model, while high-cardinality detectors (with category fields) may have multiple models, one for each entity.
`threshold` | The dynamic threshold that `anomaly_score` must exceed for the detector to classify a data point as an anomaly. This field records the current threshold value.
{: .config-table}

## Results With Imputation

When you enable imputation, results include a `feature_imputed` array that shows which features were modified because of missing data. If no features were imputed, the result omits this array.

The following example shows a result where one feature was imputed:

```json
{
    "detector_id": "kzcZ43wBgEQAbjDnhzGF",
    "schema_version": 5,
    "data_start_time": 1635898161367,
    "data_end_time": 1635898221367,
    "feature_data": [
        {
            "feature_id": "processing_bytes_max",
            "feature_name": "processing bytes max",
            "data": 2322
        },
        {
            "feature_id": "processing_bytes_avg",
            "feature_name": "processing bytes avg",
            "data": 1718.6666666666667
        },
        {
            "feature_id": "processing_bytes_min",
            "feature_name": "processing bytes min",
            "data": 1375
        },
        {
            "feature_id": "processing_bytes_sum",
            "feature_name": "processing bytes sum",
            "data": 5156
        },
        {
            "feature_id": "processing_time_max",
            "feature_name": "processing time max",
            "data": 31198
        }
    ],
    "execution_start_time": 1635898231577,
    "execution_end_time": 1635898231622,
    "anomaly_score": 1.8124904404395776,
    "anomaly_grade": 0,
    "confidence": 0.9802940756605277,
    "entity": [
        {
            "name": "process_name",
            "value": "process_3"
        }
    ],
    "model_id": "kzcZ43wBgEQAbjDnhzGF_entity_process_3",
    "threshold": 1.2368549346675202,
    "feature_imputed": [
        {
            "feature_id": "processing_bytes_max",
            "imputed": true
        },
        {
            "feature_id": "processing_bytes_avg",
            "imputed": false
        },
        {
            "feature_id": "processing_bytes_min",
            "imputed": false
        },
        {
            "feature_id": "processing_bytes_sum",
            "imputed": false
        },
        {
            "feature_id": "processing_time_max",
            "imputed": false
        }
    ]
}
```

In this example, the `processing_bytes_max` feature was imputed because of missing data, as indicated by `imputed: true`.

## Result Format With Anomaly Detected

When the detector finds an anomaly, the result includes additional fields that help you understand what triggered the detection. The following example shows a result with an anomaly:

```json
{
  "detector_id": "fylE53wBc9MCt6q12tKp",
  "schema_version": 0,
  "data_start_time": 1635927900000,
  "data_end_time": 1635927960000,
  "feature_data": [
    {
      "feature_id": "processing_bytes_max",
      "feature_name": "processing bytes max",
      "data": 2291
    },
    {
      "feature_id": "processing_bytes_avg",
      "feature_name": "processing bytes avg",
      "data": 1677.3333333333333
    },
    {
      "feature_id": "processing_bytes_min",
      "feature_name": "processing bytes min",
      "data": 1054
    },
    {
      "feature_id": "processing_bytes_sum",
      "feature_name": "processing bytes sum",
      "data": 5032
    },
    {
      "feature_id": "processing_time_max",
      "feature_name": "processing time max",
      "data": 11422
    }
  ],
  "anomaly_score": 1.1986675882872033,
  "anomaly_grade": 0.26806225550178464,
  "confidence": 0.9607519742565531,
  "entity": [
    {
      "name": "process_name",
      "value": "process_3"
    }
  ],
  "approx_anomaly_start_time": 1635927900000,
  "relevant_attribution": [
    {
      "feature_id": "processing_bytes_max",
      "data": 0.03628638020431366
    },
    {
      "feature_id": "processing_bytes_avg",
      "data": 0.03384479053991436
    },
    {
      "feature_id": "processing_bytes_min",
      "data": 0.058812549572819096
    },
    {
      "feature_id": "processing_bytes_sum",
      "data": 0.10154576265526988
    },
    {
      "feature_id": "processing_time_max",
      "data": 0.7695105170276828
    }
  ],
  "expected_values": [
    {
      "likelihood": 1,
      "value_list": [
        {
          "feature_id": "processing_bytes_max",
          "data": 2291
        },
        {
          "feature_id": "processing_bytes_avg",
          "data": 1677.3333333333333
        },
        {
          "feature_id": "processing_bytes_min",
          "data": 1054
        },
        {
          "feature_id": "processing_bytes_sum",
          "data": 6062
        },
        {
          "feature_id": "processing_time_max",
          "data": 23379
        }
      ]
    }
  ],
  "threshold": 1.0993584705913992,
  "execution_end_time": 1635898427895,
  "execution_start_time": 1635898427803
}
```

### Additional Fields for Anomalies

When an anomaly is detected, the result includes the following additional fields:

Field | Description
:--- | :---
`relevant_attribution` | The contribution of each input variable to the anomaly. Values are normalized so they sum to 1. Higher values indicate features that contributed more to flagging this anomaly.
`expected_values` | The expected value for each feature based on the patterns the model has learned.
{: .config-table}

## Late Detection Results

Sometimes a detector is late in detecting an anomaly. This happens when the detector needs additional data points to determine which value caused the anomaly.

Consider the following scenario: the detector observes alternating data patterns across slow weeks with values {1, 2, 3} and busy weeks with values {2, 4, 5}. If the detector sees {2, 2, X} but hasn't yet received the value of X, it knows an anomaly exists but can't pinpoint which `2` is the cause. If X turns out to be 3, the first `2` is anomalous because it should have been `1`. If X turns out to be 5, the second `2` is anomalous because it should have been `4`. The detector needs the complete pattern to identify the exact anomaly point, so detection is delayed.

### Late Detection Fields

When late detection occurs, the result includes these additional fields:

Field | Description
:--- | :---
`past_values` | The actual input that triggered the anomaly. If this field is `null`, the attributions and expected values come from the current input. If this field is not `null`, the attributions and expected values come from past input (for example, two steps earlier in a sequence like [1, 2, 3]).
`approx_anomaly_start_time` | The approximate time of the actual input that triggered the anomaly, in epoch milliseconds. This field helps you understand when the detector flagged the anomaly. Both single-stream and high-cardinality detectors skip querying previous anomaly results because those queries are expensive, especially for high-cardinality detectors with many entities. If data is not continuous, this field may be less accurate. The actual detection time can be earlier than this timestamp.
{: .config-table}

The following example shows a late detection result:

```json
{
  "detector_id": "kzcZ43wBgEQAbjDnhzGF",
  "confidence": 0.9746820962328963,
  "relevant_attribution": [
    {
      "feature_id": "deny_max1",
      "data": 0.07339452532666227
    },
    {
      "feature_id": "deny_avg",
      "data": 0.04934972719948845
    },
    {
      "feature_id": "deny_min",
      "data": 0.01803003656061806
    },
    {
      "feature_id": "deny_sum",
      "data": 0.14804918212089874
    },
    {
      "feature_id": "accept_max5",
      "data": 0.7111765287923325
    }
  ],
  "task_id": "9Dck43wBgEQAbjDn4zEe",
  "threshold": 1,
  "model_id": "kzcZ43wBgEQAbjDnhzGF_entity_app_0",
  "schema_version": 5,
  "anomaly_score": 1.141419389056506,
  "execution_start_time": 1635898427803,
  "past_values": [
    {
      "feature_id": "processing_bytes_max",
      "data": 905
    },
    {
      "feature_id": "processing_bytes_avg",
      "data": 479
    },
    {
      "feature_id": "processing_bytes_min",
      "data": 128
    },
    {
      "feature_id": "processing_bytes_sum",
      "data": 1437
    },
    {
      "feature_id": "processing_time_max",
      "data": 8440
    }
  ],
  "data_end_time": 1635883920000,
  "data_start_time": 1635883860000,
  "feature_data": [
    {
      "feature_id": "processing_bytes_max",
      "feature_name": "processing bytes max",
      "data": 1360
    },
    {
      "feature_id": "processing_bytes_avg",
      "feature_name": "processing bytes avg",
      "data": 990
    },
    {
      "feature_id": "processing_bytes_min",
      "feature_name": "processing bytes min",
      "data": 608
    },
    {
      "feature_id": "processing_bytes_sum",
      "feature_name": "processing bytes sum",
      "data": 2970
    },
    {
      "feature_id": "processing_time_max",
      "feature_name": "processing time max",
      "data": 9670
    }
  ],
  "expected_values": [
    {
      "likelihood": 1,
      "value_list": [
        {
          "feature_id": "processing_bytes_max",
          "data": 905
        },
        {
          "feature_id": "processing_bytes_avg",
          "data": 479
        },
        {
          "feature_id": "processing_bytes_min",
          "data": 128
        },
        {
          "feature_id": "processing_bytes_sum",
          "data": 4847
        },
        {
          "feature_id": "processing_time_max",
          "data": 15713
        }
      ]
    }
  ],
  "execution_end_time": 1635898427895,
  "anomaly_grade": 0.5514172746375128,
  "entity": [
    {
      "name": "process_name",
      "value": "process_3"
    }
  ],
  "approx_anomaly_start_time": 1635883620000
}
```

This result includes `past_values`, which shows the historical data that triggered the anomaly, and `approx_anomaly_start_time`, which indicates when the anomaly actually occurred (earlier than when the detector reported it).