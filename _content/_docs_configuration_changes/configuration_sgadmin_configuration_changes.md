---
title: Configuration changes
html_title: Configuration Changes
permalink: sgadmin-configuration-changes
category: sgadmin
order: 200
layout: docs
edition: community
description: How to use sgadmin to connect to an Elasticsearch cluster and upload configuration changes
---
<!---
Copyright 2020 floragunn GmbH
-->

# Configuration changes
{: .no_toc}

{% include toc.md %}

The Search Guard configuration is comprised of the following files:

* **sg_config.yml** - [Authentication and authorization](authentication-authorization) settings
* **sg_roles.yml** - [Search Guard roles](roles-permissions) defining access permissions to indices, documents and fields
* **sg_action_groups.yml** - [pre-defined permission sets](action-groups) like READ, WRITE, DELETE. Used to define access permissions for Search Guard roles.
* **sg_internal_users.yml** - users stored in the [Search Guard internal user database](internal-users-database)
* **sg_roles_mapping.yml** - defines how [Search Guard roles are assigned to users](mapping-users-roles)
* **sg_blocks.yml** - defines access control rules on a global level, for example blocking IPs or IP ranges
* **sg_tenants.yml** - defines the available tenants for [Kibana multi-tenancy](kibana-multi-tenancy)

You can use sgadmin to change upload all configuration fies or just a single one.

sgadmin will replace the current configuration in your Elasticsearch cluster with the one you provide. We recommended to [backup](#backup-and-restore) the configuration first before applying changes. This is to make sure you don't accidentially overwrite your existing configuration.
{: .note .js-note .note-warning}

## Uploading a single configuration file

If you want to push a single configuration file, use:

```bash
./sgadmin.sh \
    -f /path/to/configfile.yaml  \
    -cacert /path/to/root-ca.pem \
    -cert /path/to/admin-certificate.pem \
    -key /path/to/admin-certificate-key.pem    
```

Example:

```bash
./sgadmin.sh \
    -f ../sgconfig/sg_internal_users.yml  \
    -cacert ../../../root-ca.pem \
    -cert ../../../kirk.pem \
    -key ../../../kirk.key.pem    
```

| Name | Description |
|---|---|
| -f | Single config file (cannot be used together with -cd).  |
{: .config-table}

## Uploading multiple configuration files

To upload multiple configuration files at once, point sgadmin to the directory where the files are located: 

```bash
./sgadmin.sh \
    -cd /path/to/configdirectory/  \
    -cacert /path/to/root-ca.pem \
    -cert /path/to/admin-certificate.pem \
    -key /path/to/admin-certificate-key.pem    
```

Example:

```bash
./sgadmin.sh \
    -cd ../sgconfig/  \
    -cacert ../../../root-ca.pem \
    -cert ../../../kirk.pem \
    -key ../../../kirk.key.pem    
```

| Name | Description |
|---|---|
| -cd | Directory containing multiple Search Guard configuration files. |
{: .config-table}

## Environment variable substitution

Some configuration files may contain senstive information. You can use [placeholders in configuration files](configuration_environment_variables.md) which sgadmin will replace with environment variables before uploading the configuration to the Elasticsearch cluster. The environment variables must be configured on the machine you run sgadmin from.

| Name | Description |
|---|---|
| -rev | Replace placeholders in configuration files  |
{: .config-table}

## Validating configuration files

Before uploading new configurations to your cluster, you can validate them:

```bash
./sgadmin.sh \
    -cd /path/to/configdirectory/  \
    -vc <6|7>
    -cacert /path/to/root-ca.pem \
    -cert /path/to/admin-certificate.pem \
    -key /path/to/admin-certificate-key.pem    
```

Example:

```bash
./sgadmin.sh \
    -cd ../sgconfig/ \
    -vc 7 \
    -cacert ../../../root-ca.pem \
    -cert ../../../kirk.pem \
    -key ../../../kirk.key.pem    
```

| Name | Description |
|---|---|
| -vc/--validate-configs <version> | Validate configuration files specified by the -cd or -t switch. Version must be 6 for Search Guard 6 and 7 for Search Guard 7|
{: .config-table}

## Backup and Restore

You can download all current configuration files from your cluster with the following command:

```bash
./sgadmin.sh \
    -backup /path/to/configdirectory/  \
    -cacert /path/to/root-ca.pem \
    -cert /path/to/admin-certificate.pem \
    -key /path/to/admin-certificate-key.pem    
```

This will dump the currently active Search Guard configuration from your cluster to individual files in the specified folder. You can then use these files to upload the configuration again to the same or a different cluster. This is for example useful when moving a PoC to production.

To upload the dumped files to another cluster use:

```bash
./sgadmin.sh \
    -cd /path/to/configdirectory/  \
    -cacert /path/to/root-ca.pem \
    -cert /path/to/admin-certificate.pem \
    -key /path/to/admin-certificate-key.pem    
```

| Name | Description |
|---|---|
| -backup <folder> | retrieve the current Search Guard configuration from a running cluster, and dump it to the specified <folder>|
{: .config-table}