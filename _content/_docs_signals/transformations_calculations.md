---
title: Calculations
html_title: Data Calculations
slug: elasticsearch-alerting-calculations
category: transformations
order: 200
layout: docs
edition: community
description: Signals Alerting for OpenSearch/Elasticsearch uses Painless scripting for performing calculations on the data used by watches

---

<!--- Copyright 2020 floragunn GmbH -->

# Calculations
{: .no_toc}

{% include toc.md %}

A calculation is a script that

* has access to the execution context payload data
* performs one or more painless statements
* writes data back to the execution context

As opposed to [Transformations](transformations_transformations.md), Calculation scripts do not have a return statement and do not need to define a target.

Instead, they access and manipulate the watch runtime data directly.

Calculations can be used

* in the `check`s section of a watch definition
  * the calculation is executed before any actions are executed. Changes to the execution context payload data are visible for all subsequent steps and for all actions
* in the `check`s section of any action
  * the calculation is executed before the action is executed. Changes to the execution context payload data are only applied to the payload for that specific action.


A calculation painless script can be defined as inline script within the calculation definition. For example, the next calculation iterates over the hits of a query stored under the key `logs` in the  execution context, calculates the average memory usage, and makes it available under the new key `average_memory` in the execution context. All subsequent steps can access this value.

```
{
  "type": "calc",
  "name": "avg_memory",
  "source": "int total = 0; for (int i = 0; i < data.logs.hits.hits.length; ++i) { total += data.logs.hits.hits[i]._source.memory; } data.average_memory = total / data.logs.hits.hits.length;"
}
```

| Name | Description |
|---|---|
| type | calc, defines this script as calculation. Mandatory. |
| name | name of this calculation. Can be chosen freely. Mandatory. |
| source | The painless script to execute. Mandatory |
{: .config-table}

## Accessing the execution context data

All scripts have full access to the data stored in the execution context. The data in the execution context is available via the `data` prefix, followed by the target name of the data.

## Using calculations with actions

Calculations can also be used with actions. Each action can define it's own chain of `check`s, including calculations. The following snippets shows how to combine a calculation and a condition specific to an action. The calculation is the same as above, and the condition will execute the action only if the average memory consumption is above a certain threshold.

Note that you can also use the calculated value in the text_body of the email action. Actions use Mustache to render the output. Mustache has the same access to the execution context data as scripts and conditions.

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
         "to": ["management@example.com"],
         "subject": "Warning: Critical average memory consumption",
         "checks": [
          {
            "type": "calc",
            "name": "avg_memory",
            "source": "int total = 0; for (int i = 0; i < data.logs.hits.hits.length; ++i) { total += data.logs.hits.hits[i]._source.memory; } data.average_memory = total / data.logs.hits.hits.length;"
           },
           {
               "type": "condition.script",
               "name": "escalation_level_1",
               "source": "return data.average_memory > 10000"
           }
         ]
         "text_body":"Average memory consumption: {{data.average_memory}}",
    }    
  ]
}
```
<!-- {% endraw %} -->
