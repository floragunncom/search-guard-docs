---
title: Settings
html_title: Settings
permalink: automated-index-management-settings
layout: docs
edition: community
description: Configure Automated Index Management to fit your requirements
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Settings
{: .no_toc}

{% include toc.md %}

## Dynamic configuration options

The following configuration options can be set using the AIM settings API.

| Name                               | Type               | Default | Note                                                                                                                                                                                           |
|------------------------------------|--------------------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **active**                         | boolean            | true    | If this is set to `false` AIM will not execute any policies for managed indices                                                                                                                |
| **history.active**                 | boolean            | true    | If set to `false` AIM will no longer log changes of managed indices                                                                                                                            |
| **execution.period**               | (TimeValue) String | "5m"    | Sets in which period policies should be executed for managed indices                                                                                                                           |
| **execution.delay**                | (TimeValue) String | "0s"    | Sets how long AIM should wait before executing policies for the first time on a managed index                                                                                                  |                             
| **execution.delay.random.enabled** | boolean            | true    | If enabled a random delay (between 0s and `execution.period`) is added to the `execution.delay`. This ensures a better distribution of managed index tasks and increases performance stability |                       

## Static configuration options

The following configuration options can be made inside the `elasticsearch.yml`.

> **Note:**
> - Every static configuration is optional. If configurations are not set, their default value is used
> - Every static configuration must be equally set on all nodes
> - A restart of every node is required to make static configuration changes available

### General configuration

| Name                     | Type    | Default | Note                                                                     |
|--------------------------|---------|---------|--------------------------------------------------------------------------|
| **aim.enabled**          | boolean | true    | Enables/disabled AIM. Enabling AIM on a subset of nodes is not supported |
| **aim.thread_pool.size** | int     | 4       | Number of threads to be used by AIM to manage indices                    |

### History configuration

| Name                    | Type    | Default | Note                                   |
|-------------------------|---------|---------|----------------------------------------|
| **aim.history.enabled** | boolean | true    | Enables/disables the state log feature |
