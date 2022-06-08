---
title: Snapshot, Restore
html_title: Snapshot Restore
permalink: snapshot-restore
category: authorization-advanced
order: 1000
layout: docs
edition: community
description: Control access to the snapshot and restore features of OpenSearch/Elasticsearch by using Search Guard.
---
<!---
Copyright 2020 floragunn GmbH
-->
# Snapshot and restore
{: .no_toc}

{% include toc.md %}



## Required permissions

In order to perform snapshot and restore operations, the user must be assigned to the built-in `SGS_MANAGE_SNAPSHOTS` role.

## Restoring a snapshot

A snapshot can only be restored if it does not contain global state and it does not contain the 'searchguard' index. 

In order to restore indices from a snapshot that does contain global state, you need to exclude it when performing the restore. If your snapshot also contains the Search Guard index, list the indices to restore explicitely:

```json
POST /_snapshot/my_backup/snapshot_1/_restore
{
  "indices": "humanresources",  
  "include_global_state": false
}
```

It is recommended to exclude the Search Guard index from all snapshots globally.

## Snapshot and Restore: Search Guard index

The Search Guard configuration index contains sensitive data like user, role and permission information. 

Restoring the Search Guard configuration index from a snapshot is only allowed **if an admin certificate is used**.

For curl, you need to specify the admin certificate with it's complete certificate chain and the key like:

```bash
curl --insecure --cert chain.pem --key kirk.key.pem -XPOST '<host>:9200/_snapshot/my_backup/snapshot_1/_restore?pretty'
```


