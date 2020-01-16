---
title: Script Conditions
html_title: Creating Script Conditions for Signals Alerting
slug: elasticsearch-alerting-conditions-script
category: conditions
order: 100
layout: docs
edition: beta
description:
---

<!--- Copyright 2019 floragunn GmbH -->

# Script Conditions
{: .no_toc}

{% include toc.md %}

A script condition is a Painless script that has access to the complete execution runtime data and returns a boolean value.

If the script returns false, the execution flow is aborted. If it returns true, the execution flow continues.

As with other condition types, a script condition can be used to control the execution flow of a watch or an action.

If used in a watch, depending on the return value of the script, execution of the watch  is either aborted or continued.

If used in an action,  depending on the return value of the script, the action is either executed or skipped. A condition in one action does not affect execution of other actions.

The following condition tests whether the total hits of a search, stored in the execution context under the name `mysearch`, is higher than zero:

```
{
  "type": "condition.script",
  "name": "mycondition",
  "source": "data.mysearch.hits.hits.length > 0"
}
```

| Name | Description |
|---|---|
| type | condition.script, defines this conditions as script condition. Mandatory. |
| name | name of this condition. Can be chosen freely. Mandatory. |
| source | The script to execute. Mandatory |
| lang | The scripting language to be used. Optional, defaults to painless. Other scripting languages may be provided by Elasticsearch plugins. |
{: .config-table}

## Accessing the runtime data

All scripts have full access to the runtime data, gathered for example by [Elasticsearch](inputs_elasticsearch.md) or [HTTP](inputs_http.md) inputs.

The runtime data is available via the `data` prefix.

For example, the following watch runs a query against the serverlogs index to find entries where the statuscode is 500. The target property of the input is configured to be `http_error_500`; thus the document read by the input is put under this property name into the runtime data. The script condition accesses the data by using the  `data.http_error_500` prefix and only continues if the total hits is above 10.

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
        "type": "condition.script",
        "name": "error_500_threshold",
        "source": "return data.http_error_500.hits.total.value > 10"
    }
  ],
  "actions":[ ... ]
}
```

## Using script conditions with actions

A script condition can also be used to control the execution of an action. Each action can define it's own chain of `check`s, including conditions.

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
         "text_body":"Found more that {{data.http_error_500.hits.total.value}} hits."
    },
    {
         "type":"email",
         "name":"standard_admin",
         "account":"it_smtp",
         "to": ["management@example.com"],
         "subject": "Warning: Critical amount of errors found",
         "text_body":"Found more that {{data.http_error_500.hits.total.value}} hits.",
         "checks": [
           {
               "type": "condition.script",
               "name": "escalation_level_1",
               "source": "return data.http_error_500.hits.total.value > 100"
           }
         ]
    }    
  ]
}
```
<!-- {% endraw %} -->
