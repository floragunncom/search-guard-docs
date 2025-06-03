---
title: Anomaly Detection result mapping
html_title: Anomaly Detection result mapping
permalink: anomaly-detection-result-mapping
layout: docs
edition: enterprise
description: Anomaly Detection result mapping
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


# SearchGuard Anomaly Detection result mapping

{: .no_toc}

{% include toc.md %}

When you select the **Enable custom result index** box on the **Custom result index** pane, the Anomaly Detection plugin will save the results to an index of your choosing. When the anomaly detector does not detect an anomaly, the result format is as follows:

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

## Response body fields

Field | Description
:--- | :---
`detector_id` | A unique ID for identifying a detector.
`schema_version` | The mapping version of the result index.
`data_start_time` | The start of the detection range of the aggregated data.
`data_end_time` | The end of the detection range of the aggregated data.
`feature_data` | An array of the aggregated data points between the `data_start_time` and `data_end_time`.
`execution_start_time` | The actual start time of the detector for a specific run that produces the anomaly result. This start time includes the window delay parameter that you can set to delay data collection. Window delay is the difference between the `execution_start_time` and `data_start_time`.
`execution_end_time` | The actual end time of the detector for a specific run that produces the anomaly result.
`anomaly_score` | Indicates relative severity of an anomaly. The higher the score, the more anomalous a data point is.
`anomaly_grade` | A normalized version of the `anomaly_score` on a scale between 0 and 1.
`confidence` | The probability of the accuracy of the `anomaly_score`. The closer this number is to 1, the higher the accuracy. During the probation period of a running detector, the confidence is low (< 0.9) because of its exposure to limited data.
`entity` | An entity is a combination of specific category fields’ values. It includes the name and value of the category field. In the previous example, `process_name` is the category field and one of the processes such as `process_3` is the field's value. The `entity` field is only present for a high-cardinality detector (where you've selected a category field).
`model_id` | A unique ID that identifies a model. If a detector is a single-stream detector (with no category field), it has only one model. If a detector is a high-cardinality detector (with one or more category fields), it might have multiple models, one for each entity.
`threshold` | One of the criteria for a detector to classify a data point as an anomaly is that its `anomaly_score` must surpass a dynamic threshold. This field records the current threshold.

When the imputation option is enabled, the anomaly results include a `feature_imputed` array showing which features were modified due to missing data. If no features were imputed, then this is excluded.

In the following example anomaly result output, the `processing_bytes_max` feature was imputed, as shown by the `imputed: true` status:

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

When an anomaly is detected, the result is provided in the following format:

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

Note that the result includes the following additional field.

Field | Description
:--- | :---
`relevant_attribution` | Represents the contribution of each input variable. The sum of the attributions is normalized to 1.
`expected_values` | The expected value for each feature.

The detector may be late in detecting an anomaly. For example: The detector observes a sequence of data that alternates between "slow weeks" (represented by the triples {1, 2, 3}) and "busy weeks" (represented by the triples {2, 4, 5}). If the detector comes across a pattern {2, 2, X}, where it has not yet seen the value that X will take, then the detector infers that the pattern is anomalous. However, it cannot determine which 2 is the cause. If X = 3, then the first 2 is the anomaly. If X = 5, then the second 2 is the anomaly. If it is the first 2, then the detector will be late in detecting the anomaly.

When a detector is late in detecting an anomaly, the result includes the following additional fields.

Field | Description
:--- | :---
`past_values` | The actual input that triggered an anomaly. If `past_values` is `null`, then the attributions or expected values are from the current input. If `past_values` is not `null`, then the attributions or expected values are from a past input (for example, the previous two steps of the data [1,2,3]).
`approx_anomaly_start_time` | The approximate time of the actual input that triggered an anomaly. This field helps you understand the time at which a detector flags an anomaly. Both single-stream and high-cardinality detectors do not query previous anomaly results because these queries are costly operations. The cost is especially high for high-cardinality detectors that may have many entities. If the data is not continuous, then the accuracy of this field is low and the actual time at which the detector detects an anomaly can be earlier.

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

{% comment %}
## Flattened anomaly result mapping

When selecting the **Enable flattened custom result index** option in the **Custom result index** pane, the Anomaly Detection plugin saves the results with all of the nested fields flattened in the index.

The nested fields stored in the index use the following flattening rules.

Field | Flattening rule | Example nested input | Example flattened output
:--- | :--- | :--- | :---
`relevant_attribution` | `relevant_attribution_$FEATURE_NAME_data: $RELEVANT_ATTRIBUTION_FEATURE_DATA` | `relevant_attribution : [{"feature_id": "deny_max1", "data": 0.07339452532666227}]` | `relevant_attribution_deny_max1_data: 0.07339452532666227`
`past_values` | `past_values_$FEATURE_NAME_data: $PAST_VALUES_FEATURE_DATA`  | `"past_values": [{"feature_id": "processing_bytes_max", "data": 905}]`                                           | `past_values_processing_bytes_max_data: 905`
`feature_data` | `feature_data_$FEATURE_NAME_data: $FEATURE_DATA_FEATURE_NAME_DATA` | `"feature_data": [{"feature_id": "processing_bytes_max", "feature_name": "processing bytes max", "data": 1360}]` | `feature_data_processing_bytes_max_data: 1360`
`expected_values` | `expected_values_$FEATURE_NAME_data: $EXPECTED_VALUES_FEATURE_DATA`  | `"expected_values": [{"likelihood": 1, "value_list": [{"feature_id": "processing_bytes_max", "data": 905}]}]`    | `expected_values_processing_bytes_max_data: 905` 
`entity` | `entity_$NAME_value: $ENTITY_VALUE ` | `"entity": [{"name": "process_name", "value": "process_3"}]` | `entity_process_name_value: process_3 `

For example, when a detector is late in detecting an anomaly, the flattened result appears in the following format:

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
  "relevant_attribution_deny_max1_data": 0.07339452532666227,
  "relevant_attribution_deny_avg_data": 0.04934972719948845,
  "relevant_attribution_deny_min_data": 0.01803003656061806,
  "relevant_attribution_deny_sum_data": 0.14804918212089874,
  "relevant_attribution_deny_max5_data": 0.7111765287923325,
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
  "past_values_processing_bytes_max_data": 905,
  "past_values_processing_bytes_avg_data": 479,
  "past_values_processing_bytes_min_data": 128,
  "past_values_processing_bytes_sum_data": 1437,
  "past_values_processing_bytes_max_data": 8440,
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
  "feature_data_processing_bytes_max_data": 1360,
  "feature_data_processing_bytes_avg_data": 990,
  "feature_data_processing_bytes_min_data": 608,
  "feature_data_processing_bytes_sum_data": 2970,
  "feature_data_processing_time_max_data": 9670,
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
  "expected_values_processing_bytes_max_data": 905,
  "expected_values_processing_bytes_avg_data": 479,
  "expected_values_processing_bytes_min_data": 128,
  "expected_values_processing_bytes_sum_data": 4847,
  "expected_values_processing_time_max_data": 15713,
  "execution_end_time": 1635898427895,
  "anomaly_grade": 0.5514172746375128,
  "entity": [
    {
      "name": "process_name",
      "value": "process_3"
    }
  ],
  "entity_process_name_value": "process_3",
  "approx_anomaly_start_time": 1635883620000
}
```
{% endcomment %}