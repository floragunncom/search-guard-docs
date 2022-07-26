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

<!--- Copyright 2020 floragunn GmbH -->

# Search Guard Manual Installation 
{: .no_toc}

{% include toc.md %}

<<<<<<< tech-preview
This guide describes the steps necessary for a manual installation of a Search Guard secured OpenSearch/Elasticsearch test installation. It is possible to set up this installation as a single node on your local computer.
=======
To quickly set up a Search Guard secured Elasticsearch cluster on Windows:
>>>>>>> 2a2e5e1 OpenSearch support

<<<<<<< tech-preview
## Prerequisites
=======
1. Install the Search Guard Plugin to Elasticsearch
2. Download and unzip the demo certificates to the config directory of Elasticsearch
3. Add the Search Guard minimal configuration to elasticsearch.yml
>>>>>>> 2a2e5e1 OpenSearch support

<<<<<<< tech-preview
If you don't have them yet, you need to download a couple of software components. The following table lists sources you can use for downloading:
=======
To use the (optional) Search Guard Kibana plugin which adds security and configuration features to Kibana:
>>>>>>> 2a2e5e1 OpenSearch support

<<<<<<< tech-preview
| Downloads for OpenSearch | Downloads for Elasticsearch |
|---|---|
| [OpenSearch Minimum](https://opensearch.org/downloads.html) |  [Elasticsearch](https://www.elastic.co/downloads/elasticsearch) |
| [OpenSearch Dashboards Minimum](https://opensearch.org/downloads.html) | [Kibana](https://www.elastic.co/downloads/kibana) | 
| [Search Guard OpenSearch Plugin](https://docs.search-guard.com/latest/search-guard-versions) | [Search Guard Elasticsearch Plugin](https://docs.search-guard.com/latest/search-guard-versions) | 
| [Search Guard OpenSearch Dashboards Plugin](https://docs.search-guard.com/latest/search-guard-versions) | [Search Guard Kibana Plugin](https://docs.search-guard.com/latest/search-guard-versions) |

<table>
<tr><th colspan=2 style="text-align:center; font-weight:400">Platform Independent</th></tr>
<tr><td colspan=2 style="text-align:center"><a href="https://maven.search-guard.com/search-guard-suite-release/com/floragunn/sgctl/">Search Guard Control Tool sgctl</a></td></tr>
</table>

**Note:** OpenSearch Dashboards/Kibana is optional. You can also just install the backend part OpenSearch/Elasticsearch.

**Note:** While the core downloads for OpenSearch/Elasticsearch are usually os-specific, the Search Guard plugin downloads are independent of the operating system.

**Note for OpenSearch:** The "Mininum" downloads of OpenSearch come without a security plugin. Thus, Search Guard can be easily installed here. If you want to
use the non-Minimum version, you have to remove the security plugin from the `plugins` folder of the respective installation before proceeding.

Preparing a local test installation of OpenSearch/Elasticsearch is quite easy: Just unzip/untar the downloads. The following sections assume that you have these components ready.

=======
1. Install the Search Guard Kibana plugin to Kibana
2. Add the minimal Kibana configuration to `kibana.yml`
>>>>>>> 2a2e5e1 OpenSearch support

## Install Search Guard on Elasticsearch

Search Guard can be installed like any other Elasticsearch plugin by using the `elasticsearch-plugin` command. 

<<<<<<< tech-preview
* Change to the directory of your OpenSearch/Elasticsearch installation.
* For OpenSearch, execute:
=======
* Download the [Search Guard version](../_docs_versions/versions_versionmatrix.md) matching your Elasticsearch version
* Change to the directory of your Elasticsearch installation and type:
>>>>>>> 2a2e5e1 OpenSearch support

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-{{site.searchguard.esmajorversion}}-<version>.zip
```

## Download and install the Search Guard demo certificates

Download the [certificates zip file](https://downloads.search-guard.com/resources/certificates/certificates.zip){:target="_blank"}, unpack it and place all files in the following directory:

```
<ES installation directory>/config
```

## Add the minimal Search Guard configuration

<<<<<<< tech-preview
Add the following minimal Search Guard configuration to `opensearch.yml`/`elasticsearch.yml`:
=======
Add the following minimal Search Guard configuration to `elasticsearch.yml`:
>>>>>>> 2a2e5e1 OpenSearch support

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

<<<<<<< tech-preview
* Using the Search Guard Configuration GUI (Enterprise feature)
* Using the `sgctl` command line tool with the generated admin certificate
=======
* Using the Kibana Configuration GUI (Enterprise feature)
* Using the sgadmin command line tool with the generated admin certificate
>>>>>>> 2a2e5e1 OpenSearch support

For using the Kibana Configuration GUI you need to install the Search Guard Kibana Plugin, as described below. 

If you want to use the `sgctl` tool, you initially need to create a connection configuration for the running cluster. You can do so by executing the `sgctl connect` command like this. You need to adapt the path specifications to the PEM files you [downloaded earlier](#download-and-install-the-search-guard-demo-certificates) in the demo certificates zip file:

<<<<<<< tech-preview
```bash
$ ./sgctl.sh connect localhost --ca-cart /path/to/root-ca.pem --cert /path/to/kirk.pem --key /path/to/kirk-key.pem
=======
* Apply your changes to the demo configuration files located in `<Elasticsearch directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/sgconfig`
* Execute sgadmin to upload the changed configuration to Search Guard

To execute sgadmin, first cd into 

```
<Elasticsearch directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/tools
>>>>>>> 2a2e5e1 OpenSearch support
```

If the connection is successful, the command should print `Connected as CN=kirk,OU=client,O=client,L=test,C=de` and store the connection configuration for future
use. The connection settings are stored in the `.searchguard` directory inside your home directory. You can test this by just executing:

```bash
$ ./sgctl.sh connect
```

<<<<<<< tech-preview
`sgctl` can upload the Search Guard configuration as YAML files. You can find the intial Search Guard configuration in `<OpenSearch/Elasticsearch directory>/plugins/search-guard/sgconfig`. Alternatively you can just retrieve the current configuration from Search Guard by executing
=======
This will read the contents of the configuration files in `<Elasticsearch directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/sgconfig` and upload the contents to the Search Guard index. 
>>>>>>> 2a2e5e1 OpenSearch support

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

<<<<<<< tech-preview
If you have a  Dashboards/Kibana setup and the Search Guard plugin ready, the installation is simple:
=======
The Search Guard Kibana plugin adds authentication, multi tenancy and the Search Guard configuration GUI to Kibana. 
>>>>>>> 2a2e5e1 OpenSearch support

<<<<<<< tech-preview
* cd into your Dashboards/Kibana installaton directory
* For OpeanSearch Dashboards execute: 

```bash
$ bin/opensearch-dashboards-plugin install file:///path/to/opensearch-dashboards-plugin.zip
```

* For Kibana execute:

```bash
$ bin/kibana-plugin install file:///path/to/kibana-plugin.zip
```
=======
* Download the [Search Guard Kibana plugin zip](../_docs_versions/versions_versionmatrix.md) matching your exact Kibana version from Maven
* Stop Kibana
* cd into your Kibana installaton directory
* Execute: `bin/kibana-plugin install file:///path/to/kibana-plugin.zip
>>>>>>> 2a2e5e1 OpenSearch support

## Add the Search Guard Kibana configuration

<<<<<<< tech-preview
If you've used the demo configuration to set up Search Guard as outlined above, you need add some more configuration entries to use Search Guard.

For OpenSearch, edit `config/opensearch_dashboards.yml` and add:

```yaml
# Use HTTPS instead of HTTP
opensearch.hosts: "https://localhost:9200"

# Configure the Dashboards/Kibana internal server user
opensearch.username: "kibanaserver"
opensearch.password: "kibanaserver"

# Disable SSL verification because we use self-signed demo certificates
opensearch.ssl.verificationMode: none

# Whitelist the Search Guard Multi Tenancy Header
opensearch.requestHeadersWhitelist: [ "Authorization", "sgtenant" ]
```

For Kibana, edit `config/kibana.yml` and add:
=======
If you've used the demo configuration to initializing Search Guard as outlined above, add the following lines to your `kibana.yml` and restart Kibana:
>>>>>>> 2a2e5e1 OpenSearch support

```yaml
# Use HTTPS instead of HTTP
elasticsearch.hosts: "https://localhost:9200"

# Configure the Kibana internal server user
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"

# Disable SSL verification because we use self-signed demo certificates
elasticsearch.ssl.verificationMode: none

# Whitelist the Search Guard Multi Tenancy Header
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant" ]

# X-Pack security needs to be disabled for Search Guard to work properly
xpack.security.enabled: false
```

## Start Kibana

<<<<<<< tech-preview

Now you can start Dashboards ... :

```yaml
$ bin/opensearch-dashboards
```

... or Kibana:

```yaml
$ bin/kibana
```


During the first startup, Dashboards/Kibana will begin optimizing and caching browser bundles. This process might take a few minutes.
=======
After Kibana is started, it will begin optimizing and caching browser bundles. This process may take a few minutes and cannot be skipped. After the plugin is installed and optimized, Kibana will continue to start.
>>>>>>> 2a2e5e1 OpenSearch support

## Testing the Kibana installation

* Open `http://localhost:5601/`.
<<<<<<< tech-preview
* You should be redirected to the login page
=======
* You should be redirected to the Kibana login page
>>>>>>> 2a2e5e1 OpenSearch support
* On the login dialogue, use `admin` as username and `admin` as password.

If everything is set up correctly, you should see three new navigation entries on the left pane:

* Search Guard - the [Search Guard configuration GUI](../_docs_configuration_changes/configuration_config_gui.md)
* Tenants - to select a tenant for [Kibana Multitenancy](../_docs_kibana/kibana_multitenancy.md)
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

<<<<<<< tech-preview
After that, configure roles and access permissions by either modifying the configuration files and uploading them via `sgctl`, or use the Dashboards/Kibana configuration GUI to change them directly. 
=======
After that, configure roles and access permissions by either modifying the configuration files and uploading them via `sgadmin`, or use the Kibana configuration GUI to change them directly. 
>>>>>>> 2a2e5e1 OpenSearch support

* [Using and defining action groups](../_docs_roles_permissions/configuration_action_groups.md)
* [Defining roles and permissions](../_docs_roles_permissions/configuration_roles_permissions.md)
* [Mapping users to Search Guard roles](../_docs_roles_permissions/configuration_roles_mapping.md)
* [Adding users to the internal user database](../_docs_roles_permissions/configuration_internalusers.md)

If you want to use more sophisticated authentication methods like Active Directory, LDAP, Kerberos or JWT, [configure your existing authentication and authorisation backends](../_docs_auth_auth/auth_auth_configuration.md) in `sg_authc.yml`.

For fine-grained access control on document- and field level, use the Search Guard [Document and field level security module](../_docs_dls_fls/dlsfls_dls.md).

If you need to stay compliant with security regulations like GDPR, HIPAA, PCI, ISO or SOX, use the [Search Guard Audit Logging](../_docs_audit_logging/auditlogging.md) to generate and store audit trails.

And if you need to support multiple tenants in Kibana, use [Kibana Multitenancy](../_docs_kibana/kibana_multitenancy.md) to separate Visualizations and Dashboards by tenant.
