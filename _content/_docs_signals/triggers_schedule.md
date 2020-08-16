---
title: Schedule Triggers
html_title: Schedule Triggers
slug: elasticsearch-alerting-triggers-schedule
category: triggers
order: 100
layout: docs
edition: community
description: Configure how often an Alerting watch is executed that scans data in Elasticsearch for anomalies.
---

<!--- Copyright 2020 floragunn GmbH -->

# Schedule Triggers
{: .no_toc}

{% include toc.md %}

A schedule trigger defines when a watch is executed based on date and time. 

Triggers support different [time zones](triggers_timezones.md). If no time zone is specified, the default JVM time zone is used, which is based on the system clock. Thus,  the time on all nodes should be synchronized via NTP.

At the moment, the following schedule types are supported:

* daily
* weekly
* monthly
* interval
* cron

Each watch must at least define one trigger, and can define as many triggers as necessary:

## Daily triggers

### Creating a daily trigger

To create a daily trigger, you specify the time when the trigger will fire by using the  `at` attribute:

```json
{
	"trigger": {
		"schedule": {
			"daily": {
				"at": "14:00:00"
			}
		}
	},
	"checks": [],
	"actions": []
}
```

This trigger will fire each day at 2pm.

### Creating a daily trigger with multiple times

You can create a daily trigger which will fire at multiple times. Add the respective times as an array to the `at` key:

```json
{
	"trigger": {
		"schedule": {
			"daily": {
				"at": ["14:00:00", "17:00:00"]
			}
		}
	},
	"checks": [],
	"actions": []
} 
```

This trigger will fire each day at 2pm and 5pm.

## Weekly trigger

To create a weekly trigger, you define the weekday and the time.

Weekdays are defined as:

* sunday, monday, tuesday, wednesday, thursday, friday and saturday


### Creating a weekly trigger



```json
{
	"trigger": {
		"schedule": {
			"weekly": {
				"on": "thursday",
				"at": "14:00:00"
			}
		}
	},
	"checks": [],
	"actions": []
}
```

This trigger will fire each Thursday at 2pm.

### Creating a weekly trigger with multiple days and times

To create a weekly trigger, you define the weekday and the time:

```json
{
	"trigger": {
		"schedule": {
			"weekly": {
				"on": ["thursday", "friday"],
				"at": ["14:00:00", "17:00:00"]
			}
		}
	},
	"checks": [],
	"actions": []
}
```

This trigger will fire each Thursday and Friday at 2pm and 5pm.

### Creating multiple weekly triggers

To create multiple weekly trigger, you define the weekday and the time like:

```json
{
	"trigger": {
		"schedule": {
			"weekly": [
				{
					"on": "thursday",
					"at": "14:00:00"			
				},
				{
					"on": "friday",
					"at": "17:00:00"			
				}				
			]
		}
	},
	"checks": [],
	"actions": []
}
```

This trigger will fire on Thursday at 2pm and on Friday at 5pm.

## Monthly trigger

Coming soon.

## Interval triggers

Interval triggers define their schedul by configuring a time interval. The interval can be specified in seconds, minutes, hours, days or weeks:

* [n]s - fires every n seconds
* [n]m - fires every n minutes
* [n]h - fires every n hours
* [n]d - fires every n days
* [n]w - fires every n weeks

### Creating an interval trigger

```json
{
	"trigger": {
		"schedule": {
			"interval": "10m"
		}
	},
	"checks": [],
	"actions": []
}
```

This trigger will fire every 10 minutes.


### Creating an interval trigger with multiple intervals

```json
{
	"trigger": {
		"schedule": {
			"interval": ["10m", "45m"]
		}
	},
	"checks": [],
	"actions": []
}
```

This trigger will fire every 10 minutes and every 45 minutes.

## cron triggers

Cron triggers allow you to use the full power of cron expressions to define the schedule of a watch.

Signals uses the Quartz scheduler engine under the hood. For details about the cron expression syntax, please refer to [Quarts Cron Trigger Tutorial](http://www.quartz-scheduler.org/documentation/quartz-2.3.0/tutorials/crontrigger.html).

### Creating a cron trigger

```
{
	"trigger": {
		"schedule": {
			"cron": ["*/10 * * * * ?"]
		}
	},
	"checks": [],
	"actions": [],
}
```

This trigger will fire every 10 seconds.

### Creating multiple cron triggers

```
{
	"trigger": {
		"schedule": {
			"cron": [
             "0 0/2 * ? * MON-FRI",
             "0 1-59/2 * ? * SAT-SUN"
       	]
		}
	},
	"checks": [],
	"actions": [],
}
```