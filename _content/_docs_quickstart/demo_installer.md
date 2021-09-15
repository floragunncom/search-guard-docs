---
title: Demo Installer (Linux/Mac)
html_title: Demo Installer
slug: demo-installer
category: quickstart
order: 200
layout: docs
edition: community
description: Search Guard ships with a demo installer for quickly setting up a working configuration. Use it for PoCs or checking out our features. 
resources:
  - "search-guard-presentations#quickstart|Search Guard Quickstart and First Steps (presentation)"
  - "search-guard-presentations#architecture-request-flow|Architecture and Request Flow (presentation)"
  - "search-guard-presentations#configuration-basics|Configuration Basics (presentation)"

---

<!--- Copyright 2020 floragunn GmbH -->

# Demo Installer 
{: .no_toc}

{% include toc.md %}

Search Guard comes with a demo installation shell script which helps you to quickly get Search Guard up and running on a test instance of OpenSearch or Elasticsearch. The most easy way is to set it up just on your local computer.

## Running the Demo Installer

The following paragraphs will guide you through the installation process.

- Download the demo installer script for the setup you want to test:<br>[OpenSearch 1.0.0]()<br>[Elasticsearch 7.14.1]()<br>[Elasticsearch 7.10.2]()
- If you want, feel invited to review the script. The single steps are also explained as comments in the file.
- Open a shell, create a working directory, `cd` into the directory. Possibly, you have to mark the script as executable by doing `chmod u+x search-guard-suite-plugin-7.14.1-52.2.0-demo-installer.sh`. Then, execute the script:

```bash
$ ./search-guard-suite-plugin-7.14.1-52.2.0-demo-installer.sh
```

- The script will download the Search Guard plugin and the `sgctl` tool. Additionally, it will download the matching version of OpenSearch or Elasticsearch, which will be automatically extracted to the working directory. 
- Afterwards, the script will install the Search Guard plugin and apply the basic configuration necessary for Search Guard and `sgctl`.
- Now, the script is done. If you want to see what the script has downloaded installed, list the directory contents. You should see the downloaded software archives, the `sgctl.sh` tool, keys for authenticating as administrator, and the `opensearch`/`elasticsearch` directory with a ready-to-start setup.

```bash
$ ls -lh
total 391M
-rw-rw-r--  1 sg sg 1,7K Sep 15 12:34 admin-key.pem
-rw-rw-r--  1 sg sg 1,6K Sep 15 12:34 admin.pem
drwxrwxr-x 10 sg sg 4,0K Sep 15 12:34 elasticsearch
-rw-rw-r--  1 sg sg 329M Sep 15 12:34 elasticsearch-7.14.1-linux-x86_64.tar.gz
-rw-rw-r--  1 sg sg  49M Sep 15 12:34 search-guard-suite-plugin-7.14.1-52.2.0.zip
-rwxrwxr-x  1 sg sg  16K Sep 15 12:34 search-guard-suite-plugin-7.14.1-52.2.0-demo-installer.sh
-rwxrw-r--  1 sg sg  14M Sep 15 00:52 sgctl.sh
```



- You can start the cluster by running either

```bash
$ opensearch/bin/opensearch
```

or

```bash
$ elasticsearch/bin/elasticsearch
```


## Testing the installation

After having started the cluster, you can make the first steps with Search Guard.

* Open ``https://localhost:9200/_searchguard/authinfo``.
* Accept the self-signed demo TLS certificate.
* In the HTTP Basic Authentication dialogue, use ``admin`` as username and ``admin`` as password.
* This will print out information about the user ``admin`` in JSON format.

## Applying configuration changes

The Search Guard configuration, like users, roles and permissions, is stored in a dedicated index in OpenSearch/Elasticsearch itself, the so-called Search Guard Index. 

Changes to the Search Guard configuration must be applied to this index by either

* Using the Search Guard Configuration GUI (Enterprise feature)
* Using the `sgctl` command line tool

For using the Search Guard Configuration GUI you need to install the Search Guard Dashboards/Kibana Plugin, as described below. 

If you want to use the sgadmin tool:

* Apply your changes to the demo configuration files located in `my-sg-config`
* Execute `./sgctl.sh update-config my-sg-config`

This will read the contents of the configuration files in `my-sg-config` and upload the contents to the Search Guard index. 

## Review the generated configuration

If you want to know how things work under the hood, have a look at the automatically generated configuration in the files 

- `opensearch/config/opensearch.yml` resp.  `elaticsearch/config/elaticsearch.yml`

You will find lots of additional information on the options in comments in the files. Look for sections starting like this:

```yaml
# -----------------------------------------------------------
# Search Guard Demo Configuration
# -----------------------------------------------------------

# -----
# The root certificate that is used to check the authenticity
# of all other certificates presented to Search Guard
#
searchguard.ssl.transport.pemtrustedcas_filepath: root-ca.pem
searchguard.ssl.http.pemtrustedcas_filepath: root-ca.pem
...
```


## Install Search Guard on OpenSearch Dashboards or Kibana

The Search Guard Dashboards/Kibana plugin adds authentication, multi tenancy and the Search Guard configuration GUI to Open Search Dashboards and Kibana.

### OpenSearch Dashboards Installation

If you are using OpenSearch Dashboards, perform the following steps:

* Download the [Search Guard Dashboards plugin zip](../_docs_versions/versions_versionmatrix.md) matching your exact OpenSearch Dashboards version
* Stop OpenSearch Dashboards
* cd into your OpenSearch Dashboards installation directory
* Execute: `bin/opensearch-dashboards-plugin install file:///path/to/opensearch-dashboards-plugin.zip

If you've used the demo configuration to initializing Search Guard as outlined above, add the following lines to your `opensearch_bashboards.yml` and restart Dashboards:

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

### Kibana Installation

If you are using Kibana, perform the following steps:

* Download the [Search Guard Kibana plugin zip](../_docs_versions/versions_versionmatrix.md) matching your exact Kibana version
* Stop Kibana
* cd into your Kibana installation directory
* Execute: `bin/kibana-plugin install file:///path/to/kibana-plugin.zip

If you've used the demo configuration to initializing Search Guard as outlined above, add the following lines to your `kibana.yml` and restart Kibana:

```yaml
# Use HTTPS instead of HTTP
elasticsearch.hosts: "https://localhost:9200"

# Configure the Dashboards/Kibana internal server user
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"

# Disable SSL verification because we use self-signed demo certificates
elasticsearch.ssl.verificationMode: none

# Whitelist the Search Guard Multi Tenancy Header
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant" ]

# X-Pack security needs to be disabled for Search Guard to work properly
xpack.security.enabled: false
```

## Start Dashboards/Kibana

After Dashboards/Kibana is started, it will begin optimizing and caching browser bundles. This process may take a few minutes and cannot be skipped. After the plugin is installed and optimized, Dashboards/Kibana will continue to start.

## Testing the installation

* Open `http://localhost:5601/`.
* You should be redirected to the login page
* On the login dialogue, use `admin` as user name and `admin` as password.

If everything is set up correctly, you should see three new navigation entries on the left pane:

* Search Guard - the [Search Guard configuration GUI](../_docs_configuration_changes/configuration_config_gui.md)
* Tenants - to select a tenant for [Dashboards/Kibana Multitenancy](../_docs_kibana/kibana_multitenancy.md)
* Logout - to end your current session

## Applying configuration changes

The Search Guard configuration GUI allows you to edit

* Search Guard Roles - define access permissions to indices and types
* Action Groups - define groups of access permissions
* Role Mappings - Assign users by username or their backend roles to Search Guard roles
* Internal User Database - An authentication backend that stores users directly in OpenSearch/Elasticsearch

Furthermore you can view your currently active license, upload a new license if it has expired, and display the Search Guard system status.

## Where to go next

- If you have not already done so, make yourself familiar with the [Search Guard Main Concepts](../_docs_introduction/main_concepts.md). 
- After that, configure roles and access permissions by either modifying the configuration files and uploading them via `sgctl`, or use the Search Guard configuration GUI to change them directly. 
  - [Using and defining action groups](../_docs_roles_permissions/configuration_action_groups.md)
  - [Defining roles and permissions](../_docs_roles_permissions/configuration_roles_permissions.md)
  - [Mapping users to Search Guard roles](../_docs_roles_permissions/configuration_roles_mapping.md)
  - [Adding users to the internal user database](../_docs_roles_permissions/configuration_internalusers.md)
  
- If you want to use more sophisticated authentication methods like Active Directory, LDAP, Kerberos or JWT, [configure your existing authentication and authorisation backends](../_docs_auth_auth/auth_auth_configuration.md) in `sg_config.yml`.
- For fine-grained access control on document- and field level, use the Search Guard [Document and field level security module](../_docs_dls_fls/dlsfls_dls.md).
- If you need to stay compliant with security regulations like GDPR, HIPAA, PCI, ISO or SOX, use the [Search Guard Audit Logging](../_docs_audit_logging/auditlogging.md) to generate and store audit trails.
- And if you need to support multiple tenants in Dashboards/Kibana, use [Multitenancy](../_docs_kibana/kibana_multitenancy.md) to separate Visualizations and Dashboards by tenant.
- Details on how to set up a production-ready TLS can be found in [Configuring TLS](../_docs_tls/tls_configuration.md) and [Moving TLS to production](../_docs_tls/tls_certificates_production.md).