---
title: Demo Installer (Linux/Mac)
html_title: Demo Installer
permalink: demo-installer
layout: docs
edition: community
description: Search Guard ships with a demo installer for quickly setting up a working
  configuration. Use it for PoCs or checking out our features.
resources:
  - search-guard-presentations#quickstart|Search Guard Quickstart and First Steps (presentation)
  - search-guard-presentations#architecture-request-flow|Architecture and Request Flow
    (presentation)
  - search-guard-presentations#configuration-basics|Configuration Basics (presentation)
---
<!--- Copyright floragunn GmbH -->

{% include global_variables.html %}

# Demo Installer
{: .no_toc}

{% include toc.md %}

## Introduction

Search Guard provides a demo installation script that helps you quickly set up a fully functional Search Guard environment on a test instance of Elasticsearch. This is the ideal way to explore Search Guard features or create a proof of concept on your local computer without complex configuration steps.

## Running the Demo Installer

Follow these steps to install and run the Search Guard demo:

### Step 1: Download and Prepare the Installer

1. Download the demo installer script for your desired version:
  * [All Search Guard Releases](search-guard-versions)

2. Create a dedicated working directory and navigate to it:
   ```bash
   mkdir search-guard-demo
   cd search-guard-demo
   ```

3. If necessary, make the script executable:
   ```bash
   chmod u+x search-guard-flx-elasticsearch-plugin-{{versionstring}}-demo-installer.sh
   ```

### Step 2: Run the Installer

Execute the installer script:

```bash
./search-guard-flx-elasticsearch-plugin-{{versionstring}}-demo-installer.sh
```

The script performs the following actions automatically:
* Downloads the Search Guard plugins and the `sgctl` configuration tool
* Downloads matching versions of Elasticsearch and Kibana
* Extracts these components to your working directory
* Installs the Search Guard plugins
* Applies the basic configuration required for Search Guard and `sgctl`

### Step 3: Verify Installation

After the script completes, verify the installation by checking the directory contents:

```bash
ls -lh
```

You should see the following items:
* Administrator authentication keys (`admin-key.pem` and `admin.pem`)
* Elasticsearch directory with a ready-to-start setup
* Kibana directory
* Downloaded software archives
* The `sgctl.sh` tool
* Configuration directory (`my-sg-config`)

The directory structure should look similar to this:

```
total 677M
-rw-rw-r--  1 sg sg 1.7K Sep 15 12:35 admin-key.pem
-rw-rw-r--  1 sg sg 1.6K Sep 15 12:35 admin.pem
drwxrwxr-x 10 sg sg 4.0K Sep 15 12:35 elasticsearch
-rw-rw-r--  1 sg sg 329M Sep 15 12:35 elasticsearch-{{site.current_versions.elasticsearch}}-linux-x86_64.tar.gz
drwxrwxr-x 10 sg sg 4.0K Sep 15 12:35 kibana
-rw-rw-r--  1 sg sg 273M Sep 15 12:35 kibana-{{site.current_versions.elasticsearch}}-linux-x86_64.tar.gz
drwxr-xr-x  2 sg sg 4.0K Sep 15 12:35 my-sg-config
-rw-rw-r--  1 sg sg  14M Sep 15 12:35 search-guard-flx-kibana-plugin-{{versionstring}}}.zip
-rw-rw-r--  1 sg sg  49M Sep 15 12:35 search-guard-elasticsearch-plugin-{{versionstring}}.zip
-rwxrwxr-x  1 sg sg  22K Sep 15 12:35 search-guard-elasticsearch-plugin-{{versionstring}}-demo-installer.sh
-rwxrw-r--  1 sg sg  14M Sep 15 12:35 sgctl.sh
```

### Step 4: Start the Services

1. Start Elasticsearch:
   ```bash
   elasticsearch/bin/elasticsearch
   ```

2. Optional: Start Kibana in a separate terminal:
   ```bash
   kibana/bin/kibana
   ```

   > **Note:** When Kibana starts, it will optimize and cache browser bundles. This process may take a few minutes to complete.

## Testing Your Installation

### Verifying Elasticsearch with Search Guard

1. Open `https://localhost:9200/_searchguard/authinfo` in your browser
2. Accept the self-signed TLS certificate when prompted
3. Enter the default credentials:
  * Username: `admin`
  * Password: `admin`
4. You should see information about the `admin` user in JSON format

### Verifying Kibana with Search Guard

1. Open `http://localhost:5601/` in your browser
2. You'll be redirected to the Kibana login page
3. Enter the default credentials:
  * Username: `admin`
  * Password: `admin`
4. After successful login, you should see three additional navigation entries:
  * **Search Guard** - The [configuration GUI](../_docs_configuration_changes/configuration_config_gui.md)
  * **Tenants** - For selecting a [Kibana Multi-Tenancy](../_docs_kibana/kibana_multitenancy.md) tenant
  * **Logout** - To end your current session

## Managing Search Guard Configuration

The Search Guard configuration (users, roles, and permissions) is stored in a dedicated Elasticsearch index called the Search Guard Index. You can modify this configuration using one of two methods:

### Method 1: Using the sgctl Command Line Tool

1. Edit the configuration files in the `my-sg-config` directory
2. Apply changes using the command:
   ```bash
   ./sgctl.sh update-config my-sg-config
   ```

This reads the configuration files and uploads their contents to the Search Guard index.

### Method 2: Using the Search Guard Configuration GUI (Enterprise Feature)

1. Start Kibana if it's not already running
2. Click the menu icon (hamburger icon) in the top left
3. Select "Search Guard" from the menu
4. Use the [Configuration GUI](../_docs_configuration_changes/configuration_config_gui.md) to make and apply changes

## Understanding the Configuration

To learn how Search Guard is configured behind the scenes, examine the automatically generated configuration files:

* `elasticsearch/config/elasticsearch.yml`
* `kibana/config/kibana.yml`

These files contain detailed comments explaining each configuration option. Look for sections like:

```yaml
# -----------------------------------------------------------
# Search Guard Demo Configuration
# -----------------------------------------------------------

# -----
# The root certificate that is used to check the authenticity
# of all other certificates presented to Search Guard
#
searchguard.ssl.transport.pemtrustedcas_filepath: root-ca.pem
searchguard.ssl.http.pemtrustedcas_filepath: root-ca.pem
...
```

## Next Steps

After successfully setting up your Search Guard demo environment, here are recommended next steps:

### Understanding Core Concepts
* Review the [Search Guard Main Concepts](../_docs_introduction/main_concepts.md)

### Configuring Access Control
* [Define and use action groups](../_docs_roles_permissions/configuration_action_groups.md)
* [Configure roles and permissions](../_docs_roles_permissions/configuration_roles_permissions.md)
* [Map users to Search Guard roles](../_docs_roles_permissions/configuration_roles_mapping.md)
* [Add users to the internal database](../_docs_roles_permissions/configuration_internalusers.md)

### Advanced Features
* [Configure enterprise authentication methods](../_docs_auth_auth/auth_auth_configuration.md) (Active Directory, LDAP, Kerberos, JWT)
* Implement [Document and field level security](../_docs_dls_fls/dlsfls_dls.md) for fine-grained access control
* Set up [Audit Logging](../_docs_audit_logging/auditlogging.md) for compliance with regulations like GDPR, HIPAA, PCI, ISO, or SOX
* Configure [Multi-Tenancy](../_docs_kibana/kibana_multitenancy.md) to separate Kibana visualizations and dashboards by tenant

### Production Deployment
* [Configure TLS for production](../_docs_tls/tls_configuration.md)
* [Implement production-ready certificates](../_docs_tls/tls_certificates_production.md)