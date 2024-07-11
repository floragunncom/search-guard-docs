---
title: Manual Installation 
html_title: Manual Installation
permalink: manual-installation
category: quickstart
order: 300
layout: docs
edition: community
description: How to download and install Search Guard and all required TLS certificates on a Windows machine. 
---

<!--- Copyright 2022 floragunn GmbH -->

# Search Guard Manual Installation 
{: .no_toc}

{% include toc.md %}

This guide describes the steps necessary for a manual installation of a Search Guard secured Elasticsearch test installation. It is possible to set up this installation as a single node on your local computer.

## Prerequisites

1. Install the Search Guard Plugin to Elasticsearch
2. Download and unzip the demo certificates to the config directory of Elasticsearch
3. Add the Search Guard minimal configuration to elasticsearch.yml

If you don't have them yet, you need to download a couple of software components. The following table lists sources you can use for downloading:

* [Elasticsearch](https://www.elastic.co/downloads/elasticsearch)
* [Kibana](https://www.elastic.co/downloads/kibana)
* [Search Guard Elasticsearch Plugin](https://docs/search-guard.com/latest/search-guard-versions) 
* [Search Guard Kibana Plugin](https://preview-docs.search-guard.com/latest/search-guard-versions) |

<table>
<tr><th colspan=2 style="text-align:center; font-weight:400">Platform Independent</th></tr>
<tr><td colspan=2 style="text-align:center"><a href="https://maven.search-guard.com/search-guard-flx-release/com/floragunn/sgctl/">Search Guard Control Tool sgctl</a></td></tr>
</table>

**Note:** Kibana is optional. You can also just install the backend partElasticsearch.

**Note:** While the core downloads for Elasticsearch are usually OS-specific, the Search Guard plugin downloads are independent of the operating system.

Preparing a local test installation of Elasticsearch is quite easy: Just unzip/untar the downloads. The following sections assume that you have these components ready.

## Install Search Guard on Elasticsearch

Search Guard can be installed like any other Elasticsearch plugin by using the `elasticsearch-plugin` command. 

* Download the [Search Guard version](../_docs_versions/versions_versionmatrix.md) matching your Elasticsearch version
* Change to the directory of your Elasticsearch installation and type:

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-{{site.elasticsearch.majorversion}}-<version>.zip
```

## Download and install the Search Guard demo certificates

Download the [certificates zip file](https://maven.search-guard.com//downloads/search-guard-demo-certificates.zip){:target="_blank"}, unpack it and place all files in the following directory:

```
<ES installation directory>/config
```

## Add the minimal Search Guard configuration

Add the following minimal Search Guard configuration to `elasticsearch.yml`:

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-yml">
<code class=" js-code language-markup">
searchguard.ssl.transport.pemcert_filepath: esnode.pem
searchguard.ssl.transport.pemkey_filepath: esnode-key.pem
searchguard.ssl.transport.pemtrustedcas_filepath: root-ca.pem
searchguard.ssl.transport.enforce_hostname_verification: false
searchguard.ssl.http.enabled: true
searchguard.ssl.http.pemcert_filepath: esnode.pem
searchguard.ssl.http.pemkey_filepath: esnode-key.pem
searchguard.ssl.http.pemtrustedcas_filepath: root-ca.pem
searchguard.allow_unsafe_democertificates: true
searchguard.allow_default_init_sgindex: true
searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test,C=de
searchguard.enable_snapshot_restore_privilege: true
searchguard.check_snapshot_restore_write_privileges: true
searchguard.restapi.roles_enabled: ["SGS_ALL_ACCESS"]
xpack.security.enabled: false
</code>
</pre>
</div>

Restart your node(s) for the changes to take effect.

## Testing the Elasticsearch installation

* Open ``https://localhost:9200/_searchguard/authinfo``.
* Accept the self-signed demo TLS certificate.
* In the HTTP Basic Authentication dialogue, use ``admin`` as username and ``admin`` as password.
* This will print out information about the user ``admin`` in JSON format.

## Applying configuration changes

The Search Guard configuration, like users, roles and permissions, is stored in a dedicated index in Elasticsearch, the *Search Guard Index*. 

Changes to the Search Guard configuration must be applied to this index by either

* Using the Search Guard Configuration GUI (Enterprise feature)
* Using the `sgctl` command line tool with the generated admin certificate

For using the Kibana Configuration GUI you need to install the Search Guard Kibana Plugin, as described below. 

If you want to use the `sgctl` tool, you initially need to create a connection configuration for the running cluster. You can do so by executing the `sgctl connect` command like this. You need to adapt the path specifications to the PEM files you [downloaded earlier](#download-and-install-the-search-guard-demo-certificates) in the demo certificates zip file:

```bash
$ ./sgctl.sh connect localhost --ca-cart /path/to/root-ca.pem --cert /path/to/kirk.pem --key /path/to/kirk-key.pem
```

If the connection is successful, the command should print `Connected as CN=kirk,OU=client,O=client,L=test,C=de` and store the connection configuration for future
use. The connection settings are stored in the `.searchguard` directory inside your home directory. You can test this by just executing:

```bash
$ ./sgctl.sh connect
```

`sgctl` can upload the Search Guard configuration as YAML files. You can find the initial Search Guard configuration in `</Elasticsearch directory>/plugins/search-guard/sgconfig`. Alternatively you can just retrieve the current configuration from Search Guard by executing

```bash
$ ./sgctl.sh get-config -o path/to/output/dir/
```

To make configuration changes, just edit these files. If you are done with your changes, you can upload them to Search Guard with:

```bash
$ ./sgctl.sh update-config path/to/config/dir/
```

You can also just specify single files using

```bash
$ ./sgctl.sh update-config path/to/config/dir/sg_internal_users.yml
```


## Install Search Guard on Kibana

If you have a  Kibana setup and the Search Guard plugin ready, the installation is simple:

* cd into your Kibana installaton directory
* execute:

```bash
$ bin/kibana-plugin install file:///path/to/kibana-plugin.zip
```
## Add the Search Guard Kibana configuration


If you've used the demo configuration to set up Search Guard as outlined above, you need add some more configuration entries to use Search Guard. In kibana.yaml, add:

```yaml
# Use HTTPS instead of HTTP
elasticsearch.hosts: "https://localhost:9200"

# Configure the Kibana internal server user
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"

# Disable SSL verification because we use self-signed demo certificates
elasticsearch.ssl.verificationMode: none

# Whitelist the Search Guard Multi-Tenancy Header
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant" ]
```

For Elasticsearch 7 you also have to include:
```yaml
# X-Pack security needs to be disabled for Search Guard to work properly
xpack.security.enabled: false
```

{% include es8_migration_note.html deprecated_properties="xpack.security.enabled" %}

## Start Kibana

Now you can start Kibana: 

```yaml
$ bin/kibana
```

After Kibana is started, it will begin optimizing and caching browser bundles. This process may take a few minutes and cannot be skipped. After the plugin is installed and optimized, Kibana will continue to start.

## Testing the Kibana installation

* Open `http://localhost:5601/`.
* You should be redirected to the Kibana login page
* On the login dialogue, use `admin` as username and `admin` as password.

If everything is set up correctly, you should see three new navigation entries on the left pane:

* Search Guard - the [Search Guard configuration GUI](../_docs_configuration_changes/configuration_config_gui.md)
* Tenants - to select a tenant for [Kibana Multi-Tenancy](../_docs_kibana/kibana_multitenancy.md)
* Logout - to end your current session

## Applying configuration changes

The Search Guard configuration GUI allows you to edit

* Search Guard Roles - define access permissions to indices and types
* Action Groups - define groups of access permissions
* Role Mappings - Assign users by username or their backend roles to Search Guard roles
* Internal User Database - An authentication backend that stores users directly in Elasticsearch

Furthermore you can view your currently active license, upload a new license if it has expired, and display the Search Guard system status.

## Where to go next

If you have not already done so, make yourself familiar with the [Search Guard Main Concepts](../_docs_quickstart/main_concepts.md). 

After that, configure roles and access permissions by either modifying the configuration files and uploading them via `sgctl`, or use the Configuration  UI to change them directly. 

* [Using and defining action groups](../_docs_roles_permissions/configuration_action_groups.md)
* [Defining roles and permissions](../_docs_roles_permissions/configuration_roles_permissions.md)
* [Mapping users to Search Guard roles](../_docs_roles_permissions/configuration_roles_mapping.md)
* [Adding users to the internal user database](../_docs_roles_permissions/configuration_internalusers.md)

If you want to use more sophisticated authentication methods like Active Directory, LDAP, Kerberos or JWT, [configure your existing authentication and authorization backends](../_docs_auth_auth/auth_auth_configuration.md) in `sg_authc.yml`.

For fine-grained access control on document- and field level, use the Search Guard [Document and field level security module](../_docs_dls_fls/dlsfls_dls.md).

If you need to stay compliant with security regulations like GDPR, HIPAA, PCI, ISO or SOX, use the [Search Guard Audit Logging](../_docs_audit_logging/auditlogging.md) to generate and store audit trails.

And if you need to support multiple tenants in Kibana, use [Kibana Multi-Tenancy](../_docs_kibana/kibana_multitenancy.md) to separate visualizations and dashboards by tenant.
