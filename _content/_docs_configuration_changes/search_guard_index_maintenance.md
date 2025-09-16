---
title: Configuration index maintenance
html_title: Search Guard Configuration Index Maintenance
permalink: search-guard-index-maintenance
layout: docs
edition: community
description: Search Guard stores its configuration in an Elasticsearch index. This
  allows for configuration hot-reloading
---
<!--- Copyright 2022 floragunn GmbH -->

# Search Guard configuration index maintenance
{: .no_toc}

As already explained, the major settings of Search Guard are stored in indices. In this section, we are explaining advanced maintenance techniques of these indices.

{% include toc.md %}

## Index name

On a fresh installation, Search Guard FLX uses `.searchguard` as name for the main configuration index. If Search Guard FLX is started on a cluster which still uses the legacy `searchguard` index (without the leading period), Search Guard will use that index name until it finds an index called `.searchguard`. 

Using `.searchguard` as index name has the advantage that it is treated as a hidden index, which is not matched by normal wildcards. If you want to migrate your cluster from the `searchguard` index to the `.searchguard` index, you can do so as described in the section [Index name migration](#index-name-migration).

Search Guard allows the configuration of the index name using special settings. However, such a customization is strongly discouraged.


## Backup and Restore

Use `sgctl` to backup the contents of the Search Guard configuration index

Backup the current configuration from the currently connected cluster and place the files in /etc/sgbackup/:

```
$ ./sgctl.sh get-config -o /etc/sgbackup/
```

To upload the dumped files, use:

```
$ ./sgctl.sh update-config /etc/sgbackup/
```

To upload the files to another cluster, either create a separate connection profile or directly specify the connection configuration on the `sgtl update-config` command line. This may look like this:

```
$ ./sgctl.sh connect production.example.com -p 9301 --ca-cert /another/path/to/root-ca.pem --cert /another/path/to/admin-cert.pem --key /another/path/to/admin-cert-private-key.pem

$ ./sgctl.sh update-config /etc/sgbackup/
```


## Replica shards

Search Guard manages the number of replica shards of the Search Guard index automatically. If the Search Guard index is created for the first time, the number of replica shards is set to the number of nodes - 1. If you add or remove nodes, the number of shards will be increased or decreased automatically. This means that a primary or replica shard of the Search Guard index is available on all nodes.

**Note:** The commands listed in this section assume that the Search Guard index is called `.searchguard`. If it has a different name on your cluster, you need to adapt it inside the command.

If you want to manage the number of replica shards yourself, you can disable the replica auto-expand feature by using the following command:

```
$ ./sgctl.sh rest put .searchguard/_settings --json '{"index":{"auto_expand_replicas": "false"}}'
```

To set the number of replica shards, use the following command. Be sure to change the number after `number_of_replicas` to the desired value:

```
$ ./sgctl.sh rest put .searchguard/_settings --json '{"index":{"number_of_replicas": 42}}'
```


To re-enable replica auto-expansion, use the following command:

```
$ ./sgctl.sh rest put .searchguard/_settings --json '{"index":{"auto_expand_replicas": "0-all"}}'
```

## Disable auto expand replicas of the Search Guard index

There are several situations where the auto-expand feature is not suitable including:

* When using a Hot/Warm Architecture
* Running multiple instances of Elasticsearch on the same host machine
* When `cluster.routing.allocation.same_shard.host` is set to `false`, see also [elastic/elasticsearch#29933](https://github.com/elastic/elasticsearch/issues/29933)
* The searchguard index stays constantly yellow

To solve this disable the auto-expand replicas feature of the searchguard index and set the number of replicas manually.
You can also keep the auto-expand replicas feature and set it to "0-n" where n is the number of datanodes-2.

## Index name migration

Migrating from the `searchguard` index name to the `.searchguard` index name is relatively easy. However, you should test the procedure on a staging cluster before performing it on a production cluster.

The basic principle of the migration is that Search Guard will prefer to use the `.searchguard` index over the `searchguard` index as soon as it finds it.

You can use the `sgctl special move-sg-index` command to achieve this goal. The command does the following:

- Copy the contents of the `searchguard` index to the new `.searchguard` index
- Validate that configuration can be successfully loaded from the new index
- Notify Search Guard of the change

Immediately after, Search Guard will read and write configuration only from the `.searchguard` index.

The `sgctl special move-sg-index` command does not delete the old index. You need to do this by yourself after you have verified that the migration was successful.



