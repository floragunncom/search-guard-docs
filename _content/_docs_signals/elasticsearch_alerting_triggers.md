---
title: Alerting Triggers
html_title: Triggers
permalink: elasticsearch-alerting-triggers
layout: docs
edition: community
canonical: triggers-overview
description: How to create triggers for Signals Alerting for Elasticsearch that control
  the execution of watches
---
<!--- Copyright 2022 floragunn GmbH -->

# Creating triggers for Elasticsearch watches
{: .no_toc}

{% include toc.md %}

## What is a trigger

Every watch has to define a trigger. A trigger specifies when a watch gets executed ("triggered"). Currently the following trigger types are supported:

* Date and time
  * for example, every Wednesday at 2pm 
* Interval
  * for example, every 10 minutes 
* cron
  * gives you the full power of cron expressions

Example:

```json
{
	"trigger": {
		"schedule": {
			"weekly": {
				"on": "thursday",
				"at": "14:40:45"
			}
		}
	},
	"checks": [ ... ],
	"actions": [ ... ]
}
```


## Trigger execution

Each trigger gets registered with the Trigger Execution Engine. The execution engine makes sure that

* Each trigger is executed on exactly one node at a time
  * You can specify node filters to define on which nodes Signals Alerting should run
* Triggers created in different tenants will not interfere with each other
  * This applies only when you are using [Multi-Tenancy](elasticsearch-alerting-security-multi-tenancy).   
   
## Time zones

Signals supports different [time zones](elasticsearch-alerting-triggers-timezones). If no time zone is specified, the default JVM time zone is used. 
