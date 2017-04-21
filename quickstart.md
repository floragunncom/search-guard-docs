<!---
Copryight 2016 floragunn GmbH
-->

# Quickstart

If you just want to try out Search Guard or if you want to verify that Search Guard will work with your specific environment, we provide two options. Both options use a self-signed demo TLS certificates, so **do not use in production**!

# Search Guard Bundle

The Search Guard bundle is an Elasticsearch installation that comes pre-installed and pre-configured with Search Guard. All required TLS certificates and all enterprise modules are included. Just download, unpack and run. 

We keep the Search Guard Bundle up-to-date with the latest Search Guard revisions, both for ES 2.x and ES 5.x. You can download SG here:

[https://github.com/floragunncom/search-guard/wiki/Search-Guard-Bundle](https://github.com/floragunncom/search-guard/wiki/Search-Guard-Bundle)

## How to use

After downloading and unpacking:

* ``cd`` into the directory where you unpacked the bundle.
* Start Elasticsearch. 
 * ``./elasticsearch-<VERSION>-localhost/bin/elasticsearch`` 
* Open a new shell and ``cd``into the directory where you unpacked the bundle.
* ``cd`` into the ``searchguard-client`` folder
* Execute ``./sgadmin.sh``, ``chmod`` the script first if necessary.
 * This will install the yml configuration files from ``searchguard-client/plugins/search-guard-2/sgconfig/`` or ``searchguard-client/plugins/search-guard-5/sgconfig/``.
 * If you would like to change the configuration, do it in that directory.
 * If you need to configure SSL and a few other options which are not hot reloadable,do this in elasticsearch.yml, which is here: ``elasticsearch-<VERSION>-localhost/config/elasticsearch.yml``.
* Open ``https://localhost:9200/_searchguard/authinfo``.
* Accept the self-signed demo TLS certificate.
* In the HTTP Basic Authentication dialogue, use ``admin`` as username and ``admin`` as password.
* This will print out some information about the user ``admin`` in JSON format.

# Demo installation script  

Search Guard ships with a demo installation script from v12 onwards. The installation script will:

* Generate the keystore and trustore files containing the demo TLS certificates.
* Add the required configuration to the ``elasticsearch.yml`` file.

Note that the script only works with out of the box Elasticsearch installations. If you already made changes to ``elasticsearch.yml``, especially the cluster name and the host entries, you might need to adapt the generated configuration.

## How to use

* Install the Search Guard plugin as described in the [installation chapter](installation.md)
* ``cd`` into ``<Elasticsearch directory>/plugins/search-guard-<version>/tools``
* Execute ``./install_demo_configuration.sh``, ``chmod`` the script first if necessary.

This will generate the truststore and two keystore files. You can find them in the ``config`` directory of your Elasticsearch installation:

* ``truststore.jks``—the Root CA and intermediate/signing CA.
* ``keystore.jks``—the node certificate. 
* ``kirk.jks``—the admin certificate required for running ``sgadmin``

In order to upload the demo configuration with users, roles and permissions:

* ``cd`` into ``<Elasticsearch directory>/plugins/search-guard-<version>/tools``
* Execute ``./sgadmin_demo.sh``, ``chmod`` the script if necessary first

This will execute ``sgadmin`` and populate the Search Guard configuration index with the files contained in the ``plugins/search-guard-<version>/sgconfig`` directory. If you want to play around with different configuration settings, you can change the files in the ``sgconfig`` directory directly. After that, just execute ``./sgadmin_demo.sh`` again for the changes to take effect.
 
