---
title: Webhook Actions
html_title: Webhook Actions
slug: elasticsearch-alerting-actions-webhook
category: actions
order: 300
layout: docs
edition: community
description: Signals Alerting for Elasticsearch can send notifications to webhooks in case it detects anomalies in your data

---

<!--- Copyright 2020 floragunn GmbH -->

# Webhook Action
{: .no_toc}

{% include toc.md %}

Use webhook actions to call arbitrary HTTP endpoints from watches. You can use Mustache templates to define parts of the URI and the request body.

## Basic Functionality

A basic webhook action looks like this:

<!-- {% raw %} -->
```json
 {
	"actions": [
		{
			"type": "webhook",
			"name": "my_webhook_action",
			"throttle_period": "10m",
			"request": {
				"method": "POST",
				"url": "https://my.test.web.hook/endpoint",
				"body": "{\"flight_number\": \"{{data.source.FlightNum}}\"}",
				"headers": {
					"Content-Type": "application/json"
				}
			}
		}
	]
}
```
<!-- {% endraw %} -->

The basic configuration attributes are:

**name:** A name identifying this action. Required.

**checks:** Further checks which can gather or transform data and decide whether to execute the actual action. Optional.

**throttle_period:** The throttle period. Optional. Specify the time duration using an *amount*, followed by its *unit*. Supported units are m (minutes), h (hours), d (days), w (weeks). For example, `1h` means one hour.

**request.method:** Specifies the HTTP request method. Required. One of `GET`, `POST`, `PUT` or `DELETE`.

**request.url:** The URL of the HTTP endpoint. Required.

**request.path:** Overrides the path of the specified URL. Can be used to specify dynamic paths using Mustache templates. Optional.

**request.query_params:** Overrides the query part of the specified URL. Can be used to specify dynamic queries using Mustache templates. Optional.

**request.body:** The body of the HTTP request. Optional. Mustache templates can be used to render attributes from the watch runtime data.

**request.headers:** Specifies HTTP headers to be sent along the request. Optional.

**request.auth:** Optional. The authentication method for the HTTP request. See [Authentication](#authentication) for details.

**tls:** Configuration for TLS connections. See [TLS](#tls) for details.

**connection_timeout:** Specifies the time after which the try to create an connection shall time out. Optional. Specified in seconds.

**read_timeout:** Specifies the timeout for reading the response data after a connection has been already established. Optional. Specified in seconds.


## Dynamic Endpoints

The HTTP endpoint in the `request.url` attribute cannot be changed dynamically directly. However, you can use the configuration attributes `request.path` and `request.query_params` to define the respective parts of the URL using Mustache templates. The resulting path and/or query parameters then override the respective parts of the URL defined in `request.url`.

<!-- {% raw %} -->
```json
 {
	"actions": [
		{
			"type": "webhook",
			"name": "my_webhook_action",
			"throttle_period": "10m",
			"request": {
				"method": "POST",
				"url": "https://my.test.web.hook/",
				"path": "fight/{{data.source.FlightNum}}"
			}
		}
	]
}
```
<!-- {% endraw %} -->

## Authentication

Right now, Signals directly supports [basic authentication](#basic-authentication) and [TLS client certificate authentication](#tls) when connecting to HTTP resources. If you need a token-based authentication scheme, you should be able use the `request.headers` option to set the appropriate HTTP headers.

### Basic Authentication

Basic authentication credentials are configured in the `auth` section if the `request` configuration. Configuring basic auth looks like this:

```json
{
  "actions": [{
    "type": "webhook",
    "name": "my_webhook_action",
    "request": {
      "url": "https://my.test.web.hook/",
      "method": "POST",
      "auth": {"type":"basic","username":"admin","password":"admin"}
    }
  }]
}
```

**Note:** In the current version, the password is stored unencrypted and returned in verbatim when the watch is retrieved using the REST API. Future versions will provide a more secure way of storing authentication data.

## TLS

You can configure both the trusted certificates and client certificates that shall be used when creating TLS connections.

If you do not provide an explicit configuration, the defaults configured for the JVM in which ES is running will be used.

**Note:** Right now, certificates have to be specfied in PEM format in-line in the watch configuration. Future versions will provide a more secure way of storing certificates.

A TLS configuration might look like this:

```json
{
  "actions": [{
    "type": "webhook",
    "name": "my_webhook_action",
    "request": {
      "url": "https://my.test.web.hook/",
      "method": "POST",
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

**tls.trusted_certs:** An array of certificats in PEM format. If you only have one cert, you can also specify it directly as string without an array. Optional.

**tls.client_auth:** If you want to use TLS client certificate authentication, you have to specify the certificate, its private key and the password for the private key here. Optional.

**tls.verify_hostnames:** If true, it is checked that a presented certificate actually belongs to the name of the host we are connecting to. Optional, defaults to false.

**tls.trust_all:** Trust any presented certificate. Thus, the authenticity of the host we are connecting to won't be verified. *This option should be only used for testing purposes, as the security of the connection cannot be guaranteed.* Optional, defaults to false.



## Security Considerations

Keep in mind that webhook actions allow to send arbitrary HTTP requests from Elasticsearch nodes. This can be limited using the Signals setting `http.allowed_endpoints`. See the section on [Administration](administration.md) for details.
