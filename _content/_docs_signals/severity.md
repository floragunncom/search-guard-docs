---
title: Severity Levels
html_title: Severity Levels
slug: elasticsearch-alerting-severity
category: signals
order: 650
layout: docs
edition: community
description: Signals Alerting for Elasticsearch can be configured using severity levels, making it simple to implement an escalation schema
---

<!--- Copyright 2020 floragunn GmbH -->

# Using Severity with Signals Watches

{: .no_toc}

{% include toc.md %}

The Severity feature of Signals provides you an easy way to map any metric obtained by a watch to a severity level. The severity level is a first-class property of a Signals watch; Signals continuously keeps track of the current severity level of a watch. Thus, it knows whether the severity has just increased, decreased, or if it stayed the same. In consequence, Signals can use it to automatically provide a number of severity-related functionalities:

* The Signals Dashboard displays the currently observed severity along with each watch. So, you can quickly see where the most important things are happening.
* You can assign actions to severity levels. The actions will be then only executed if these severity levels are reached.
* You can define resolve actions. Resolve actions are executed when a watch determines that the current severity has sunk to a level under the formerly observed severity level.



## Basic Structure

The severity feature of Signals consists of these building blocks:

* The first building block is the severity mapping. It is automatically evaluated by Signals after all checks of a watch have been executed. The severity mapping maps a numeric value gathered by the checks to one of the severity levels `info`, `warning`, `error`, `critical`.
* After having determined the current severity level, Signals executes the actions. An action can be associated with severity levels; if so, the action is only executed if the severity level is right now active.
* Finally, in case the severity level has decreased, Signals executes the resolve actions. Resolve actions are also associated with severity levels; they are only executed if the configured severity levels were active before but are active not any more.

## Defining Severity Mappings

The most important part for using severity is the severity mapping. A watch with a severity mapping may look like this:

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
    "severity": {
        "value": "data.errors.hits.total.value",
        "order": "ascending",
        "mapping": [
            {
                "threshold": 100,
                "level": "warning"
            },
            {
                "threshold": 500,
                "level": "error"            	  
            },
            {
                "threshold": 1000,
                "level": "critical"
			 }            
        ]
    }
}
```

The `severity` element supports these attributes:

**value:** This is a Painless script which defines a numeric value which shall be mapped to severity levels. In the easiest case, this is a simple expression such as `data.errors.hits.total.value`. However, you can also use any Painless script in order to do more advanced computations. The only requirement is that the script returns a number. The script is executed after all checks have been executed.

**order:** This is either `ascending` or `descending`. If `ascending` is specified here, severity increases with increasing numbers determined by the script defined in the `value` property. If `descending` is specified here, increasing values means decreasing severity. If this attribute is ommitted, `ascending` order is assumed.

**mapping:** This is an array of objects; each object maps a numeric `threshold` to a severity `level`. If the specified `order` is `ascending`, the threshold the minimum value necessary to enter the specified severity level. If the specified order is `descending`, the threshold is the maximum value for the specified severity level. The `level` attribute may be one of (in order of increasing severity) `info`, `warning`, `error`, `critical`. If you use a severity mapping, you need to define at least one severity levels. However, you don't need to define thresholds for all levels. Levels without thresholds are not in use for the particular watch.


When a watch is executed, the severity mapping is evaluated after all checks have been run,

## Assigning Actions to Severity Levels

After having defined the severity mapping, you can assign severity levels to actions. You can do so with the `severity` attribute:

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
    "severity": {
        "value": "data.errors.hits.total.value",
        "order": "ascending",
        "mapping": [
            {
                "threshold": 100,
                "level": "warning"
            },
            {
                "threshold": 500,
                "level": "error"            	  
            },
            {
                "threshold": 1000,
                "level": "critical"
			 }            
        ]
    },
    "actions": [
        {
            "type": "slack",
            "name": "slack_info",
            "severity": [ "error", "critical" ],
            "channel": "#notifications",
            "text": "Severity level is now {{severity.level}} because {{severity.value}} >= {{severity.threshold}}"
        }
    ]
}
```
<!-- {% endraw %} -->

In the `severity` attribute, you can specify one or more severity levels. You can only use the severity levels, which are defined by the severity mapping. Thus, in the example above, you cannot use the severity level `info` in the action, because the severity mapping above does not define it.

An action is only executed if the current severity is equal to one of the configured severities. Thus, if you configure an action *only* for the level `error`, it won't be executed in the higher level `critical`. This way, you can define an alternative action which covers the higher level without having the other action executing at the same time.

If you don't specify a `throttle_period` for the action, it will be executed quite frequently -- just like actions without an assigned severity. You can set the `throttle_period` to a longer time interval to suppress the action execution as long as the severity stays unchanged. If, however, the severity increases to a level which is also configured for the action, the throttling is interrupted and the action will be executed again.

The same holds for the acknowledge function: If an action was acknowledged, its execution is interrupted until:

* The severity increases to a level which is configured for the action as well
* Or: The severity decreases and afterwards increases again to one of the configured levels

If you use severity levels, you can still configure `checks` for the action. The checks will be evaluated *after* the severity level.

If an action does not define a `severity` attribute, it is executed for any severity level.

## Referencing The Current Severity Level From Scripts

If a watch defines a severity mapping, any scripts or mustache templates defined inside actions can use the special property `severity` to get information about the current severity.

The property `severity` as these sub-properties:

**level:** The current severity level. The type of this property is `com.floragunn.signals.watch.severity.SeverityLevel`, which is an enum. It has the values `INFO`, `WARNING`, `ERROR`, `FATAL`. There is the further value `NONE`, which however won't be encountered in actions assigned to severity levels. It can be however encountered in actions which are not associated to severity levels, or in resolve actions. The `level` property provides a couple of sub-properties:

* **level.id:** The id of this severity levels as a string. One of `none`, `info`,  `warning`, `error`, `fatal`.
* **level.name:** A human readable name of the level. Right now, this is the id with the first letter capitalized.
* **level.level:** A numeric representation of the level. You can use this to determine the order of the levels.

**value:** The value produced by the `value` expression of the severity mapping.

**threshold:** This is the threshold configured for the current severity level inside the severity mapping.

## Using Resolve Actions

After having defined a severity mapping, you can also use *resolve actions*. A resolve action is assigned to one or more severity levels; the action is executed if one of these severity levels was active before, but is not active any more.

This might look like this:

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
    "severity": {
        "value": "data.errors.hits.total.value",
        "order": "ascending",
        "mapping": [
            {
                "threshold": 100,
                "level": "warning"
            },
            {
                "threshold": 500,
                "level": "error"            	  
            },
            {
                "threshold": 1000,
                "level": "critical"
			 }            
        ]
    },
    "resolve_actions": [
        {
            "type": "slack",
            "name": "slack_resolve_info",
            "resolves_severity": [ "error" ],
            "channel": "#notifications",
            "text": "Severity level is now {{severity.level}}; it was before: {{resolved.severity.level}}. The value has decreased from {{resolved.severity.value}} to {{severity.value}}"
        }
    ]
}
```
<!-- {% endraw %} -->

In contrast to normal actions, resolve actions are not executed repeatedly. They are executed *only once* when the severity level has dropped below the level configured in `resolves_severity`. For this reason, throttling and acknowledgement is not applicable to resolve actions.

If `resolves_severity` defines several levels, the action is executed each time the severity level drops below one of the configured levels.

For resolve actions, you can use any action type you can also use for normal actions. See [here](actions.md) for an overview over all available action types.

## Data Available to Scripts of Resolve Actions

Scripts or templates defined inside resolve actions have access to one further property: The property `resolved` contains a snapshot of all the runtime data during the previous execution of the watch - when the severity level was not resolved yet.

So, you can access this information via the `resolved` property:

**resolved.severity:** The severity information of the previous watch run. See above for the available properties.

**resolved.data:** The runtime data gathered by the checks of the previous watch run.

**resolved.trigger:** The time when the previous execution was scheduled and when it was triggered.


When using resolve actions, you should be aware that the current severity might have dropped to a level which is not covered by the severity mapping. If this is the case `severity.level` will be `NONE` and `severity.threshold` will be `null`.
