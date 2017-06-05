<!---
Copryight 2017 floragunn GmbH
-->

# Snapshots and Restore

## Default behaviour

Since all user, role and permission settings are stored in the Search Guard index inside Elasticsearch, they will also be part of a snapshot. Snaphots and restores are therefore **only allowed if an admin certificate** is sent with the snapshot or restore request. This is the default behaviour of Search Guard.

## Enabling snapshot and restore for regular users

If you want to allow snapshot and restore requests also for regular users without an admin certificate, you need to enable this feature explicitly in `elasticsearch.yml`:

```
searchguard.enable_snapshot_restore_privilege: true
```

### Required permissions

A role definition in `roles.yml` which allows all snapshot and restore operations on all indices looks like:

```
sg_snapshot_restore:
  cluster:
    - cluster:admin/snapshot/status
    - cluster:admin/repository/get
    - cluster:admin/snapshot/create
    - cluster:admin/snapshot/restore
    - cluster:admin/snapshot/delete
  indices:
    '*':
      '*':
        - indices:data/write/index
        - indices:admin/create
```

### Restoring a snapshot

Note that a snapshot can only be restored when it does not contain global state and it does not contain the 'searchguard' index! In order to restore indices from a snapshot that does contain global state, you need to exclude it when performing the restore. If your snapshot contains the Search Guard index, list the indices to restore explicitely:

```
POST /_snapshot/my_backup/snapshot_1/_restore
{
  "indices": "humanresources",  
  "include_global_state": false
}
```