---
title: Signals operator view
html_title: Signals operator view and Kibana panel
permalink: elasticsearch-alerting-operator-view
layout: docs
section: alerting
edition: community
description: How Signals Alerting operator view works
---
<!--- Copyright 2022 floragunn GmbH -->

# Signals operator view and Kibana panel
{: .no_toc}

The Signals operator view provides system operators with a quick, actionable overview of the active watches and their current statuses.
Unlike the traditional watch overview (used mainly by users who create and maintain watches), the operator view is designed for monitoring and responding to alerts and issues as they arise.

Note: Watches will only appear in the operator view if they define severity levels. The operator view then displays the watches ordered by severity level, highest severity first. In addition, watches which encounter errors during execution, will be displayed above all other watches.

## Columns and actions

The operator view consists of three columns:

- The "Status" column displays the severity status and the status of actions that were executed due to the severity status. See the chart below for the possible severity statuses and their color codes. The icon at the left side of each entry represents the action status: A bell indicates that an action has been executed. A striked-through bell indicates that all action executions have been suppressed, as the watch severity status has been acknowledged by the user. Clicking on the bell will acknowledge the whole watch, including all actions.
- The "Name" column displays the name of the respective watch.
- The "Actions" column displays an icon for each action defined for a watch. This allows you to see which actions have been executed, and which actions have not been executed (due to the associated severity level or acknowledgement status). Clicking on the bell icon next to an action name will acknowledge the individual action, without acknowledging the whole watch. An acknowledged watch is displayed with a strike through bell.

By default the operator view is refreshed every 10 seconds, this can be disabled or set to a different time period using the "Auto refresh" icon.

<p align="center">
    <img src="{{ '/img/signals-alerting-operator-view.jpg' | relative_url }}" alt="Signals Alerting operator view" class="md_image" style="max-width: 100%"/>
</p>

The severity levels are color coded as follows:

- `not yet executed`: yellow
- `executed successfully`: green
- `paused`: grey
- `info`: Light gray
- `warning`: Amber
- `error`: Red
- `critical`: Violet
- `failed` (action/execution): Black

## External references

It is possible to externally link or embed certain configurations of the operator view. For this, a number of URL query parameters are provided which control the displayed watches:


- `query`: The displayed watches will be restricted to the ones where watch name or watch id match the given query. You can also use wildcards, for example `watch_*`.

- `sortDirection`: the sorting of the watches (asc or desc).

- `pageIndex`: the page number (first page is 0).

- `pageSize`: the number of watches displayed on each page. The default is `100` (options are `10`, `20`, `50` or `100`).


## Kibana dashboards integration

Signals provides a custom Kibana panel which can be used to display the severity status of a watch in a dashboard. In order to add such a panel to a dashboard, click on "Add Panel" button in the edit dashboard view and choose "Add Signals watch".
The panel will display the current severity status of the respective watch with the same color codes as the operator view.

<p align="center">
    <img src="{{ '/img/signals-alerting-watch-panels.jpg' | relative_url }}" alt="Signals Alerting Kibana panel" class="md_image" style="max-width: 100%"/>
</p>