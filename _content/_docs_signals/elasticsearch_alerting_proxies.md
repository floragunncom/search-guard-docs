---
title: Proxies
html_title: Proxies
permalink: elasticsearch-alerting-proxies
layout: docs
section: alerting
edition: community
description: How to use proxies
---
<!--- Copyright 2023 floragunn GmbH -->

# Proxies
{: .no_toc}

{% include toc.md %}

Some Signals' actions (e.g. [Webhook action](elasticsearch-alerting-actions-webhook)) and [HTTP Input](elasticsearch-alerting-inputs-http)
may need an HTTP proxy to connect to the target endpoint. If neither the action or input nor the global Signals settings configure a proxy,
requests are sent directly to the target endpoint, which in this case may be inaccessible. To overcome this inconvenience, 
it is possible to define which proxy should be used by a Signals component to route requests. An example of 
such a configuration is visible below.

```json
{
  "proxy": "http://127.0.0.1:8090"
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

## Proxy values

The `proxy` attribute is supported by [Webhook](elasticsearch-alerting-actions-webhook), [Jira](elasticsearch-alerting-actions-jira) and [PagerDuty](elasticsearch-alerting-actions-pagerduty) actions, by the [HTTP Input](elasticsearch-alerting-inputs-http), and by [email](elasticsearch-alerting-actions-email) attachments of type `request`. Slack actions always use the global proxy. The SMTP connection of email actions uses the proxy settings of the email [account](elasticsearch-alerting-accounts), not the proxies described here.

Signals interprets the value of the `proxy` attribute as follows (case-insensitive):

| Value | Meaning |
|---|---|
| Not set, empty or `default` | Use the global proxy from the Signals setting `http.proxy`. If it is not set, connect directly. |
| `none` | Connect directly, even if a global proxy is configured. |
| Starts with `http:` or `https:` | Use this proxy URL, e.g. `http://proxy.example.com:3128`. |
| Anything else | The ID of a proxy added with the [REST API](#proxy-management). |
{: .config-table}

A value that is neither a keyword nor starts with `http:` or `https:` is always treated as a proxy ID. For example, `127.0.0.1:9199` is not a valid proxy URL, but the ID of a proxy that most likely does not exist. When a watch is created or updated, Signals rejects IDs of proxies that do not exist with the error *Http proxy '&lt;id&gt;' not found*.

Signals refuses to delete a proxy that is still used by a watch. If a watch references a proxy that does not exist when Signals loads the watch, for example after the watch was restored from a backup, the action or input connects without that proxy and Signals logs a warning.

## Selecting a proxy in Kibana

In Kibana, webhook actions have a **Proxy** field that offers **Default**, **None** and the stored proxies. See [Selecting a proxy in Kibana](elasticsearch-alerting-actions-webhook#selecting-a-proxy-in-kibana).

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
      "proxy": "http://127.0.0.1:9199"
    }
  ],
  "active": true,
  "log_runtime_data": false,
  "_meta": {}
}
```
