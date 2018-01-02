---
redirect_to:
  - http://docs.search-guard.com/latest/snapshot-restore
---

<!---
Copryight 2017 floragunn GmbH
-->

# Snapshots and Restore

## Default behaviour

Since all user, role and permission settings are stored in the Search Guard index inside Elasticsearch, they will also be part of a snapshot. Restores are therefore **only allowed if an admin certificate** is sent with the restore request. This is the default behaviour of Search Guard.

For curl, you need to specify the admin certificate with it's complete certificate chain, and also the key:

```
curl --insecure --cert chain.pem --key kirk.key.pem -XPOST '<host>:9200/_snapshot/my_backup/snapshot_1/_restore?pretty'
```

If you use the example PKI scripts provided by Search Guard SSL, the `kirk.key.pem` is already generated for you. You can generate the chain file by `cat`ing the certificate and the ca chain file:

```
cd search-guard-sll
cat example-pki-scripts/kirk.crt.pem example-pki-scripts/ca/chain-ca.pem > chain.pem
```

## Enabling snapshot and restore for regular users (ES 5.x and above only)

If you want to allow snapshot and restore requests also for regular users without an admin certificate, you need to enable this feature explicitly in `elasticsearch.yml`:

```
searchguard.enable_snapshot_restore_privilege: true
```

### Required permissions

A role definition in `roles.yml` which allows all snapshot and restore operations on all indices looks like:

```
sg_snapshot_restore:
  cluster:
    - cluster:admin/repository/put
    - cluster:admin/repository/get
    - cluster:admin/snapshot/status
    - cluster:admin/snapshot/get
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