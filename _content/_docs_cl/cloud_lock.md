---
title: Cloud Lock
html_title: Cloud Lock
permalink: cloud-lock
category: cl
order: 100
layout: docs
edition: community
description: Cloud Lock - Encryption at Rest for ElasticSearch
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# SearchGuard Cloud Lock - Encryption at Rest for ElasticSearch
{: .no_toc}

{% include toc.md %}


SearchGuard Cloud Lock provides Encryption at Rest for Elasticsearch indices and snapshot. Take full control over your data, even on public clouds.


## Introduction
We are proud to present GA release SearchGuard Cloud Lock, a plugin enabling encryption at rest (EAR) for Elasticsearch.

SearchGuard Cloud Lock encrypts all your Elasticsearch data that resides on disk and is available today as a technology preview. SearchGuard Cloud Lock is the missing piece to regain complete control over your data of Elasticsearch deployments, especially on public clouds. SearchGuard Cloud Lock can also be used in private clouds or on-premises installations to protect your data at rest.

The plugin ships with a command line tool called clctl to initialize the plugin and manage the encryption keys.

## How it Works
SearchGuard Cloud Lock is an Elasticsearch plugin and can be installed as every other plugin. It works in all environments - whether you run Elasticsearch on Docker, Kubernetes, EC2, or in your own data center. And the good news is - the plugin requires almost no configuration!

Once the plugin is installed and initialized, you can create encrypted indices. All data which resides in an encrypted index is stored encrypted on disk. No one without the correct decryption key can read or modify the data of encrypted indices.

The decryption key is only held in memory on the cluster nodes and never stored on the disk of the server.

*Your data deserves the highest level of protection, especially in the cloud.*

## Encrypted Snapshots (Backups)
In addition to the encrypted indices feature, the plugin also provides the functionality to encrypt snapshots, which are typically used to back up your data. An encrypted snapshot can contain encrypted and non-encrypted indices and is therefore independent of using encrypted indices.

So, if you have only regular non-encrypted indices in your cluster, and you want to snapshot and store them safely and encrypted on S3 or NFS, then encrypted snapshots are for you.

## Preconditions and Limitations
There are only a few preconditions and limitations with encrypted indices:

- Realtime get actions are executed as non-realtime actions
- There is a slight performance impact when indexing and searching in encrypted indices  
- The mapping must include a metadata field _encrypted_tl_content of type binary. This field will never appear in any search results, and you can otherwise completely ignore it
- After a full cluster restart (shutting down all nodes at once), which happens rarely, the plugin must be initialized again before encrypted indices can be accessed

Apart from the limitations mentioned above, an encrypted index works like any other index and supports all queries and mappings.

## Walkthrough

### Preparation
Create a new cluster key pair on a client machine. This is typically done by a system administrator and is only necessary once per cluster. You can use tools like openssl to generate the key pair, or simply use earctl like:

```bash
$ clctl.sh create-cluster-keypair
```

Create a new RSA key pair with UUID <uuid>  
Public key will be stored in public_cluster_key_<uuid>.pubkey  
Public key config template will be stored in elasticsearch_yaml_<uuid>.yml  
Secret key will be stored in secret_cluster_key_<uuid>.seckey  

This key pair needs to be backed up in a safe location. If keys are lost, it is not possible to decrypt the data stored in encrypted indices on this cluster.

### Installation
Install Elasticsearch and add this configuration to elasticsearch.yml and restart the nodes:

```yaml
searchguard.cloud_lock.enabled: true
searchguard.cloud_lock.public_cluster_key: <public key>
```

The <public key> can be found in the public_cluster_key_<uuid>.pubkey file. There is also a "copy and paste" ready variant in elasticsearch_yaml_<uuid>.yml.

### Initialize Cloud Lock
This needs only be done once after using Cloud Lock for the first time, or after a full cluster restart. It is usually performed by a system administrator from a client machine:

```bash
$ clctl.sh -h osnode.company.com -p 9200 initialize-cluster --pk-file secret_cluster_key_<uuid>.seckey
```

Cluster initialized

### Create an Encrypted Index
Creating an encrypted index is the same as creating any other index:

```bash
curl "https://osnode.company.com:9200/my_encrypted_index?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "encryption_enabled": true,
    "store.type": "encrypted",
    ...
    ...
  },
  "mappings": {
      "properties": {
        "_encrypted_tl_content": {
          "type": "binary"
        },
      ...
      ...
  }
}
'
```

This curl command creates an encrypted index named my_encrypted_index. There is nothing special about it except two settings and one mapping:

- The index settings encryption_enable: true and store.type: encrypted defines this index as an encrypted index.
- The mapping _encrypted_tl_content with type binary is required and only used internally, as explained above.

After the index my_encrypted_index was created, it can be used to index and search data like any other index, but its contents are never stored in plaintext on disk.

To list all your encrypted indices, use clctl with the list-encrypted-indices command:

```bash
$ clctl.sh -h osnode.company.com -p 9200 list-encrypted-indices
```

my_encrypted_index  
my_other_encrypted_index  
...

### Create and Restore an Encrypted Snapshot
First, register the encrypted snapshot repository. This delegates to a previously registered repository like S3 and needs only be done once:

```bash
curl "https://osnode.company.com:9200/_snapshot/my_encrypted_s3_backup?pretty" -H 'Content-Type: application/json' -d '
{
  "type": "encrypted",
  "settings": {
    "delegate": "my_s3_backup"
  }
}
```

You can now create or restore snapshots as usual, referencing the encrypted snapshot repository my_encrypted_s3_backup like:

```
_snapshot/my_encrypted_s3_backup/snapshot_1

_snapshot/my_encrypted_s3_backup/snapshot_1/_restore
```

### Simplify With Index Templates
When you need to create a lot of encrypted indices, we recommend using an index template for that:

```bash
curl "https://osnode.company.com:9200/_index_template/encrypted_index_template?pretty" -H 'Content-Type: application/json' -d '
{
  "index_patterns": ["*encrypted*","*dashboards_sample*"],
  "priority": 300,
  "template": {
    "mappings": {
      "properties": {
        "_encrypted_tl_content": {
          "type": "binary"
        }
      }
    },
    "settings":{
      "encryption_enabled": true,
      "number_of_shards": 3,
      "number_of_replicas": 2,
      "store.type": "encrypted"
    }
  }
}'
```

This will create indices whose name match encrypted or dashboards_sample as encrypted indices.
```