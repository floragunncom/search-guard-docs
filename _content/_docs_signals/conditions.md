---
title: Conditions
html_title: Conditions
permalink: elasticsearch-alerting-conditions
category: signals
order: 600
layout: docs
edition: community
canonical: elasticsearch-alerting-conditions-overview
description: In Signals Alerting, conditions are used to check for threshold values, controlling the execution flow and trigger notifications.
---

<!--- Copyright 2020 floragunn GmbH -->

# Conditions
{: .no_toc}

Conditions are used to control the execution flow. A condition can be used anywhere in the execution chain for watches and actions. 

A condition is a script - usually written in Painless - that has access to the complete execution runtime data and returns a boolean value. If the condition returns true, the execution continues. If the condition returns false, the execution is stopped.

In watches, a condition controls whether a certain value or threshold is reached, to decide whether the watch should continue execution.

In actions, conditions can be used to control if a certain action should be executed. For example, you can decide to send an email to an administrator if the error level in  your log files is too high. In addition, if the error level stays high for a certain amount of time, you can send another email, escalating the issue to another person. 

The following condition tests whether the total hits of a search, stored in the execution context under the name `mysearch`, is higher than zero:

```
{
  "type": "condition",
  "name": "mycondition",
  "source": "data.mysearch.hits.hits.length > 0"
}
```

| Name | Description |
|---|---|
| type | condition, defines this check as condition. Mandatory. |
| name | name of this condition. Can be chosen freely. Mandatory. |
| source | The script to execute. Mandatory |
| lang | The scripting language to be used. Optional, defaults to painless. Other scripting languages may be provided by OpenSearch/Elasticsearch plugins. |
{: .config-table}

## Accessing the runtime data

All scripts have full access to the runtime data, gathered for example by [search](inputs_elasticsearch.md) or [HTTP](inputs_http.md) inputs.

The runtime data is available via the `data` prefix.

For example, the following watch runs a query against the server logs index to find entries where the status code is 500. The target property of the input is configured to be `http_error_500`; thus the document read by the input is put under this property name into the runtime data. The script condition accesses the data by using the  `data.http_error_500` prefix and only continues if the total hits is above 10.

```
{
  "trigger":{},
  "checks":[
    {
        "type":"search",
        "name":"server_errors",
        "target":"http_error_500",
        "request":{
            "indices":[ "serverlogs" ],
            "body":{
               "query" : { "match" : { "statuscode" : "500" } }
            }
        }
    },
    {
        "type": "condition",
        "name": "error_500_threshold",
        "source": "return data.http_error_500.hits.total.value > 10"
    }
  ],
  "actions":[ ... ]
}
```

## Using conditions with actions

A condition can also be used to control the execution of an action. Each action can define its own chain of `check`s, including conditions.

Continuing on the example above, the following snippet will send an email to the administrator if the watch fires.

A second action will send an additional email to a manager if the total number of hits is above 100. This is controlled by the script condition in the action definition:

<!-- {% raw %} -->
```
{
  "trigger":{},
  "checks":[],
  "actions":[
    {
         "type":"email",
         "name":"standard_admin",
         "account":"it_smtp",
         "to": ["admin@example.com"],
         "subject": "Too many errors detected.",
         "text_body":"Found more than {{data.http_error_500.hits.total.value}} hits."
    },
    {
         "type":"email",
         "name":"standard_admin",
         "account":"it_smtp",
         "to": ["management@example.com"],
         "subject": "Warning: Critical amount of errors found",
         "text_body":"Found more than {{data.http_error_500.hits.total.value}} hits.",
         "checks": [
           {
               "type": "condition",
               "name": "escalation_level_1",
               "source": "return data.http_error_500.hits.total.value > 100"
           }
         ]
    }    
  ]
}
```
<!-- {% endraw %} -->
