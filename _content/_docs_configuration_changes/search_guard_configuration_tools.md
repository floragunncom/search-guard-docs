---
title: Configuration Tools
html_title: Configuration Tools
permalink: search-guard-configuration-tools
layout: docs
section: security
description: Tools for managing Search Guard configuration
---

<!--- Copyright 2025 floragunn GmbH -->

# Configuration Tools

Search Guard provides multiple tools for managing configuration. Choose the tool that best fits your workflow and environment.

## Available Tools

### sgctl (Command-Line Interface)

The primary tool for managing Search Guard configuration from the command line. Perfect for automation, CI/CD pipelines, and server management.

- **[Basic Usage](sgctl)** - Core sgctl commands and concepts
- **[Common Examples](sgctl-examples)** - Real-world configuration examples
- **[Making Changes](sgctl-configuration-changes)** - How to apply configuration changes
- **[System Administration](sgctl-system-administration)** - Advanced system operations

**When to use sgctl:**
- Automating configuration deployment
- Managing configuration in CI/CD pipelines
- Scripting configuration changes
- Working on servers without GUI access

### Configuration GUI (Kibana)

A web-based interface for managing Search Guard configuration through Kibana. Ideal for interactive configuration and visual management.

- **[Configuration GUI](configuration-gui)** - Web-based configuration management

**When to use the GUI:**
- Interactive configuration editing
- Visual role and permission management
- Quick configuration changes
- Teams preferring graphical interfaces

### REST API

Programmatic access to Search Guard configuration for custom integrations and applications.

- **[Access Control](rest-api-access-control)** - API authentication and permissions
- **[Usage and Return Values](rest-api)** - General API usage patterns
- **[Internal Users API](rest-api-internalusers)** - Manage internal users
- **[Roles API](rest-api-roles)** - Manage roles and permissions
- **[Role Mappings API](rest-api-roles-mapping)** - Manage user-to-role mappings
- **[Action Groups API](rest-api-actiongroups)** - Manage action groups
- **[Tenants API](rest-api-tenants)** - Manage Multi-Tenancy
- **[Blocks API](rest-api-blocks)** - Manage index blocks
- **[License API](rest-api-license)** - Check and update licenses
- **[Cache API](rest-api-cache)** - Manage authentication/authorization cache
- **[Bulk Requests](rest-api-bulk)** - Batch API operations
- **[Reserved and Hidden Resources](rest-api-reserved-hidden)** - System resources

**When to use the REST API:**
- Custom application integrations
- External user management systems
- Automated provisioning systems
- Advanced scripting requirements

## Choosing the Right Tool

| Requirement | sgctl | GUI | REST API |
|-------------|-------|-----|----------|
| Command-line automation | ✅ | ❌ | ✅ |
| Visual interface | ❌ | ✅ | ❌ |
| CI/CD integration | ✅ | ❌ | ✅ |
| Custom applications | ❌ | ❌ | ✅ |
| Quick manual changes | ✅ | ✅ | ❌ |
| Bulk operations | ✅ | ⚠️ | ✅ |
| Fine-grained control | ✅ | ⚠️ | ✅ |
{: .config-table}

## Common Workflows

### Initial Setup (sgctl)
```bash
# Download configuration
sgctl get-config -o my-config/

# Edit configuration files
# ... make changes ...

# Upload configuration
sgctl update-config my-config/
```

### Quick Change (GUI)
1. Navigate to Search Guard in Kibana
2. Select the configuration type (Users, Roles, etc.)
3. Make changes in the web interface
4. Save changes (applied immediately)

### Automated Provisioning (REST API)
```bash
# Create user via API
curl -XPUT https://localhost:9200/_searchguard/api/internalusers/newuser \
  -H 'Content-Type: application/json' \
  -d '{"password":"password123"}'
```

## Next Steps

- Start with [sgctl Basic Usage](sgctl) to learn command-line configuration
- Or explore the [Configuration GUI](configuration-gui) for web-based management
- For programmatic access, review the [REST API documentation](rest-api)
