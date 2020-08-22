---
title: System Administration
slug: sgadmin-system-administration
category: sgadmin
order: 300
layout: docs
edition: community
description: sgadmin offers some handy and powerful tools for administering a Search Guard secured Elasticsearch custer
---

<!---
Copyright 2020 floragunn GmbH
-->

# System administration
{: .no_toc}

{% include toc.md %}

sgadmin offers some handy and powerful switches for administering a Search Guard secured Elasticsearch custer.

## Index and replica settings

The following switched control the Search Guard index settings.

| Name | Description |
|---|---|
| -er | Set explicit number of replicas or autoexpand expression for searchguard index|
| -era | Enable replica auto-expand.|
| -dra | Disable replica auto-expand.|
| -us | Update the replica settings.|
{: .config-table}

The first time you run sgadmin.sh, the ```-us```, ```-era```, ```dra```, and ```-rl``` (reload configuration), flags can cause the initial setup to fail, as the searchguard index does not yet exist.

See chapter [index management](../_docs_configuration_changes/configuration_sgindex.md) for more details on how the Search Guard index is structured and how to manage it.

## Cache invalidation 

Search Guard by default caches authenticated users and their roles and permissions for one hour. You can invalidate the cache by reloading the Search Guard configuration:

```bash
./sgadmin.sh -rl -ts ... -tspass ... -ks ... -kspass ...
```
| Name | Description |
|---|---|
| -rl | reload the current Search Guard configuration stored in your cluster, invalidating any cached users, roles and permissions.|
{: .config-table}

## Rescue tools

| Name | Description |
|---|---|
| -dci | Delete the Search Guard configuration index and exit. May be useful if the cluster state is red due to a corrupt Search Guard index. |
| -esa | Enable shard allocation and exit. May be useful if you disabled shard allocation while performing a full cluster restart, and you need to recreate the Search Guard index. |
{: .config-table}

## License information

| Name | Description |
|---|---|
| -si | Displays the currently active Search Guard license |
{: .config-table}

## Whoami

| Name | Description |
|---|---|
| -w | Displays information about the used admin certificate |
{: .config-table}




