---
title: Conditions Overview
html_title: Conditions Overview
permalink: automated-index-management-conditions-overview
layout: docs
edition: community
description: How conditions work in AIM
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Conditions Overview
{: .no_toc}

{% include toc.md %}

## Basics

Conditions check index parameters to determine if the step actions have to be executed and if the next step can be entered.
Steps can contain no, one or multiple conditions.
If a step has multiple conditions at least one condition has to be met in order to execute the step.

Every condition has a `type` field that defines the condition type and one additional threshold parameter.

## Available Conditions

Supported conditions are:
- [age](conditions_age.md): Triggers the step execution if the index is older than the configured time period.
- [doc_count](conditions_doc_count.md): Triggers the step execution if the number of documents the index contains is larger than the configured number.
- [size](conditions_size.md): Triggers the step execution if the memory size of the index is larger than the configured size.


## Advanced logic

By default, the results of multiple conditions of a step are connected with a logical *or* to determine if a step gets executed.

In case you need two or more conditions to be met in order to execute actions, you can introduce separate check steps that only contain conditions.
This acts as a logic *and*.

### Example

In the following example the `rollover` action would only be executed if the index is larger than 10gb *and* the index is older than 30 days:

```json
{
  "steps": [
    {
      "name": "my-check-step",
      "conditions": [
        {
          "type": "size",
          "max_size": "10gb"
        }
      ],
      "actions": []
    },
    {
      "name": "my-step",
      "conditions": [
        {
          "type": "age",
          "max_age": "30d"
        }
      ],
      "actions": [
        {
          "type": "rollover"
        }
      ]
    }
  ]
}
```
