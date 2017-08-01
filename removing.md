# Removing Search Guard

In order to remove Search Guard you need to

* Deletr or remove the plugins/search-guard-5 folder from all nodes
* Delete or comment the Search Guard configuration entries from elasticsearch.yml

A full cluster restart is required for removing Search Guard completely. Since transport traffic is TLS encrypted, you can't perform a rolling restart. Nodes running with TLS cannot talk to nodes running with TLS anymore, so you would end up with a split cluster (TLS / non-TLS).

The Search Guard configuration entries from `elasticsearch.yml` need to be removed or commented as well. Elasticsearch refuses to start when there are configuration entries present not defined by any installed plugin.

Once the Search Guard plugin is removed and your cluster is not protected anymore, you will also have access to the Search Guard configuration index. If the index is not needed anymore you delete it as well. The default index name is `searchguard`.

If you want to backup the configuration before deleting the Search Guard index, you can use the `-r/--retrieve` switch in `sgadmin`. This will dump the currently active configuration to your file system. 
