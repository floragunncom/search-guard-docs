---
title: Basic Usage
permalink: sgctl
category: sgctl
order: 100
layout: docs
edition: community
index: false
description: Use the powerful and easy-to-use sgctl command line tool to manage and configure  everything in Search Guard.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Using `sgctl` to Configure Search Guard
{: .no_toc}

{% include toc.md %}



The Search Guard configuration is stored in an index on the OpenSearch/Elasticsearch cluster. This allows for configuration hot-reloading, and eliminates the need to place configuration files on any node.

Configuration settings are uploaded to the Search Guard configuration index using the `sgctl` tool. When installing Search Guard for the first time, you have to run `sgctl` at least once to initialize the configuration index.

You have to download `sgctl` separately at [https://maven.search-guard.com/search-guard-suite-release/com/floragunn/sgctl/](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/sgctl/). The same `sgctl` command can be used both for OpenSearch clusters and Elasticsearch clusters.

<!--
You can find sample sgadmin calls in the [examples chapter](configuration_sgadmin_examples.md)
-->

## Connection Settings

`sgctl` is able to store and automatically re-use the basic connection settings for a cluster. In order to initially set up a connection to a cluster, execute `sgctl` this way:

```bash
$ ./sgctl.sh connect localhost --ca-cart /path/to/root-ca.pem --cert /path/to/admin-cert.pem --key /path/to/admin-cert-private-key.pem
```

You need to replace the path specifications by paths to the certificate of the root CA which signed the TLS certificates by your cluster (`--ca-cert`)  and by an admin 
certificate and its corresponding private key (`--cert` and `--key`). If the private key is password protected, specify `--key-pass` to be get a request for the password on the command line.

If the Elasticsearch REST port is not the default 9200, you also need to specify the port using the `-p` parameter.

If the connection is successful, the command should print `Connected as CN=kirk,OU=client,O=client,L=test,C=de` and store the connection configuration for future
use. The connection settings are stored in the `.searchguard` directory inside your home directory. You can test this by just executing:

```bash
$ ./sgctl.sh connect
```

### Managing Connection Settings for Several Clusters

`sgctl` makes it easy to manage several clusters at once. To connect to another cluster, just type:

```bash
$ ./sgctl.sh connect another-cluster-host.example.com --ca-cart /another/path/to/root-ca.pem --cert /another/path/to/admin-cert.pem --key /another/path/to/admin-cert-private-key.pem
```

This will now connect to this cluster and store the connection settings separately. From now on, in order to switch between both clusters, just type:


```bash
$ ./sgctl.sh connect localhost
```

or


```bash
$ ./sgctl.sh connect another-cluster-host.example.com
```

**Note:** By default, `sgctl` uses the host name as identifier of the cluster. If you want to use your own identifiers, you can use the `-c` option to specify it:

```bash
$ ./sgctl.sh connect -c my-cluster 2001:0db8:85a3:0000:0000:8a2e:0370:7334 --ca-cart /another/path/to/root-ca.pem --cert /another/path/to/admin-cert.pem --key /another/path/to/admin-cert-private-key.pem
```

Reconnect whith:

```bash
$ ./sgctl.sh connect -c my-cluster
```

## Uploading Search Guard Configuration

The most important command of `sgctl` is probably `sgctl update-config`. This command is used to upload Search Guard YAML configuration files to Search Guard. 

You can specify single files to be uploaded:

```bash
$ ./sgctl.sh update-config path/to/config/dir/sg_internal_users.yml path/to/config/dir/sg_roles.yml
```

... or also or a whole directory:

```bash
$ ./sgctl.sh update-config path/to/config/dir/
```
