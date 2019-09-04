---
title: Accounts
html_title: Using Accounts for Signals Alerting
slug: elasticsearch-alerting-accounts
category: signals
subcategory: accounts
order: 790
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Accounts Registry
{: .no_toc}

{% include toc.md %}

## Basics

If you want to use e-mail or Slack actions, you have to configure accounts in the accounts registry beforehand. 

The purpose of the account registry is to:

* Make account data reusable and thus avoid configuring the same accounts again and again for each watch.
* Storing credentials for these accounts safely.
* Controlling which external resources can be used by watches.

While watches may be configured by a wide range of users, accounts shall be only defined by administrators. Normal users will then be able to use the predefined accounts.

## Account Types

The different account types are document in the following sections.

### E-Mail Accounts

E-mail accounts represent connection data and credentials for SMTP servers. 

A typical e-mail account looks like this:

```json
{
	"type": "email",
	"host": "smtp.example.com",
	"port": 465,
	"user": "signals",
	"password": "secret",
	"enable_tls": true,
	"default_from": "signals@example.com",
	"default_bcc": "signals@example.com"
}
```

These properties are available: 

**host:** The hostname of the SMTP server to connect to. Required.

**port:** The number of the port to connect to. Required.

**user:** The user name used for authentication. Optional.

**password:** The password user for authentication. Optional.

**enable_tls:** If true, the connection is established by TLS.

**enable_start_tls:** If true, the connection is established using STARTTLS.

**trusted_hosts:** Only accept server certificates issued to one of the provided hostnames, *and disables certificate issuer validation.* Optional; array of host names.
*Security warning: Any certificate matching any of the provided host names will be accepted, regardless of the certificate issuer; attackers can abuse this behavior by serving a matching self-signed certificate during a man-in-the-middle attack.*

**trust_all:** If true, trust all hosts and don't validate any SSL keys. Optional.

**default_from:** Defines the from address used in e-mails when an e-mail action does not configure an explicit from address. Optional.

**default_to, default_cc, default_bcc:** Defines the recipient addresses used in e-mails when an e-mail action does not configure an explicit values for the respective recipient types. Optional; array of e-mail addresses.

**session_timeout:** Sets the timeout for connecting to and communicating with the SMTP server. Optional; time duration in seconds.

**proxy_host, proxy_port, proxy_user, proxy_password:** Allows the specification of a SOCKS proxy to connect to the SMTP server. Optional.

**debug:** If true, protocol data is logged to the Elasticsearch log when mails are sent.

### Slack Accounts

Slack accounts represent webhook URIs for sending messages to Slack Apps.

A Slack account looks rather simple:

```json
{
	"type": "slack",
	"url": "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
}
```

The value for the `url` property must be optained by creating a Slack App inside Slack. See the [Slack docs](https://api.slack.com/incoming-webhooks) for details.

## REST API

Accounts may be managed using these REST API endpoints:

* [GET Account](rest_api_destination_get.md)
* [PUT Account](rest_api_destination_put.md)
* [DELETE Account](rest_api_destination_delete.md)
* [Search Account](rest_api_destination_search.md)


