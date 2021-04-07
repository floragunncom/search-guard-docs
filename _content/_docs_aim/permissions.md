---
title: Permissions
html_title: API Permissions
slug: automated-index-management-permissions
category: aim
order: 300
layout: docs
edition: community
description: Configure API permissions for Automated Index Management.
---

<!--- Copyright 2020 floragunn GmbH -->

# Permissions based access to Automated Index Management API
{: .no_toc}

{% include toc.md %}

Automated Index Management is controlled by Search Guard Role Based Access Control (RBAC). Automated Index Management ships with the following static action groups:

|Action group name|Description|
|-|-|
|SGS_AIM_ALL|Grants all permissions for Automated Index Management|
|SGS_AIM_POLICY_READ|Grants read permission for Automated Index Management policies|
|SGS_AIM_POLICY_MANAGE|Grants permissions to read, write and delete for Automated Index Management policies|
|SGS_AIM_POLICY_INSTANCE_READ|Grants read permission for Automated Index Management policy instances|
|SGS_AIM_POLICY_INSTANCE_MANAGE|Grants permissions to read, execute and retry Automated Index Management policy instances|
