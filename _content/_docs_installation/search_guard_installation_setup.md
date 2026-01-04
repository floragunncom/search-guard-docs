---
title: Installation and Setup
html_title: Installation and Setup
permalink: search-guard-installation-setup
layout: docs
section: security
description: Complete guide to installing and setting up Search Guard
---

<!--- Copyright 2025 floragunn GmbH -->

# Installation and Setup

This section covers everything needed to install and configure Search Guard in your Elasticsearch environment, from initial installation through TLS setup and version management.

## What's in This Section

- **[Installation](search-guard-installation)** - Step-by-step installation of Search Guard plugins
- **[TLS Certificate Setup](search-guard-tls-setup)** - Configure transport and REST layer encryption
- **[Versions and Compatibility](search-guard-versions-compatibility)** - Find compatible versions and check EOL status
- **[Upgrades and Migrations](search-guard-upgrades)** - Upgrade between versions or migrate from classic to FLX

## Installation Workflow

### 1. Install Search Guard Plugins

Start with [Installation](search-guard-installation) to install the Search Guard Elasticsearch and Kibana plugins. This guide covers plugin installation for all supported versions.

### 2. Set Up TLS Encryption

TLS is required for Search Guard. The [TLS Certificate Setup](search-guard-tls-setup) section provides:
- **[Quick Setup (TLS Tool)](offline-tls-tool)** - Generate certificates automatically (recommended)
- **[Alternative (Installer)](tls-certificates-installer)** - Use the installer method
- **[Configuring TLS](configuring-tls)** - Configure transport and REST layer TLS
- **[Certificate Revocation](elasticsearch-certificate-revocation)** - Implement certificate revocation
- **[TLS Hot Reload](hot-reload-tls)** - Reload certificates without restart

### 3. Verify Compatibility

Check the [Versions and Compatibility](search-guard-versions-compatibility) section to ensure you're using compatible versions:
- **[Available Versions](search-guard-versions)** - Download links for all versions
- **[Compatibility Matrix](search-guard-compatibility)** - Elasticsearch/Search Guard version compatibility
- **[End of Life Policy](eol-policy)** - Support lifecycle information

### 4. Upgrade or Migrate (If Needed)

If upgrading an existing installation or migrating from classic Search Guard, see [Upgrades and Migrations](search-guard-upgrades):
- **[Upgrading Between Minor Versions](upgrading)** - Standard upgrade process
- **[Upgrading from FLX 1.x to 2.x](sg-200-upgrade)** - Major version upgrade guide
- **[Upgrading from 7.x to 8.x](sg-upgrade-7-8)** - Cross-major version upgrade
- **[Migrating from Classic to FLX](search-guard-migration)** - Migration from pre-FLX versions

## Prerequisites

Before installation, ensure you have:
- Compatible Elasticsearch version installed
- Java 11 or higher (Java 17 recommended)
- Sufficient disk space for plugin installation
- Network access to download Search Guard plugins

## Next Steps

After completing installation and setup, proceed to [Configuration](search-guard-configuration) to configure users, roles, and permissions.
