---
title: Cloud Lock
html_title: Cloud Lock
permalink: cloud-lock
category: cl
order: 100
layout: docs
edition: enterprise
description: Cloud Lock - Encryption at Rest for ElasticSearch
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}


# SearchGuard Cloud Lock

{: .no_toc}

{% include toc.md %}

SearchGuard Cloud Lock provides encryption at rest for Elasticsearch indices and snapshots – encrypting your Elasticsearch data that resides on disk.

It is the missing piece to regain complete control over your data in Elasticsearch deployments, especially in public clouds. SearchGuard Cloud Lock can also be used in private clouds or on-premises installations to protect your data at rest.

## Technical Preview Version Download

- The Technical Preview version of the clctl tool is available [here](https://maven.search-guard.com//search-guard-cloud-lock-release/com/floragunn/search-guard-cloud-lock/search-guard-cloud-lock-plugin/3.0.3-tp1-es-8.17.3/search-guard-cloud-lock-plugin-3.0.3-tp1-es-8.17.3.zip)
- The Technical Preview version of the SearchGuard plugin is available [here](https://maven.search-guard.com//search-guard-cloud-lock-release/com/floragunn/search-guard-cloud-lock/search-guard-cloud-lock-ctl/3.0.3-tp1-es-8.17.3/search-guard-cloud-lock-ctl-3.0.3-tp1-es-8.17.3.zip)

## Installation of Cloud Lock Plugin

In order to install Cloud Lock plugin, execute the following command:

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-cloud-lock-plugin.zip
```

## Enable Cloud Lock

1. Download Cloud Lock Control Tool ([clctl](https://maven.search-guard.com//search-guard-cloud-lock-release/com/floragunn/search-guard-cloud-lock/search-guard-cloud-lock-plugin/3.0.3-tp1-es-8.17.3/search-guard-cloud-lock-plugin-3.0.3-tp1-es-8.17.3.zip))

2. Create a new cluster key pair on a client machine  
   This is typically done by a system administrator and is only necessary once per cluster. You can use tools like openssl to generate the key pair, or simply use clctl like:

   ```bash
   clctl.sh create-cluster-keypair
   

   Created a new RSA key pair with UUID:
   - Public key will be stored in public_cluster_key_.pubkey
   - Public key config template will be stored in elasticsearch_yaml_.yml
   - Secret key will be stored in secret_cluster_key_.seckey
   ```

   *This key pair needs to be backed up in a safe location. If keys are lost, it is not possible to decrypt the data stored in encrypted indices on this cluster.*

3. Add the following lines to elasticsearch.yml on each node:

   ```yaml
   cloud_lock.enabled: true
   cloud_lock.public_cluster_key: MIICIjAN...EAAQ==
   ```

   The key can be found in the public_cluster_key_.pubkey file. There is also a "copy and paste" ready variant in elasticsearch_yaml_.yml.

4. Restart each node.


## Initialize the Cloud Lock

This needs only be done once after installing the plugin, or after a full cluster restart. It is usually performed by a system administrator from a client machine. 

First connect the clctl.sh tool to the cluster using admin certificate, key and root ca, see following example:

```bash
./clctl.sh connect localhost --ca-cert ./config/root-ca.pem --cert ./config/kirk.pem --key ./config/kirk-key.pem
```

Once the clctl tool is connected to the cluster, execute the following command to initialize the Cloud Lock:

```bash
./clctl.sh initialize-cluster --pk-file secret_cluster_key_<uuid>.seckey
```

## Create an Encrypted Index

Creating an encrypted index is the same as creating any other index:

```bash
curl -k -XPUT -u admin:admin "https://esnode.company.com:9200/my_encrypted_index1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "cloud_lock_enabled": true,
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
}
'
```

This curl command creates an encrypted index named my_encrypted_index. Please note the two settings and one mapping:

- The index settings encryption_enable: true and store.type: encrypted defines this index as an encrypted index.
- The mapping _encrypted_tl_content with type binary is required and only used internally, as explained above.

To list all your encrypted indices, (connect clctl.sh tool to the cluster if not already done so and) execute the following command:

```bash
$ clctl.sh list-encrypted-indices
```
**NOTE:** Successful clctl.sh command execution does not return any __success message__.

## Create and Restore an Encrypted Snapshot

1. Register the encrypted snapshot repository:

    ```bash
    curl -k -X PUT -u admin:admin "https://esnode.company.com:9200/_snapshot/my_encrypted_fs_backup?pretty" -H 'Content-Type: application/json' -d '
    {                                   
      "type": "encrypted",              
      "settings": {               
        "delegate": "my_fs_backup"
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

## How it Works

All data which resides in an encrypted index is stored encrypted on disk. No one without the correct decryption key can read or modify the data of encrypted indices. The decryption key is only held in memory on the cluster nodes and never stored on the disk of the server.

The plugin also provides encrypted snapshots functionality for backing up data. An encrypted snapshot can contain both encrypted and non-encrypted indices.

## Preconditions and Limitations

- Realtime get actions are executed as non-realtime actions
- There is a slight performance impact when indexing and searching in encrypted indices
- The mapping must include a metadata field _encrypted_tl_content of type binary
- After a full cluster restart, the plugin must be initialized again before accessing encrypted indices

Apart from these preconditions, an encrypted index supports all queries and mappings like any other index.
