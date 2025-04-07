---
title: Security Integration
html_title: Security Integration
permalink: automated-index-management-security-integration
layout: docs
edition: community
description: Configure Automated Index Management with Search Guard security features
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# Security Integration
{: .no_toc}

{% include toc.md %}

Automated Index Management ships with predefined action groups that can easily be assigned to Search Guard roles.

## AIM action groups

| Action group name              | Note                                                                             |
|--------------------------------|----------------------------------------------------------------------------------|
| SGS_AIM_ALL                    | Grants access to all AIM APIs                                                    |
| SGS_AIM_POLICY_READ            | Grants read-only access to all AIM Policies                                      |
| SGS_AIM_POLICY_MANAGE          | Grants permissions to create, delete and read AIM Policies                       |
| SGS_AIM_POLICY_INSTANCE_READ   | Grants access to read the current status of an index managed by AIM              |
| SGS_AIM_POLICY_INSTANCE_MANAGE | Grants access to manually execute, retry and read the current status of an index |

## Applying AIM permission to Search Guard roles

Permissions for the AIM APIs are assigned to roles in the `cluster_permissions` section of the role definition.

```yaml
sg_aim_manager:
  cluster_permissions:
    - SGS_AIM_POLICY_INSTANCE_MANAGE
  index_permissions:
    ...
  tenant_permissions:
    ...
```