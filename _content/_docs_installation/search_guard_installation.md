---
title: Search Guard Installation
html_title: Installation
permalink: search-guard-installation
layout: docs
description: Step by step instructions for setting up Search Guard on a new or existing
  Elastcsearch cluster.
resources:
- https://search-guard.com/presentations/|Search Guard Quickstart and First Steps (presentation)
---
<!---
Copyright 2022 floragunn GmbH
-->

# Installation
{: .no_toc}

{% include toc.md %}

<span style="color:red">If you're upgrading to SG FLX 2.0.0, please review [the upgrade guide](../_docs_installation/sg200_upgrade.md).
This version introduces backwards-incompatible changes.</span>
{: .note .js-note .note-warning}

This chapter describes the steps to install and initialize Search Guard manually. If you just want to try out Search Guard or set up a quick PoC, follow the **[Quickstart Guide](../_docs_quickstart/demo_installer.md)**. 

## Community, Enterprise and Compliance Edition

Search Guard ships with all Enterprise and Compliance features already installed and enabled by default. Just install the [Enterprise Edition matching the version of your Elasticsearch installation](../_docs_versions/versions_versionmatrix.md) and you are good to go.

If you just want to use the free Community Edition, install Search Guard Enterprise and then [disable all commercial features](../_docs_versions/versions_community.md). 

## Prerequisites

### Ensure that your Java Virtual Machine is supported

* We support the same JVM versions and vendors listed here: [Support Matrix](https://www.elastic.co/de/support/matrix#matrix_jvm)
* There is **no** support for IBM VM and Azul Zing

### Generate all required TLS certificates

Make sure you have TLS certificates for all nodes and at least one admin certificate. If you already have a PKI infrastructure in place, you usually obtain the required certificates by issuing certificate signing requests to your PKI.

If this is not the case, you have the following options to generate certificates:

* Use the [Search Guard demo installation script](../_docs_tls/tls_generate_installation_script.md)  (not safe for production)
* Use the [Offline TLS Tool](../_docs_tls/tls_generate_tlstool.md) (safe for production)
* Use and customize the [example PKI scripts](../_docs_tls/tls_generate_example_scripts.md) (safe for production)
* Create a CSR and send it to your existing PKI infrastructure, if any (safe for production)
* Using tools like OpenSSL and/or keytool (safe for production)

For a typical installation you will want to generate

* One certificate for each node
* One admin certificate

It's possible to use the same certificate on each node, however this is less secure since you cannot use the hostname verification and DNS lookup feature of Search Guard to check the validity of the TLS certificates.

## First time installation: Full cluster restart

A first time installation of Search Guard on a cluster always requires a full cluster restart. TLS encryption is mandatory on the transport layer of Elasticsearch, and thus all nodes must have Search Guard installed in order to be able to talk to each other. If you already have Search Guard installed and want to upgrade, follow our [upgrade instructions](../_docs_installation/installation_upgrading.md).

## General

The first time installation procedure on a production cluster is to:

1. Disable shard allocation
2. Stop all nodes
3. Install the Search Guard plugin on all nodes
4. Add at least the [TLS configuration](../_docs_tls/tls_configuration.md) to `elasticsearch.yml`
5. Restart Elasticsearch and check that the nodes come up
6. Re-enable shard allocation
7. Configure authentication/authorization, users, roles and permissions by uploading the Search Guard configuration with [sgctl](sgctl-configuration-changes)

While for an already configured Search Guard plugin you can also use the Kibana Search Guard configuration GUI, for vanilla systems you need to execute sgctl at least once to initialize the Search Guard index.

## Disable shard allocation

This step is optional but recommended especially for large clusters with a huge amount of data. This step makes sure that shards will not be shifted around when restarting the cluster, causing a lot of I/O. See also [https://www.elastic.co/guide/en/elasticsearch/reference/current/shards-allocation.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/shards-allocation.html){:target="_blank"}

### Using sgctl

```bash
./sgctl.sh rest put _cluster/settings --json '{"persistent":{"cluster.routing.allocation.enable": "none"}}'
```

### Using curl

```bash
curl -Ss -XPUT 'https://localhost:9200/_cluster/settings?pretty' \ 
  -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "none"
  }
}
'
```

## Installing Search Guard

Search Guard can be installed like any other Elasticsearch plugin by using the `elasticsearch-plugin` command. 

* Download the [Search Guard version](../_docs_versions/versions_versionmatrix.md) matching your Elasticsearch version
* Change to the directory of your Elasticsearch installation and type:

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-flx-<version>.zip
```

### Additional permissions dialogue


You will see the following warning message when installating Search Guard. Confirm it by pressing 'y':

```bash
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@     WARNING: plugin requires additional permissions     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
* java.lang.RuntimePermission accessClassInPackage.sun.misc
* java.lang.RuntimePermission getClassLoader
* java.lang.RuntimePermission loadLibrary.*
* java.lang.reflect.ReflectPermission suppressAccessChecks
* java.security.SecurityPermission getProperty.ssl.KeyManagerFactory.algorithm
...
See http://docs.oracle.com/javase/8/docs/technotes/guides/security/permissions.html
for descriptions of what these permissions allow and the associated risks.
```

## Adding the TLS configuration

The bare minimum Search Guard configuration consists of the TLS settings on transport layer and at least one admin certificate for initializing the Search Guard index. This is configured in elasticsearch.yml, all paths to certificates must be specified relative to the Elasticsearch `config` directory:

```yaml
searchguard.ssl.transport.pemcert_filepath: <path_to_node_certificate>
searchguard.ssl.transport.pemkey_filepath: <path_to_node_certificate_key>
searchguard.ssl.transport.pemkey_password: <key_password (optional)>
searchguard.ssl.transport.pemtrustedcas_filepath: <path_to_root_ca>
searchguard.ssl.transport.enforce_hostname_verification: <true | false>

searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test, C=de
```

The `searchguard.ssl.transport.pem*` keys define the paths to the node certificate, relative to the Elasticsearch `config` directory.

The `searchguard.authcz.admin_dn` entry configures the admin certificate that you can use with sgctl or the REST management API. You need to state the full DN of the certificate, and you can configure more than one admin certificate.

If you want to use TLS also on the REST layer (HTTPS), add the following lines to `elasticsearch.yml`

```yaml
searchguard.ssl.http.enabled: true
searchguard.ssl.http.pemcert_filepath: <path_to_http_certificate>
searchguard.ssl.http.pemkey_filepath: <path_to_http_certificate_key>
searchguard.ssl.http.pemkey_password: <key_password (optional)>
searchguard.ssl.http.pemtrustedcas_filepath: <path_to_http_root_ca>
```

You can use the same certificates on the transport and on the REST layer. For production systems, we recommend to use individual certificates.

## Optional: Enable the REST management API

In order to use the REST management API, configure the Search Guard roles that should have access to the API. The following entry grants full access to the API for the role `SGS_ALL_ACCESS`:

```yaml
searchguard.restapi.roles_enabled: ["SGS_ALL_ACCESS"]
```

If you want to further restrict access to certain API endpoints, please refer to the [REST management API documentation chapter](../_docs_rest_api/restapi_api_access.md).

The REST management API is an Enterprise feature.

## Re-enable shard allocation

After the cluster is up again, re-enable shard allocation so that the Search Guard configuration index can be created in the next step. Since Search Guard is active now, but not initialized yet, you need to use the admin certificate in combination with sgctl or curl:

```bash
./sgctl.sh rest put _cluster/settings --json '{"persistent":{"cluster.routing.allocation.enable": "all"}}'
```

## Initializing Search Guard

All settings regarding users, roles, permissions and authentication methods are stored in an Search Guard index on Elasticsearch. By default, this index is not populated automatically for security reasons. Search Guard propagates a "Security First" mantra, so no default users or passwords are applied by default.

You initialize Search Guard by using the [sgctl command line tool](../_docs_configuration_changes/configuration_sgctl.md) with the admin certificate configured by the `searchguard.authcz.admin_dn` configuration key. This has to be performed at least once to tell Search Guard which [authentication modules](../_docs_auth_auth/auth_auth_configuration.md) to use.

Once initialized, you can also use the Search Guard configuration GUI to edit roles and permissions.

## Search Guard Health Check

To check if Search Guard is installed and up and running, access the healthcheck endpoint like:

```
https://<hostname>:9200/_searchguard/health
```

It returns a JSON snippet like:

```
{
  message: null,
  mode: "strict",
  status: "UP"
}
```

## Fixing curl issues

If you experience problems with curl commands see [Fixing curl](../_troubleshooting/tls_troubleshooting.md#fixing-curl) first before reporting any issues.