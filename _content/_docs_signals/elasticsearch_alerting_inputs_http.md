---
title: HTTP Input
html_title: HTTP Data Input
permalink: elasticsearch-alerting-inputs-http
layout: docs
edition: community
description: Signals Alerting for Elasticsearch can pull in data from any REST HTTP
  endpoint make it available to watches and conditions.
---
<!--- Copyright 2022 floragunn GmbH -->

# HTTP input
{: .no_toc}

{% include toc.md %}


An HTTP input pulls in data by accessing an HTTP endpoint. Most commonly, this will be a REST API.

All data from all inputs can be combined by using [Transformation](elasticsearch-alerting-transformations) and [Calculations](elasticsearch-alerting-calculations), used in [Conditions](elasticsearch-alerting-conditions) and pushed to [action endpoints](elasticsearch-alerting-actions-overview).

For example, if you aggregate data from the [Search Guard Audit Log](audit-logging-compliance), you can  use an HTTP input to retrieve Geo Data information for the logged IP addresses and enrich the data from the audit log.

## Example

```json
{
  "checks": [{
    "type": "http",
    "name": "testhttp",
    "target": "samplejson",
    "request": {
      "url": "https://jsonplaceholder.typicode.com/todos/1",
      "method": "GET",
      "headers": {"My-Secret-Token": "pizza"}
    }
  }]
}
```

**type:** `http`, defines this input as HTTP input type

**target:** the name under which the data is available in later execution steps.

**request.url:** The URL for this HTTP input. Mandatory.

**request.path:** Overrides the path of the specified URL. Can be used to specify dynamic paths using Mustache templates. Optional.

**request.query_params:** Overrides the query part of the specified URL. Can be used to specify dynamic queries using Mustache templates. Optional.

**request.method:** One of: GET, PUT, POST, DELETE

**request.auth:** Optional. The authentication method for the HTTP request. See [Authentication](#authentication) for details.

**request.body:** The body of the HTTP request. Optional. Mustache templates can be used to render attributes from the watch runtime data. `request.body` and `request.json_body_from` are mutually exclusive.

**request.json_body_from:** The body of the HTTP request. Optional. It should be a valid [JsonPath](https://goessner.net/articles/JsonPath/) expression which refers to the structure of the watch runtime data. Specifies which subtrees of the watch runtime data should be serialized to JSON and used as a request body. `request.json_body_from` and `request.body` are mutually exclusive.

**request.headers:** Additional HTTP headers to be sent to the end point specified as an object of key-value pairs. Optional. Starting with Search Guard FLX 1.2, Mustache templates can be used to render attributes from the watch runtime data.

**tls:** Configuration for TLS connections. See [TLS](#tls) for details.

**connection_timeout:** Specifies the time after which the try to create an connection shall time out. Optional. Specified in seconds.

**read_timeout:** Specifies the timeout for reading the response data after a connection has been already established. Optional. Specified in seconds.

**proxy:** Specifies the proxy through which outgoing requests will be routed. One of: `default`, `none`, an HTTP URL or (starting with Search Guard FLX 1.6.0) the `id` of the [proxy added previously](elasticsearch-alerting-proxies) with the REST API. 

## Accessing HTTP input data in the execution chain

In this example, the return values from the HTTP call can be accessed in later execution steps like:

```
data.samplejson.mykey
```

## Dynamic Endpoints

The HTTP endpoint in the `request.url` attribute cannot be changed dynamically directly. However, you can use the configuration attributes `request.path` and `request.query_params` to define the respective parts of the URL using Mustache templates. The resulting path and/or query parameters then override the respective parts of the URL defined in `request.url`.


<!-- {% raw %} -->
```json
{
  "checks": [{
    "type": "http",
    "name": "testhttp",
    "target": "samplejson",
    "request": {
      "method": "GET",
      "url": "https://jsonplaceholder.typicode.com/",
      "path": "todos/{{data.todo_no}}",
    }
  }]
}
```
<!-- {% endraw %} -->


## Authentication

Right now, Signals directly supports [basic authentication](#basic-authentication) and [TLS client certificate authentication](#tls) when connecting to HTTP resources. If you need a token-based authentication scheme, you should be able use the `request.headers` option to set the appropriate HTTP headers.

### Basic Authentication

Basic authentication credentials are configured in the `auth` section if the `request` configuration. Configuring basic auth looks like this:

```json
{
  "checks": [{
    "type": "http",
    "name": "testhttp",
    "target": "samplejson",
    "request": {
      "url": "https://jsonplaceholder.typicode.com/todos/1",
      "method": "GET",
      "auth": {"type":"basic","username":"admin","password":"admin"}
    }
  }]
}
```

**Note:** In the current version, the password is stored unencrypted and returned in verbatim when the watch is retrieved using the REST API. Future versions will provide a more secure way of storing authentication data.

## TLS

You can configure both the trusted certificates and client certificates that shall be used when creating TLS connections.

If you do not provide an explicit configuration, the defaults configured for the JVM in which ES is running will be used.

**Note:** Right now, certificates have to be specified in PEM format in-line in the watch configuration. Future versions will provide a more secure way of storing certificates.

A TLS configuration might look like this:

```json
{
  "checks": [{
    "type": "http",
    "name": "testhttp",
    "target": "samplejson",
    "request": {
      "url": "https://jsonplaceholder.typicode.com/todos/1",
      "method": "GET",
    },
    "tls": {
      "trusted_certs": "-----BEGIN CERTIFICATE-----\n....\n-----END CERTIFICATE-----\n",
      "client_auth": {
        "certs": "-----BEGIN CERTIFICATE-----\n....\n-----END CERTIFICATE-----\n",
        "private_key": "-----BEGIN ENCRYPTED PRIVATE KEY-----\n...\n-----END ENCRYPTED PRIVATE KEY-----\n",
        "private_key_password": "secret"
      }
    }
  }]
}
```

**tls.trusted_certs:** An array of certificates in PEM format. If you only have one cert, you can also specify it directly as string without an array. Optional.

**tls.client_auth:** If you want to use TLS client certificate authentication, you have to specify the certificate, its private key and the password for the private key here. Optional.

**tls.verify_hostnames:** If true, it is checked that a presented certificate actually belongs to the name of the host we are connecting to. Optional, defaults to false.

**tls.trust_all:** Trust any presented certificate. Thus, the authenticity of the host we are connecting to won't be verified. *This option should be only used for testing purposes, as the security of the connection cannot be guaranteed.* Optional, defaults to false.

**tls.truststore_id** The `id` of the [trust store uploaded previously](elasticsearch-alerting-trust-stores) with the REST API. All certificates from the trust store are considered trusted. The parameter is optional and mutually exclusive with `tls.trusted_certs`.

**tls.client_session_timeout** Define a TLS session timeout, please see [TLS session timeout](elasticsearch-alerting-trust-stores#tls-session-timeout).

## Security Considerations

Keep in mind that HTTP inputs allow to send arbitrary HTTP requests from Elasticsearch nodes. This can be limited using the Signals setting `http.allowed_endpoints`. See the section on [Administration](elasticsearch-alerting-administration) for details.
