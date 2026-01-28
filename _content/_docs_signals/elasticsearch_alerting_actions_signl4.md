---
title: Signl4 Actions
html_title: Signl4 Actions
permalink: elasticsearch-alerting-actions-signl4
layout: docs
section: alerting
edition: community
description: Signals Alerting for Elasticsearch can send mobile alerts to your team
  via Signl4 push notifications, SMS, and voice calls
---
<!--- Copyright 2022 floragunn GmbH -->

# Signl4 Actions
{: .no_toc}

{% include toc.md %}

Use Signl4 actions to send mobile alerts to your team via [Signl4](https://www.signl4.com/). Signl4 provides mobile push notifications, SMS, and voice calls for critical alerts.

## Overview

Signl4 is a mobile alerting service that ensures critical alerts reach the right people via push notifications, SMS, or voice calls. The Signl4 action type in Signals simplifies the configuration by providing:

- A dedicated "Signl4" option in the actions menu
- A pre-configured Events API endpoint with placeholders for your team ID and API key
- A default body format optimized for Signl4

Under the hood, Signl4 actions are webhook actions.

## Prerequisites

Before you can use Signl4 actions, you need:

1. **A Signl4 account** - Sign up at [signl4.com](https://www.signl4.com/)

2. **Your Signl4 Team ID** - To get your team ID:
   - Log in to the [Signl4 portal](https://connect.signl4.com/)
   - Navigate to your team settings
   - Find your **Team ID** (also called Webhook ID)

3. **A Signl4 API Key** - To create an API key:
   - In the Signl4 portal, go to **Integrations** → **API Keys**
   - Create a new API key
   - Copy and save the key securely

The Events API endpoint you'll use is:
```
https://connect.signl4.com/api/v2/events/{webhookIdOrTeamId}
```

## Basic Functionality

### Using the Kibana UI

When creating a watch in the Kibana UI:

1. Click **Add Action** and select **Signl4**
2. Enter a **Name** for your action
3. Replace `{webhookIdOrTeamId}` in the **URL** with your team ID
4. Add your API key in the `X-S4-Api-Key` header
5. Customize the **Body** with your alert message

The default body uses a simple text format that Signl4 parses automatically:

<!-- {% raw %} -->
```
Title: Signals Alert
Message: Watch "{{watch.id}}" was triggered at {{trigger.triggered_time}}
X-S4-ExternalID: {{watch.id}}
X-S4-Service: Security
```
<!-- {% endraw %} -->

### JSON Format

A Signl4 action in JSON format looks like this:

<!-- {% raw %} -->
```json
{
  "actions": [
    {
      "type": "webhook",
      "name": "my_signl4_alert",
      "request": {
        "method": "POST",
        "url": "https://connect.signl4.com/api/v2/events/{webhookIdOrTeamId}",
        "body": "Title: Signals Alert\nMessage: {{data.mysearch.hits.total.value}} hits detected\nX-S4-ExternalID: {{watch.id}}",
        "headers": {
          "Content-Type": "text/plain",
          "X-S4-Api-Key": "your-api-key-here"
        }
      }
    }
  ]
}
```
<!-- {% endraw %} -->

### Configuration Attributes

| Attribute | Description | Required |
|-----------|-------------|----------|
| `type` | Must be `webhook` | Yes |
| `name` | A unique name identifying this action | Yes |
| `request.url` | The Signl4 Events API endpoint including your team ID | Yes |
| `request.body` | The payload to send. Supports Mustache templates. | Yes |
| `request.headers` | HTTP headers, including `X-S4-Api-Key` for authentication | Yes |
{: .config-table}

For additional configuration options such as throttling, authentication, and TLS settings, see [Webhook Actions](elasticsearch-alerting-actions-webhook).

## Customizing the Alert Payload

Signl4 accepts both `text/plain` and `application/json` payloads.

### Text Format (Default)

Use key-value pairs, one per line:

<!-- {% raw %} -->
```
Title: Signals Alert
Message: High error rate: {{data.mysearch.hits.total.value}} errors
X-S4-Service: Signals
X-S4-ExternalID: {{watch.id}}
X-S4-AlertingScenario: single_ack
```
<!-- {% endraw %} -->

### JSON Format

When using JSON, set the header `Content-Type: application/json`.

<!-- {% raw %} -->
```json
{
  "title": "Signals Alert",
  "message": "High error rate: {{data.mysearch.hits.total.value}} errors",
  "X-S4-Service": "Signals",
  "X-S4-ExternalID": "{{watch.id}}",
  "X-S4-AlertingScenario": "single_ack"
}
```
<!-- {% endraw %} -->

### Alert Title and Message

Use `Title` and `Message` as the parameter names for your alert content. Any additional custom parameters you include will appear in the alert's detail view.

### Signl4 Control Parameters

| Parameter | Description |
|-----------|-------------|
| `X-S4-Service` | Assigns the alert to a service category (e.g., "Security", "Database") |
| `X-S4-ExternalID` | External reference ID for correlating multiple events to a single incident |
| `X-S4-AlertingScenario` | `single_ack` (one person acknowledges), `multi_ack` (all on-duty must acknowledge), or `emergency` (notifies everyone regardless of duty status) |
| `X-S4-Location` | GPS coordinates as `latitude,longitude` (e.g., `"40.6413,-73.7781"`) |
| `X-S4-Status` | Status management: `new`, `acknowledged`, or `resolved` |
{: .config-table}

Any additional fields you include (e.g., `source`, `severity`, `environment`) will appear in the alert's detail view.

For more details, see:
- [Signl4 Webhook Integration](https://docs.signl4.com/integrations/webhook/webhook.html)
- [Signl4 Inbound Webhook Documentation](https://connect.signl4.com/webhook/docs/index.html)
- [Signl4 REST API](https://docs.signl4.com/integrations/rest-api/rest-api.html)
- [Control Parameters Reference](https://support.signl4.com/hc/en-us/articles/9124452127773-Control-parameters-X-S4-parameters-Status-mapping-enrichment-filtering)

### Using Mustache Templates

You can use Mustache templates to include dynamic data from your watch checks:

<!-- {% raw %} -->
```
Title: {{data.mysearch.hits.total.value}} errors detected
Message: Time: {{trigger.triggered_time}}
X-S4-ExternalID: {{watch.id}}-{{trigger.triggered_time}}
```
<!-- {% endraw %} -->

## Webhook Endpoint (Alternative)

Alternatively, you can use the [Signl4 webhook endpoint](https://docs.signl4.com/integrations/webhook/webhook.html) directly without an API key. This approach is simpler but provides only URL-based authentication. Use the webhook endpoint:

`https://connect.signl4.com/webhook/{webhookIdOrTeamId}`

The request body format is the same as for the Events API. Here is a complete example:

<!-- {% raw %} -->
```json
{
  "type": "webhook",
  "name": "signl4_webhook",
  "request": {
    "method": "POST",
    "url": "https://connect.signl4.com/webhook/{webhookIdOrTeamId}",
    "body": "{\"Title\": \"{{data.mysearch.hits.total.value}} errors detected\", \"Message\": \"Watch {{watch.id}} triggered\"}",
    "headers": {
      "Content-Type": "application/json"
    }
  }
}
```
<!-- {% endraw %} -->

**Note:** The Events API endpoint with API key authentication is recommended for better security.

## Advanced Options

Signl4 actions are built on [Webhook Actions](elasticsearch-alerting-actions-webhook). For advanced configuration, refer to the webhook documentation:

- [Dynamic Endpoints](elasticsearch-alerting-actions-webhook#dynamic-endpoints) - Use Mustache templates in the URL
- [TLS Configuration](elasticsearch-alerting-actions-webhook#tls) - Configure custom certificates
- [Security Considerations](elasticsearch-alerting-actions-webhook#security-considerations) - Restrict allowed endpoints

