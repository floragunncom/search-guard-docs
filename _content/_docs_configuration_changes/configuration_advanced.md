---
title: Configuration index maintenance
html_title: Search Guard Configuration Index Maintenance
permalink: search-guard-index-maintenance
category: configuration
order: 1000
layout: docs
edition: community
description: Search Guard stores its configuration in an OpenSearch/Elasticsearch index. This allows for configuration hot-reloading
---
<!--- Copyright 2020 floragunn GmbH -->

# Search Guard configuration index maintenance
{: .no_toc}

As already explained, the major settings of Search Guard are stored in indices. In this section, we are explaining advanced maintenance techniques of these indices.

{% include toc.md %}

## Index name

If nothing else is specified, Search Guard uses `searchguard` as index name.  

You can configure the name of the Search Guard index in `opensearch.yml` or `elasticsearch.yml` by setting:

```
searchguard.config_index_name: myindexname 
```


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
$ ./sgctl.sh connect production.example.com -p 9301 --ca-cart /another/path/to/root-ca.pem --cert /another/path/to/admin-cert.pem --key /another/path/to/admin-cert-private-key.pem

$ ./sgctl.sh update-config /etc/sgbackup/
```


## Replica shards

Search Guard manages the number of replica shards of the Search Guard index automatically. If the Search Guard index is created for the first time, the number of replica shards is set to the number of nodes - 1. If you add or remove nodes, the number of shards will be increased or decreased automatically. This means that a primary or replica shard of the Search Guard index is available on all nodes.

If you want to manage the number of replica shards yourself, you can disable the replica auto-expand feature by using the `-dra` switch of sgadmin. To set the number of replica shards, use sgadmin with the `-us` switch. To re-enable replica auto-expansion, use the `-era` switch. See also section "Index and replica settings" in the [sgadmin chapter](../_docs_configuration_changes/configuration_sgadmin.md).

Note that the `-us`, `-era` and `-dra` only apply if there is an existing Search Guard index.

## Disable auto expand replicas of the Search Guard index

There are several situations where the auto-expand feature is not suitable including:

* When using a Hot/Warm Architecture
* Running multiple instances of OpenSearch/Elasticsearch on the same host machine
* When `cluster.routing.allocation.same_shard.host` is set to `false`, see also [elastic/elasticsearch#29933](https://github.com/elastic/elasticsearch/issues/29933)
* The searchguard index stays constantly yellow

To solve this disable the auto-expand replicas feature of the searchguard index and set the number of replicas manually.
You can also keep the auto-expand replicas feature and set it to "0-n" where n is the number of datanodes-2.
