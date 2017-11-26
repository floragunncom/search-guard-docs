---
title: sgadmin troubleshooting
slug: troubleshooting-sgadmin
category: troubleshooting
order: 200
layout: troubleshooting
description: How to troubleshoot problems and issues with the Search Guard sgadmin command line tool.
---

<!--- Copryight 2017 floragunn GmbH -->

# Troubleshooting sgadmin

### Cluster not reachable

If the cluster is not reachable at all by `sgadmin`, you will see the following error message:

```
Search Guard Admin v5
Will connect to localhost:9300
ERR: Seems there is no elasticsearch running on localhost:9300 - Will exit
```

**Solution:**

* Check the hostname of your cluster
  * By default, sgadmin uses `localhost`
  * If your cluster runs on any other host, specify the hostname with the `-h` option
* Check the port
  * Check that you are running `sgadmin` against the transport port, **not the HTTP port** 
  * By default, `sgadmin` uses `9300`  
  * If you're running on a different port, use the `-p` option to specify the port number

### None of the configured nodes are available

If `sgadmin` can reach the cluster, but there are issues uploading the configuration, you will see the following error message:

``` 
Contacting elasticsearch cluster 'elasticsearch' and wait for YELLOW clusterstate ...
Cannot retrieve cluster state due to: None of the configured nodes are available: [{#transport#-1}{mr2NlX3XQ3WvtVG0Dv5eHw}{localhost}{127.0.0.1:9300}]. This is not an error, will keep on trying ...
   * Try running sgadmin.sh with -icl and -nhnv (If thats works you need to check your clustername as well as hostnames in your SSL certificates)
   * If this is not working, try running sgadmin.sh with --diagnose and see diagnose trace log file)
   * Add --accept-red-cluster to allow sgadmin to operate on a red cluster.
```

**Solution:**

* Check the cluster name
  * By default, sgadmin uses `elasticsearch` as cluster name
  * If your cluster is named differently either:
     * let sgadmin ignore the cluster name completely by using the `-icl` swith **or**
     * specify the name of your cluster with the `-cn` switch 
* Check the hostname and hostname verification
  * By default, sgadmin will verify that the hostname in your node's certificate matches the node's actual hostname
  * If this is not the case, e.g. you're using demo certificates
     * disable hostname verification by adding the `-nhnv` switch   
* Check the cluster state
  * By default, sgadmin ony executes when the cluster state is at least yellow
  * If your cluster state is red, you can stll execute sgadmin, but you need to add the `-arc/--accept-red-cluster` switch
* Check the Search Guard index name
  * By default, Search Guard uses `searchguard` as the name of the confguration index 
  * If you configured a different index name in `elasticsearch.yml`, you need to specify it with the `-i` option
  
### Using the diagnose switch

If you cannot find out why sgadmin is not executing, add the `--diagnose` switch to gather debug information, for example

```
./sgadmin.sh -diagnose -cd ../sgconfig/ -cacert ... -cert ... -key ... -keypass ...
```

sgadmin will print the location of the generated diagnostic file:

```
Diagnostic trace written to: /../../sgadmin_diag_trace_2017-<DATE>.txt
```

### Search Guard Community Forum

You can also ask for help on the [Search Guard Community Forum](https://groups.google.com/forum/#!forum/search-guard).

**Always add the diagnose file to any sgadmin related questions on the Community Forum!**