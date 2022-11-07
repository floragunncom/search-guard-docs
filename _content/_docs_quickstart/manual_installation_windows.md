---
title: Manual Installation (Windows)
html_title: Manual Installation
permalink: installation-windows
category: quickstart
order: 500
layout: docs
edition: community
description: How to download and install Search Guard and all required TLS certificates on a Windows machine. 
---

<!--- Copyright 2020 floragunn GmbH -->

# Manual installation (Windows) 
{: .no_toc}

{% include toc.md %}

To quickly set up a Search Guard secured Elasticsearch cluster on Windows:

1. Install the Search Guard Plugin to Elasticsearch
2. Download and unzip the demo certificates to the config directory of Elasticsearch
3. Add the Search Guard minimal configuration to elasticsearch.yml

To use the (optional) Search Guard Kibana plugin which adds security and configuration features to Kibana:

1. Install the Search Guard Kibana plugin to Kibana
2. Add the minimal Kibana configuration to `kibana.yml`

## Install Search Guard on Elasticsearch

Search Guard can be installed like any other Elasticsearch plugin by using the `elasticsearch-plugin` command. 

* Download the [Search Guard version](../_docs_versions/versions_versionmatrix.md) matching your Elasticsearch version
* Change to the directory of your Elasticsearch installation and type:

```bash
bin/elasticsearch-plugin install -b file:///path/to/search-guard-{{site.searchguard.esmajorversion}}-<version>.zip
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

* Using the Kibana Configuration GUI (Enterprise feature)
* Using the sgadmin command line tool with the generated admin certificate

For using the Kibana Configuration GUI you need to install the Search Guard Kibana Plugin, as described below. 

If you want to use the sgadmin tool:

* Apply your changes to the demo configuration files located in `<Elasticsearch directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/sgconfig`
* Execute sgadmin to upload the changed configuration to Search Guard

To execute sgadmin, first cd into 

```
<Elasticsearch directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/tools
```

And execute:

```
sgadmin.bat -cd ..\sgconfig -key ..\..\..\config\kirk-key.pem -cert ..\..\..\config\kirk.pem -cacert ..\..\..\config\root-ca.pem -nhnv -icl
```

This will read the contents of the configuration files in `<Elasticsearch directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/sgconfig` and upload the contents to the Search Guard index. 

The sgadmin tool is very powerful and offers a lot of features to manage any Search Guard installation. For more information about sgadmin, head over to the [Using sgadmin](../_docs_configuration_changes/configuration_sgadmin.md) chapter.

## Install Search Guard on Kibana

The Search Guard Kibana plugin adds authentication, multi tenancy and the Search Guard configuration GUI to Kibana. 

* Download the [Search Guard Kibana plugin zip](../_docs_versions/versions_versionmatrix.md) matching your exact Kibana version from Maven
* Stop Kibana
* cd into your Kibana installaton directory
* Execute: `bin/kibana-plugin install file:///path/to/kibana-plugin.zip

## Add the Search Guard Kibana configuration

If you've used the demo configuration to initializing Search Guard as outlined above, add the following lines to your `kibana.yml` and restart Kibana:

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

After Kibana is started, it will begin optimizing and caching browser bundles. This process may take a few minutes and cannot be skipped. After the plugin is installed and optimized, Kibana will continue to start.

## Testing the Kibana installation

* Open `http://localhost:5601/`.
* You should be redirected to the Kibana login page
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

After that, configure roles and access permissions by either modifying the configuration files and uploading them via `sgadmin`, or use the Kibana configuration GUI to change them directly. 

* [Using and defining action groups](../_docs_roles_permissions/configuration_action_groups.md)
* [Defining roles and permissions](../_docs_roles_permissions/configuration_roles_permissions.md)
* [Mapping users to Search Guard roles](../_docs_roles_permissions/configuration_roles_mapping.md)
* [Adding users to the internal user database](../_docs_roles_permissions/configuration_internalusers.md)

If you want to use more sophisticated authentication methods like Active Directory, LDAP, Kerberos or JWT, [configure your existing authentication and authorisation backends](../_docs_auth_auth/auth_auth_configuration.md) in `sg_config.yml`.

For fine-grained access control on document- and field level, use the Search Guard [Document and field level security module](../_docs_dls_fls/dlsfls_dls.md).

If you need to stay compliant with security regulations like GDPR, HIPAA, PCI, ISO or SOX, use the [Search Guard Audit Logging](../_docs_audit_logging/auditlogging.md) to generate and store audit trails.

And if you need to support multiple tenants in Kibana, use [Kibana Multitenancy](../_docs_kibana/kibana_multitenancy.md) to separate Visualizations and Dashboards by tenant.
