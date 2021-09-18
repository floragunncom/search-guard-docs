---
title: Basic usage
html_title: sgadmin Basic Usage
permalink: sgadmin-basic-usage
category: sgadmin
order: 100
layout: docs
edition: community
description: How to use sgadmin to connect to an OpenSearch/Elasticsearch cluster to configure Search Guard
---
<!---
Copyright 2020 floragunn GmbH
-->

# Basic Usage
{: .no_toc}

{% include toc.md %}

The Search Guard configuration is stored in an index on the OpenSearch/Elasticsearch cluster. This allows for configuration hot-reloading, and eliminates the need to place configuration files on any node.

Configuration settings are uploaded to the Search Guard configuration index using the `sgadmin` tool. When installing Search Guard for the first time, you have to run sgadmin at least once to initialize the configuration index.

Search Guard ships with sgadmin included. 

```
<ES installation directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/tools
```

You can also [download a standalone version](search-guard-versions) of sgadmin with all dependencies. You can run sgadmin from any machine that has access to the transport port of your cluster. This means that you can change the Search Guard configuration without having to access your nodes via SSH. 

You can find sample sgadmin calls in the [examples chapter](configuration_sgadmin_examples.md)

## Prerequisites

### Linux

Change the permissions on that script and give it execution rights:

```bash
chmod +x plugins/search-guard-{{site.searchguard.esmajorversion}}/tools/sgadmin.sh
```

### Windows

Before executing sgadmin.bat check that you have set JAVA_HOME environment variable, e.g.:

```
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_65
```

Replace `jdk1.8.0_65` with your installed JDK or JRE version.

### Configuring the admin certificate

sgadmin requires an *TLS admin certificate* to make configuration changes. An admin certificate is a regular TLS certificate that has been granted full access to your cluster, including the configuration index.

Admin certificates are configured in elasticsearch.yml by listing their DNs:

```yaml
searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test,C=DE
  - CN=spock,OU=client,O=client,L=test,C=DE
```

*Do not use node certificates as admin certifcates. The intended use is to keep node and admin certificates separate. Using node certificates as admin certificates can lead to unexpected results. Also, do not use any whitespaces between the parts of the DN.*

## Connecting to OpenSearch/Elasticsearch with PEM certificates

If you use PEM certificates, you need to provide

* the root certificate in PEM format
* the admin certificate in PEM format
* the private key of the certificate in PEM format
* optional: the password of the private key

```bash
./sgadmin.sh  
   -cacert ../../../config/root-ca.pem 
   -cert ../../../config/kirk.pem 
   -key ../../../config/kirk-key.pem 
   ...
```

All PEM options:

| Name | Description |
|---|---|
| cert | The location of the pem file containing the admin certificate and all intermediate certificates, if any. You can use an absolute or relative path. Relative paths are resolved relative to the execution directory of sgadmin.|
| key | The location of the pem file containing the private key of the admin certificate. You can use an absolute or relative path. Relative paths are resolved relative to the execution directory of sgadmin. The key must be in PKCS#8 format.|
| keypass | The password of the private key of the admin certificate, if any.|
| cacert | The location of the pem file containing the root certificate. You can use an absolute or relative path. Relative paths are resolved relative to the execution directory of sgadmin.|
{: .config-table}

## Connecting to OpenSearch/Elasticsearch with keystore files

You can also use keystore files in JKS format in conjunction with `sgadmin`, for example: 

```bash
./sgadmin.sh -cd ../sgconfig -icl -nhnv 
  -ts <path/to/truststore> -tspass <truststore password> 
  -ks <path/to/keystore> -kspass <keystore password> 
  
```

Options:

| Name | Description |
|---|---|
| -ks | The location of the keystore containing the admin certificate and all intermediate certificates, if any. You can use an absolute or relative path. Relative paths are resolved relative to the execution directory of sgadmin.|
| -kspass | The password for the keystore.|
| -kst | The key store type, either JKS or PKCS12/PFX. If not specified, Search Guard tries to deduct the type from the file extension.|
| -ksalias | The alias of the admin certificate, if any.|
| -ts | The location of the truststore containing the root certificate. You can use an absolute or relative path. Relative paths are resolved relative to the execution directory of sgadmin.|
| -tspass | The password for the truststore.|
| -tst | The trust store type, either JKS or PKCS12/PFX. If not specified, Search Guard tries to deduct the type from the file extension.|
| -tsalias | The alias for the root certificate, if any.|
{: .config-table}

## Certificate validation settings

Use the following options to control certificate validation:

| Name | Description |
|---|---|
| -nhnv | disable-host-name-verification, do not validate hostname. Default: false|
| -nrhn | disable-resolve-hostname, do not resolve hostname (Only relevant if -nhnv is not set.).|
|-noopenssl| Do not use OpenSSL even if available (default: use OpenSSL if available)|
{: .config-table}

### Cipher settings

Usually you do not need to change the cipher settings. If you do, use the following switches:

| Name | Description |
|---|---|
| -ec | enabled-ciphers, comma separated list of enabled TLS ciphers.|
| -ep | enabled-protocols, comma separated list of enabled TLS protocols.|
{: .config-table}


## OpenSearch/Elasticsearch cluster settings

If you run a default OpenSearch/Elasticsearch installation, which listens on transport port 9300, and uses `elasticsearch` as cluster name, you can omit the following settings altogether. Otherwise, specify your OpenSearch/Elasticsearch settings by using the following switches:

| Name | Description |
|---|---|
| -h | elasticsearch hostname, default: localhost |
| -p | elasticsearch port, default: 9300 (NOT the http port!) |
| -cn | clustername, default: elasticsearch |
| -icl | Ignore clustername. |
| -sniff | Sniff cluster nodes. |
| -arc,--accept-red-cluster | Execute sgadmin even if the cluster state is red. Default: sgadmin won't execute on red cluster state |
{: .config-table}

Ignore cluster name means that the name of your cluster will not be validated. Sniffing can be used to detected available nodes by using the ES cluster state API. You can read more about this feature in the [OpenSearch/Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/client/java-api/current/transport-client.html).