---
title: Watch API
html_title: Elasticsearch Alerting Watch API
slug: alerting-api-watch
category: signals
order: 200
layout: docs
edition: community
description: How to use the Signals Watch REST API endpoint to create, update and delete watch definitions.
---
<!--- Copyright 2019 floragunn GmbH-->

# Watch API
{: .no_toc}

{% include toc.md %}

## Endpoint

```
/_signals/watch/{watchid}
```
Where `watchid ` is the id of the watch

## GET

### Get a single watch

```
GET /_signals/watch/{watchid}
```

Retrieve a watch, specified by `watchid?, in JSON format.

```
GET /_signals/watch/mywatch
```

```json
{  
  
}

```

## DELETE

```
DELETE /_signals/watch/{watchid}
```

Deletes the watch specified by `watchid `. If successful, the call returns with status code 200 and a JSON success message.

```
DELETE /_signals/watch/mywatch
```

```json
{
}
```

## PUT

```
PUT /_signals/watch/{watchid}
```

Replaces or creates the watch specified by `watchid `.

```json
{
	"trigger": { ... },
	"checks": [ ... ],
	"actions": [ ... ],
	"active": <true|false>,
	"log_runtime_data": <true|false>
}    
```

### Example

```
PUT /_signals/watch/{watchid}
```

```json
{
	"trigger":{
		"schedule":{
			"cron":[
				"*/10 * * * * ?"
			]
		}
	},
	"checks":[
		{
			"type":"search",
			"name":"Audit log events",
			"target":"auditlog",
			"request":{
				"indices":[
					"audit*"
				],
				"body":{
					"size":1,
					"query":{
						"bool":{
							"must":[
								{
									"match":{
										"audit_category":{
											"query":"FAILED_LOGIN"
										}
									}
								},
								{
									"range":{
										"@timestamp":{
											"gte":"now-2m"
										}
									}
								}
							]
						}
					}
				}
			}
		},
		{
			"type":"condition.script",
			"name":"testcondition",
			"source":"ctx.auditlog.hits.total.value > 10"
		}
	],
	"actions":[
		{
			"type":"index",
          "name": "rawdata",
			"index":"signals_data"
		}
	],
	"active":false,
	"log_runtime_data":false
}    
```