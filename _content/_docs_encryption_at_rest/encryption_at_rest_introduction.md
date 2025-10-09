---
title: Encryption at Rest
html_title: Encryption at Rest
permalink: encryption-at-rest-introduction
layout: docs
edition: enterprise
description: Encryption at Rest for ElasticSearch
---
<!--- Copyright 2025 floragunn GmbH -->

# Search Guard Encryption at Rest

{: .no_toc}

{% include toc.md %}

Search Guard Encryption at Rest provides encryption at rest for Elasticsearch indices and snapshots, encrypting your Elasticsearch data stored on disk.

It is the missing piece needed to regain complete control over your data in Elasticsearch deployments, especially in public cloud environments. Search Guard Encryption at Rest can also be used in private cloud or on-premises installations to protect your data at rest.

## Download

{% include sg_ear_versions.html versions="search-guard-encryption-at-rest"%}

## Installation of Encryption at Rest Plugin

To install the Encryption at Rest plugin, run the following command:

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-encryption-at-rest-plugin-1.0.0-es-8.18.2.zip
```

This plugin requires either the [Search Guard Security Plugin](https://docs.search-guard.com/latest/search-guard-versions) or Elasticsearch X-Pack Security to be installed and configured.
While this plugin operates independently of the aforementioned plugins, SSL/TLS and authentication/authorization features are necessary to protect the Encryption at Rest API.

## Enable Encryption at Rest

1. Unzip the Encryption at Rest Control Tool (*enctl*) in any directory. Make sure you have Java >= 17 installed.

2. Create a new cluster key pair on a client machine

This is typically done by a system administrator and is only necessary once per cluster. You can use tools like openssl to generate the key pair, or simply use enctl like:

   ```bash
   enctl.sh create-cluster-keypair
   
   Created a new RSA key pair with UUID:
   - Public key will be stored in public_cluster_key_.pubkey
   - Public key config template will be stored in elasticsearch_yaml_.yml
   - Secret key will be stored in secret_cluster_key_.seckey
   ```

<span style="color:red">Caution: This key pair must be backed up in a secure location. If the keys are lost, it will not be possible to decrypt data stored in encrypted indices on this cluster. Without the private key, it will also not be possible to restore backups from encrypted snapshot repositories.</span>
{: .note .js-note .note-warning}


3. Add the following lines to elasticsearch.yml on each node:

```yaml
encryption_at_rest.enabled: true
encryption_at_rest.public_cluster_key: MIICIjAN...EAAQ==
```

The key can be found in the public_cluster_key_UUID.pubkey file. There is also a "copy and paste" ready variant in elasticsearch_yaml_UUID.yml.

4. Restart each node as [documented here](https://www.elastic.co/docs/deploy-manage/maintenance/start-stop-services/full-cluster-restart-rolling-restart-procedures#restart-cluster-rolling).

## Initialize Encryption at Rest

This only needs to be done once after installing the plugin or after a full cluster restart. It is typically performed by a system administrator from a client machine.

When Search Guard Security is installed:

```bash
./enctl.sh initialize-cluster -h localhost --ca-cert root-ca.pem --cert admin-cert.pem --key admin-cert-key.pem --pk-file secret_cluster_key_UUID.seckey
```

When X-Pack Security is installed:

```bash
./enctl.sh initialize-cluster -h localhost -u elastic --password XXXX --force-https --ca-cert http_ca.crt --pk-file secret_cluster_key_UUID.seckey
```

## Create an Encrypted Index

Creating an encrypted index is nearly identical to creating any other index:

```bash
curl -k -XPUT -u admin:admin "https://esnode.company.com:9200/my_encrypted_index1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "encryption_at_rest_enabled": true,
    "store.type": "encrypted",
    ...
    ...
  },
  "mappings": {
     "properties": {
       "_encrypted_tl_content": {
         "type": "binary"
       }
     }
}
'
```

This curl command creates an encrypted index named `my_encrypted_index`. Please note the two settings and one mapping:
- The index settings `encryption_enable: true` and `store.type: encrypted` define this index as an encrypted index.
- The mapping `_encrypted_tl_content` with type `binary` is required and used only internally. If the mapping is missing, translog recovery may fail.


To list all your encrypted indices, connect the enctl.sh tool to the cluster (if not already done) and execute the following command:

```bash
$ enctl.sh list-encrypted-indices
```
**NOTE:** Successful enctl.sh command execution does not return any __success message__.

## Create and Restore an Encrypted Snapshot

The `encrypted snapshot` feature is independent of the `encrypted index` feature. This means you can back up encrypted or unencrypted indices using an `encrypted repository`. The contents of a snapshot created with an `encrypted repository` are always encrypted.

1. Register the encrypted snapshot repository:

   #### `fs` storage type:

    ```bash
    curl -k -X PUT -u admin:admin "https://esnode.company.com:9200/_snapshot/my_encrypted_fs_backup?pretty" -H 'Content-Type: application/json' -d '
    {                                   
      "type": "encrypted",              
      "settings": {               
        "storage_type": "fs",
        "location": "/my_repo_path/my_encrypted_fs_backup"
      }                  
    }'
    ```

   #### `s3` storage type:

    ```bash
    curl -k -X PUT -u admin:admin "https://esnode.company.com:9200/_snapshot/my_encrypted_s3_backup?pretty" -H 'Content-Type: application/json' -d '
    {                                   
      "type": "encrypted",              
      "settings": {               
        "storage_type": "s3",
        "bucket": "my-bucket",
        ...
      }                  
    }'
    ```

2. Create or restore snapshots as usual:

    ```
    _snapshot/my_encrypted_s3_backup/snapshot_1
    _snapshot/my_encrypted_s3_backup/snapshot_1/_restore
    ```

<span style="color:red">Caution: It is not possible to use or restore an encrypted snapshot in any cluster other than the one in which it was created.</span>
{: .note .js-note .note-warning}


## Simplify With Index Templates

For creating multiple encrypted indices:

```bash
curl -k -X PUT -u admin:admin "https://esnode.company.com:9200/_index_template/encrypted_index_template?pretty" -H 'Content-Type: application/json' -d '
{
  "index_patterns": ["encrypted_*"],
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
      "encryption_at_rest_enabled": true,
      "store.type": "encrypted",
      "number_of_shards": 3,
      "number_of_replicas": 2
    }
  }
}'
```

## Reindex

<span style="color:red">Caution: Please read the following paragraph before using reindex API</span>
{: .note .js-note .note-warning}

When using `reindex` with encrypted indices, ensure that the target index is also encrypted.
This does not happen automatically and is not enforced, so make sure to create an encrypted target index first
before reindexing into it.

Use `enctl.sh list-encrypted-indices` to verify which indices are encrypted.


## How it Works

All data residing in an encrypted index is stored encrypted on disk. No one without the correct decryption key can read or modify the data within encrypted indices. The decryption key is held only in memory on cluster nodes and is never stored on the server's disk.

The plugin also provides encrypted snapshot functionality for backing up data. An encrypted snapshot can contain both encrypted and non-encrypted indices.

## Preconditions and Limitations

- Real-time get actions are executed as non-real-time actions
- Field names, index mappings, and some metadata are not stored encrypted (because they are part of the cluster state)
- Do not use multiple `path.data` locations in elasticsearch.yml [as advised here](https://www.elastic.co/guide/en/elasticsearch/reference/8.18/path-settings-overview.html#multiple-data-paths)
- There is a performance impact when indexing and searching encrypted indices
- The mapping for every encrypted index must include a metadata field `_encrypted_tl_content` of type binary as explained above
- After a full cluster restart, the plugin must be initialized again before encrypted indices can be accessed
- The `encrypted` snapshot repository does not officially support the Elasticsearch searchable snapshots feature, although it may work
- The `encrypted` snapshot repository does not officially support "azure" and "gcs" storage types yet, although they may work
- Resize API operations like `split`, `shrink`, and `clone` are not supported. Use `reindex` instead
- [Swappiness should be disabled](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/setup-configuration-memory) to prevent leaking unencrypted memory to disk
- It is recommended to [disable core dumps](https://github.com/elastic/elasticsearch/blob/6832ca40b3986ceb1b0a7daefd8bec193f47701d/distribution/src/config/jvm.options#L73), which are enabled by default, to prevent leaking unencrypted memory to disk
- Some advanced features like MMAP (not enabled by default) are not supported on Windows

Apart from these preconditions, an encrypted index supports all queries and mappings just like any other index.


## API

Initialize Encryption at rest
```json
POST _encryption_at_rest/api/_initialize_key
{
   "key":"MII...Lw=="
}
```
**key**: Base64 encoded PKCS8 Private RSA Key

Get encrypted indices
```json
GET _encryption_at_rest/api/_get_encrypted_indices
```

Get the initialization status
```json
GET _encryption_at_rest/api/_state
```

## Troubleshooting

### I lost the private cluster key

- If your cluster is still running, keep it running and do not shut down any nodes. Contact our [support team](https://search-guard.com/contacts/).
- If all nodes of your cluster are down, it is not possible to restore any encrypted index or snapshot.

### After a full cluster restart, my encrypted indices are in a red state and not available

You need to initialize Search Guard Encryption at Rest again

```bash
./enctl.sh initialize-cluster ... --pk-file secret_cluster_key_<uuid>.seckey
```

### Some encrypted replica shards are stuck in INITIALIZING state

Although this is not directly related to encryption, you can fix stuck shards:

```json
POST _cluster/reroute?retry_failed=true
```

If this does not help, [set replicas to a lower value or "0" and then increase again](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-put-settings).

### Creating or restoring snapshots to/from s3 with the encrypted repository consumes too much memory or is slow

Update the repository settings to disable support for retrying failed uploads and increase the chunk size to 32 GB:

```json
{                                   
  "type": "encrypted",              
  "settings": {               
    "storage_type": "s3",
    "bucket": "my-bucket",
    "support_upload_retry": false,
    "chunk_size": "32gb"
  }                  
}
```

### Heap usage is increased or OOM occurs

Encryption and decryption require additional CPU and memory. If possible, increase heap size on all data nodes.
Additionally, you can try:
- Reducing the number of encrypted indices/shards and replicas
- Enable MMAP (Please contact our support for further details)
- Adjust the encryption mode and settings (Please contact our support for further details)

### Indexing and search performance on encrypted indices is decreased

Encryption and decryption require additional CPU, so a performance decline is expected.
Internal benchmarks show that indexing is around 30% slower and searching is between 10-75% slower depending on the exact queries and aggregations.
It's also expected that CPU load will be slightly higher and memory consumption will increase by around 10-20%.
If you experience different performance issues, please contact our support.