---
title: Throttling and Acknowledgement
html_title: Notification Throttling
permalink: elasticsearch-alerting-throttling
layout: docs
edition: community
description: How to throttle notifications in Signals Alerting for Elasticsearch to
  prevent alert flooding
---
<!--- Copyright 2022 floragunn GmbH -->

# Throttling and Acknowledgement
{: .no_toc}

{% include toc.md %}

Signals supports both time-based and acknowledgement based throttling.

The purpose of throttling is to prevent any action to be executed too many times, thus generating too many notifications.

Assume you have a watch that is executed every second. If the condition of the watch is met, the configured action would also fire every second. Which means a notification is generated every second.

Time-based throttling enables you to limit the execution of an action based on a time interval: Even if the watch is executed every second, the action only fires every n seconds/minutes/hours etc.

Acknowledge-based throttling enables you to "silence" a watch which currently fires.  

## Time-based throttling

To throttle the execution of an action, you can set a `throttle_period` in the action definition:

```json
 {
	"actions": [
		{
			"type": "email",
			"name": "my_email_action",
			"throttle_period": "1h",
			"account": "internal_mail",
			"to": "notify@example.com",
			"subject": "...",
			"text_body": "..."
		}
	]
}
```

In this example, regardless how often the condition in the watch definition fires, the email action will be executed only once per hour.

On other words, if you define a throttle period, the action will not fire if the last time the action was executed is withing the timeframe of the throttle period.

## Acknowledgement

Acknowledging a watch that currently fires will prevent any action from being executed again. If a watch is [acknowledged via the REST API](rest_api_watch_acknowledge.md), it will move into the `acknowledged` state. As long as a watch is in `acknowledged` state, no actions will be executed.

This is useful in a situation where a watch condition is met, and you want to acknowledge that someone has noticed it and is working on solving the issue. 

A watch will remain in the `acknowledged` state until the watch condition evaluates to `false`, i.e. the condition is not met. This will move the watch out of the `acknowledged` state, so the next time the condition is met, the actions will be executed again.

### Kibana deeplinks for acknowledging actions

Introduced in Search Guard FLX 1.1.0
{: .available-since}

You can use Kibana deeplinks to acknowledge one or more actions of a watch. A deeplink makes it possible to

- Acknowledge all actions of a watch
- Acknowledge one specific action of a watch
- Acknowledge several specific actions of a watch

To acknowledge all actions of a watch, you can use the following deeplink:

```
https://<Kibana URL>/app/searchguard-signals#/watch/{watch_id}/ack. 
```

If selective actions are supposed to be acknowledged, they can be specified as comma-separated query params:

```
https://<Kibana URL>/app/searchguard-signals#/watch/{watch_id}/ack?actions=action_a,action_b
```

Signals provides two variables for generating deeplinks. These variables can be used in Mustache templates, for example to generate
an Email or a Slack message:

* `{{ '{{' }}ack_watch_link}}`: Link to acknowledge the whole watch
* `{{ '{{' }}ack_action_link}}`: Link to acknowledge the particular action which generated the current alert

**Prerequisites**

Since the deeplinks contain the base URL of Kibana, you need to configure it as a setting in Signals using the [PUT settings REST API](elasticsearch-alerting-rest-api-settings-put):

Example curl call:

``
curl -u username:password \
  -H 'Content-Type: application/json' \
  -X PUT "https://<Elasticsearch URL>:9200/_signals/settings/frontend_base_url" \
  -d '"https://kibana.example.com:5601"'
``

By default, the user has to acknowledge the watch with an additional button press on the Kibana acknowledge page.
If you want to auto-acknowledge the specified actions once the user clicks on the deeplink, add `one_click=true` as a query parameter to the link:

```
https://<Kibana URL>/app/searchguard-signals#/watch/{watch_id}/ack?actions=action_a,action_b&one_click=true
```

### Unacknowledgeable actions

Introduced in Search Guard FLX 1.1.0
{: .available-since}

Search Guard FLX 1.1.0 introduces a new boolean attribute for actions: `ack_enabled` (defaults to true).

If set to false, any try to acknowledge a watch will not acknowledge this action, and thus it continues to run:

```
/_signals/watch/{tenant}/{watch_id}/_ack 
```

If an unacknowlegeable action is explicitly specified, the request will fail with status 400 Bad Request.

```
/_signals/watch/{tenant}/{watch_id}/_ack/{action_id}
```
