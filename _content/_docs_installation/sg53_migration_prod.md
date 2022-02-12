---
title: Production
html_title: Migrating older SG authentication configuration with minimal outage
permalink: kibana-authentication-migration-prod
category: kibana-authentication-migration-overview
order: 300
layout: docs
edition: community
description: How to migrate older Kibana authentication configurations to sg_frontend_config.yml with minimal outage
---
<!---
Copyright 2020 floragunn GmbH
-->

# Production Cluster: Migrating from Search Guard 52 and before
{: .no_toc}

This chapter describes how to migrate a cluster running legacy Search Guard configuration to the new structure with minimal outage.

**Please Note:** 

- You should do a test run on a test cluster before doing the actual migration.
- Users that were logged into Kibana while the update is performed, will need to log in again after the update is finalized.


## Prerequisites

In order to perform the migration, you need the following:

- The file `sg_config.yml` from the existing Elasticsearch setup.
- Sometimes, `sg_config.yml` references further files, such as PEM files. You need these as well.
- If you are also using Kibana, you need the file `kibana.yml` from the `config` directory of the existing Dashboards/Kibana setup.
- You need to download the `sgctl` tool. It does not require any special installation, just copy it to a suitable place and execute it.

## Migrating the Configuration

Open a shell and perform the following steps:

- Create a work directly 
- Call `sgctl migrate-config /path/to/legacy/sg_config.yml /path/to/legacy/kibana.yml -o /path/to/your/work/directory`. Be sure to specify the correct paths to the files `sg_config.yml` and `kibana.yml`. If you are using Elasticsearch 7.11 or newer, additionally specify the option `--target-platform es711`. If you are not using Kibana, just omit the path to  `kibana.yml`.
- `sgctl` will now create new configuration files and print additional information to the console. Carefully review the printed information and the produced configuration.
- The new Search Guard version requires that users who shall be allowed to log into Kibana have a certain privilege. If your users are mapped to the role `SGS_KIBANA_USER` (which was already a recommended practice before), the users will automatically have that privilege. If your users are not mapped to the role, you need to edit your role mapping accordingly.

## Applying the Configuration

To execute the update, follow this process:

- Perform a rolling update of the Search Guard Elasticsearch plugin.
- Use `sgctl` to upload the `sg_frontend_config.yml` file produced by `sgctl`. 
- Perform an update of the Search Guard Kibana plugin. Also, copy the new `kibana.yml` file to the `config` directory of the Kibana installation.
- Restart the Kibana instance.
- Now also upload the other generated files (`sg_authc.yml`, and possibly `sg_authz.yml`, `sg_frontend_multi_tenancy.yml`, `sg_auth_token_service.yml`, `sg_license_key.yml`) file using `sgctl`.

The update is now finished. Users which were logged in before, will now have to login again once.

