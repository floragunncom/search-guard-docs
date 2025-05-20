---
title: TLS hot-reload
permalink: hot-reload-tls
layout: docs
edition: community
description: Search Guard supports hot-reload of TLS certificates
resources:
- troubleshooting-tls|Troubleshooting TLS problems (docs)
- https://search-guard.com/elasticsearch-searchguard-tls-introduction/|An introduction
  to TLS (blog post)
- https://search-guard.com/elasticsearch-tls-certificates/|An introduction to TLS
  certificates (blog post)
---
# TLS certificate hot-reload

TLS certificate hot-reload provides you the ability to change the TLS certificates and private keys used by Search Guard without having to restart the ES cluster.

Note that this an advanced feature; enabling it has security implications. Furthermore, activating an invalid certificate configuration on your cluster can actually lock yourself out of the cluster. Thus, please be sure to read this documentation thoroughly and to test the procedure.
{: .note .js-note .note-warning}

The hot-reload feature is only available if you have enabled TLS for HTTP connections. Furthermore, you must add this configuration setting to `elasticsearch.yml`:

```
searchguard.ssl.cert_reload_enabled: true
```

## Use Cases for TLS Certificate Hot-Reload

There is a number of different cases where you can use the hot-reload feature:

* [Updating node certificates](#updating-node-certificates): In this simple case, you just want to update the TLS certificates the nodes are using for transport and/or HTTP communication. 
* [Updating root certificates](#updating-root-certificates): This is a fundamental change to the TLS configuration of the cluster. Safely performing this requires a more complicated approach involving several phases.

### Updating Node Certificates

Updating node certificates is the most common procedure when maintaining your cluster's TLS infrastructure. Typically, you need to update node certificates when the expiration date of the certificates is coming close. 

You only need to update the certificates of the nodes which require an update. It is possible that there are nodes which don't need an update. These can be left untouched.

There are two types of connections managed by Search Guard: ES transport connections and REST connections. It is possible to use separate certificates for the different connection types; thus, Search Guard also allows separate updates of these certificates.

To update node certificates, follow this procedure:

1. For each node which requires an updated certificate:
	1. Determine in which file on the node the existing certificate is stored. This information is stored in the `config/elasticsearch.yml` file on the respective node. Look for the `searchguard.ssl.transport` resp. `searchguard.ssl.http` options. For details on these options, see [Configuring TLS](configuring-tls).
	2. Generate the new keys and certificates. The certificates need to have the same issuer distinguished name, the same subject distinguished name and the same subject alternative names (if any). Furthermore, the new certificates must have an expiry date which is after the expiry date of the existing certificates. The new key must use the same password as the existing key. It is not possible to change the value of the password configured in `config/elasticsearch.yml`. If you use JKS files, the aliases must stay the same.
	3. If you use intermediate certificates, remember to include these in the respective files.
	4. Copy the new certificate and key files over the existing certificate and key files on the particular node.
	5. Trigger the TLS reload. You can use the [sgctl](sgctl) tool or call the REST API directly, for example via `curl`.
	
```
$ ./sgctl.sh -h cluster_node1 rest post _searchguard/api/ssl/transport/reloadcerts/
$ ./sgctl.sh -h cluster_node1 rest post _searchguard/api/ssl/http/reloadcerts/
```
		
Note: You need to call `sgctl` for each host where you want to perform the reload. You can specify the respective host using the `-h` option.

If you want to call the REST API directly, see [below](#rest-api).

### Updating Root Certificates

If you need to update the root certificates, you must follow a two-phase process. In the first phase, you add the new root certificates to the trusted certificates of the cluster. In the second phase, you remove the old root certificates. Without the intermediate phase where both old and new root certificates are trusted, the internal communication in the cluster would break down during the certificate update process, leaving you with a broken cluster. Furthermore, when updating root certificates, you must be sure that you update *every* node in the cluster.

There are two types of connections managed by Search Guard: ES transport connections and REST connections. It is possible to use separate root CAs for the different connection types; thus, Search Guard also allows separate updates of these root CAs.

To update root certificates, follow this procedure:

1. Generate a new root certificate 
2. For each node in the cluster, add the new root certificate: 
	1. Determine in which file on the node the trusted certificates are stored. This information is stored in the `config/elasticsearch.yml` file on the respective node. Look for the options `searchguard.ssl.transport.pemtrustedcas_filepath`, `searchguard.ssl.http.pemtrustedcas_filepath`, `searchguard.ssl.transport.truststore_*`, `searchguard.ssl.http.truststore_*` . For details on these options, see [Configuring TLS](configuring-tls).
	2. Add the new certificates to the respective files. Be sure to keep the old certificates.
    3. Trigger the TLS reload. You can use the [sgctl](sgctl) tool or call the REST API directly, for example via `curl`.
    
```
$ ./sgctl.sh -h cluster_node1 rest post _searchguard/api/ssl/transport/reloadcerts/
$ ./sgctl.sh -h cluster_node1 rest post _searchguard/api/ssl/http/reloadcerts/
```

3. For each node in the cluster, update the node certificate:
	1. Determine in which file on the node the existing node certificate is stored. This information is stored in the `config/elasticsearch.yml` file on the respective node. Look for the `searchguard.ssl.transport` resp. `searchguard.ssl.http` options. For details on these options, see [Configuring TLS](configuring-tls).
	2. Generate the new keys and certificates. The certificates need to have the same issuer distinguished name, the same subject distinguished name and the same subject alternative names (if any). Furthermore, the new certificates must have an expiry date which is after the expiry date of the existing certificates. The new key must use the same password as the existing key. It is not possible to change the value of the password configured in `config/elasticsearch.yml`. If you use JKS files, the aliases must stay the same.
	3. If you use intermediate certificates, remember to include these in the respective files.
	4. Copy the new certificate and key files over the existing certificate and key files on the particular node.
	5. Trigger the TLS reload. This needs to be done for each node in the cluster.  You can use the same command as in step 3. 		
4. Generate new admin certificates using the new root certificate
5. For each node in the cluster, remove the old root certificates:
	1. Remove the old root certificates from the respective files.
	2. Trigger the TLS reload.  This needs to be done for each node in the cluster. You can use the same command as in step 3. However, remember that the specified root CA must match the new root certificate now. Also, you need to use the newly generated admin certificate.

Note: You need to call sgctl for each host where you want to perform the reload. You can specify the respective host using the `-h` option.

If you want to call the REST API directly, see [below](#rest-api).


## REST API

You can trigger the TLS reload also directly by using the REST API. It is available at these endpoints, which reload HTTP certs or transport certs respectively:

```
POST /_searchguard/api/ssl/http/reloadcerts/	
```

```
POST /_searchguard/api/ssl/transport/reloadcerts/	
```

Note: These endpoints take only effect on the node they have been called on. If you want to trigger a reload for the whole cluster, you need to call the endpoint on each node of the cluster.

The endpoints expect an empty request body.

The endpoints are only available when authenticating by TLS client authentication using an admin certificate.

 