---
title: Transformations
html_title: Transformation Scripts
permalink: elasticsearch-alerting-transformations
category: transformations
order: 100
layout: docs
edition: community
description: Signals Alerting uses the Elasticsearch Painless scripting language for transforming data.
---

<!--- Copyright 2020 floragunn GmbH -->

# Transformations
{: .no_toc}

{% include toc.md %}

A transformation is a script that

* has access to the runtime data
* performs one or more painless statements
* replaces the runtime data in the `target` context  

As opposed to [Calculations](transformations_calculations.md), Transformation scripts have a return statement and need to define the target context where the transformed values are written back to.

If the target context already exists, it is overwritten. If not, a new one is created.

Transformations can be used

* in the `check`s section of a watch definition
  * the transformation is executed before any actions are executed. Changes to the execution context runtime data are visible for all subsequent steps and for all actions
* in the `check`s section of any action
  * the transformation is executed before the action is executed. Changes to the execution context runtime data are only applied for that specific action.

A transformation painless script can be defined as inline script within the transformation definition.

For example, the next transformation accesses a runtime context that has stored an Elasticsearch query result. It will replace the context data with only the `hit`s of the search result, discarding all other data like total hits or execution time

```
{
  "type": "transform",
  "name": "extract_search_hits",
  "target": "mysearchresult"
  "source": "return data.logs.hits.hits;"
}
```

| Name | Description |
|---|---|
| type | transform, defines this script as transformation. Mandatory. |
| name | name of this transformation. Can be chosen freely. Mandatory. |
| target | Under which context name to store the result of the transformation in the runtime data. If the context already exists, it is replaced. If it does not exist, a new contect is created. If omitted, the top-level context will be used. |
| source | The script to execute. Mandatory |
| lang | The scripting language to be used. Optional, defaults to painless. Other scripting languages may be provided by Elasticsearch plugins. |
{: .config-table}

## Accessing the runtime data

All scripts have full access to the runtime data. The data in the execution context is available via the `data` prefix.

## Using transformations with actions

Transformations can also be used with actions. Each action can define it's own chain of `check`s, including transformation.

The next example runs a transformation that extracts the hits from an Elasticsearch result set prior to writing it back to another Elasticsearch index via an [Index Action](actions_index.md).

```
{
  "trigger":{},
  "checks":[],
  "actions":[
    {
      "type": "index",
      "name": "store_cleaned_data",
      "checks": [
        {
          "type": "transform",
          "name": "extract_search_hits",
          "target": "mysearchresult"
          "script_id": "extract_hits"
        }
      ],
      "index": "signals-data"
    }
  ]
}
```
