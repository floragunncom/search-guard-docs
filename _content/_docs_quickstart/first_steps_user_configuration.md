---
title: Adding users
html_title: Adding users
permalink: first-steps-user-configuration
layout: docs
description: How to add new Search Guard users by using sgctl and the Search Guard
  configuration.
resources:
  - internal-users-database|Internal user database (docs)
  - sgctl|Using sgctl (docs)
---
<!---
Copyright 2022 floragunn GmbH
-->

# Adding Search Guard Users
{: .no_toc}

{% include toc.md %}

This guide assumes that you have already installed Search Guard in your cluster using the [demo installer](demo-installer).
{: .note .js-note .note-info}

## Understanding Authentication Options

Search Guard provides flexible authentication methods to suit different organizational needs. While external authentication systems like LDAP, OpenID, SAML, or Kerberos can be integrated with Search Guard, this guide focuses on using the **internal user database**.

The internal user database stores user credentials directly within Elasticsearch, providing a self-contained authentication solution without requiring external systems.

## Managing Users in the Internal Database

There are four methods for managing users in the internal database:

| Method | Edition | Description |
|--------|---------|-------------|
| Configure `sg_internal_users.yml` | Community | Edit the configuration file and upload via `sgctl` |
| Direct management with `sgctl` | Community | Add, update, or delete users directly on a running cluster |
| Configuration GUI | Enterprise | Use the web-based interface for user management |
| REST API | Enterprise | Programmatically manage users via HTTP endpoints |

This guide focuses primarily on the Community Edition methods using `sgctl` and configuration files.

## User Configuration Structure

Users in the internal database are defined with the following attributes:

```yaml
<username>:
  hash: <hashed password>
  backend_roles:
    - role1
    - role2
  search_guard_roles:
    - sg_role1
    - sg_role2
  attributes:
    key: value      
```

| Attribute | Required | Description |
|-----------|----------|-------------|
| `hash` | Yes | BCrypt hash of the user's password |
| `backend_roles` | No | Groups or roles used for permission mapping |
| `search_guard_roles` | No | Direct assignment of Search Guard roles |
| `attributes` | No | Custom key-value pairs for the user |

## Creating Users with Configuration Files

### Step 1: Create a User Entry

For our example, we'll create a user named `jdoe` who belongs to the `hr_department` backend role. Backend roles function similarly to LDAP or Active Directory groups, allowing you to organize users and simplify permission assignments.

### Step 2: Generate a Password Hash

Search Guard requires passwords to be stored as BCrypt hashes rather than plaintext. While you can use [any tool capable of generating BCrypt hashes](https://bcrypt-generator.com/), the easiest approach is to use `sgctl`.

### Step 3: Add the User with `sgctl`

To create a user in a local configuration file, use the `add-user-local` command:

```bash
./sgctl.sh add-user-local jdoe --backend-roles hr_department --password -o /path/to/a/local/sg_internal_users.yml
```

When you run this command:
1. You'll be prompted to enter a password (unless you specify it with the `--password` option)
2. If the specified file doesn't exist, it will be created
3. If the file exists, the new user will be appended

The resulting entry in `sg_internal_users.yml` will look like this:

```yaml
jdoe:
  hash: $2y$12$AwwN1fn0HDEw/LBCwWU0y.Ys6PoKBL5pR.WTYAIV92ld7tA8kozqa
  backend_roles:
    - hr_department
```

Since BCrypt generates unique hashes even for the same password, your hash values may differ from those shown in this guide.
{: .note .js-note .note-info}

### Step 4: Upload the Configuration

To activate your changes, upload the configuration file to the Search Guard configuration index:

```bash
./sgctl.sh update-config /path/to/the/changed/sg_internal_users.yml
```

If you haven't yet configured a connection for `sgctl`, set it up once:

```bash
./sgctl.sh connect localhost --ca-cert /path/to/root-ca.pem --cert /path/to/admin-cert.pem --key /path/to/admin-cert-private-key.pem
```

Your configuration changes take effect immediately without requiring a cluster restart.

## Enabling Kibana Access

If you want a user to access Kibana, they need the special role `SGS_KIBANA_USER`. You can assign this role either:

1. **Directly to the user:**

```yaml
jdoe:
  hash: $2y$12$AwwN1fn0HDEw/LBCwWU0y.Ys6PoKBL5pR.WTYAIV92ld7tA8kozqa
  backend_roles:
    - hr_department
  search_guard_roles:
    - SGS_KIBANA_USER  
```

2. **Through role mapping:**
   Map the `SGS_KIBANA_USER` role to the user's backend role (e.g., `hr_department`).
   See the [roles mapping guide](first-steps-mapping-users-roles) for details.

## Direct User Management on the Cluster

Instead of editing configuration files, you can manage users directly on a running cluster using `sgctl`.

### Adding Users

```bash
./sgctl.sh add-user jdoe --backend-roles hr_department --password
```

### Updating Users

```bash
./sgctl.sh update-user jdoe --backend-roles another_department
```

### Deleting Users

```bash
./sgctl.sh delete-user jdoe 
```

**Important:** After using `sgctl` to directly modify users on the cluster, any local `sg_internal_users.yml` files become outdated. Using these files to update the configuration later could overwrite user changes made directly on the cluster.

## Managing Multiple Users

When managing a team or organization, you might need to add multiple users with similar configurations. Here are some strategies:

### Batch Creation with Script

For adding multiple users, you can create a simple shell script:

```bash
#!/bin/bash
USERS=("jdoe:hr_department" "psmith:hr_department" "mwilson:finance_department")

for USER_INFO in "${USERS[@]}"; do
  USERNAME=$(echo $USER_INFO | cut -d':' -f1)
  ROLE=$(echo $USER_INFO | cut -d':' -f2)
  ./sgctl.sh add-user-local $USERNAME --backend-roles $ROLE --password password123 -o sg_internal_users.yml
done

./sgctl.sh update-config sg_internal_users.yml
```

### Creating Additional Sample Users

To expand our example, let's add two more users:

```bash
./sgctl.sh add-user-local psmith --backend-roles hr_department --password -o /path/to/sg_internal_users.yml
./sgctl.sh add-user-local cmaddock --backend-roles devops --password -o /path/to/sg_internal_users.yml
```

This creates three users in total:
- `jdoe` and `psmith` in the `hr_department` backend role
- `cmaddock` in the `devops` backend role

These backend roles will be used in later chapters to map users to specific Search Guard roles, which define their permissions.

## Best Practices

- **Secure password management**: Never store plaintext passwords
- **Use unique, strong passwords**: Each user should have a unique, complex password
- **Regular credential rotation**: Update passwords periodically
- **Backup configuration**: Maintain backups of your user configuration
- **Least privilege principle**: Assign only necessary roles and permissions
- **Audit user accounts**: Regularly review user accounts and remove unused ones