---
title: Configuration changes
html_title: Configuration Changes
permalink: sgctl-configuration-changes
layout: docs
edition: community
description: How to use sgctl to connect to an Elasticsearch cluster and upload configuration
  changes
---
<!---
Copyright 2022 floragunn GmbH
-->

# Configuration changes
{: .no_toc}

{% include toc.md %}

You can use sgctl to change upload all configuration files or just a single one.

sgctl will replace the current configuration in your Elasticsearch cluster with the one you provide. We recommended to [backup](#backup-and-restore) the configuration first before applying changes. This is to make sure you don't accidentally overwrite your existing configuration.
{: .note .js-note .note-warning}

## Uploading a single configuration file

If you want to push a single configuration file, use:

```bash
./sgctl.sh update-config /path/to/configfile.yaml  
```

## Uploading multiple configuration files

To upload multiple configuration files, use:

```bash
./sgctl.sh update-config /path/to/configfile.yaml /path/to/another/configfile.yaml  
```

## Uploading multiple configuration files from a directory

To upload multiple configuration files at once, point sgctl to the directory where the files are located: 

```bash
./sgctl.sh update-config /path/to/configs/
```

## Backup and Restore

You can download all current configuration files from your cluster with the following command:

```bash
./sgctl.sh get-config -o /path/to/store/
```

This will dump the currently active Search Guard configuration from your cluster to individual files in the specified folder. You can then use these files to upload the configuration again to the same or a different cluster. This is for example useful when moving a PoC to production.

To upload the dumped files to another cluster use:

```bash
./sgctl.sh update-config /path/to/store/
```

