---
title: Mapping users to Search Guard roles
html_title: Roles mapping
permalink: first-steps-mapping-users-roles
layout: docs
description: How to map users to Search Guard roles to assign cluster- and index-level
  access permissions.
resources:
  - mapping-users-roles|Mapping users to roles (docs)
  - sgctl|Using sgctl (docs)
---
<!--- Copyright 2022 floragunn GmbH -->

# Mapping Users to Search Guard Roles
{: .no_toc}

{% include toc.md %}

This guide assumes that you have already installed Search Guard in your cluster using the [demo installer](demo-installer).
{: .note .js-note .note-info}

## Understanding Role Mapping

After creating Search Guard users and roles, you need to connect them together through role mapping. This crucial step establishes which users have access to specific permissions defined in your roles.

When mapping users to Search Guard roles, you can use:

* The username directly
* The user's backend roles (recommended for flexibility)
* The source hostname or IP address (for advanced use cases)

Backend roles provide the most flexible approach to role mapping. Depending on your authentication method, backend roles can come from:

* LDAP/Active Directory groups
* JWT claims
* SAML assertions
* Backend roles defined in the internal user database

<p align="center">
<img src="rolemapping.png" style="width: 70%" class="md_image"/>
</p>

In this guide, we'll use backend roles configured in the internal user database to demonstrate the mapping process.

## User Backend Roles Overview

In the previous chapter, we configured three users with the following backend roles:

```
jdoe:
  hash: $2y$12$AwwN1fn0HDEw/LBCwWU0y.Ys6PoKBL5pR.WTYAIV92ld7tA8kozqa
  backend_roles:
    - hr_department

psmith:
  hash: $2y$12$YOVZhJ.gbZOAoGyd9YGNMuw7rWYTfB73n8OGBLtsrihMkW5rg5D1G
  backend_roles:
    - hr_department

cmaddock:
  hash: $2y$12$3UFikPXIZLoHcsDGD0hyqOvxjytdXeRkefIF1M58jA5oueSDKthzu
  backend_roles:
    - devops
```

Our goal is to implement the following mapping:

* Map all users with the `hr_department` backend role to the `sg_human_resources` Search Guard role
* Map all users with the `devops` backend role to the `sg_devops` Search Guard role

## Configuring Role Mapping

Role mapping is defined in the `sg_roles_mapping.yml` file using a straightforward structure:

```
<Search Guard role name>:
  users:
    - <username>
    - ...
  backend_roles:
    - <rolename>
    - ...
  hosts:
    - <hostname>
    - ...
```

Since we're using backend roles for mapping, our configuration will look like this:

```
sg_human_resources:
  backend_roles:
    - hr_department

sg_devops:
  backend_roles:
    - devops
```

This configuration creates the following mappings:

* Users `jdoe` and `psmith` → `sg_human_resources` role (via their `hr_department` backend role)
* User `cmaddock` → `sg_devops` role (via the `devops` backend role)

The diagram below illustrates how backend roles connect users to Search Guard roles:

<p align="center">
<img src="rolemapping.png" style="width: 70%" class="md_image"/>
</p>

## Applying Your Configuration

To activate your role mapping configuration, you must upload it to the Search Guard configuration index using the `sgctl` command line tool:

```
./sgctl.sh update-config /path/to/changed/config_files/
```

After running this command, your user-to-role mappings will become active, and users will receive the permissions defined in their assigned roles.

## Configuration Options

The table below shows the available mapping options in the `sg_roles_mapping.yml` file:

| Configuration Option | Description |
|---------------------|-------------|
| `users` | List of usernames to directly map to the role |
| `backend_roles` | List of backend role names that grant access to this role |
| `hosts` | List of hostnames or IP addresses from which users must connect to be mapped to this role |

## Best Practices

* **Use backend roles whenever possible** - They provide more flexibility than direct username mapping
* **Follow the principle of least privilege** - Assign users only to roles with permissions they need
* **Keep role mappings organized** - Document the purpose of each mapping for easier maintenance
* **Regularly audit role mappings** - Review periodically to ensure they reflect current organizational needs

## Troubleshooting

If users are not receiving expected permissions after mapping:

1. Verify the user has the correct backend roles assigned
2. Confirm the `sg_roles_mapping.yml` file correctly maps those backend roles to Search Guard roles
3. Check that you've uploaded the updated configuration with `sgctl`
4. Examine the Search Guard logs for any error messages related to role mapping