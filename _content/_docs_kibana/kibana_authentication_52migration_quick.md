---
title: Quick Start
html_title: Quickly migrating older SG authentication configuration
slug: kibana-authentication-migration-quick
category: kibana-authentication-migration-overview
order: 100
layout: docs
edition: community
description: How to migrate older Kibana authentication configurations to sg_frontend_config.yml
---
<!---
Copyright 2020 floragunn GmbH
-->

# Quick Start: Migrating from Search Guard 52 and before
{: .no_toc}

This chapter describes how to quickly migrate legacy Search Guard configuration to the new structure. This is useful for testing - possibly as a preparatory step for updating a production cluster.

**Note:** If you need to update a production cluster with only minimal outage, refer to [the corresponding guide](kibana_authentication_52migration_production.md).

## Prerequisites

In order to perform the migration, you need the following:

- The file `sg_config.yml` from the existing Elasticsearch setup.
- Sometimes, `sg_config.yml` references further files, such as PEM files. You need these as well.
- The file `kibana.yml` from the `config` directory of the existing Kibana setup.
- A system to run the test setup. This can a remote system or your local computer. 
- You need to download the `sgctl` tool. It does not require any special installation, just copy it to a suitable place and execute it.

## Migrating the Configuration

Open a shell and perform the following steps:

- Create a work directly 
- Call `sgctl migrate-config /path/to/legacy/sg_config.yml /path/to/legacy/kibana.yml -o /path/to/your/work/directory`. Be sure to specify the correct paths to the files `sg_config.yml` and `kibana.yml`. If you are using Elasticsearch 7.11 or newer, additionally specify the option `--target-platform es711`.
- `sgctl` will now create new configuration files and print additional information to the console. Carefully review the printed information and the produced configuration.
- The new Search Guard version requires that users who shall be allowed to log into Kibana have a certain privilege. If your users are mapped to the role `SGS_KIBANA_USER` (which was already a recommended practice before), the users will automatically have that privilege. If your users are not mapped to the role, you need to edit your role mapping accordingly.
- Start your Elasticsearch test instance and upload the new `sg_config.yml` and `sg_frontend_config.yml` to it using `sgctl` or `sgadmin`. 
- Copy the new `kibana.yml` to the `config` directory of the Kibana test instance and start Kibana.

## Testing the Configuration

For testing the configuration, just open the Kibana test instance in your favorite web browser. 

If you are experiencing issues, switch on debug mode by editing `sg_config.yml` like this:

```yaml
sg_config:
  dynamic:
    debug: true
    # ...
```

After having activated the configuration with `sgadmin` or `sgctl`, again open Kibana in your browser and try to log in. If you encounter a login failure, you should see more detailed information about the login process. 

More more details refer to the [Troubleshooting](kibana_authentication_troubleshooting.md) section.

