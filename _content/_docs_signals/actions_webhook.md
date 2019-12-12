---
title: Webhook Actions
html_title: Creating Webhook Actions for Signals Alerting
slug: elasticsearch-alerting-actions-webhook
category: actions
order: 300
layout: docs
edition: community
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Webhook Action
{: .no_toc}

{% include toc.md %}

Use webhook actions to call arbitrary HTTP endpoints from watches. You can use Mustache templates to define parts of the URI and the request body.

## Basic Functionality

A basic webhook action looks like this:

```json
 {
     /* ... */ 
 
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

The basic configuration attributes are:

**name:** A name identifying this action. Required.

**checks:** Further checks which can gather or transform data and decide whether to execute the actual action. Optional.

**throttle_period:** The throttle period. Optional. Specify the time duration using an *amount*, followed by its *unit*. Supported units are m (minutes), h (hours), d (days), w (weeks). For example, `1h` means one hour.

**request.method:** Specifies the HTTP request method. Required. One of `GET`, `POST`, `PUT` or `DELETE`.

**request.url:** The URL of the HTTP endpoint. Required.

**request.body:** The body of the HTTP request. Optional. Mustache templates can be used to render attributes from the watch runtime data. 

**request.headers:** Specifies HTTP headers to be sent along the request. Optional.

## Dynamic Endpoints

The HTTP endpoint in the `request.url` attribute cannot be changed dynamically directly. However, you can use the configuration attributes `request.path` and `request.query_params` to define the respective parts of the URL using Mustache templates. The resulting path and/or query parameters then override the respective parts of the URL defined in `request.url`.

```json
 {
    /* ... */ 
 
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

## Authentication

You can use the `auth` attribute to specify HTTP basic auth data.

```json
 {
    /* ... */ 
 
	"actions": [
		{
			"type": "webhook",
			"name": "my_webhook_action",
			"throttle_period": "10m",
			"request": {
				"method": "POST",
				"url": "https://my.test.web.hook/",
				"auth": {
					"type": "basic",
					"username": "test",
					"password": "test"
				}
			}
		}
	]
}
```

**Note:** In the current version of the tech preview, the password is stored unencrypted and returned in verbatim when the watch is retrieved using the REST API. Future versions will provide a more secure way of storing authentication data.

## Advanced Functionality

Furthermore, webhook actions provide these configuration options:

**connection_timeout:** Specifies the time after which the try to create an connection shall time out. Optional. Specified in seconds.

**read_timeout:** Specifies the timeout for reading the response data after a connection has been already established. Optional. Specified in seconds.

## Security Considerations

Keep in mind that webhook actions allow to send arbitrary HTTP requests from Elasticsearch nodes. We are still working on mechanisms to define restrictions on the use of webhook actions and the allowed endpoints.

