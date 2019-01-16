---
title: Demo Installer Generated Artefacts
html_title: Generated Artefacts
slug: demo-installer-generated-artefacts
category: quickstart
order: 300
layout: docs
description: Description of the generated artefacts of the demo installer, what they mean, and how to use them. 
---

<!--- Copyright 2017 floragunn GmbH -->

# Generated artefacts and settings
{: .no_toc}

{% include_relative _includes/toc.md %}

## Generated certificates

After executing the demo installer, you will find the following generated certificates in the config directory of your Elasticsearch installation:

* ``root-ca.pem``— the root CA used for signing all other certificates
* ``esnode.pem``— the node certificate used on the transport- and REST-layer. 
* ``esnode-key.pem``— the private key for the node certificate
* ``kirk.pem``— the admin certificate, allows full access to the cluster and can be used with sgadmin and the REST management API
* ``kirk-key.pem``— the private key for the admin certificate

These certificates are used for TLS encryption on the REST- and the transport layer of Elasticsearch, and for granting admin access to the Search Guard configuration index. For a detailed description on the types of certificates Search Guard uses, please see [Moving TLS to production](tls_certificates_production.md).

## Generated configuration

The demo installer automatically appends mandatory and useful configuration settings for Search Guard to `elasticsearch.yml`. These additions are enclosed by the following lines:

```yaml
######## Start Search Guard Demo Configuration ########
...
######## End Search Guard Demo Configuration ########
```

If for any reason you want to execute the demo installation script again. remove these lines and everything between them. The script will refuse to run if it finds an existing Search Guard configuration in `elasticsearch.yml`.

### TLS settings

The following lines configure TLS for the REST- and the transport layer:

```yaml
searchguard.ssl.http.enabled: true
searchguard.ssl.http.pemcert_filepath: esnode.pem
searchguard.ssl.http.pemkey_filepath: esnode-key.pem
searchguard.ssl.http.pemtrustedcas_filepath: root-ca.pem

searchguard.ssl.transport.pemcert_filepath: esnode.pem
searchguard.ssl.transport.pemkey_filepath: esnode-key.pem
searchguard.ssl.transport.pemtrustedcas_filepath: root-ca.pem
searchguard.ssl.transport.enforce_hostname_verification: false
```

Notes: TLS on the transport layer is mandatory, so you cannot switch it off. TLS on the REST layer can be enabled or disables per node.

For details on the TLS configuration please refer to [Configuring TLS](tls_configuration.md).

### Admin certificate

In order to apply changes to the Search Guard configuration index, an admin TLS cetificate is required. This line tells Search Guard that the DN of the generated `kirk.pem` certificate denotes an admin certificate and should be granted elevated privileges:

```yaml
searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test, C=de
```

### Allow demo certificates and auto-initialization

By adding these two lines, Search Guard will accept the generated demo certificates and initialize the Search Guard index with the contents from the `<Elasticsearch directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/sgconfig` directory. 

```yaml
searchguard.allow_unsafe_democertificates: true
searchguard.allow_default_init_sgindex: true
```

Both options are unsafe for production, so their default value is `false`. Don't forget to remove them if you move your configuration to production!

### Allow snapshot / restore

To perform snapshot and restore operations, a user needs to have special privileges assigned. The next two lines enable these privileges:

```yaml
searchguard.enable_snapshot_restore_privilege: true
searchguard.check_snapshot_restore_write_privileges: true
```

Details can be found in the [Snapshot & Restore](configuration_snapshots.md) chapter.

### Audit logging

This line tells Search Guard to enable audit logging and to store the generated audit trail directly in Elasticsearch:

```yaml
searchguard.audit.type: internal_elasticsearch
```

The default index name for storing the audit trail is `sg6-auditlog-YYYY.MM.dd` which means a daily rolling index is used. A complete description how to configure and use Audit Logging can be found [here](auditlogging.md).


### REST API access control

Tells Search Guard which Search Guard roles can access the REST Management API to perform changes to the configuration:

```yaml
searchguard.restapi.roles_enabled: ["sg_all_access"]
```

In the demo setup, this Search Guard role is assigned to the user `admin`. If you have installed the Kibana Configuration GUI, simply login as `admin/admin`.

### Default cluster name and host

```yaml
cluster.name: searchguard_demo
network.host: 0.0.0.0
```