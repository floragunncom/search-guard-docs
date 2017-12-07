---
title: Snapshot, Restore, Index Aliases
html_title: Snapshot Restore
slug: snapshot-restore
category: esstack
order: 1000
layout: docs
description: Control access to the snapshot and restore features of Elasticsearch by using Search Guard.
---
<!---
Copryight 2017 floragunn GmbH
-->

# Snapshot and Restore

## Default behaviour

Since all user, role and permission settings are stored in the Search Guard index inside Elasticsearch, they will also be part of a snapshot. Restores are therefore **only allowed if an admin certificate** is sent with the restore request. This is the default behaviour of Search Guard.

For curl, you need to specify the admin certificate with it's complete certificate chain, and also the key:

```bash
curl --insecure --cert chain.pem --key kirk.key.pem -XPOST '<host>:9200/_snapshot/my_backup/snapshot_1/_restore?pretty'
```

If you use the example PKI scripts provided by Search Guard SSL, the `kirk.key.pem` is already generated for you. You can generate the chain file by `cat`ing the certificate and the ca chain file:

```bash
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

```yaml
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

```json
POST /_snapshot/my_backup/snapshot_1/_restore
{
  "indices": "humanresources",  
  "include_global_state": false
}
```

# Index alias handling

Search Guard will resolve any aliases on any index to their underlying index name. This makes sure that all security related checks apply in all situations. The same is true for 

* Index wildcards, also with multiple index names
  * e.g. `https://localhost:9200/i*ex*,otherindex/_search` 
* Date math index names
  * e.g.  `https://localhost:9200/<logstash-{now/d}>/_search/_search`
* Filtered index aliases 

## Handling multiple filtered index aliases

Filtered index aliases can be used to filter some documents from the underlying index. However, **using filteres aliases is not a secure way to restrict access to certain documents**. In order to do that, please use the [Document Level Security](dlsfls.md) feature of Search Guard.

Because of this potential security leak, Search Guard detects and treats multiple filtered index aliases in a special way. You can either disallow them completely, or issue a warning message on `WARN` or `DEBUG` level.

The following entry in sg_config can be used to configure this:

```yaml
 searchguard:
    dynamic:		    
      filtered_alias_mode: <warn|nowarn|disallow>
```

| Name  | Description  |
|---|---|
| disallow | forbids multiple filtered index aliases completely |
| warn | default, logs a warning message if multiple filtered index aliases are detected on `WARN` level |
| nowarn | logs a warning message if multiple filtered index aliases are detected on `DEBUG` level |      