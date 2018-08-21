---
title: Cross Cluster Search and Tribe
html_title: Cross Cluster and Tribe
slug: cross-cluster-tribe
category: ccs
order: 800
layout: docs
edition: community
description: Search Guard fully supports the Cross Cluster Search feature of Elasticsearch. Implement access control on distributed clusters.
---
<!---
Copryight 2017 floragunn GmbH
-->
# Cross Cluster Search Support

Search Guard supports [Cross Cluster Search](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-cross-cluster-search.html){:target="_blank"} out of the box, so there is nothing special to configure to make it work. Cross Cluster Search will replace Tribe nodes which are deprecated in Elasticsearch 6.x.

## Authentication Flow

When accessing a `remote cluster` from a `coordinating cluster` via Cross Cluster Search:

* Search Guard authenticates the user on the coordinating cluster
* Search Guard fetches the users backend roles on the coordinating cluster
* The call including the authenticated user is forwarded to the remote cluster
* The user's permissions are evaluated on the remote cluster

While it is possible to have different configurations regarding authentication and authorization on the remote and coordinating cluster, it is highly recommended to use the same settings on both.

## Permissions

To query indices on remote clusters, the user needs to have the following permissions for this index, in addition to the READ or SEARCH permissions:

```
indices:admin/shards/search_shards
```

Example:

```
sg_ humanresources:
  cluster:
    - CLUSTER_COMPOSITE_OPS_RO
  indices:
    'humanresources':
      '*':
        - READ
        - indices:admin/shards/search_shards # needed for CCS
```

# Tribe nodes

**Note: Tribe nodes are deprecated from Elasticsearch 6.x onwards.**

Search Guard offers support for tribe nodes. A tribe node ["acts as a federated client across multiple clusters"](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-tribe.html){:target="_blank"} and is commonly used to retrieve information from multiple Elasticsearch clusters making it look like one combined cluster.

## Preconditions

In order for tribe nodes to work with Search Guard, please make sure that the Search Guard index, i.e., the configuration settings, are identical on each particpiating cluster.

## Configuration

A tribe node will create a node client to connect to each configured cluster. If the participating clusters are secured via Search Guard, you need to configure the TLS settings on the transport layer for each. Think of the node client the tribe node as a regular node. This means that you need to create a keystore with a valid TLS certificate and the truststore containing the root CA and any intermediate certificate.

```yaml
tribe:
  cl1:
    cluster.name: cl1
    searchguard.ssl.transport.keystore_filepath: cluster-1-keystore.jks
    searchguard.ssl.transport.keystore_password: changeit
    searchguard.ssl.transport.truststore_filepath: truststore.jks
    searchguard.ssl.transport.truststore_password: changeit
  cl2:
    cluster.name: cl2
    searchguard.ssl.transport.keystore_filepath: cluster-2-keystore.jks
    searchguard.ssl.transport.keystore_password: changeit
    searchguard.ssl.transport.truststore_filepath: truststore.jks
    searchguard.ssl.transport.truststore_password: changeit
```
As with regular nodes, you can, and probably should, create a certificate for each node separately, or use the same certificate on all nodes.

You can also use all the other configuration options for TLS, for example if OpenSSL should be used, if hostname verification should be enabled, or if the hostname should be resolved.

```yaml
searchguard.ssl.transport.enable_openssl_if_available: true
searchguard.ssl.transport.enforce_hostname_verification: <true|false>
searchguard.ssl.transport.resolve_hostname: <true|false>
```

In addition to that, you also need to configure the TLS settings for the tribe node itself:

```yaml
searchguard.ssl.transport.keystore_filepath: tribe-transport-keystore.jks
searchguard.ssl.transport.keystore_password: changeit
searchguard.ssl.transport.truststore_filepath: truststore.jks
searchguard.ssl.transport.truststore_password: changeit

searchguard.ssl.http.enabled: true
searchguard.ssl.http.keystore_filepath: tribe-rest-keystore.jks
searchguard.ssl.http.keystore_password: changeit
searchguard.ssl.http.truststore_filepath: truststore.jks
searchguard.ssl.http.truststore_password: changeit
searchguard.ssl.http.clientauth_mode: NONE
```
As always, TLS on the REST layer is optional, but recommended.

As with a regular data nodes in your cluster, also specify the DN of the admin certificate(s) you want to use with sgadmin.

```yaml
searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test, C=DE
```

## Index management

If the tribe node starts up for the first time, it fetches the Search Guard index from one of the participating clusters.

If you make any changes, you need to refresh the Search Guard index on the tribe node as well. This might be automated in the future, but for now, use the `-rl` switch to refresh manually:

```bash
./sgadmin.sh -ts truststore.jks -tspass ... -ks keystore.jks -kspass ... -p <tribe node port> -rl
```
