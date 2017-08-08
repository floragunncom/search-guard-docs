# Disabling or Removing Search Guard

In order to disable Search Guard without removing it, add the following line to `elasticsearch.yml`:

```
searchguard.disabled: true
```

Disabling Search Guard requires a full cluster restart, since transport layer TLS will also be disabled. You don't need to remove the Search Guard specific settings from `elasticsearch.yml`.

**Note: If you disable Search Guard, the Search Guard configuration index will also be exposed. Please use this feature carefully.**

In order to remove Search Guard completely you need to

* Delete or remove the plugins/search-guard-5 folder from all nodes
* Delete or comment the Search Guard configuration entries from elasticsearch.yml

A full cluster restart is required for removing Search Guard completely. Since transport traffic is TLS encrypted, you can't perform a rolling restart. Nodes running with TLS cannot talk to nodes running with TLS anymore, so you would end up with a split cluster (TLS / non-TLS).

The Search Guard configuration entries from `elasticsearch.yml` need to be removed or commented as well. Elasticsearch refuses to start when there are configuration entries present not defined by any installed plugin.

Once the Search Guard plugin is removed and your cluster is not protected anymore, you will also have access to the Search Guard configuration index. If the index is not needed anymore you delete it as well. The default index name is `searchguard`.

If you want to backup the configuration before deleting the Search Guard index, you can use the `-r/--retrieve` switch in `sgadmin`. This will dump the currently active configuration to your file system. 
