---
title: Pagerduty Actions
html_title: Pagerduty Actions
slug: elasticsearch-alerting-actions-pagerduty
category: actions
order: 500
layout: docs
edition: enterprise
description: How to create PagerDuty incidents from Signals Alerting for OpenSearch/Elasticsearch if anomalies are detected.
---

<!--- Copyright 2020 floragunn GmbH -->

# PagerDuty Actions
{: .no_toc}

{% include toc.md %}


The PagerDuty action type allows you to integrate Signals with PagerDuty; it allows to automatically open PagerDuty incidents from Signals watches. Furthermore, PagerDuty actions can also automatically resolve incidents in PagerDuty as soon as the watch has left alert state. PagerDuty actions do this incident resolution automatically by default; this is in contrast to other actions which require an explicit resolve action to be configured. 

If a watch defines severity levels, these are also directly mapped to the severity defined in the event sent to PagerDuty.

The PagerDuty action type is an enterprise feature; you need to have an enterprise license to use PagerDuty actions.

## Prerequisites

In order to use PagerDuty actions, you need to get a Service integration key from PagerDuty. If you already have configured a service in PagerDuty, open that service in the PagerDuty configuration and click on the *Integrations* tab. Click on the *New Integration* button. In the next screen select *Use our API directly* as *Integration Type* and select the *Events API v2* in the dropdown below.

If you don't have any service in PagerDuty yet, go in PagerDuty to *Configuration* > *Services* and click on the *New Service* button. In the next screen, you will also have the configuration elements for the *Integration Settings*. Select 	*Use our API directly* as *Integration Type* and select the *Events API v2* in the dropdown below.

After creating the integration, PagerDuty will show an Integration Key. You will then need to configure a PagerDuty account in Signals using this integration key. See the [accounts registry documentation](accounts.md) for more on that.

## Basic Functionality

PagerDuty actions require very little configuration in Signals. After having created a PagerDuty account with the id `default` in Signals, you can use this action configuration to create incidents in PagerDuty and resolve them.

<!-- {% raw %} -->
```json
 {
	"actions": [
		{
			"type": "pagerduty",
			"name": "my_pagerduty_action",
			"event": {
				"dedup_key": "cheese_stock_shortage",
				"payload": {
					"summary": "Cheese stock < {{data.cheese_stock}}",
					"source": "Cheese shop"
				}
			}
		}
	]
}
```
<!-- {% endraw %} -->

The attribute `event.dedup_key` groups events sent to PagerDuty into incidents. If events are sent to PagerDuty while there is already an open incident with the same `dedup_key`, no new incident will be created.

The attribute `event.payload.summary` is a human readable description of the situation and will become the alert description within PagerDuty. 

The attribute `event.payload.source` shall identify the system having the problem.

Mustache templates can be used for all three attributes.


## Adding Information to Events

A number of further configuration attributes can be used to add more information to the events sent to PagerDuty.

**event.payload.component:** Can be used to define the affected component of a system. Optional. Mustache templates can be used for dynamic content.

**event.payload.group:** You can define a group here which the affected system belongs to. Optional. Mustache templates can be used for dynamic content.

**event.payload.class:** You can classify the event here. Optional. Mustache templates can be used for dynamic content.

**event.payload.custom_details:** While the other attributes define textual information, this attribute defines structured information which will be sent as JSON to PagerDuty. You need to use a Painless expression to define the structured data. For example, the value `data`  sends the complete runtime data to PagerDuty. As runtime data might be quite big, it might be a wise choice to send a smaller data set. You can use a Painless map expression for this purpose: `['amount': 'data.aggregations.cheese_amount.total']` 


## Advanced Functionality

Furthermore, Signals provides configuration options to completely control the event data sent to PagerDuty. This is however usually not necessary, as Signals initializes these event attributes with suitable defaults.

The structure of the configuration sticks closely to the structure of the PagerDuty event v2 API. Thus, see also the [PagerDuty API docs](https://v2.developer.pagerduty.com/docs/events-api-v2) for details.

**auto_resolve:** By default, PagerDuty actions will automatically send resolve events to PagerDuty, even if no resolve action is configured in Signals. Set this to false to suppress resolve actions.

**event.event_action:** One of `trigger`, `acknowledge` or `resolve`. By default, Signals sends `trigger`or `resolve` depending on whether the Watch is in alert state or it has left alert state.

**event.payload.severity:** One of `info`, `warning`, `error`, `critical`. By default Signals sends the severity defined by the severity mapping of the respective watch.

