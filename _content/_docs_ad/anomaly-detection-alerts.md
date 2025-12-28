---
title: Alerts and Integration
html_title: Alerts and Integration
permalink: anomaly-detection-alerts
layout: docs
section: anomaly_detection
edition: enterprise
description: Set up alerts for anomaly detection
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

# Alerts and Integration

{: .no_toc}

{% include toc.md %}

Set up alerts to get notified when anomalies are detected. Alerting enables immediate response to potential issues, ensuring your team can act before problems escalate.

## Integrate with Signals Alerting

Pair the Anomaly Detection plugin with [Signals Alerting](elasticsearch-alerting-getting-started) to receive notifications as soon as an anomaly occurs. Signals provides a powerful alerting framework that lets you monitor anomaly detection results, send notifications through multiple channels, trigger automated responses, and escalate based on severity.

Signals supports multiple notification channels including email, Slack, webhooks, PagerDuty, and more. Each channel helps you reach the right people at the right time.

## Set Up Alerts

Follow these steps to configure alerts for your anomaly detector.

### Identify Your Detector

Start by gathering the information you need. Note the detector ID from the detector details page, then identify which anomaly fields you want to monitor.

The following table describes the key fields available for monitoring:

Field | Description
:--- | :---
`anomaly_grade` | Severity of the anomaly on a 0–1 scale. Higher values indicate more severe anomalies.
`confidence` | Confidence level of the detection. Higher values mean the model is more certain about its assessment.
`feature_data` | Actual feature values. Use this to see what values triggered the anomaly.
`anomaly_score` | Raw anomaly score before normalization.
{: .config-table}

### Create a Watch

Create a watch that queries the anomaly detection results index. See [Signals Alerting](elasticsearch-alerting-getting-started) for detailed instructions on creating watches.

The following example shows a watch that triggers when `anomaly_grade` exceeds 0.7:

```json
{
  "search": {
    "request": {
      "indices": [".searchguard-ad-results*"],
      "body": {
        "query": {
          "bool": {
            "filter": [
              {
                "term": {
                  "detector_id": "<YOUR_DETECTOR_ID>"
                }
              },
              {
                "range": {
                  "anomaly_grade": {
                    "gt": 0.7
                  }
                }
              },
              {
                "range": {
                  "data_end_time": {
                    "gte": "now-10m"
                  }
                }
              }
            ]
          }
        }
      }
    }
  }
}
```

Replace `<YOUR_DETECTOR_ID>` with your actual detector ID. This watch checks for anomalies that occurred in the last 10 minutes.

### Configure Actions

Define what happens when the watch finds an anomaly. You can configure email notifications to send alerts to your team with anomaly details in the message body. Slack messages can post to a channel and tag relevant team members for urgent anomalies. Webhook calls can trigger automated remediation by kicking off scripts or automation tools. Index actions can log alerts to an index for tracking, letting you build dashboards from alert history.

Choose actions that match your team's workflow and escalation procedures.

### Set Alert Frequency

Configure how often the watch checks for anomalies. Match or slightly exceed your detector interval—if your detector runs every 5 minutes, check every 5–10 minutes. Avoid checking too frequently, as this reduces system load and prevents duplicate alerts.

## Follow Best Practices

Apply these practices to create effective alerts that inform without overwhelming your team.

### Choose the Right Thresholds

Start conservative by beginning with higher `anomaly_grade` thresholds like 0.7–0.9. This prevents alert fatigue while you learn what's normal for your environment.

Tune over time by adjusting based on false positive and negative rates. Lower the threshold if you miss real problems, or raise it if you receive too many false alarms.

Consider adding a minimum `confidence` threshold to reduce noise. Only alert when the model is confident about its detection. You can also use feature-specific thresholds to alert on specific features rather than all anomalies, targeting the metrics that matter most to your operations.

### Prevent Alert Fatigue

Too many alerts overwhelm your team and lead to ignored notifications. Set appropriate thresholds to alert only on significant anomalies—minor anomalies can be logged for later review instead.

Use time windows to aggregate anomalies over a period before alerting. Three anomalies in 15 minutes might warrant an alert, while a single anomaly might not. Implement escalation by starting with low-priority notifications and escalating to pages if anomalies persist.

For high-cardinality detectors, group related anomalies by entity rather than sending separate alerts for each IP address or user.

### Example: Conservative Configuration

The following query configuration triggers only for significant anomalies where both the `anomaly_grade` and `confidence` are high:

```json
{
  "bool": {
    "filter": [
      {
        "range": {
          "anomaly_grade": {
            "gte": 0.8
          }
        }
      },
      {
        "range": {
          "confidence": {
            "gte": 0.9
          }
        }
      }
    ]
  }
}
```

This watch triggers only when `anomaly_grade` is at least 0.8 and model `confidence` is at least 0.9, which reduces false positives significantly.

## Monitor Multiple Detectors

For environments with multiple detectors, you can choose between two approaches.

### Option 1: Separate Watches

Create one watch per detector. This approach lets you set specific thresholds for each detector, giving you fine-grained control. Different detectors can have different alert thresholds based on their criticality. The drawback is more watches to manage and more configuration to maintain.

### Option 2: Single Watch

Monitor all detectors with one watch using a general threshold. This approach offers simpler management with one configuration to maintain. The drawback is less flexibility—all detectors use the same threshold.

The following example monitors any detector with high-severity anomalies:

```json
{
  "search": {
    "request": {
      "indices": [".searchguard-ad-results*"],
      "body": {
        "query": {
          "range": {
            "anomaly_grade": {
              "gt": 0.8
            }
          }
        }
      }
    }
  }
}
```

Omitting the `detector_id` filter means the watch checks all detectors.

### Tag Your Watches

Use watch metadata to organize and filter alerts. Add tags like `detector_type`, `severity`, or `team` to help you manage many watches and route alerts to the correct recipients.

## Use Custom Result Indices

If you configured custom result indices, update your watches accordingly:

1. Change the index pattern in your watch query.
2. Use your custom index name instead of `.searchguard-ad-results*`.
3. Ensure your watch has appropriate permissions to access the custom index.

For example, use `["searchguard-ad-result-my-custom-index*"]` as the index pattern.

## Clean Up Watches

If you stop or delete a detector, remember to delete associated watches. Orphaned watches continue to run, generating errors and creating unnecessary system load.
{: .note}

To clean up:

1. Identify watches associated with the detector.
2. Delete or disable the watches using the Signals API.
3. Verify watches are removed from the watch list.

Keeping your watch list clean improves system performance and reduces confusion.

## Advanced Alert Scenarios

These scenarios address specialized alerting needs for more complex environments.

### Entity-Specific Alerts

For detectors with category fields, you can create alerts for specific entities. The following example monitors a specific IP address:

```json
{
  "bool": {
    "filter": [
      {
        "term": {
          "entity.name": "ip"
        }
      },
      {
        "term": {
          "entity.value": "<IP_ADDRESS>"
        }
      },
      {
        "range": {
          "anomaly_grade": {
            "gt": 0.7
          }
        }
      }
    ]
  }
}
```

Replace `<IP_ADDRESS>` with the IP address you want to monitor, such as `192.168.1.100`.

### Time-Based Alert Suppression

Suppress alerts during maintenance windows or known anomaly periods to prevent false alarms during expected changes. You can use time-based conditions by adding time range filters to your watch query. You can also temporarily disable watches during planned maintenance, or filter out specific time ranges in the watch query itself.

### Severity-Based Routing

Route alerts based on anomaly severity, since different severity levels warrant different responses. For high severity anomalies (`anomaly_grade` ≥ 0.9), page the on-call engineer for immediate action. For medium severity (0.7–0.9), send a Slack notification for team awareness. For low severity (< 0.7), log to an index only and review during business hours.

To implement this pattern, create multiple watches with different actions for each severity level.

## Next Steps

Now that you've learned how to set up alerts for anomaly detection, explore these related topics:

- [Learn more about Signals Alerting](elasticsearch-alerting-getting-started) to explore advanced alerting features.
- [Explore API options](anomaly-detection-api-results) for programmatic result access.
- [Review result mappings](anomaly-detection-result-mapping) to understand all available fields for alerting.