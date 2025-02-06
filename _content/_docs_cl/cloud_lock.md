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


# SearchGuard Cloud Lock

{: .no_toc}

{% include toc.md %}

SearchGuard Cloud Lock provides encryption at rest for Elasticsearch indices and snapshots – encrypting all your Elasticsearch data that resides on disk.

It is the missing piece to regain complete control over your data in Elasticsearch deployments, especially in public clouds. SearchGuard Cloud Lock can also be used in private clouds or on-premises installations to protect your data at rest.

## Enable Cloud Lock

1. Download Cloud Lock Control Tool (clctl) and unpack it

2. Create a new cluster key pair on a client machine  
   This is typically done by a system administrator and is only necessary once per cluster. You can use tools like openssl to generate the key pair, or simply use clctl like:

   ```bash
   clctl.sh create-cluster-keypair
   ```

   Created a new RSA key pair with UUID:
   - Public key will be stored in public_cluster_key_.pubkey
   - Public key config template will be stored in elasticsearch_yaml_.yml
   - Secret key will be stored in secret_cluster_key_.seckey

   *This key pair needs to be backed up in a safe location. If keys are lost, it is not possible to decrypt the data stored in encrypted indices on this cluster.*

3. Add the following lines to elasticsearch.yml on each node:

   ```yaml
   searchguard.cloud_lock.enabled: true
   searchguard.cloud_lock.public_cluster_key: MIICIjAN...EAAQ==
   ```

   The key can be found in the public_cluster_key_.pubkey file. There is also a "copy and paste" ready variant in elasticsearch_yaml_.yml.

4. Restart each node.


## Initialize the Cloud Lock

This needs only be done once after installing the plugin, or after a full cluster restart. It is usually performed by a system administrator from a client machine:

```bash
clctl.sh initialize-cluster -h osnode.company.com -p 9200 --pk-file secret_cluster_key_<uuid>.seckey
```

## Create an Encrypted Index

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

To list all your encrypted indices:

```bash
$ clctl.sh -h osnode.company.com -p 9200 list-encrypted-indices
```

## Create and Restore an Encrypted Snapshot

1. Register the encrypted snapshot repository:

    ```bash
    curl "https://osnode.company.com:9200/_snapshot/my_encrypted_s3_backup?pretty" -H 'Content-Type: application/json' -d '
    {
      "type": "encrypted",
      "settings": {
        "delegate": "my_s3_backup"
      }
    }'
    ```

2. Create or restore snapshots as usual:

    ```
    _snapshot/my_encrypted_s3_backup/snapshot_1
    
    _snapshot/my_encrypted_s3_backup/snapshot_1/_restore
    ```

## Simplify With Index Templates

For creating multiple encrypted indices:

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

## How it Works

All data which resides in an encrypted index is stored encrypted on disk. No one without the correct decryption key can read or modify the data of encrypted indices. The decryption key is only held in memory on the cluster nodes and never stored on the disk of the server.

The plugin also provides encrypted snapshots functionality for backing up data. An encrypted snapshot can contain both encrypted and non-encrypted indices.

## Preconditions and Limitations

- Realtime get actions are executed as non-realtime actions
- There is a slight performance impact when indexing and searching in encrypted indices
- The mapping must include a metadata field _encrypted_tl_content of type binary
- After a full cluster restart, the plugin must be initialized again before accessing encrypted indices

Apart from these limitations, an encrypted index supports all queries and mappings like any other index.
