---
title: Email Actions
html_title: Creating Email Actions for Signals Alerting
slug: elasticsearch-alerting-actions-email
category: actions
order: 200
layout: docs
edition: community
description:
---

<!--- Copyright 2020 floragunn GmbH -->

# Email Action
{: .no_toc}

{% include toc.md %}

Use e-mail actions to send e-mail notifications from watches. You can use Mustache templates to define dynamic content for mail subject and content.

## Prerequisites

In order to use e-mail actions, you need to configure an SMTP server using the [accounts registry](accounts.md) of Signals.

## Basic Functionality

A basic e-mail action looks like this:

<!-- {% raw %} -->
```json
 {
	"actions": [
		{
			"type": "email",
			"name": "my_email_action",
			"throttle_period": "1h",
			"account": "internal_mail",
			"to": "notify@example.com",
			"subject": "Bad destination weather for {{data.bad_weather_flights.hits.total.value}} flights over last {{data.constants.window}}!",
			"text_body": "Flight Number: {{data.source.FlightNum}}\n  Route: {{data.source.OriginAirportID}} -> {{data.source.DestAirportID}}",
			"html_body": "<p>Flight Number: {{data.source.FlightNum}}\n  Route: {{data.source.OriginAirportID}} -> {{data.source.DestAirportID}}</p>",
            "attachments" : {
                "attachment.txt" : {
                  "type" : "<runtime|request>",
                  "request": {
                    "method": "GET",
                    "url": "https://my.test.web.hook/report"
                    }
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

**account:** Identifies the SMTP server and account which shall be used for sending the email. See the [accounts registry documentation](accounts.md).

**to:** Specifies the e-mail address of the recipient of the mail. Multiple recipients can be specified by using an array. Optional. Falls backs to defaults set in the account configuration.

**cc, bcc:** Further recipient email addresses can be specified using the attributes `cc` and `bcc`. Optional. Falls backs to defaults set in the account configuration.

**from:** Specifies the *from* address of the e-mail.  Optional. Falls backs to defaults set in the account configuration.

**subject:** Defines the subject of the mail. Mustache templates can be used to render attributes from the watch runtime data. Required.

**text_body:** Defines the content of the mail as plain text. Mustache templates can be used to render attributes from the watch runtime data.

**html_body:** Defines the content of the mail as HTML. Mustache templates can be used to render attributes from the watch runtime data.

**attachments** Defines which attachments to be included. See [Request](#Request) for details.

**attachments.name** Name of the attachment to be included, e.g. 'report.pdf'.

**attachments.type** Currently you can attach the Signal runtime as JSON ('runtime') and any arbitrary response from a HTTP request ('request'). Multiple attachments are allowed. See [Request](#Request) for details.

**attachments.request** You can include the response of any arbitrary HTTP request to the sent mail as an attachment, e.g. include a PDF, JSON or a CSV file from an endpoint to the sent mail. 

**attachments.request.method:** Specifies the HTTP request method. Required. One of `GET`, `POST`, `PUT` or `DELETE`.

**attachments.request.url:** The URL of the HTTP endpoint. Required.
  
**attachments.request.path:** Overrides the path of the specified URL. Can be used to specify dynamic paths using Mustache templates. Optional.
  
**attachments.request.query_params:** Overrides the query part of the specified URL. Can be used to specify dynamic queries using Mustache templates. Optional.
  
**attachments.request.body:** The body of the HTTP request. Optional. Mustache templates can be used to render attributes from the watch runtime data.
  
**attachments.request.headers:** Specifies HTTP headers to be sent along the request. Optional.
  
**attachments.request.auth:** Optional. The authentication method for the HTTP request. See [Authentication](#authentication) for details.

**attachments.tls:** Configuration for TLS connections. See [TLS](#tls) for details.

Please note that it is mandatory to specify at least one `text_body` or a `html_body`. You can of course provide both, a `text_body` and a `html_body` inside an email action.

## Request

You can include the response of arbitrary HTTP requests to the sent mail as an attachment, e.g. include a PDF, JSON or a CSV file from an endpoint to the sent mail.

### Authentication

Right now, Signals directly supports [basic authentication](#basic-authentication) and [TLS client certificate authentication](#tls) when connecting to HTTP resources. If you need a token-based authentication scheme, you should be able use the `request.headers` option to set the appropriate HTTP headers.

#### Basic Authentication

Basic authentication credentials are being configured in the `auth` section of the `attachment.request` configuration. Configuring basic auth looks like this:

```json
{
  "actions": [{
    "type": "email",
    "name": "my_email_action",
    "throttle_period": "1h",
    "account": "internal_mail",
    "to": "notify@example.com",
    "subject": "Bad destination weather for {{data.bad_weather_flights.hits.total.value}} flights over last {{data.constants.window}}!",
    "text_body": "Flight Number: {{data.source.FlightNum}}\n  Route: {{data.source.OriginAirportID}} -> {{data.source.DestAirportID}}",
    "attachments" : {
      "some_text_file.txt": {
        "type": "request",
        "request": {
            "url": "https://my.test.web.hook/",
            "method": "GET",
            "auth": {"type":"basic","username":"admin","password":"admin"}
        }
      }
    }
  }]
}
```

**Note:** In the current version, the password is stored unencrypted and returned in verbatim when the watch is retrieved using the REST API. Future versions will provide a more secure way of storing authentication data.

### TLS

You can configure both the trusted certificates and client certificates that shall be used when creating TLS connections.

If you do not provide an explicit configuration, the defaults configured for the JVM in which ES is running will be used.

**Note:** Right now, certificates have to be specified in PEM format in-line in the watch configuration. Future versions will provide a more secure way of storing certificates.

A TLS configuration might look like this:

```json
{
  "actions": [{
    "type": "email",
    "name": "my_email_action",
    "throttle_period": "1h",
    "account": "internal_mail",
    "to": "notify@example.com",
    "subject": "Bad destination weather for {{data.bad_weather_flights.hits.total.value}} flights over last {{data.constants.window}}!",
    "text_body": "Flight Number: {{data.source.FlightNum}}\n  Route: {{data.source.OriginAirportID}} -> {{data.source.DestAirportID}}",
    "attachments" : {
      "some_text_file.txt": {
        "type": "request",
        "request": {
            "url": "https://my.test.web.hook/",
            "method": "GET"
        },
        "tls": {
          "trusted_certs": "-----BEGIN CERTIFICATE-----\n....\n-----END CERTIFICATE-----\n",
          "client_auth": {
            "certs": "-----BEGIN CERTIFICATE-----\n....\n-----END CERTIFICATE-----\n",
            "private_key": "-----BEGIN ENCRYPTED PRIVATE KEY-----\n...\n-----END ENCRYPTED PRIVATE KEY-----\n",
            "private_key_password": "secret"
          }
        }
      }
    }
  }]
}
```

**tls.trusted_certs:** An array of certificats in PEM format. If you only have one cert, you can also specify it directly as string without an array. Optional.

**tls.client_auth:** If you want to use TLS client certificate authentication, you have to specify the certificate, its private key and the password for the private key here. Optional.

**tls.verify_hostnames:** If true, it is checked that a presented certificate actually belongs to the name of the host we are connecting to. Optional, defaults to false.

**tls.trust_all:** Trust any presented certificate. Thus, the authenticity of the host we are connecting to won't be verified. *This option should be only used for testing purposes, as the security of the connection cannot be guaranteed.* Optional, defaults to false.


### Security Considerations

Keep in mind that webhook actions allow to send arbitrary HTTP requests from Elasticsearch nodes. This can be limited using the Signals setting `http.allowed_endpoints`. See the section on [Administration](administration.md) for details.
