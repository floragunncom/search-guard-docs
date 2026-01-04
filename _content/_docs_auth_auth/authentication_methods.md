---
title: Authentication Methods
html_title: Authentication Methods
permalink: authentication-methods
layout: docs
section: security
description: Overview of authentication methods supported by Search Guard
---

<!--- Copyright 2025 floragunn GmbH -->

# Authentication Methods

Search Guard supports multiple authentication methods to integrate with your existing security infrastructure. Choose the method that matches your environment and requirements.

## Available Authentication Methods

### Internal Users Database

Manage users directly within Search Guard using the internal user database.

- **[Internal Users Database](internal-users-database)** - Built-in user management

**Best for:** Small deployments, development environments, or when no external authentication system exists.

### Basic Authentication

Standard HTTP Basic Authentication with username and password.

- **[Basic Authentication](http-basic-authorization)** - HTTP Basic Auth configuration

**Best for:** Simple deployments, testing, or when combined with internal users database.

### Active Directory / LDAP

Integrate with Active Directory or LDAP servers for centralized user management.

- **[Quick Start](active-directory-ldap)** - Basic AD/LDAP configuration
- **[Advanced Configuration](active-directory-ldap-advanced)** - Complex AD/LDAP setups, nested groups, multiple servers

**Best for:** Enterprise environments with existing Active Directory or LDAP infrastructure.

### JSON Web Tokens (JWT)

Use JSON Web Tokens for stateless authentication, ideal for microservices and API authentication.

- **[Quick Start](json-web-tokens)** - Basic JWT configuration
- **[Advanced Configuration](json-web-tokens-advanced)** - Custom claims, key rotation, multiple issuers

**Best for:** Microservices architectures, single sign-on (SSO), API authentication, mobile applications.

### Kerberos / SPNEGO

Integrate with Kerberos for single sign-on in Windows environments.

- **[Kerberos / SPNEGO](kerberos-spnego)** - Kerberos configuration and setup

**Best for:** Windows-based environments with existing Kerberos infrastructure, enterprises requiring SSO.

### Proxy Authentication

Delegate authentication to a reverse proxy or web server.

- **[Quick Start](proxy-authentication)** - Basic proxy authentication
- **[Advanced Configuration](proxy-authentication-advanced)** - Custom headers, trusted proxies

**Best for:** Environments with existing authentication proxies, complex SSO setups.

### Client Certificate Authentication

Use X.509 client certificates for strong authentication.

- **[Client Certificate Authentication](client-certificate-auth)** - Certificate-based authentication

**Best for:** Machine-to-machine communication, high-security requirements, internal tools.

### Anonymous Authentication

Allow unauthenticated access to specific resources.

- **[Anonymous Authentication](anonymous-authentication)** - Configure anonymous access

**Best for:** Public dashboards, read-only public data, landing pages.

### Search Guard Auth Tokens

Generate temporary authentication tokens for programmatic access.

- **[Search Guard Auth Tokens](search-guard-auth-tokens)** - Token-based authentication

**Best for:** Temporary access, service accounts, automation scripts.

## Choosing an Authentication Method

| Method | Use Case | Complexity | Security |
|--------|----------|------------|----------|
| Internal Users | Small deployments, dev/test | Low | Medium |
| Basic Auth | Simple setups, testing | Low | Medium |
| Active Directory/LDAP | Enterprise environments | Medium | High |
| JWT | Microservices, APIs | Medium | High |
| Kerberos | Windows environments | High | High |
| Proxy | Existing auth infrastructure | Medium | High |
| Client Certificates | M2M communication | Medium | Very High |
| Anonymous | Public access | Low | Low |
| Auth Tokens | Programmatic access | Low | Medium |
{: .config-table}

## Combining Multiple Methods

Search Guard supports using multiple authentication methods simultaneously. For example:
- Basic Auth for administrators
- JWT for API access
- LDAP for regular users

See the [General Configuration](authentication-general-config) section for details on combining authentication methods.

## Configuration

All authentication methods are configured in the `sg_authc.yml` file. See [Introduction to sg_authc](authentication-authorization-configuration) for configuration fundamentals.

## Next Steps

1. Choose an authentication method from the list above
2. Follow the Quick Start guide for your chosen method
3. Review the Advanced Configuration if you have complex requirements
4. Configure [Authorization](authorization-overview) to define what authenticated users can access
