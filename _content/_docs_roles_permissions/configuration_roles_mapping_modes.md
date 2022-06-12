---
title: Role mapping modes
permalink: role-mapping-modes
category: rolespermissions
order: 600
layout: docs
edition: community
description: Different ways to use the Search Guard role mapping feature to map users, backend roles and hosts to Search Guard roles.
---
<!---
Copyright 2020 floragunn GmbH
-->
# Expert: Role mapping modes
{: .no_toc}

{% include toc.md %}

By default, Search Guard maps every incoming request to a Search Guard role by mapping the user name, the backend roles and/or the hostname to one or more Search Guard roles. This is configured in roles mapping configuration.

This offers great flexibility when working with external authentication systems like LDAP, which have their own role management: You can for example map multiple backend roles stored in your LDAP to one Search Guard role. The same applies for backend roles coming from a JWT or the Internal Users Database.

However, in some cases this is too much overhead, especially when you want to map backend roles 1:1 to Search Guard roles. For example, you want to just map a backend role from LDAP or the Internal Users Database directly to a Search Guard role.

By specifying the role mapping mode, you can configure how Search Guard maps backend roles. This can be configured in elasticsearch.yml by setting:

```
searchguard.roles_mapping_resolution: <mode>
```

## Mode: MAPPING_ONLY

This is the default and means that all backend roles are mapped via the roles mapping as described above. If there is no entry for a specific backend role in `sg_roles_mapping.yml` it is not mapped to any Search Guard role.

## Mode: BACKENDROLES_ONLY

The backend roles are mapped to Search Guard roles directly, effectively skipping the role mapping completely. If you use this setting, you can use the names of the backend roles in `sg_roles.yml` directly, but no additional mapping takes place. 

For example, if your LDAP returns a role `ldap_finance`, you can directly define the permissions in `sg_roles.yml` like:

```yaml
ldap_finance:
  cluster_permissions:
    - CLUSTER_COMPOSITE_OPS_RO
  index_permissions:
    ...
```

## Mode: BOTH

In this mode, the roles are mapped via  `sg_roles_mapping.yml` as in `MAPPING_ONLY`, but the backend roles are added to the final set of roles as well. This is basically a combination of `MAPPING_ONLY` and `BACKENDROLES_ONLY`.

Let's say you've defined a mapping like:

```yaml
sg_finance:
  backend_roles:
    - ldap_finance
```

If your LDAP returns a role `ldap_finance`, the user will have two Search Guard roles:

* ldap_finance: The role from LDAP
* sg_finance: The mapped role from LDAP

 