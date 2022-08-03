---
title: Quick Start
html_title: Quickly migrating from older Search Guard versions
permalink: sg-classic-config-migration-quick
category: kibana-authentication-migration-overview
order: 100
layout: docs
edition: community
description: How to migrate older Search Guard authentication configurations to sg_authc.yml and sg_frontend_authc.yml
---
<!---
Copyright 2022 floragunn GmbH
-->

# Quick Start: Migrating from Search Guard 53 and before
{: .no_toc}

This chapter describes how to quickly migrate legacy Search Guard configuration to the new structure. This is useful for testing - possibly as a preparatory step for updating a production cluster.

**Note:** If you need to update a production cluster with only minimal outage, refer to [the corresponding guide](sg53_migration_prod.md).

## Prerequisites

In order to perform the migration, you need the following:

- The file `sg_config.yml` from the existing Elasticsearch setup.
- Sometimes, `sg_config.yml` references further files, such as PEM files. You need these as well.
- If you are also using Kibana, you need the file `kibana.yml` from the `config` directory of the existing Kibana setup.
- A system to run the test setup. This can a remote system or your local computer. 
- You need to download the `sgctl` tool. It does not require any special installation, just copy it to a suitable place and execute it.

## Migrating the configuration

Open a shell and perform the following steps:

- Create a work directly 
- Call `sgctl migrate-config /path/to/legacy/sg_config.yml /path/to/legacy/kibana.yml -o /path/to/your/work/directory`. Be sure to specify the correct paths to the files `sg_config.yml` and `kibana.yml`. If you are using Elasticsearch 7.11 or newer, additionally specify the option `--target-platform es711`. If you are not using Kibana, just omit the path to  `kibana.yml`.
- `sgctl` will now create new configuration files and print additional information to the console. Carefully review the printed information and the produced configuration.
- The new Search Guard version requires that users who shall be allowed to log into Kibana have a certain privilege. If your users are mapped to the role `SGS_KIBANA_USER` (which was already a recommended practice before), the users will automatically have that privilege. If your users are not mapped to the role, you need to edit your role mapping accordingly.
- Start your Elasticsearch test instance and upload the newly generated config files using `sgctl`. These will be `sg_authc.yml` and - depending on the configuration - a couple of further files. 
- Copy the new `kibana.yml` to the `config` directory of the Kibana test instance and start Kibana.

## Testing the configuration

### Elasticsearch

If you are using password-based authentication, just open `https://your-cluster.example.com:9200/_searchguard/authinfo` in your favorite web browser. 

If you are experiencing issues, you can switch on debug mode. For this, either edit `sg_authc.yml`, add `debug: true` to the top level and upload the file using `sgctl`. Alternatively, just use this command:

```
$ ./sgctl.sh set authc debug --true
```

You can then open the URL `https://your-cluster.example.com:9200/_searchguard/auth/debug` to see detailed information on what is going on during the login process.

**Note:** This mode might reveal sensitive data. Only use this mode on test clusters. Do not forget to switch the debug mode off before going into production.

More on this: [Debugging the authc configuration](../_docs_auth_auth/auth_auth_rest_config.md#debugging-the-authc-configuration).

## Kibana

For testing the configuration, just open the Kibana test instance in your favorite web browser. 

You can also enable a debug mode for Kibana. Use the following command:

```
$ ./sgctl.sh set frontend_config debug --true
```

When debug mode is active, again open Kibana in your browser and try to log in. If you encounter a login failure, you should see more detailed information about the login process. 

More more details refer to the [Troubleshooting](kibana_authentication_troubleshooting.md) section.

