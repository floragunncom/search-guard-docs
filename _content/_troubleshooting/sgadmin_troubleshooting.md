---
title: sgadmin Troubleshooting
permalink: troubleshooting-sgadmin
category: troubleshooting
order: 200
layout: troubleshooting
description: How to troubleshoot problems and issues with the Search Guard sgadmin command line tool.
---

<!--- Copyright 2020 floragunn GmbH -->

# sgadmin Troubleshooting

## Cluster not reachable

If the cluster is not reachable at all by `sgadmin`, you will see the following error message:

```
Search Guard Admin v6
Will connect to localhost:9300
ERR: Seems there is no elasticsearch running on localhost:9300 - Will exit
```

### Check the hostname of your cluster

* By default, sgadmin uses `localhost`
* If your cluster runs on any other host, specify the hostname with the `-h` option

### Check the port

* Check that you are running `sgadmin` against the transport port, **not the HTTP port** 
* By default, `sgadmin` uses `9300`  
* If you're running on a different port, use the `-p` option to specify the port number


## None of the configured nodes are available

If `sgadmin` can reach the cluster, but there are issues uploading the configuration, you will see the following error message:

``` 
Contacting elasticsearch cluster 'elasticsearch' and wait for YELLOW clusterstate ...
Cannot retrieve cluster state due to: None of the configured nodes are available: [{#transport#-1}{mr2NlX3XQ3WvtVG0Dv5eHw}{localhost}{127.0.0.1:9300}]. This is not an error, will keep on trying ...
   * Try running sgadmin.sh with -icl and -nhnv (If thats works you need to check your clustername as well as hostnames in your SSL certificates)
   * If this is not working, try running sgadmin.sh with --diagnose and see diagnose trace log file)
   * Add --accept-red-cluster to allow sgadmin to operate on a red cluster.
```

### Check the cluster name
* By default, sgadmin uses `elasticsearch` as cluster name
* If your cluster is named differently either:
  * let sgadmin ignore the cluster name completely by using the `-icl` swith **or**
  * specify the name of your cluster with the `-cn` switch 

### Check the hostname and hostname verification

* By default, sgadmin will verify that the hostname in your node's certificate matches the node's actual hostname
* If this is not the case, e.g. you're using demo certificates, disable hostname verification by adding the `-nhnv` switch   

### Check the cluster state
* By default, sgadmin ony executes when the cluster state is at least yellow
* If your cluster state is red, you can stll execute sgadmin, but you need to add the `-arc/--accept-red-cluster` switch

### Check the Search Guard index name
* By default, Search Guard uses `searchguard` as the name of the confguration index 
* If you configured a different index name in `opensearch.yml`/`elasticsearch.yml`, you need to specify it with the `-i` option

## ERR: CN=... is not an admin user  

If the TLS certificate used in the sgadmin call cannot be used as admin certificate, you will see a message like:

```
Connected as CN=node-0.example.com,OU=SSL,O=Test,L=Test,C=DE
ERR: CN=node-0.example.com,OU=SSL,O=Test,L=Test,C=DE is not an admin user
```
### Check if a node certificate was used

* Check if the output of `sgadmin` contains the following message:

```
Seems you use a node certificate. This is not permitted, you have to use a client certificate and register it as admin_dn in elasticsearch.yml
```

* If this is the case it means you used a node certificate, and not an admin certificate in the `sgadmin` call.
* Use a certificate that has admin privileges, i.e. that is configured in the `searchguard.authcz.admin_dn` section of `opensearch.yml`/`elasticsearch.yml`.
* See [Types of certificates](../_docs_tls/tls_certificates_production.md) for more information.

### Check if a non-admin certificate was used

* Check if the output of `sgadmin` contains the following message:

```
Seems you use a client certificate but this one is not registered as admin_dn
```

* If this is the case the used certificate is not listed in the `searchguard.authcz.admin_dn` section of `opensearch.yml`/`elasticsearch.yml`.
* Follow the steps printed out by sgadmin and add the DN of your certificate to `searchguard.authcz.admin_dn`.
* Sample output:

```
ERR: CN=kirk,OU=client,O=client,L=Test,C=DE is not an admin user
Seems you use a client certificate but this one is not registered as admin_dn
Make sure elasticsearch.yml on all nodes contains:
searchguard.authcz.admin_dn:
  - "CN=kirk,OU=client,O=client,L=Test,C=DE"
```
## Using the diagnose switch

If you cannot find out why sgadmin is not executing, add the `--diagnose` switch to gather debug information, for example

```
./sgadmin.sh -diagnose -cd ../sgconfig/ -cacert ... -cert ... -key ... -keypass ...
```

sgadmin will print the location of the generated diagnostic file:

```
Diagnostic trace written to: /../../sgadmin_diag_trace_2020-<DATE>.txt
```

### Search Guard Community Forum

You can also ask for help on the [Search Guard Community Forum](https://groups.google.com/forum/#!forum/search-guard).

**Always add the diagnose file to any sgadmin related questions on the Community Forum!**