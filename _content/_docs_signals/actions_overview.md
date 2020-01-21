---
title: Actions Overview
html_title: Creating Actions for Signals Alerting
slug: elasticsearch-alerting-actions-overview
category: actions
order: 0
layout: docs
edition: beta
description:
---

<!--- Copyright 2019 floragunn GmbH -->

# Actions
{: .no_toc}

{% include toc.md %}

## Basics

When the checks configured in a watch found a situation to be noteworthy, it's time to take action. This is done using the equally named watch building block: Actions.

Actions can be used to send notifications by e-mail or other messaging services such as [Slack](actions_slack.md). Also, actions allow to write data to [Elasticsearch indices](actions_index.md). A general purpose mechanism to invoke external services is the [webhook action](actions_webhook.md) which allows making HTTP requests to configurable endpoints.

A watch can have several actions; either for sending notifications via different media, or for acting differently depending on the situation.

## Invoking actions

Actions are generally invoked if all checks configured for a watch ran with a positive result. Thus, if a condition configured in the checks evaluates to false, watch execution is aborted an no actions are invoked. The actions operate on the runtime data collected by these checks.

Still, it is possible to configure further action-specific checks. This way, it is for example possible to configure different escalation levels: Certain actions will only be triggered when certain values exceed a further threshold. Also, action-specific checks can be used to prepare further runtime data for the action. Modifications of the runtime data done by action-specific checks are always scoped to this action and are invisible to other actions.

**Note:** By using the severity feature, you can configure actions to be executed only if a certain problem severity was determined before. Also, you can configure resolve actions which get executed if the problem severity decreased. See [Severity](severity.md) for details.



## Action Types

These actions are available at the moment:

**[Index Action](actions_index.md):** Writes data to an Elasticsearch index.

**[E-Mail Action](actions_email.md):** Sends e-mails to configurable recipients. Mail content can be defined using templating.

**[Webhook Actions](actions_webhook.md):** Sends HTTP requests to external services.

**[Slack Action](actions_slack.md):** Sends Slack messages to configurable recipients. Message content is templateable as well.

**[PagerDuty Actions](actions_pagerduty.md):** Sends notifications to PagerDuty (Enterprise Feature).

**[JIRA Actions](actions_jira.md):** Sends notifications to JIRA, for example to create a new issue (Enterprise Feature).

## Action Throttling

In order to avoid getting spammed or flooded by automatic notifications caused by actions, Signals provides two mechanisms: Throttling automatically suppresses the repeated execution of actions for a configurable amount of time. Furthermore, users can acknowledge actions which suppresses action execution until the checks of a watch change their state.

For each action, a `throttle_period` can be configured. Throttle periods are time durations during which execution of the particular action will be suppressed after the it was executed. This way, a watch can be configured to be run very frequently in order to get quickly notified about newly commencing situations. Yet, actions would be triggered less frequently – in the frequency configured by the throttle period.

If actions are throttled, the watches are still executed. The watch log will contain information about the execution and list the respective actions as throttled.

Throttle periods can be either constant time values like `1h` (1 hour) or `10m` (10 minutes). Alternatively, you can specify throttle periods which increase while the situation recognized by the watch persists. These throttle periods are called exponential periods. You also use the `throttle_period`  attribute for configuring exponential periods. The initial throttling and the increase is configured using a special syntax of the value.  The syntax is `duration ** basis of exponentiation |  maximum duration`. For example, the value `1m**2|1h` would pause notifications after the initial notification for these durations: 1 minute, 2 minutes, 4 minutes, 8 minutes, 16 minutes, 32 minutes, 60 minutes. Afterwards, notifications are repeated every 60 minutes until the situation which causes the action is resolved. The specification of a maximum duration is optional, so you can also just write `1m**2`. The maximum duration then defaults to one day.

Supported units for simple throttle periods and exponential throttle periods are m (minutes), h (hours), d (days), w (weeks).

A throttle period can be also specified on the level of a watch. This then serves as a default throttle period for all actions. Actions can still define specific throttle periods, though.

If no explicit throttle period is configured, a default throttle period of 10 seconds is used. This default can be adjusted using the Signals settings. See the section on [Administration](administration.md) for details.

## Acknowledging Actions

A manual way of suppressing the execution of actions is acknowledging actions.

If an action is acknowledged, its execution is suppressed for an indefinite amount of time. Still, the watch continues to be executed on its normal schedule. During each watch execution, the conditions that would lead to the execution of the action are checked. If the conditions remain the same, the action remains acknowledged and thus execution is suppressed. Only if the conditions go away, the acknowledge state of the action is reset. Thus, if the conditions change back again so the action would be executed, the action would be actually executed again.

## Processing Collections of Objects in Actions

Some types of watches can produce several objects at once which then need to be processed by actions.

There are at least two ways of achieving this task:

* Executing an action once which condenses the object collection using scripts or templates
* Executing an action for each object from the collection.

Especially for notification actions, the first approach is strongly recommended. It is not feasible to have a potentially unbounded number of notifications being sent by one watch.

For achieving this, you can use for example loops in Mustache templates. This might look like this:

<!-- {% raw %} -->
```json
{
	"checks": [
        {
            "type": "search",
            "name": "errors",
            "target": "errors",
            "request": {
                "indices": ["errors"],
                "body": {}
            }
        }
    ],
    "actions": [
        {
            "type": "slack",
            "name": "slack_info",
            "channel": "#notifications",
            "text": "Found errors:\n{{#data.errors.hits.hits}}\n* {{_source.message}} {{/data.errors.hits.hits}}"
        }
    ]
}
```
<!-- {% endraw %} -->

In some cases, however, it will get necessary to execute the action for each element of a collection. This can be achieved by setting the `foreach` attribute of an action to a Painless expression producing a collection. The action will be then executed for each element of that collection. To access the current element of the collection, use the property called `item`. The `data` property is still providing a view of the complete runtime data.

In order to avoid actions being accidentially executed on very large collections, the amount of iterations is limited. By default, an action is only executed for the first 100 elements of a collection. This limit can be changed by setting the `foreach_limit` property of an action.

A watch using the `foreach` property might look like this:

<!-- {% raw %} -->
```json
{
    "checks": [
        {
            "type": "search",
            "name": "errors",
            "target": "errors",
            "request": {
                "indices": ["errors"],
                "body": {}
            }
        }
    ],
    "actions": [
        {
            "type": "webhook",
            "name": "post_error_to_webhook",
            "foreach": "data.errors.hits.hits",
            "throttle_period": "10m",
            "request": {
                "method": "POST",
                "url": "https://my.test.web.hook/endpoint",
                "body": "{{item._source.message}}"
            }
        }
    ]
}
```
<!-- {% endraw %} -->

## Common Action Properties

All action types share a set of common configuration properties. Consider the following example action:

```json
 {
	"actions": [
		{
			"type": "email",
			"name": "my_email_action",
			"checks": [
				{
					"type": "condition.script",
					"source": "data.bad_weather_flights.hits.total.value > 100"
				}
			],
			"throttle_period": "1h",
		}
	]
}
```

The common configuration attributes are:

**type:** The type of the action. Required. Can be index, email, slack or webhook right now.

**name:** A name identifying this action. Required.

**checks:** Further checks which can gather or transform data and decide whether to execute the actual action. Optional.

**foreach:** Executes the action for each element of a collection. The collection to use is identified by the Painless expression specified for this attribute. Optional see [Processing Collections of Objects in Actions](#Processing Collections of Objects in Actions) for details.

**foreach_limit:** Specifies the maximum allowed number of iterations performed when using `foreach`. Optional. Defaults to 100.

Alert actions (i.e., non-resolve actions) additionally support  these properties:

**throttle_period:** The throttle period. Optional. Specify the time duration using an *amount*, followed by its *unit*. Alternatively, specify an exponential throttle period using the syntax *duration*`**`*basis of exponentiation*`|` *maximum duration*. Supported units are m (minutes), h (hours), d (days), w (weeks). For example, `1h` means one hour.  

**severity:** Selects the severity levels in which this action shall be executed. Optional. An array of `info`, `warning`, `error`, `fatal`. See the section on [Severity](severity.md) for details.


Resolve actions additionally support these properties:

**resolves_severity:** Selects the severity levels which need to be resolved in order to execute this action. Mandatory. An array of `info`, `warning`, `error`, `fatal`. See the section on [Severity](severity.md) for details.
