---
title: Actions
html_title: Creating Actions for Signals Alerting
slug: elasticsearch-alerting-actions
category: signals
subcategory: actions
order: 700
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

**[E-Mail Action](actions_email.md):** Sends e-mails to configurable recipients. Mail content can be defined using templating.

**[Slack Action](actions_slack.md):** Sends Slack messages to configurable recipients. Message content is templateable as well.

**[Webhook Actions](actions_webhook.md):** Sends HTTP requests to external services.

**[Index Action](actions_index.md):** Writes data to an Elasticsearch index.

## Action Throttling

In order to avoid getting spammed or flooded by automatic notifications caused by actions, Signals provides two mechanisms: Throttling automatically suppresses the repeated execution of actions for a configurable amount of time. Furthermore, users can acknowledge actions which suppresses action execution until the checks of a watch change their state.

For each action, a throttle period can be configured. Throttle periods are time durations during which execution of the particular action will be suppressed after the it was executed. This way, a watch can be configured to be run very frequently in order to get quickly notified about newly commencing situations. Yet, actions would be triggered less frequently – in the frequency configured by the throttle period.

If actions are throttled, the watches are still executed. The watch log will contain information about the execution and list the respective actions as throttled.

A throttle period can be also specified on the level of a watch. This then serves as a default throttle period for all actions. Actions can still define specific throttle periods, though.

If no explicit throttle period is configured, a default throttle period of 10 seconds is used.

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

In some cases, however, it will get necessary to execute the action for each element of a collection. This can be achieved by setting the `foreach` attribute of an action to a Painless expression producing a collection. The action will be then executed for each element of that collection. To access the current element of the collection, use the property called `item`. The `data` property is still providing a view of the complete runtime data. 

In order to avoid actions being accidentially executed on very large collections, the amount of iterations is limited. By default, an action is only executed for the first 100 elements of a collection. This limit can be changed by setting the `foreach_limit` property of an action.

A watch using the `foreach` property might look like this:

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

## Common Action Properties

All action types share a set of common configuration properties. Consider the following example action:

```json
 {
     
    ...
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
			...
		}
	]
}
```

The common configuration attributes are:

| Name | Description |
|---|---|
| type | The type of the action. Required. Can be index, email, slack or webhook right now. |
| name | A name identifying this action. Required. |
| checks | Further checks which can gather or transform data and decide whether to execute the actual action. Optional. |
| throttle_period | The throttle period. Optional. Specify the time duration using an *amount*, followed by its *unit*. Supported units are m (minutes), h (hours), d (days), w (weeks). For example, `1h` means one hour. |
