---
title: Accounts
html_title: Using Accounts for Signals Alerting
slug: elasticsearch-alerting-accounts
category: actions
order: 50
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

* Make account data reusable thus avoiding configuring the same accounts again and again for each watch.
* Storing credentials for these accounts safely.
* Controlling which external resources can be used by watches.

While watches may be configured by a wide range of users, accounts shall be only defined by administrators. Normal users will then be able to use the predefined accounts.

## Account Types

### E-Mail Accounts

E-mail accounts represent connection data and credentials for SMTP servers. 

A typical e-mail account looks like this:

```json
{
	"host": "smtp.example.com",
	"port": 465,
	"user": "signals",
	"password": "secret",
	"enable_tls": true,
	"default_from": "signals@example.com",
	"default_bcc": "signals@example.com"
}
```

| Name | Description |
|---|---|
| host | The hostname of the SMTP server to connect to. Required. |
| port | The number of the port to connect to. Required. |
| user | The user name used for authentication. Optional. |
| password | The password user for authentication. Optional. |
| enable\_tls | If true, the connection is established by TLS. |
| enable\_start\_tls | If true, the connection is established using STARTTLS. |
| trusted_hosts | Only accept server certificates issued to one of the provided host names, *and disables certificate issuer validation.* Optional; array of host names. *Security warning: Any certificate matching any of the provided host names will be accepted, regardless of the certificate issuer; attackers can abuse this behavior by serving a matching self-signed certificate during a man-in-the-middle attack.* |
| trust_all | If true, trust all hosts and don't validate any SSL keys. Optional. |
| default_from | Defines the from address used in e-mails when an e-mail action does not configure an explicit from address. Optional. |
| default\_to, default\_cc, default\_bcc  | Defines the recipient addresses used in e-mails when an e-mail action does not configure an explicit values for the respective recipient types. Optional; array of e-mail addresses |
| session_timeout | Sets the timeout for connecting to and communicating with the SMTP server. Optional; time duration in seconds. |
| proxy\_host, proxy\_port, proxy\_user, proxy\_password | Allows the specification of a SOCKS proxy to connect to the SMTP server. Optional. |
| debug | If true, protocol data is logged to the Elasticsearch log when mails are sent. |

### Slack Accounts

Slack accounts represent webhook URIs for sending messages to Slack Apps.

A Slack account looks rather simple:

```json
{
	"url": "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
}
```

The value for the `url` property must be obtained by creating a Slack App inside Slack. See the [Slack docs](https://api.slack.com/incoming-webhooks) for details.

## REST API

Accounts may be managed using these REST API endpoints:

* [Get Account](rest_api_account_get.md)
* [Put Account](rest_api_account_put.md)
* [Delete Account](rest_api_account_delete.md)
* [Search Account](rest_api_account_search.md)


