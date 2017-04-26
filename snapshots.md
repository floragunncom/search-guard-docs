<!---
Copryight 2017 floragunn GmbH
-->

# Snapshots and Restore

## Default behaviour

Since all user, role and permission settings are stored in the Search Guard index inside Elasticsearch, they will also be part of any snapshot.

Because the Search Guard index contains sensitive information, snaphots and restores are only allowed if an admin certificate is sent with the snapshot or restore request. This is the default behaviour of Search Guard.

## Enabling snapshot and restore for regular users

Since v12, you can set snapshot and restore permissions for regular users. Because this can cause security issues, you need to enable this feature explicitly in `elasticsearch.yml`:

```
searchguard.enable_snapshot_restore_privilege: true
```

### Required permissions

In order for a user/role to perform snapshots and restores, the following permissions must be granted in `roles.yml`:

```
cluster:
  cluster:admin/snapshot/restore
indices:
  - indices:data/write/index
  - indices:admin/create  
```

Note that by default a snapshot can only be restored when it does not contain global state and does not restore the 'searchguard' index.

### Disabling the indices checks

If you want to allow a user to restore a snapshot even if it contains global state or the 'searchguard' index, you can disable the additional indices checks:

```
searchguard.check_snapshot_restore_write_privileges: false
```

**Warning: Disabling the indices checks is a potentially dangerous setting. A user could restore a manipulated Search Guard index.  This introduce security leaks.**
