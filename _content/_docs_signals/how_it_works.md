---
title: How Signals Alerting works
html_title: How Signals Alerting works
slug: elasticsearch-alerting-how-it-works
category: signals
order: 200
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# How Signals Alerting works
{: .no_toc}

{% include toc.md %}

Signals can be used to create and execute watches that:

* load data from different sources into a watch execution context
* perform calculations and transformations of the loaded data
* check whether conditions are met based on the loaded data
* execute one or more actions if the condition is met


## Log file analysis example

Assume you are ingesting log files from production systems to Elasticsearch. The most typical usecase is to use Signals to detect an unusual amount of errors.

You can use Signals to:

* run an aggregaton periodically on the logs index that counts the amount of errors in the last 5 minutes
* implement a condition that checks whether the error level is above a certain threshold
* if the condition is met, send out notifications via Email or Slack to inform your DevOps team. 

## Audit logging example

Asume you use the [Search Guard audit log feature](audit-logging-compliance) and want to be able to detect brute-force attempts to your cluster. 

You can use Signals to

* run an aggregation periodically on the auditlog index that looks for documents where the category is FAILED\_LOGIN\_ATTEMPTS
* aggregate the documents by username and count the failed login attempts
* retain all aggregations where the number of login attempts in the last 30 minutes is above a certain threshold
* Enrich the remaining aggregations by pulling in Geo information from a REST API
* send out an email and/or Slack notification
* send an addition escalation email if the issue persist for more than 1 hour

## Components of a Signals watch

A Signals watch consists of the following components:

* Trigger
  * A [trigger](triggers.md) defines when a watch will be executed. Each watch needs to have at least on trigger
* Inputs
  * An [input](inputs.md) pulls in data from a source. Can be Elasticsearch, HTTP or constants.
* Execution context payload
  * Data pulled in by inputs is stored in the runtime execution payload under a unique name. All subsequent steps have access to this payload.
* Transformations and Calculations
  * If required you can run painless scripts to [transform data in the payload, or calculate new values](transformations.md)
* Conditions
  * [Conditions](conditions.md) control the execution flow. Conditions can be defined for watches and also actions. 
  * If a watch-level condition is not met, execution of the watch is aborted.     
  * If an action-level condition is not me, execution of this action is skipped.
* Actions
  * [Actions](actions.md) are executed if all conditions are met.
  * Actions be used to alert users via [Email](actions_email.md), [Slack](actions_slack.md), [Webhooks](actions_webhook.md) or PagerDuty (coming soon).
  * Actions can be used to write the payload data back to data sinks like [Elasticsearch](actions_index.md).

## Execution chain: Checks

Inputs, transformations and conditions can be configured freely and in any order in the execution chain of the watch. Each step in the execution chain is called a `check`. You can configure as many checks as required.

In addition, you can also configure `checks` for actions. For example, you can implement a condition for an action, so it is only executed if the condition is met, not affecting other actions. Before the action is executed, you can implement an action-specific transform, which cleans up and formats data prior to using it in a notification.

## Overview

<p align="center">
<img src="watch_anatomy.png" style="width: 30%" class="md_image"/>
</p>

## Sample Watch

```
{
  "trigger": {
    "schedule": {
      "interval": ["1m"]
    }
  },
  "checks": [
    {
      "type": "static",
      "name": "constants",
      "target": "constants",
      "value": {
        "ticket_price": 800,
        "window": "1h"
      }
    },
    {
      "type": "search",
      "name": "avg_ticket_price",
      "target": "avg_ticket_price",
      "request": {
        "indices": [
          "kibana_sample_data_flights"
        ],
        "body": {
          "size": 0,
          "aggregations": {
            "when": {
              "avg": {
                "field": "AvgTicketPrice"
              }
            }
          },
          "query": {
            "bool": {
              "filter": {
                "range": {
                  "timestamp": {
                    "gte": "now-{{data.constants.window}}",
                    "lte": "now"
                  }
                }
              }
            }
          }
        }
      }
    },
    {
      "type": "condition.script",
      "name": "low_price",
      "source": "data.avg_ticket_price.aggregations.when.value < data.constants.ticket_price"
    }
  ],
  "actions": [
    {
      "type": "webhook",
      "name": "myslack",
      "throttle_period": "1s",
      "request": {
        "method": "POST",
        "url": "https://hooks.slack.com/services/token",
        "body": "{\"text\": \"Average flight ticket price decreased to {{data.avg_ticket_price.aggregations.when.value}} over last {{data.constants.window}}\"}",
        "headers": {
          "Content-type": "application/json"
        }
      }
    }
  ],
  "active": true,
  "log_runtime_data": false,
  "_id": "avg_ticket_price"
}
```