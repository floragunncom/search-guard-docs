---
title: Manual Installation
html_title: Manual Installation
permalink: manual-installation
layout: docs
edition: community
description: How to download and install Search Guard and all required TLS certificates
  on a Windows machine.
---
<!--- Copyright 2022 floragunn GmbH -->

# Search Guard Manual Installation
{: .no_toc}

{% include toc.md %}

This guide provides step-by-step instructions for manually installing Search Guard to secure your Elasticsearch deployment. You can follow these instructions to set up a single-node test environment on your local machine.

## Overview

The installation process consists of these main steps:

1. Installing the Search Guard plugin in Elasticsearch
2. Configuring TLS certificates
3. Adding Search Guard settings to Elasticsearch
4. Setting up Kibana with Search Guard (optional)

## Required Components

Before you begin, download the following components:

| Component | Download Location |
|-----------|------------------|
| Elasticsearch | [Elasticsearch Downloads](https://www.elastic.co/downloads/elasticsearch) |
| Kibana (optional) | [Kibana Downloads](https://www.elastic.co/downloads/kibana) |
| Search Guard Elasticsearch Plugin | [Search Guard Versions](https://docs.search-guard.com/latest/search-guard-versions) |
| Search Guard Kibana Plugin (optional) | [Search Guard Versions](https://docs.search-guard.com/latest/search-guard-versions) |
| Search Guard Control Tool (sgctl) | [sgctl Download](https://maven.search-guard.com/search-guard-flx-release/com/floragunn/sgctl/) |
| Search Guard Demo Certificates | [Demo Certificates](https://maven.search-guard.com//downloads/search-guard-demo-certificates.zip) |

**Note:** While Elasticsearch and Kibana downloads are typically OS-specific, the Search Guard plugins work on any operating system.

## Installing Search Guard for Elasticsearch

### Step 1: Install Elasticsearch

Unzip/untar your Elasticsearch download to a location of your choice. This will be your Elasticsearch installation directory.

### Step 2: Install the Search Guard Plugin

1. Download the Search Guard plugin version that matches your Elasticsearch version
2. Navigate to your Elasticsearch installation directory and run:

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-{{site.elasticsearch.majorversion}}-<version>.zip
```

### Step 3: Configure TLS Certificates

1. Download the [demo certificates zip file](https://maven.search-guard.com//downloads/search-guard-demo-certificates.zip)
2. Extract all certificate files to your Elasticsearch configuration directory:

```
<ES installation directory>/config
```

**Important:** The demo certificates are self-signed and should only be used for testing. In production, use certificates from a trusted certificate authority.

### Step 4: Configure Search Guard Settings

Add the following configuration to your `elasticsearch.yml` file:

```yaml
# Transport layer TLS settings
searchguard.ssl.transport.pemcert_filepath: esnode.pem
searchguard.ssl.transport.pemkey_filepath: esnode-key.pem
searchguard.ssl.transport.pemtrustedcas_filepath: root-ca.pem
searchguard.ssl.transport.enforce_hostname_verification: false

# HTTP layer TLS settings
searchguard.ssl.http.enabled: true
searchguard.ssl.http.pemcert_filepath: esnode.pem
searchguard.ssl.http.pemkey_filepath: esnode-key.pem
searchguard.ssl.http.pemtrustedcas_filepath: root-ca.pem

# Demo mode settings (disable in production)
searchguard.allow_unsafe_democertificates: true
searchguard.allow_default_init_sgindex: true

# Admin certificate DN
searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test,C=de

# Additional security settings
searchguard.check_snapshot_restore_write_privileges: true
searchguard.restapi.roles_enabled: ["SGS_ALL_ACCESS"]
xpack.security.enabled: false
```

### Step 5: Start Elasticsearch

Start Elasticsearch and wait for it to initialize:

```bash
./bin/elasticsearch
```

## Verifying Your Elasticsearch Installation

To confirm that Search Guard is properly installed and configured:

1. Open `https://localhost:9200/_searchguard/authinfo` in your browser
2. Accept the self-signed certificate warning
3. When prompted for authentication, enter:
    * Username: `admin`
    * Password: `admin`
4. You should see JSON output containing information about the `admin` user

## Managing Search Guard Configuration

Search Guard stores its configuration in a dedicated Elasticsearch index. To modify this configuration, you can use either:

* The Search Guard Configuration GUI (Enterprise feature)
* The `sgctl` command-line tool

### Using sgctl for Configuration Management

#### Setting Up sgctl

1. First, create a connection configuration:

```bash
./sgctl.sh connect localhost --ca-cert /path/to/root-ca.pem --cert /path/to/kirk.pem --key /path/to/kirk-key.pem
```

This command should print `Connected as CN=kirk,OU=client,O=client,L=test,C=de` if successful. Connection settings are stored in the `.searchguard` directory in your home folder.

2. Test the connection:

```bash
./sgctl.sh connect
```

#### Retrieving Current Configuration

To export the current Search Guard configuration:

```bash
./sgctl.sh get-config -o path/to/output/dir/
```

#### Applying Configuration Changes

1. Edit the exported YAML files to make your changes
2. Upload the modified files:

```bash
./sgctl.sh update-config path/to/config/dir/
```

You can also update individual files:

```bash
./sgctl.sh update-config path/to/config/dir/sg_internal_users.yml
```

## Installing Search Guard for Kibana (Optional)

### Step 1: Install the Search Guard Kibana Plugin

Navigate to your Kibana installation directory and run:

```bash
bin/kibana-plugin install file:///path/to/kibana-plugin.zip
```

### Step 2: Configure Kibana for Search Guard

Add the following settings to your `kibana.yml` file:

```yaml
# Use HTTPS for Elasticsearch connection
elasticsearch.hosts: "https://localhost:9200"

# Kibana server user credentials
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"

# Disable SSL verification for demo certificates
elasticsearch.ssl.verificationMode: none

# Enable Search Guard multi-tenancy
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant" ]

# Disable X-Pack security (required for Elasticsearch 7)
xpack.security.enabled: false
```

{% include es8_migration_note.html deprecated_properties="xpack.security.enabled" %}

### Step 3: Start Kibana

```bash
bin/kibana
```

When first starting, Kibana will optimize and cache browser bundles, which may take several minutes.

## Verifying Your Kibana Installation

1. Navigate to `http://localhost:5601/`
2. You should be redirected to the Kibana login page
3. Log in with username `admin` and password `admin`

If successful, you should see three new navigation entries in the left pane:
* Search Guard - configuration interface
* Tenants - tenant selection for multi-tenancy
* Logout - session management

## Configuration Options

The Search Guard configuration GUI provides interfaces for managing:

| Component | Description |
|-----------|-------------|
| Search Guard Roles | Define access permissions to indices and types |
| Action Groups | Create reusable permission sets |
| Role Mappings | Connect users to Search Guard roles |
| Internal User Database | Manage users stored in Elasticsearch |

Additionally, you can view license information and system status.

## Next Steps

After installation, you should:

1. Familiarize yourself with [Search Guard Main Concepts](../_docs_quickstart/main_concepts.md)
2. Configure permissions using either configuration files or the GUI:
    * [Using and defining action groups](../_docs_roles_permissions/configuration_action_groups.md)
    * [Defining roles and permissions](../_docs_roles_permissions/configuration_roles_permissions.md)
    * [Mapping users to Search Guard roles](../_docs_roles_permissions/configuration_roles_mapping.md)
    * [Managing the internal user database](../_docs_roles_permissions/configuration_internalusers.md)

For advanced features, consider:

* [Enterprise authentication backends](../_docs_auth_auth/auth_auth_configuration.md) (Active Directory, LDAP, Kerberos, JWT)
* [Document and field level security](../_docs_dls_fls/dlsfls_dls.md)
* [Audit logging](../_docs_audit_logging/auditlogging.md) for compliance with regulations like GDPR, HIPAA, PCI
* [Kibana Multi-Tenancy](../_docs_kibana/kibana_multitenancy.md) for separating dashboards by tenant