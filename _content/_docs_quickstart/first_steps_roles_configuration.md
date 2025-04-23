---
title: Configuring roles and permissions
html_title: Configuring roles
permalink: first-steps-roles-configuration
layout: docs
description: How to configure Search Guard roles to control access to indices, documents
  and fields.
resources:
  - roles-permissions|Roles and permissions (docs)
  - action-groups|Action groups (docs)
  - sgctl|Using sgctl (docs)
---
<!--- Copyright 2022 floragunn GmbH-->

# Configuring Roles and Permissions
{: .no_toc}

{% include toc.md %}

This guide assumes that you have already installed Search Guard in your cluster using the [demo installer](demo-installer).
{: .note .js-note .note-info}

## Understanding Roles and Permissions

Search Guard roles are the core component for implementing access control in your Elasticsearch cluster. Each role defines a specific set of permissions that determine what actions users can perform.

A comprehensive role definition can include permissions across four distinct levels:

* **Cluster-level permissions** (Community Edition)
  * Control access to cluster-wide operations
  * Example: Checking cluster health, creating snapshots

* **Index-level permissions** (Community Edition)
  * Define what operations users can perform on specific indices
  * Example: Read or write access to particular indices

* **Document-level permissions** (Enterprise Edition)
  * Control which specific documents within an index users can access
  * Example: HR personnel can only view employee documents from their department

* **Field-level permissions** (Enterprise Edition)
  * Restrict access to specific fields within documents
  * Example: Support staff can view customer contact information but not payment details

You can manage roles through multiple interfaces:
* `sgctl` command-line tool
* [REST API](rest-api-internalusers)
* [Search Guard Config GUI](configuration-gui)

Before you can assign permissions to users, you must first define your roles. User-to-role assignments happen through role mapping, which we'll cover in the next chapter.

## Role Definition Structure

Search Guard roles are defined in the `sg_roles.yml` file located at:

```
<ES installation directory>/plugins/search-guard-flx/sgconfig/sg_roles.yml
```

A basic role definition follows this structure:

```
<role_name>:
  cluster_permissions:
    - <cluster_permission>
  index_permissions:
    - index_patterns:
      - <index_pattern>
      allowed_actions:
        - <index_permission>
```

### Permission Components

| Component | Description |
|-----------|-------------|
| `role_name` | A unique identifier for the role |
| `cluster_permissions` | List of permissions for cluster-wide operations |
| `index_permissions` | Container for index-specific permissions |
| `index_patterns` | Patterns that identify which indices the permissions apply to |
| `allowed_actions` | Specific operations permitted on the matching indices |

## Using Action Groups

To simplify permission management, Search Guard provides pre-configured sets of related permissions called "action groups." These groups bundle common operations together, making role configuration more intuitive.

For example, instead of listing individual index operations like `indices:data/read/search`, you can use the `SGS_READ` action group, which includes all read operations.

For a complete list of available action groups, see the [Search Guard action groups documentation](action-groups#built-in-action-groups).

## Creating Sample Roles

Let's create two example roles to demonstrate how role configuration works in practice:

### Example 1: Human Resources Role

This role provides read-only access to HR data:

```
sg_human_resources:
  cluster_permissions:
    - "SGS_CLUSTER_COMPOSITE_OPS"
  index_permissions:
    - index_patterns:
      - "humanresources"
      allowed_actions:
        - "SGS_READ"
```  

In this configuration:
* `SGS_CLUSTER_COMPOSITE_OPS` grants basic cluster operations needed for normal usage
* `SGS_READ` provides read-only access to the `humanresources` index
* Users with this role cannot access any other indices

### Example 2: DevOps Role

This role provides varying levels of access to infrastructure and log data:

```
sg_devops:
  cluster_permissions:
    - "SGS_CLUSTER_COMPOSITE_OPS"
  index_permissions:
    - index_patterns:
      - "infrastructure"
      allowed_actions:
        - SGS_READ
        - SGS_WRITE
    - index_patterns:
      - "logs-*"
      allowed_actions:
        - SGS_READ
```  

In this configuration:
* The role grants read and write access to the `infrastructure` index
* It provides read-only access to any index whose name starts with `logs-`
* The wildcard pattern (`logs-*`) is particularly useful for time-based indices like daily logs

## Pattern Matching for Index Names

Search Guard supports flexible index pattern matching, including:

* Exact matches: `humanresources`
* Wildcards: `logs-*` matches all indices starting with "logs-"
* Regular expressions: For more complex matching patterns

This flexibility allows you to create dynamic permission schemes that automatically apply to new indices that match your patterns.

## Applying Your Configuration

To activate your role definitions, upload the configuration file to the Search Guard configuration index using the `sgctl` command line tool:

```
./sgctl.sh update-config /path/to/changed/sg_roles.yml
```

After running this command, your new roles will be active and ready to be assigned to users through role mapping.

## Best Practices

* **Follow the principle of least privilege**: Grant only the permissions necessary for each role
* **Use descriptive role names**: Names like `sg_human_resources` clearly indicate the role's purpose
* **Leverage action groups**: Use pre-defined action groups when possible to simplify configuration
* **Document your roles**: Maintain documentation about what each role is intended for
* **Audit regularly**: Review roles periodically to ensure they align with current security requirements