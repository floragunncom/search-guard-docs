---
title: Static
html_title: Creating static inputs for Signals Alerting
slug: elasticsearch-alerting-inputs-static
category: inputs
order: 900
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Static inputs
{: .no_toc}

A static input can be used to define global constant values that can be used anywhere in the execution chain.

Example:

```
{
	"trigger": { ... },
	"checks": [
	  {
			"type": "static",
			"name": "constants",
			"target": "myconstants",
			"value": {
				"threshold": 10,
				"time_period": "10s",
				"ping_account": "admins"
			}
		}	],
	"actions": [ ... ]
}
```

| Name | Description |
|---|---|
| type | static, defines this input as static input type|
| target | the name under which the data is available in later execution steps. |
| value | An object defining the constants. |

## Accessing static input data in the execution chain

In this example, the constant values defined in the `value`section can be accessed in later execution steps like:

```
data.myconstants.time_period
```

