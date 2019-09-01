---
title: HTTP
html_title: Creating HTTPP inputs for Signals Alerting
slug: elasticsearch-alerting-inputs-http
category: inputs
order: 200
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# HTTP input
{: .no_toc}

{% include toc.md %}


An HTTP input pulls in data by accessing an HTTP endpoint. Most commonly, this will be a REST API. All data from all inputs can be combined by using [Transformation](transformations_transformations.md) and [Calculations](transformations_calculations.md), used in [Conditions](conditions.md) and pushed to [action endpoints](actions.md).

For example, if you aggregate data from the [Search Guard Audit Log](auditlog), you can  use an HTTP input to retrieve Geo Data information for the logged IP adresses.

## Example

```json
{
  "trigger": { ... },
  "checks": [{
    "type": "http",
    "name": "testhttp",
    "target": "samplejson",
    "request": {
      "url": "https://jsonplaceholder.typicode.com/todos/1",
      "method": "GET",
      "auth": {"type":"basic","username":"admin","password":"admin"}
    }
  }],
  "actions": [ ... ]
}
```

| Name | Description |
|---|---|
| type | http, defines this input as HTTP input type|
| target | the name under which the data is available in later execution steps. |
| request | The HTTP request details |
| request.url | The URL for this HTTP input |
| request.method | One of  GET|PUT|POST|DELETE |
| request.auth | Optional. The authentication method for the HTTP request. |

## Accessing HTTP input data in the execution chain

In this example, the return values from the HTTP call can be accessed in later execution steps like:

```
data.samplejson.mykey
```

## Authentication

Authentication credentials are configured in the `auth` section if the `request` configuration. At the time of writing, the only authentication method is HTTP Basic Authentication.

