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

* [hourly](#hourly-triggers)
* [daily](#daily-triggers)
* [weekly](#weekly-triggers)
* [monthly](#monthly-triggers)
* [interval](#interval-triggers)
* [cron](#cron-triggers)

Each watch must at least define one trigger, and can define as many triggers as necessary:

## Hourly triggers

### Creating an hourly trigger

To create an hourly trigger, you specify the minute of the hour when the trigger will fire by using the  `minute` attribute:

```json
{
	"trigger": {
		"schedule": {
			"hourly": {
				"minute": 30
			}
		}
	},
	"checks": [],
	"actions": []
}
```

This trigger will fire each hour at minute 30.

You also can specify an array for the `minute` attribute. The trigger will then fire several times the hour, on the respective minutes:

```json
{
	"trigger": {
		"schedule": {
			"hourly": {
				"minute": [0, 30]
			}
		}
	},
	"checks": [],
	"actions": []
}
```

This trigger will fire two times each hour; first at minute 0; then at minute 30.

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

## Weekly triggers

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

## Monthly triggers

### Creating a monthly trigger


For monthly triggers, you need to specify the day of month using the `on` attribute and the time of the day using the `at` attribute:

```json
{
	"trigger": {
		"schedule": {
			"monthly": {
			    "on": 15,
				"at": "14:00:00"
			}
		}
	},
	"checks": [],
	"actions": []
}
```

This trigger will fire once a month on the 15th at 2pm.

You can also specify arrays for the `on` and `at` attributes. Then, the trigger will fire on several days per month, or on several hours of the day, respectively:

```json
{
	"trigger": {
		"schedule": {
			"monthly": {
			    "on": [1, 15],
				"at": ["8:00:00, "14:00:00"]
			}
		}
	},
	"checks": [],
	"actions": []
}
```

This trigger will fire four times a month: on the 1st, it will fire at 8am and 2pm. On the 15th, it will fire at the same times.

This trigger will fire on Thursday at 2pm and on Friday at 5pm.

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