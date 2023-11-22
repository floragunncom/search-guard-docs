---
title: JIRA Actions
html_title: JIRA Actions
permalink: elasticsearch-alerting-actions-jira
category: actions
order: 600
layout: docs
edition: enterprise
description: How to create JIRA issues directly from Signals Alerting if anomalies are detected.
---

<!--- Copyright 2022 floragunn GmbH -->

# Jira Actions
{: .no_toc}

{% include toc.md %}


The Jira action type allows creating issues and sub-tasks in the Jira bug tracking software. 

The Jira action type is an enterprise feature; you need to have an enterprise license to use Jira actions.

## Prerequisites

In order to use Jira actions, you need to obtain an API token from Jira and store it as Jira account in Signals. To get an API token from Jira, click on the user icon in the bottom left of the Jira web application. In the appearing pop-up, choose *Account Settings*; afterwards go to *Security* and *Create and manage API tokens*.

The resulting token needs to be registered together with your Jira login email address in the Signals account registry. 
See the [accounts registry documentation](accounts.md) for more details.

Note that Jira API tokens are always tied to the user who created the token. Thus, issues created using such a token normally show the owner of the token as *Reporter*.

## Basic Functionality

The attributes you can use to configure Jira actions quite resemble to the fields available in the Jira UI for creating issues. 

A basic Jira action might look like this:


<!-- {% raw %} -->
```json
 {
	"actions": [
		{
			"type": "jira",
			"name": "my_jira_action",
			"throttle_period": "1w",
			"project": "JP",
			"issue": {
				"type": "Bug",
				"summary": "Cheese stock < {{data.cheese_stock}}",
				"description:" "Please take action",
			}
		}
	]
}
```
<!-- {% endraw %} -->

These attributes are available:

**project:** The *key* of the Jira project in which the issue shall be created. This is usually an abbreviation of the project name and it shows up as prefix of the issue numbers. Mandatory.

**issue.type:** The type of the Jira issue to be created. Note that the available values depend on the configuration of your Jira instance. Typical types include *Bug* and *Task*. Mandatory. You can use Mustache templates for specifying dynamic values. If you specify an issue type which is not configured in your Jira instance, creating the issue will fail.

**issue.summary:** The issue summary which Jira shows in issue lists and as title of the issue. Mandatory. You can use Mustache templates for specifying dynamic values.

**issue.description:** The main text content of the issue. Mandatory. You can use Mustache templates for specifying dynamic values.

**issue.priority:** The priority that shall be assigned to the issue. Note that the available values depend on the configuration of your Jira instance. Typical priorities include *High*, *Medium* and *Low*. Optional. You can use Mustache templates for specifying dynamic values. If you specify a priority which is not configured in your Jira instance, creating the issue will fail.

**issue.component:** A component to be assigned to the issue. Note that the available values depend on the configuration of your Jira instance. Optional. You can use Mustache templates for specifying dynamic values. If you specify a component which is not configured in your Jira instance, creating the issue will fail.

**issue.label:** A label that shall be assigned to the issue. Labels can be created on the fly be specifying them.  Optional. You can use Mustache templates for specifying dynamic values.

**issue.parent:** If you want to create a subtask, you can specify the ID of the parent issue here. Optional. You can use Mustache templates for specifying dynamic values.

**proxy:** Specifies the proxy through which outgoing requests will be routed. One of: `default`, `none`, an HTTP URL or (starting with Search Guard FLX 1.4.0) the `id` of the [proxy added previously](elasticsearch-alerting-proxies) with the REST API. 
