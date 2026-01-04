---
title: Authorization Overview
html_title: Authorization Overview
permalink: authorization-overview
layout: docs
section: security
description: Overview of Search Guard's role-based access control system
---

<!--- Copyright 2025 floragunn GmbH -->

# Authorization Overview

After users authenticate, Search Guard's authorization system determines what actions they can perform and which data they can access. This is accomplished through a role-based access control (RBAC) system.

## How Authorization Works

1. **User Authentication** - User proves their identity
2. **Role Mapping** - User is mapped to one or more Search Guard roles
3. **Permission Evaluation** - Search Guard checks role permissions for each request
4. **Access Decision** - Request is allowed or denied based on permissions

## Key Components

### Roles

Roles define permissions for cluster operations, indices, and specific actions. Each role specifies:
- Cluster-level permissions (create indices, manage snapshots, etc.)
- Index-level permissions (read, write, delete documents, etc.)
- Document and field-level security restrictions
- Tenant access for multi-tenancy

See [Defining Roles](roles-permissions) for details on creating and managing roles.

### Role Mappings

Role mappings connect authenticated users to Search Guard roles. Mappings can be based on:
- Usernames
- Backend roles (LDAP groups, JWT claims, etc.)
- Hostnames or IP addresses

See [Mapping Users to Roles](mapping-users-roles) for configuration details.

### Action Groups

Action groups are reusable sets of permissions that simplify role definitions. Instead of listing individual permissions, you can reference action groups.

See [Action Groups](action-groups) for predefined and custom action groups.

## Topics in This Section

- **[Authorization Overview](authorization-overview)** - This page
- **[Mapping Users to Roles](mapping-users-roles)** - Connect users to roles
- **[Role Mapping Modes](role-mapping-modes)** - Configure how role mapping works
- **[Defining Roles](roles-permissions)** - Create and manage roles
- **[Roles (Legacy 2.x format)](roles-permissions-2x)** - Older role format reference
- **[Action Groups](action-groups)** - Reusable permission sets
- **[Runtime Privilege Evaluation](authorization-runtime-index-privilege-evaluation)** - How permissions are evaluated
- **[User Impersonation](user-impersonation)** - Act as another user

## Common Authorization Scenarios

### Read-Only User

Create a role that allows reading all indices but no modifications:
```yaml
sg_read_only:
  cluster_permissions:
    - SGS_CLUSTER_MONITOR
  index_permissions:
    - index_patterns:
        - '*'
      allowed_actions:
        - SGS_READ
```

### Department-Specific Access

Limit users to indices for their department:
```yaml
sg_hr_department:
  index_permissions:
    - index_patterns:
        - 'hr-*'
      allowed_actions:
        - SGS_CRUD
```

### Administrator

Full cluster access:
```yaml
sg_admin:
  cluster_permissions:
    - '*'
  index_permissions:
    - index_patterns:
        - '*'
      allowed_actions:
        - '*'
```

## Authorization Flow

1. **User authenticates** (e.g., via LDAP)
2. **Backend provides backend roles** (e.g., LDAP groups: `developers`, `managers`)
3. **Role mapping evaluated** (map `developers` group to `sg_developer` role)
4. **User assigned Search Guard roles** (user gets `sg_developer` role)
5. **Permission check** (does `sg_developer` role allow this action?)
6. **Access granted or denied**

## Best Practices

- **Principle of least privilege** - Grant only necessary permissions
- **Use action groups** - Simplify role definitions with reusable permission sets
- **Organize by function** - Create roles based on job functions, not individual users
- **Document roles** - Add descriptions to role definitions
- **Regular audits** - Review role assignments periodically
- **Avoid wildcard permissions** - Be specific about allowed actions and indices

## Next Steps

1. **[Map users to roles](mapping-users-roles)** - Connect authenticated users to Search Guard roles
2. **[Define roles](roles-permissions)** - Create roles with specific permissions
3. **[Use action groups](action-groups)** - Leverage predefined permission sets
4. **Configure [Fine-Grained Access Control](search-guard-fine-grained-access)** - Add document and field-level security
