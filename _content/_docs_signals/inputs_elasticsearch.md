---
title: Elasticsearch
html_title: Creating Elasticsearch inputs for Signals Alerting
slug: elasticsearch-alerting-inputs-elasticsearch
category: inputs
order: 200
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Search input
{: .no_toc}

A search input can be used to pull in data from an Elasticsearch index.

You can use the full power of the Elasticsearch query syntax to query, filter and aggregate your data. 

Example:

```
{
	"type": "search",
	"name": "Audit log events",
	"target": "auditlog",
	"request": {
		"indices": [
			"audit*"
		],
		"body": {
			"size": 5,
			"query": {
				"bool": {
					"must": [{
							"match": {
								"audit_category": {
									"query": "FAILED_LOGIN"
								}
							}
						},
						{
							"range": {
								"@timestamp": {
									"gte": "now-5m"
								}
							}
						}
					]
				}
			},
			"aggs": {
				"failed_logins": {
					"terms": {
						"field": "audit_request_effective_user.keyword"
					}
				}
			}
		}
	}
}
```

| Name | Description |
|---|---|
| type | search, defines this input as a search on Elasticsearcgh|
| target | the name under which the data is available in later execution steps. |
| request | The search request to execute |
| request.indices | The indices to execute the `request.query` against. **The user that defines the watch needs to have a role that has access to the specified index / indices.**|
| request.body | The body of the search request. You can use all features of the Elasticsearch query and aggregation DSL here. **All attributes of the request body can be dynamically defined using Mustache templates**.|





