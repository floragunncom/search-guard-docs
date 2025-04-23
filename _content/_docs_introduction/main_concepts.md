---
title: Main concepts
permalink: main-concepts
layout: docs
description: How Search Guard extracts credentials from a request and how they are
  mapped to users, roles and permissions.
resources:
  - search-guard-presentations#quickstart|Search Guard Quickstart and First Steps (presentation)
  - search-guard-presentations#architecture-request-flow|Architecture and Request Flow
    (presentation)
  - search-guard-presentations#configuration-basics|Configuration Basics (presentation)
---
<!--- Copyright floragunn GmbH -->

# Search Guard Main Concepts
{: .no_toc}

{% include toc.md %}

## Introduction

Search Guard secures your Elasticsearch cluster using industry-standard authentication methods including Kerberos, LDAP/Active Directory, JSON Web Tokens (JWT), TLS certificates, and Proxy authentication/Single Sign-On (SSO).

Regardless of the authentication method you choose, Search Guard follows a consistent security flow:

1. A user attempts to **access** an Elasticsearch cluster (e.g., by submitting a query)
2. Search Guard extracts the user's **credentials** from the request
3. Search Guard **authenticates** these credentials against configured authentication backends
4. Search Guard **authorizes** the user by retrieving their roles from the authorization backend
5. Search Guard **maps** the user and their backend roles to **Search Guard roles**
6. Search Guard determines the **permissions** associated with these roles and decides whether to allow the requested action
7. If [Document and Field-Level Security](../_docs_dls_fls/dlsfls_dls.md) is enabled, additional fine-grained permissions can be applied to specific documents and fields

## Authentication Flow

<p align="center">
<img src="authentication_flow.png" style="width: 40%" class="md_image"/>
</p>

## Credentials

Search Guard begins by identifying the user through their **credentials**. The nature of these credentials varies depending on the authentication technology:

* With HTTP Basic Authentication: credentials are `username` and `password`
* With JSON Web Tokens (JWT): credentials are embedded within the token itself
* With TLS certificates: credentials are the Distinguished Name (DN) of the certificate

Credential providers fall into two categories:

| Provider Type | Behavior |
|---------------|----------|
| **Challenging** | Actively prompts the user for credentials if they're missing from the request (e.g., displaying an HTTP Basic Auth dialog) |
| **Non-challenging** | Assumes credentials are already present in the request and won't prompt if they're missing |

## Authentication (Authc)

Once credentials are extracted, Search Guard **authenticates** them against configured backend authentication modules such as LDAP, Active Directory, Kerberos, or JWT.

Search Guard supports authentication chaining, where multiple authenticators can be configured in sequence. When a request arrives, Search Guard tries each authenticator in order until one succeeds. A common implementation combines the Search Guard internal user database with external systems like LDAP/Active Directory.

Additionally, Search Guard supports **user information backends** that can enrich an authenticated user's profile with additional roles or attributes. For example:

* A user might authenticate via JWT (which already contains some role information)
* An LDAP user information backend can then provide additional roles for this authenticated user

For enterprises using **external authentication or Single Sign-On (SSO)** solutions that act as proxies or store authentication data in HTTP headers, Search Guard provides an HTTP proxy authenticator that can interpret these header fields.

## Users and Roles

After successful authentication and role retrieval, Search Guard **maps** the user and any **backend roles** to **Search Guard roles**.

This mapping can be configured in various ways:

* One-to-one mapping: Each backend role maps directly to a corresponding Search Guard role
* Many-to-one mapping: Multiple backend roles map to a single Search Guard role
* Custom mapping: Combinations of users and roles mapped to specific Search Guard roles

This flexible mapping system allows administrators to align security permissions with organizational structures without modifying the backend authentication systems.

## Permissions

Every interaction with Elasticsearch involves a **user** attempting to execute an **action** on a specific **cluster** and one or more **indices**.

A permission defines:

* Which role
* Can perform which action
* Against which cluster or index

For example, a permission allowing search operations on an index would be expressed as:

`indices:data/read/search*`

Permissions are defined per role and can be applied at either the cluster or index level. Search Guard includes built-in permission groups like `SGS_READ`, `SGS_WRITE`, and `SGS_SEARCH` to simplify configuration.

## Action Groups

Action groups serve as **aliases for sets of permissions** and can be **nested** for more modular configuration. For example:

```yaml
SGS_SEARCH:
  - "indices:data/read/search*"
  - "indices:data/read/msearch*"
  - SGS_SUGGEST
SGS_SUGGEST:
  - "indices:data/read/suggest*"
```

In this example, the `SGS_SEARCH` action group includes several direct permissions and also incorporates all permissions from the `SGS_SUGGEST` action group.

Action groups can be used in role configurations either instead of or alongside fine-grained permissions. Search Guard provides a comprehensive set of built-in action groups that are regularly updated, making them the **recommended approach for role configuration**.

## The Search Guard Index

All Search Guard configuration settings—including users, roles, and permissions—are stored as documents in a dedicated Search Guard index. This index is secured so that only admin users with special SSL certificates can read from or write to it. These **admin certificates** are defined in the `elasticsearch.yml` configuration file.

Storing configuration in an Elasticsearch index enables **hot config reloading**, allowing you to:

* Change user, role, and permission settings without restarting nodes
* Apply configuration changes immediately
* Modify authenticator configurations at runtime
* Manage your security settings from any machine with cluster access

The core configuration consists of the following files:

| Configuration File | Purpose |
|-------------------|---------|
| `sg_authc.yml` | Configures authentication mechanisms |
| `sg_roles.yml` | Defines roles and their associated permissions |
| `sg_internal_users.yml` | Stores users, roles, and hashed passwords for the internal user database |
| `sg_action_groups.yml` | Defines named permission groups |

For Kibana deployments, additional configuration files are needed:

| Configuration File | Purpose |
|-------------------|---------|
| `sg_frontend_authc.yml` | Authentication settings for Kibana |
| `sg_frontend_multi_tenancy.yml` | Basic multi-tenancy settings for Kibana |
| `sg_tenants.yml` | Defines tenants for configuring Kibana access |

Special features require these additional configuration files:

| Configuration File | Purpose |
|-------------------|---------|
| `sg_authz.yml` | Authorization-specific settings |
| `sg_auth_token_service.yml` | Configures the API authentication token service |
| `sg_blocks.yml` | Defines blocked users and IP addresses |

Sample templates for all configuration files are included in the Search Guard download package.

Configuration changes are applied by pushing the content of one or more configuration files to the Search Guard secured cluster using the `sgctl` tool. For detailed instructions, refer to the [sgctl documentation](../_docs_configuration_changes/configuration_sgctl.md).