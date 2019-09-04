---
title: Execution chain and payload
html_title: Chaining Inputs, Transformations and Conditions
slug: elasticsearch-alerting-chaining-checks
category: signals
order: 250
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Execution chain and execution context payload
{: .no_toc}

{% include toc.md %}

## Execution chain: Checks

Each watch can define as many inputs, transformations, calculations and conditions as required, in any order.

Each step in  the execution chain is called a `check` and needs to have a unique name. Example:

```
{
  "trigger": { ...},
  "checks": [
    {
      "type": "static",
      "name": "constants",
      ...
    },
    {
      "type": "search",
      "name": "avg_ticket_price",
      ...
    },
    {
      "type": "condition.script",
      "name": "low_price"
      ...
    },
    {
      "type": "transform",
      "name": "format_data"
      ...
    },
    {
      "type": "http",
      "name": "add_geo_data"
      ...
    },
    ...    
  ],
  "actions": [ ... ]
}
```

## Execution context: Payload

All `check`s operate on the watch execution context. The execution context stores all runtime data of the watch. 

[Input](inputs.md) checks add data to the context under a unique name. [Transformations](transformations_transformations.md) transform existing data, [Calculations](transformations_calculations.md) add data based on existing data, and [Conditions](conditions.md) control the execution flow based on the runtime data.

[Actions](actions.md) send out notifications based on the runtime data, or store all or parts of the runtime data on a data sink, like Elasticsearch.

<p align="center">
<img src="runtime_context.png" style="width: 40%" class="md_image"/>
</p>

### Adding data to the execution context

An [input](inputs.md) fetches data and places it in the execution context under a name specified by the `target` of the check.  Example:

```
{
  "trigger": { ...},
  "checks": [
    {
      "type": "search",
      "name": "avg_ticket_price",
      "target": "avg_ticket_price",
      "request": {
        "indices": [
          "kibana_sample_data_flights"
        ],
        "body": {
         "query": { ... }
        }
    }
    ...    
  ],
  "actions": [ ... ]
}
```

This input executes an Elasticsearch query and stores the result of the query under the name `avg_ticket_price`.

### Accessing data in the execution context

Transformations, calculations and conditions access data in the execution context by using the target name:

```
{
  "trigger": { ...},
  "checks": [
    {
      "type": "condition.script",
      "name": "low_price",
      "source": "data.avg_ticket_price.aggregations.when.value < data.constants.ticket_price"
    }
    ...    
  ],
  "actions": [ ... ]
}
```

Format:

```
data.<target name>.path.to.data
```

### Accessing data in moustache templates

Actions format their messages by using moustache templates. Moustache templates have access to the execution context data as well. Example:


```
{
  "trigger": { ...},
  "checks": [ ... ],
  "actions": [
      {
      "type": "webhook",
      "name": "myslack",
      "throttle_period": "1s",
      "request": {
        "method": "POST",
        "url": "https://hooks.slack.com/services/token",
        "body": "{\"text\": \"Average flight ticket price decreased to {{data.avg_ticket_price.aggregations.when.value}} over last {{data.constants.window}}\"}",
        "headers": {
          "Content-type": "application/json"
        }
      }
    }
  
  ]
}
```

Format:

```
{{data.<target name>.path.to.data}}
```

## Top-level context

If an input does not define any target, the data is stored in the top-level of the execution context.