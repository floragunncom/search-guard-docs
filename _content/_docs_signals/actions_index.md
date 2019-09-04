---
title: Index Actions
html_title: Creating Index  Actions for Signals Alerting
slug: elasticsearch-alerting-actions-index
category: actions
order: 100
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Index Action
{: .no_toc}

{% include toc.md %}

Use index actions to store data in an Elasticsearch index.

## Basic Functionality

A typical index action looks like this:

```json
{
	/* ... */

	"actions": [
		{
			"type": "index",
			"checks": [
				{
					"type": "transform",
					"source": "['flight_num': data.source.FlightNum, 'dest': data.source.DestAirportID]"
				}
			]
			"index": "testindex"
		}
	]
}
```

Index actions write a complete snapshot of the current runtime data as one JSON document into the specified index.

Therefore, as shown in the example above, index actions are typically accompanied by transforms which can explicitly define the data to be indexed using Painless scripts - or any other installed script engine. The script should return a map which will converted to a JSON document by the action.

## Specifying the Document ID

Normally, documents will be indexed with an automatically generated ID. You can however also explicitly define the ID of the document by providing an additional attribute in the runtime data called `_id`. 

## Indexing Multiple Documents

If you want to index multiple documents by one action execution, you need to prepare the runtime data in a special way: Store the documents to be indexed in an array and store this array in an attribute called `_doc` at the top level of the runtime data. The following example stores two documents:

```json
{
	/* ... */

	"actions": [
		{
			"type": "index",
			"checks": [
				{
					"type": "transform",
					"source": "['_doc': [ [ 'x': 1 ], [ 'x': 2 ] ] ]"
				}
			]
			"index": "testindex"
		}
	]
}
```

## Authorization

The index operation will be executed with the privileges the user had when creating or updating the watch. So, you must make sure to have all the privileges necessary to write to the respective indexes when creating or updating a watch.

## Advanced Attributes

Further configuration attributes are:


**refresh:** The Elasticsearch index [refresh policy](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-refresh.html). One of `false`, `true` or `wait_for`. Optional; default is `false`. 

**timeout:** If the index operation does not complete in the specified time (in seconds), it will be aborted. Optional; default is 60 seconds.


