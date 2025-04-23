---
title: Encryption at Rest
html_title: Encryption at Rest
permalink: encryption-at-rest-introduction
layout: docs
edition: enterprise
description: Encryption at Rest for ElasticSearch
---
<!--- Copyright floragunn GmbH -->

{% include beta_warning.html %}

# SearchGuard Encryption at Rest
{: .no_toc}

{% include toc.md %}

## Introduction

SearchGuard Encryption at Rest secures your Elasticsearch data by encrypting indices and snapshots stored on disk. This solution provides the critical security layer needed to maintain complete control over your data, whether deployed in public clouds, private clouds, or on-premises environments.

With SearchGuard Encryption at Rest, your sensitive information remains protected from unauthorized access even if physical storage media is compromised.

## Technical Preview Downloads

| Component | Version | Download Link |
|-----------|---------|--------------|
| clctl Tool | 3.0.3-tp1-es-8.17.3 | [Download](https://maven.search-guard.com//search-guard-cloud-lock-release/com/floragunn/search-guard-cloud-lock/search-guard-cloud-lock-ctl/3.0.3-tp1-es-8.17.3/search-guard-cloud-lock-ctl-3.0.3-tp1-es-8.17.3.zip) |
| SearchGuard Plugin | 3.0.3-tp1-es-8.17.3 | [Download](https://maven.search-guard.com//search-guard-cloud-lock-release/com/floragunn/search-guard-cloud-lock/search-guard-cloud-lock-plugin/3.0.3-tp1-es-8.17.3/search-guard-cloud-lock-plugin-3.0.3-tp1-es-8.17.3.zip) |

## Installation Guide

### Installing the Encryption at Rest Plugin

To install the plugin, run the following command on each Elasticsearch node:

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-cloud-lock-plugin.zip
```

### Enabling Encryption at Rest

Follow these steps to enable encryption for your Elasticsearch cluster:

1. **Download the Control Tool**:
   Download the Encryption at Rest Control Tool (`clctl`) from the link in the Technical Preview Downloads section.

2. **Create a Cluster Key Pair**:
   Generate a new cluster key pair on a client machine. This only needs to be done once per cluster by a system administrator:

   ```bash
   clctl.sh create-cluster-keypair
   ```

   You'll see output similar to:
   ```
   Created a new RSA key pair with UUID:
   - Public key will be stored in public_cluster_key_.pubkey
   - Public key config template will be stored in elasticsearch_yaml_.yml
   - Secret key will be stored in secret_cluster_key_.seckey
   ```

   > **Important**: Back up these keys securely. If they are lost, you will not be able to decrypt data stored in encrypted indices.

3. **Configure Each Node**:
   Add the following configuration to the `elasticsearch.yml` file on every node:

   ```yaml
   cloud_lock.enabled: true
   cloud_lock.public_cluster_key: MIICIjAN...EAAQ==
   ```

   The public key value can be found in the `public_cluster_key_.pubkey` file or copied directly from the `elasticsearch_yaml_.yml` template.

4. **Restart Nodes**:
   Restart each node in your cluster to apply the new configuration.

### Initializing Encryption at Rest

After installing the plugin or following a full cluster restart, you must initialize the Encryption at Rest functionality. This is typically done once by a system administrator.

1. **Connect to the Cluster**:
   First, connect the `clctl.sh` tool to your cluster using appropriate authentication:

   ```bash
   ./clctl.sh connect localhost --ca-cert ./config/root-ca.pem --cert ./config/kirk.pem --key ./config/kirk-key.pem
   ```

2. **Initialize the Cluster**:
   Execute the initialization command, providing the path to your secret key file:

   ```bash
   ./clctl.sh initialize-cluster --pk-file secret_cluster_key_<uuid>.seckey
   ```

## Working with Encrypted Data

### Creating an Encrypted Index

Creating an encrypted index follows the standard index creation process with specific encryption settings:

```bash
curl -k -XPUT -u admin:admin "https://esnode.company.com:9200/my_encrypted_index1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "cloud_lock_enabled": true,
    "store.type": "encrypted",
    ...
  },
  "mappings": {
    "properties": {
      "_encrypted_tl_content": {
        "type": "binary"
      },
      ...
    }
  }
}
'
```

The key components that enable encryption are:
- `cloud_lock_enabled: true` and `store.type: "encrypted"` in the settings section
- `_encrypted_tl_content` field with `"type": "binary"` in the mappings section

### Listing Encrypted Indices

To view all encrypted indices in your cluster:

```bash
./clctl.sh list-encrypted-indices
```

> **Note**: Successful `clctl.sh` commands typically don't display success messages.

### Managing Encrypted Snapshots

Encrypted snapshots provide secure backups of your Elasticsearch data:

1. **Register an Encrypted Snapshot Repository**:

   ```bash
   curl -k -X PUT -u admin:admin "https://esnode.company.com:9200/_snapshot/my_encrypted_fs_backup?pretty" -H 'Content-Type: application/json' -d '
   {                                   
     "type": "encrypted",              
     "settings": {               
       "delegate": "my_fs_backup"
     }                  
   }'
   ```

2. **Create or Restore Snapshots** using standard Elasticsearch commands:

   ```
   # Create a snapshot
   _snapshot/my_encrypted_s3_backup/snapshot_1
   
   # Restore a snapshot
   _snapshot/my_encrypted_s3_backup/snapshot_1/_restore
   ```

### Simplifying with Index Templates

For efficiently creating multiple encrypted indices, set up an index template:

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
      "cloud_lock_enabled": true,
      "number_of_shards": 3,
      "number_of_replicas": 2,
      "store.type": "encrypted"
    }
  }
}'
```

With this template in place, any index created with a name starting with `encrypted_` will automatically be encrypted with the specified settings.

## How Encryption at Rest Works

SearchGuard Encryption at Rest operates by encrypting all data within designated indices as it's written to disk. This means:

- All index data is stored in encrypted form on the storage media
- Decryption keys are held only in memory on cluster nodes and never written to disk
- Without the correct decryption key, data cannot be read or modified
- Both indices and snapshots can be encrypted for comprehensive protection

## Limitations and Considerations

When using encrypted indices, be aware of the following limitations:

* **Real-time Actions** - Real-time get actions are executed as non-real-time actions
* **Performance** - There is a slight performance impact when indexing and searching encrypted indices
* **Required Mapping** - All encrypted indices must include a metadata field `_encrypted_tl_content` of type binary
* **Cluster Restarts** - After a full cluster restart, the plugin must be re-initialized before accessing encrypted indices

Despite these considerations, encrypted indices support all the same queries and mappings as standard Elasticsearch indices, making integration seamless for most use cases.