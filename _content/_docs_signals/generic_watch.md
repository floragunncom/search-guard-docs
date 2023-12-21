---
title: Generic Watch
html_title: Generic Watch
permalink: elasticsearch-alerting-generic-watch
category: signals
order: 800
layout: docs
edition: community
description: How to use generic watch
---

<!--- Copyright 2023 floragunn GmbH -->

# Generic watch
{: .no_toc}

{% include toc.md %}

In various production environments, it is necessary to use a significant number of watches which are very similar to each other. For example, a user can use many similar watches for its (network) device monitoring. In such a case it is necessary to create one watch for each device despite the watches created for each devices are very similar. This leads to obvious duplication and complicates watch management. If the user needs to correct such watch definition then it is required to update the watches responsible for each device monitoring. Generic watches can be used to alleviate this problem. A generic watch acts as a template with predefined parameters. Later on, values of parameters for the generic watch are provided by the generic watch instance definition.

## Watch types
* single instance
  * default watch type
  * cannot be parameterized
  * is executable
* generic watches
  * are used to define the kind of template which contains parameters
  * is not executable
* generic watch instances
  * link template with parameter definition
  * is executable

## Generic watch definition
Generic watches are similar to single instance watches but can additionally contain in its JSON definition attribute `instances` with `enabled` subattribute and value `true`. The default value for the  `instances.enabled` attribute is `false` therefore by default "single instances" watches are created. Additionally `instances` JSON attribute can contain a list `params` which specify generic watch parameter names which can be referenced in the generic definition. Values for these parameters are provided in generic watch instances. The below JSON document contains a simplified definition of the generic watch

```json
{
	"instances": {
		"enabled": true,
		"params":["device_id", "time_range", "temperature_threshold", "desc"]
	},
	"checks": [{}],
	
	"trigger": {
		"schedule": {
			"interval": [
				"1s"
			]
		}
	},
	"actions": [{}]
}
```
## Parameters
{% raw %}
The parameter names can contain only lower and upper case letters, digits and the underscore character. Furthermore, parameter names must not start with a digit. The `id` parameter name is reserved and cannot be used. The allowed parameter value types are strings, numbers, boolean and dates. The parameter values cannot contain compound data structures as lists or maps. Furthermore, the generic watch definition can be updated but the update must not modify the parameter list. Parameter values can be referenced in signal scripts with the usage of `instance` objects. For example, the generic watch instance id can be referenced by Mustache template `{{instance.id}}` whereas the template `{{instance.parameter_defined_by_a_user}}` is used to retrieve the value of instance parameter `parameter_defined_by_a_user`.
{% endraw %}

## Generic watch instances management

The following REST API is defined to perform CRUD (create, read, update, delete) and other operations on generic watches.
* [Create or Update](./rest_api_watch_create_or_update_generic_instance.md)
* [Create or Update Many](./rest_api_watch_create_or_update_many_generic_instances.md)
* [Get One](./rest_api_watch_get_one_generic_instance.md)
* [Get All](./rest_api_watch_get_all_generic_instances.md)
* [Delete](./rest_api_watch_delete_generic_instance.md)
* [Enable](./rest_api_watch_enable_generic_instance.md)
* [Disable](./rest_api_watch_disable_generic_instance.md)

Additionally, REST APIs which can be used with single instance watches have a dedicated version which accepts instance id path parameter therefore is also applicable for generic watch instances, for example [Acknowledge Watch](./rest_api_watch_acknowledge.md) or [Get Watch State](./rest_api_watch_state.md)

## Permissions
Generic watch instances are always executed with the permission of the user who created the generic watch. If a user with limited permission creates a generic watch instance then the instance is executed possibly with the wider permission of the user who defined the generic watch.

## Example

### Device temperature

#### Create generic watch definition
The generic watch `devices` is created in the scope of `_main` tenant with the following parameters
* `device_id`
* `time_range`
* `temperature_threshold`
* `desc`

Furthermore, the parameter values are used in the watch definition which contains the following references to the parameters
{% raw %}
* `{{instance.device_id}}`
* `{{instance.time_range}}`
* `instance.temperature_threshold`
* `{{instance.desc}}`
{% endraw %}

Generic watch creation does not trigger the execution of the watch. The generic watches are not executable because the parameter values used in the definition are missing.

```
PUT /_signals/watch/_main/devices
```

{% raw %}
```json
{
	"instances": {
		"enabled": true,
		"params": [
			"device_id",
			"time_range",
			"temperature_threshold",
			"desc"
		]
	},
	"checks": [
		{
			"type": "search",
			"name": "iot_max_temperature-device-{{instance.device_id}}",
			"target": "maxtmp",
			"request": {
				"indices": [
					"device_data"
				],
				"body": {
					"size": 0,
					"query": {
						"bool": {
							"filter": [
								{
									"term": {
										"device-id": "{{instance.device_id}}"
									}
								},
								{
									"range": {
										"timestamp": {
											"gt": "now-{{instance.time_range}}",
											"lte": "now"
										}
									}
								}
							]
						}
					},
					"aggs": {
						"max_iot_temp": {
							"max": {
								"field": "temperature"
							}
						},
						"time": {
							"max": {
								"field": "timestamp"
							}
						}
					}
				}
			}
		},
		{
			"type": "condition",
			"name": "too high temperature",
			"source": "(data?.maxtmp?.aggregations?.max_iot_temp?.value ?: -100) > instance.temperature_threshold"
		}
	],
	"trigger": {
		"schedule": {
			"interval": [
				"1s"
			]
		}
	},
	"actions": [
		{
			"type": "webhook",
			"name": "http-webhook",
			"throttle_period": "3s",
			"request": {
				"method": "POST",
				"url": "http://localhost:8899/temperature_limit_exceeded",
				"body": "{\"time\": \"{{execution_time}}\", \"value\":{{data.maxtmp.aggregations.max_iot_temp.value}}},\"device_id\":{{instance.device_id}},\"description\":{{instance.desc}}",
				"headers": {
					"Content-Type": "application/json"
				}
			}
		}
	]
}
```
{% endraw %}
#### Generic watch instance creation
To create a generic watch instance it is necessary to provide the instance id and all parameters defined in the generic watch.
```
PUT /devices/instances/device_2nd_floor
```

```json
{
	"device_id":256,
	"time_range":"5s",
	"temperature_threshold":15,
	"desc":"My device on 2nd floor"
}
```

#### Multiple instances creation
```
PUT /_signals/watch/_main/devices/instances
```

```json
{
	"device_1st_floor": {
		"device_id": 256,
		"time_range": "5s",
		"temperature_threshold": 15,
		"desc": "My device on 1st floor"
	},
	"device_3rd_floor": {
		"device_id": 256,
		"time_range": "5s",
		"temperature_threshold": 15,
		"desc": "My device on 3rd floor"
	}
}
```

### Instance id example
The example defines a generic watch which inserts periodically documents into the `watch_logs` index. The document contains the watch instance id. The generic watch definition does not contain any parameters besides its instances id which is referenced with the following expression `instance.id`.
#### Watch definition
```
PUT /_signals/watch/_main/instance_id_example
```

```json
{
	"instances": {
		"enabled": true
	},
	"checks": [
	],
	"trigger": {
		"schedule": {
			"interval": [
				"25s"
			]
		}
	},
	"actions": [
		{
			"type": "index",
			"name": "just log execution",
			"throttle_period": "2m",
			"checks": [
				{
					"type": "transform",
					"source": "['instance_id': instance.id,  'message':'executed', 'created_at':execution_time, 'level':'info']"
				}
			],
			"index": "watch_logs"
		}
	]
}
```
#### Instance definition
The instance with id `my_first_instance_id` is defined. The instance does not contain any parameters besides its id.
```
PUT /_signals/watch/_main/instance_id_example/instances/my_first_instance_id
```

```json
{}
```
The execution of the above generic watch instance cause insertions into `watch_logs` index documents which are similar to the below one
```json
{
  "instance_id": "my_first_instance_id",
  "level": "info",
  "created_at": "2023-12-20T16:24:48.569205Z",
  "message": "executed"
}
```


