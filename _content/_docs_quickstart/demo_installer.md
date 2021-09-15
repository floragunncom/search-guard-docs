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

- The script will download the Search Guard plugins and the `sgctl` tool. Additionally, it will download the matching version of OpenSearch or Elasticsearch, which will be automatically extracted to the working directory. The same will be done for OpenSearch Dashboards or Kibana, respectively.
- Afterwards, the script will install the Search Guard plugins and apply the basic configuration necessary for Search Guard and `sgctl`.
- Now, the script is done. If you want to see what the script has downloaded installed, list the directory contents. You should see the downloaded software archives, the `sgctl.sh` tool, keys for authenticating as administrator, and the `opensearch`/`elasticsearch` directory with a ready-to-start setup.

```bash
$ ls -lh
total 677M
-rw-rw-r--  1 sg sg 1,7K Sep 15 12:35 admin-key.pem
-rw-rw-r--  1 sg sg 1,6K Sep 15 12:35 admin.pem
drwxrwxr-x 10 sg sg 4,0K Sep 15 12:35 elasticsearch
-rw-rw-r--  1 sg sg 329M Sep 15 12:35 elasticsearch-7.14.1-linux-x86_64.tar.gz
drwxrwxr-x 10 sg sg 4,0K Sep 15 12:35 kibana
-rw-rw-r--  1 sg sg 273M Sep 15 12:35 kibana-7.14.1-linux-x86_64.tar.gz
drwxr-xr-x  2 sg sg 4,0K Sep 15 12:35 my-sg-config
-rw-rw-r--  1 sg sg  14M Sep 15 12:35 search-guard-kibana-plugin-7.14.1-51.0.0.zip
-rw-rw-r--  1 sg sg  49M Sep 15 12:35 search-guard-suite-plugin-7.14.1-52.2.0.zip
-rwxrwxr-x  1 sg sg  22K Sep 15 12:35 search-guard-suite-plugin-7.14.1-52.2.0-demo-installer.sh
-rwxrw-r--  1 sg sg  14M Sep 15 12:35 sgctl.sh
```



- You can start the cluster by running either

```bash
$ opensearch/bin/opensearch
```

or

```bash
$ elasticsearch/bin/elasticsearch
```

- If you want, you can also start Dashboards, resp. Kibana in a parallel shell by executing:

```bash
$ opensearch-dashboards/bin/opensearch-dashboards
```

or

```bash
$ kibana/bin/kibana
```

Note: While Dashboards/Kibana is started, it will begin optimizing and caching browser bundles. This process may take a few minutes. 

## Testing the installation

After having started the cluster, you can make the first steps with Search Guard.

* Open ``https://localhost:9200/_searchguard/authinfo``.
* Accept the self-signed demo TLS certificate.
* In the HTTP Basic Authentication dialogue, use ``admin`` as username and ``admin`` as password.
* This will print out information about the user ``admin`` in JSON format.

If you also have started Dashboards/Kibana, you can test it as well:

* Open `http://localhost:5601/`.
* You should be redirected to the login page
* On the login dialogue, use `admin` as user name and `admin` as password.

If everything is set up correctly, you should see three new navigation entries on the left pane:

* Search Guard - the [Search Guard configuration GUI](../_docs_configuration_changes/configuration_config_gui.md)
* Tenants - to select a tenant for [Dashboards/Kibana Multitenancy](../_docs_kibana/kibana_multitenancy.md)
* Logout - to end your current session

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

If you also have started Dashboards/Kibaba, you can also edit the configuration via the Search Guard Config GUI. Click on the hamburger icon and then on the "Search Guard" menu item to get directed to the [Search Guard Config GUI](../_docs_configuration_changes/configuration_config_gui.md).

## Review the generated configuration

If you want to know how things work under the hood, have a look at the automatically generated configuration in the files 

- `opensearch/config/opensearch.yml` resp.  `elaticsearch/config/elaticsearch.yml`
- `opensearch-dashboards/config/opensearch_dashboards.yml` resp.  `kibana/config/kibana.yml`


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