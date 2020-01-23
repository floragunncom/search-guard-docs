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
			"text_body": "Flight Number: {{data.source.FlightNum}}\n  Route: {{data.source.OriginAirportID}} -> {{data.source.DestAirportID}}"
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

**text_body:** Defines the content of the mail. Mustache templates can be used to render attributes from the watch runtime data. Optional.
