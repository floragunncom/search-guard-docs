---
title: Read Only mode
html_title: Kibana Read Only mode
permalink: kibana-read-only
layout: docs
section: security
edition: enterprise
description: Use the Kibana read only mode to give users access to dashboards, but
  prevent them from accessing anything else.
---
# Read only mode
{: .no_toc}

{% include toc.md %}

Search Guard provides a read only mode for Kibana. When a user is assigned to this mode, only the dashboards and, if configured, the Multi-Tenancy navigation entries are accessible.

Thus, a user can view already configured dashboards and change tenants, but is not able to use any other functionalities of Kibana.

## Defining read only roles

The Kibana read only mode is based on the Search Guard roles of a user:

If a user is assigned to one or more configured *read only roles*, the Kibana read only mode is activated automatically upon login.

Use the following entry in `kibana.yml` to configure the read only roles:

```
searchguard.readonly_mode.roles: ["sg_read_only_1", "sg_read_only_2", ...]
```

If a Search Guard user has either the role `sg_read_only_1` or `sg_read_only_2`, the Kibana read only mode is activated.

## Read only mode: effects

In read only mode:

* Only the Dashboard application is accessible
* Only the Dashboard and (if configured) the Multi-Tenancy links are visible
* The controls to create, edit and delete dashboards are hidden
* All tenants are switched to read only automatically