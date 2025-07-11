---
title: Encryption at Rest
html_title: Encryption at Rest
permalink: encryption-at-rest-introduction
layout: docs
edition: enterprise
description: Encryption at Rest for ElasticSearch
---
<!--- Copyright 2025 floragunn GmbH -->

{% include beta_warning.html %}


# Search Guard Encryption at Rest

{: .no_toc}

{% include toc.md %}

Search Guard Encryption at Rest provides encryption at rest for Elasticsearch indices and snapshots – encrypting your Elasticsearch data that resides on disk.

It is the missing piece to regain complete control over your data in Elasticsearch deployments, especially in public clouds. Search Guard Encryption at Rest can also be used in private clouds or on-premises installations to protect your data at rest.

## Technical Preview Version Download

**At the moment, the technical preview of Encryption at Rest is available for Elasticsearch 8.17.3.**

- Download the technical preview of the [Encryption at Rest plugin](https://maven.search-guard.com:443//search-guard-encryption-at-rest-release/com/floragunn/search-guard-encryption-at-rest/search-guard-encryption-at-rest-plugin/3.0.3-tp2-es-8.17.3/search-guard-encryption-at-rest-plugin-3.0.3-tp2-es-8.17.3.zip)
- Download the technical preview of the [Encryption at Rest command line tool for](https://maven.search-guard.com:443//search-guard-encryption-at-rest-release/com/floragunn/search-guard-encryption-at-rest/search-guard-encryption-at-rest-ctl/3.0.3-tp2-es-8.17.3/search-guard-encryption-at-rest-ctl-3.0.3-tp2-es-8.17.3.zip)

## Installation of Encryption at Rest Plugin

In order to install the Encryption at Rest plugin, execute the following command:

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-encryption-at-rest-plugin-3.0.3-tp2-es-8.17.3.zip
```

## Enable Encryption at Rest

1. Unzip the Encryption at Rest Control Tool (*enctl*) in any directory

2. Create a new cluster key pair on a client machine

This is typically done by a system administrator and is only necessary once per cluster. You can use tools like openssl to generate the key pair, or simply use enctl like:

   ```bash
   enctl.sh create-cluster-keypair
   

   Created a new RSA key pair with UUID:
   - Public key will be stored in public_cluster_key_.pubkey
   - Public key config template will be stored in elasticsearch_yaml_.yml
   - Secret key will be stored in secret_cluster_key_.seckey
   ```

   *This key pair needs to be backed up in a safe location. If keys are lost, it is not possible to decrypt the data stored in encrypted indices on this cluster.*

3. Add the following lines to elasticsearch.yml on each node:

```yaml
encryption_at_rest.enabled: true
encryption_at_rest.public_cluster_key: MIICIjAN...EAAQ==
```

The key can be found in the public_cluster_key_.pubkey file. There is also a "copy and paste" ready variant in elasticsearch_yaml_.yml.

4. Restart each node.

## Initialize Encryption at Rest

This needs only be done once after installing the plugin, or after a full cluster restart. It is usually performed by a system administrator from a client machine. 

First connect the enctl.sh tool to the cluster using admin certificate, key and root ca, see following example:

```bash
./enctl.sh connect localhost --ca-cert ./config/root-ca.pem --cert ./config/kirk.pem --key ./config/kirk-key.pem
```

Once the enctl tool is connected to the cluster, execute the following command to initialize Encryption at Rest:

```bash
./enctl.sh initialize-cluster --pk-file secret_cluster_key_<uuid>.seckey
```

## Create an Encrypted Index

Creating an encrypted index is the same as creating any other index:

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

To list all your encrypted indices, (connect enctl.sh tool to the cluster if not already done so and) execute the following command:

```bash
$ enctl.sh list-encrypted-indices
```
**NOTE:** Successful enctl.sh command execution does not return any __success message__.

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
      "encryption_at_rest_enabled": true,
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
