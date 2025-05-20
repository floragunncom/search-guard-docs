---
title: Proxies
html_title: Proxies
permalink: elasticsearch-alerting-proxies
layout: docs
edition: community
description: How to use proxies
---
<!--- Copyright 2023 floragunn GmbH -->

# Proxies
{: .no_toc}

{% include toc.md %}

Some Signals' actions (e.g. [Webhook action](elasticsearch-alerting-actions-webhook)) and [HTTP Input](elasticsearch-alerting-inputs-http)
may need an HTTP proxy to connect to the target endpoint. If no additional proxy configuration is provided for the action or input then
requests will be sent directly to the target endpoint, which in this case may be inaccessible. To overcome this inconvenience, 
it is possible to define which proxy should be used by a Signals component to route requests. An example of 
such a configuration is visible below.

```json
{
  "proxy": "http://localhost:127.0.0.1:8090"
}
```

The above configuration directly defines proxy which is present in the field `proxy`. This means that it might be necessary to update 
such configuration in many various Signals components when the proxy address changes.

To simplify proxy management Search Guard offers a REST API which can be used for proxies management. The proxies are created
via the REST API and then referenced by id in the configuration like in the below example
```json
{
  "proxy": "my-proxy-id"
}
```

The proxy can be modified with the REST API and all Signals components which referenced the proxy by id will start using the newer configuration
on the fly.

Signals supports also global configuration of an HTTP proxy which is used for all Signals actions and checks which create HTTP connections.
This global configuration may be overridden on action or check level as described above. 

The global proxy can be configured via [REST API](elasticsearch-alerting-rest-api-settings-put), using the Signals setting `http.proxy`. 

## Proxy management

The following REST API is defined to perform CRUD (create, read, update, delete) operations on the proxies.
* [Get one proxy](elasticsearch-alerting-rest-api-proxy-get-one)
* [Get all proxies](elasticsearch-alerting-rest-api-proxy-get-all)
* [Create or replace proxy](elasticsearch-alerting-rest-api-proxy-create-or-replace)
* [Delete proxy](elasticsearch-alerting-rest-api-proxy-delete)

REST API for managing global Signals settings.
* [Put global setting](elasticsearch-alerting-rest-api-settings-put)

## Example
The following watch uses proxy in the [HTTP Input](elasticsearch-alerting-inputs-http) and 
[Webhook action](elasticsearch-alerting-actions-webhook) configuration.
```json
{
  "trigger": {
    "schedule": {
      "interval": [
        "30s"
      ]
    }
  },
  "actions": [
    {
      "type": "webhook",
      "name": "testhook",
      "throttle_period": "0",
      "request": {
        "method": "GET",
        "url": "http://localhost:8080/test"
      },
      "proxy": "my-proxy-id"
    }
  ],
  "checks": [
    {
      "type": "http",
      "name": "testhttp",
      "target": "samplejson",
      "request": {
        "url": "http://localhost:8080/test",
        "method": "GET"
      },
      "proxy": "127.0.0.1:9199"
    }
  ],
  "active": true,
  "log_runtime_data": false,
  "_meta": {}
}
```
