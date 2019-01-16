---
title: Compliance event routing
html_title: Event routing
slug: compliance-event-routing
category: compliance
order: 500
layout: docs
edition: compliance
description: How to configure event routing to ship the compliance events to their correct storage destination
---
<!---
Copyright 2017 floragunn GmbH
-->

# Event routing and multiple endpoints
{: .no_toc}

{% include_relative _includes/toc.md %}

The Search Guard Compliance Edition extends the storage capabilities of the Audit Log module and makes it possible to configure multiple endpoints per event category.

For example, this makes it possible to store compliance related events in a data lake, while shipping security related events to a SIEM system like SIEMonster or ArcSight.

Events can also be routed to multiple storage endpoints at the same time. Combined with the possibility to filter events, this allowes for very flexible storage configuration settings.

## Configuring the default storage endpoint

If you are already familiar with audit logging, you know that you can configure the endpoint used for storing the events in elasticsearch.yml like:

<pre>
searchguard:
  audit:
    threadpool:
      size: 10
    ignore_users:
      - kibanaserver
    <b>type: internal_elasticsearch
    config:
      index: "auditlog-default"</b>
</pre>

The event routing module is backwards compatible with this configuration, so there are no changes involved. The only difference is that this endpoint becomes the *default storage endpoint*: If there are no specific endpoint configured for a particular event, it will be stored on the default endpoint.

## Adding new endpoints

You can configure as many endpoints as you need under the `searchguard.audit.endpoints` configuration key:

```
searchguard:
  audit:
    endpoints:
      [endpoint name]:
        type: [endpoint type]
        config: [endpoint configuration]
      [endpoint name]:
        type: [endpoint type]
        config: [endpoint configuration]
```

| Name | Description |
|---|---|
| endpoint name | A telling name for the endpoint used to reference it in the routing configuration. Must be unique.|
| endpoint type | Any [supported endpoint type](auditlogging_storage.md) |
| endpoint configuration | The configuration for the configured endpoint, individual for each type. |

The configuration settings are specific for each endpoint. For a reference, please refer to the [audit storage documentation](auditlogging_storage.md).

### Example

The following example configures the default endpoint and three additional ones:

```
searchguard:
  audit:
    type: internal_elasticsearch
    config:
      index: "auditlog-default"
    endpoints:
      failed_login:
        type: internal_elasticsearch
        config:
          index: "auditlog-failedlogin"
      granted_privileges:
        type: internal_elasticsearch
        config:
          index: "auditlog-granted"
      missing_privileges:
        type: external_elasticsearch
        config:
          index: "auditlog-missing"
          http_endpoints: ["sgssl-0.example.com:9200", "sgssl-1.example.com:9200"]
          username: admin
          password: admin
          enable_ssl: true
          verify_hostnames: true
```

### Configuring the fallback endpoint

If an endpoint is not able to store an audit event, for example due to network congestion, Search Guard will store the event on the fallback endpoint instead. By default this is set to `debug`, which means the event is simply printed on standard out.

If you want to use a different endpoint as fallback, simply register it under the name `fallback`:

```
searchguard:
  audit:
    endpoints:
      fallback:
        type: log4j
        config:
          log4j:
            logger_name: fallbacklogger
            level: ERROR
```

**Be sure to always chose a fallback endpoint that is able to store a potentially huge amount of events in a short period of time.** 

## Configuring the event routing

Events can be routed to one or more endpoints by their category. To configure the endpoints for a category, use the following configuration schema:

```
searchguard:
  audit:
    routes:
      [category name]:
        endpoints:
          - [endpoint name]
          - [endpoint name]
          - ...
      [category name]:
        endpoints:
          - [endpoint name]
          - [endpoint name]
          - ...
```

| Name | Description |
|---|---|
| category name | The category for which this routing applies. Must match one of the audit and/or compliance event categories. Must be unique.|
| endpoint name | Name of the endpoint to use. Must be one of the endpoints under the `searchguard.audit.endpoints configuration` settings, or `default`.|

If there is no specific routing for a category defined the events will be send to the `default` endpoint.

If there is a specific routing configured for a category the events will only be send to the configured endpoints. If the event should also be stored on the default endpoint, you need to add it explicitely.

### Example

```
searchguard:
  audit:
    routes:
      FAILED_LOGIN:
        endpoints:
          - failed_login
          - default
      MISSING_PRIVILEGES:
        endpoints:
          - missing_privileges
      GRANTED_PRIVILEGES:
        endpoints:
          - granted_privileges
```