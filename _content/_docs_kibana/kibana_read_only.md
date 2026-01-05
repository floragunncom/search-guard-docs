---
title: Read-Only mode
html_title: Kibana Read-Only mode
permalink: kibana-read-only
layout: docs
section: security
edition: enterprise
description: Use the Kibana Read-Only mode to give users access to dashboards, but
  prevent them from accessing anything else.
---
# Read-Only mode
{: .no_toc}

{% include toc.md %}

Search Guard provides a Read-Only mode for Kibana. When a user is assigned to this mode, only the dashboards and, if configured, the Multi-Tenancy navigation entries are accessible.

Thus, a user can view already configured dashboards and change tenants, but is not able to use any other functionalities of Kibana.

## Defining Read-Only roles

The Kibana Read-Only mode is based on the Search Guard roles of a user:

If a user is assigned to one or more configured *Read-Only roles*, the Kibana Read-Only mode is activated automatically upon login.

Use the following entry in `kibana.yml` to configure the Read-Only roles:

```
searchguard.readonly_mode.roles: ["sg_read_only_1", "sg_read_only_2", ...]
```

If a Search Guard user has either the role `sg_read_only_1` or `sg_read_only_2`, the Kibana Read-Only mode is activated.

## Read-Only mode: effects

In Read-Only mode:

* Only the Dashboard application is accessible
* Only the Dashboard and (if configured) the Multi-Tenancy links are visible
* The controls to create, edit and delete dashboards are hidden
* All tenants are switched to Read-Only automatically