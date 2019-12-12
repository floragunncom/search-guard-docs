---
title: HTTP
html_title: Creating HTTPP inputs for Signals Alerting
slug: elasticsearch-alerting-inputs-http
category: inputs
order: 300
layout: docs
edition: community
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# HTTP input
{: .no_toc}

{% include toc.md %}


An HTTP input pulls in data by accessing an HTTP endpoint. Most commonly, this will be a REST API. 

All data from all inputs can be combined by using [Transformation](transformations_transformations.md) and [Calculations](transformations_calculations.md), used in [Conditions](conditions.md) and pushed to [action endpoints](actions.md).

For example, if you aggregate data from the [Search Guard Audit Log](auditlog), you can  use an HTTP input to retrieve Geo Data information for the logged IP adresses and enrich the data from the audit log.

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
| request.method | One of: GET, PUT, POST, DELETE |
| request.auth | Optional. The authentication method for the HTTP request. |
| request.body | The body of the HTTP request. Optional. Mustache templates can be used to render attributes from the watch runtime data. |

## Accessing HTTP input data in the execution chain

In this example, the return values from the HTTP call can be accessed in later execution steps like:

```
data.samplejson.mykey
```

## Dynamic Endpoints

The HTTP endpoint in the `request.url` attribute cannot be changed dynamically directly. However, you can use the configuration attributes `request.path` and `request.query_params` to define the respective parts of the URL using Mustache templates. The resulting path and/or query parameters then override the respective parts of the URL defined in `request.url`.



```json
{
  "trigger": { ... },
  "checks": [{
    "type": "http",
    "name": "testhttp",
    "target": "samplejson",
    "request": {
      "method": "GET",
      "url": "https://jsonplaceholder.typicode.com/",
      "path": "todos/{{data.todo_no}}",
      "auth": {"type":"basic","username":"admin","password":"admin"}
    }
  }],
  "actions": [ ... ]
}
```


## Authentication

Authentication credentials are configured in the `auth` section if the `request` configuration. At the time of writing, the only authentication method is HTTP Basic Authentication.

### Technical Preview Limitations
In the current version of the tech preview, the password is stored unencrypted and returned in verbatim when the watch is retrieved using the REST API. Future versions will provide a more secure way of storing authentication data.

## Advanced Functionality

Furthermore, HTTP inputs provide these configuration options:

**connection_timeout:** Specifies the time after which the try to create an connection shall time out. Optional. Specified in seconds.

**read_timeout:** Specifies the timeout for reading the response data after a connection has been already established. Optional. Specified in seconds.

## Security Considerations

Keep in mind that webhook actions allow to send arbitrary HTTP requests from Elasticsearch nodes. We are working on mechanisms to define restrictions on the use of webhook actions and the allowed endpoints.
