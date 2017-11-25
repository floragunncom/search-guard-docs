---
title: Demo Installer
slug: demo-installer
category: quickstart
order: 200
layout: docs
description: Search Guard ships with a demo installer for quickly setting up a working configuration. Use it for PoCs or checking out our features. 
---
<!---
Copryight 2016 floragunn GmbH
-->

# Quickstart

To quickly set up a Search Guard secured Elasticsearch cluster, you have two options:

1. Using the Search Guard demo installation scripts
2. Using the Search Guard bundle

The demo installation scripts will setup and configure Search Guard on an existing Elasticsearch cluster. They also provide demo users for Elasticsearch, Kibana and Logstash.

The Search Guard bundle is an Elasticsearch and Kibana installation that comes pre-installed and pre-configured with Search Guard. All required TLS certificates and all enterprise modules are included and fully functional. Just download, unpack and run.

Both ways use self-signed demo certificates, so **do not use in production**!

# Demo installation script

Search Guard ships with a demo installation script from v12 onwards. The installation script will:

* Generate the keystore and trustore files containing the demo TLS certificates.
* Add the required configuration to the ``elasticsearch.yml`` file.

Note that the script only works with vanilla Elasticsearch installations. If you already made changes to ``elasticsearch.yml``, especially the cluster name and the host entries, you might need to adapt the generated configuration.

## How to use

* Install the Search Guard plugin as described in the [installation chapter](installation.md), for example:

```
bin/elasticsearch-plugin install -b com.floragunn:search-guard-5:5.4.2-13
```

* ``cd`` into ``<Elasticsearch directory>/plugins/search-guard-5/tools``

* Execute ``./install_demo_configuration.sh``, ``chmod`` the script first if necessary.

This will generate the truststore and two keystore files. You can find them in the ``config`` directory of your Elasticsearch installation:

* ``truststore.jks``—the root CA and intermediate/signing CA.
* ``keystore.jks``—the node certificate. 
* ``kirk.jks``—the admin certificate required for running ``sgadmin``

The script will also add the TLS configuration to the `config/elasticsearch.yml` file automatically.

In order to upload the demo configuration with users, roles and permissions:

* ``cd`` into ``<Elasticsearch directory>/plugins/search-guard-5/tools``

* Execute ``./sgadmin_demo.sh``, ``chmod`` the script if necessary first

This will execute ``sgadmin`` and populate the Search Guard configuration index with the files contained in the ``plugins/search-guard-<version>/sgconfig`` directory. If you want to play around with different configuration settings, you can change the files in the ``sgconfig`` directory directly. After that, just execute ``./sgadmin_demo.sh`` again for the changes to take effect.

# Search Guard Bundle

The Search Guard bundle is an Elasticsearch installation that comes pre-installed and pre-configured with Search Guard. All required TLS certificates and all enterprise modules are included and fully functional.

We keep the Search Guard Bundle up-to-date with the latest Search Guard, Elasticsearch and Kibana versions. You can download SG here:

[https://github.com/floragunncom/search-guard/wiki/Search-Guard-Bundle](https://github.com/floragunncom/search-guard/wiki/Search-Guard-Bundle){:target="_blank"}

## How to use

After downloading and unpacking:

* ``cd`` into the directory where you unpacked the bundle.

* Start Elasticsearch. 
  * ``./elasticsearch-<version>-localhost/bin/elasticsearch`` 

* Open a new shell and ``cd``into the directory where you unpacked the bundle.

* ``cd`` into the ``searchguard-client`` folder

* Execute ``./sgadmin.sh``, ``chmod`` the script first if necessary.
  * This will install the yml configuration files from ``searchguard-client/plugins/search-guard-5/sgconfig/``.
  * If you would like to change the configuration, do it in the directory shown above and re-execute ``./sgadmin.sh``

## Testing the installation

* Open ``https://localhost:9200/_searchguard/authinfo``.
* Accept the self-signed demo TLS certificate.
* In the HTTP Basic Authentication dialogue, use ``admin`` as username and ``admin`` as password.
* This will print out information about the user ``admin`` in JSON format.
