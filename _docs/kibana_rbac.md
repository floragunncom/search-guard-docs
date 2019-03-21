---
title: Role-Based Access Control
html_title: Kibana Role-Based Access Control
slug: kibana-rbac
category: kibana
order: 300
layout: docs
edition: community
description: Search Guard adds true multi tenancy to Kibana. Separate your dashboards and visualizations by users and roles.


---

# Role-Based Access Control 
{: .no_toc}

{% include_relative _includes/toc.md %}

## Overview

## Installation and configuration

In order to use RBAC, you first need to enable it using a switch in sg_config.yml. 

```yaml
searchguard:
  dynamic:
    kibana:
      rbac_enabled: true
```
 
Afterwards, you can assign Kibana application permissions to roles. You can do so directly in sg_roles.yml or inside Kibana. You have to restart Kibana once in order to let it activate RBAC.   

### Configuring Kibana application permissions

Kibana application permissions may be assigned to roles and tenants. For example, this sg_roles configuration gives the complete set of Kibana application permissions to the role `kibana_full_access`:

```yaml
kibana_full_access:
  applications:
    - kibana:ui:navLinks/*
```

If you are configuring the tenants available to a role in sg_roles.yml, you can configure the application permissions individually for the tenant.
The following example defines a tenant called `guests`. Users with the role `kibana_guest` get read-only access to it and are only allowed to access the Kibana dashboard.

```yaml
kibana_guest:
  tenants:
    guests:
      applications:
      - searchguard:tenant/read
      - kibana:ui:navLinks/kibana:dashboard
```

For more details on multitenancy configuration, please refer to the [Multitenancy Documentation](./kibana_multitenancy.md).



### Configuration of existing Search Guard installations

If you are activating RBAC for an existing Search Guard installation and leave the existing role configuration unchanged, Search Guard will automatically modify it and provide all Kibana application permissions to any user. This retains the Kibana functionality that was available before activating RBAC. Without modification, the configuration would be void of any Kibana application permissions, which means you would lose any access to Kibana.

Concretely, the automatic process adds the role `sg_kibana_user_all_application_access` using this definition: 

```yaml
sg_kibana_user_all_application_access:
  applications:
   - kibana:ui:navLinks/* 
```

In `sg_role_mapping`, the role is assigned to any user using this definition:

```yaml
sg_kibana_user_all_application_access:
  users:
   - '*'
```

*As this role definition gives full Kibana UI access to any user, you need to amend it in order to define users with more restricted permissions.*    
 
Furthermore, any [legacy tenant definitions](./kibana_multitenancy.md#Legacy tenant configuration) (using the keywords RW/RO) will be migrated to the new format.  

This automatic process is triggered on startup of Kibana if the role configuration does not contain any role definitions having an `applications` block or if it contains legacy tenant definitions.    

In order to avoid the automatic migration, you need to configure application permissions in sg_roles.yml before activating RBAC. 

If you do not want to specify any application permissions, but still want to avoid the automatic process, you can add an empty `applications` block to any role definition. Remember, however, that this will disable any UI in Kibana, so the use cases for this are quite limited:

```yaml
some_role:
  applications: []
```

### Configuration of new Search Guard installations

The default configuration provided for new Search Guard installations provides full Kibana access to the admin user (via the role `sg_all_access`) and to any user with the role `sg_kibana_user`.

