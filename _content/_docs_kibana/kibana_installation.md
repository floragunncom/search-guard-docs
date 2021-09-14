---
title: Installing the Plugin
html_title: Installing the Search Guard Dashboards/Kibana Plugin
slug: kibana-plugin-installation
category: kibana
order: 100
layout: docs
edition: community
description: How to install the Search Guard Dashboards/Kibana plugin which adds authentication, multi tenany and the configuration GUI.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Installing the Search Guard Dashboards/Kibana plugin
{: .no_toc}

{% include toc.md %}

Search Guard is compatible with [Dashboards/Kibana](https://www.elastic.co/products/kibana){:target="_blank"} and you can use nearly all features of Search Guard with Dashboards/Kibana, including SSO with Kerberos and JWT and DLS/FLS.

In the following description, we assume that you have already set up a Search Guard secured OpenSearch/Elasticsearch cluster. We'll walk through all additional steps needed for integrating Dashboards/Kibana with your setup.

We also assume that you have enabled TLS support on the REST layer via Search Guard SSL. While this is optional, we strongly recommend using this feature. Otherwise, traffic between Dashboards/Kibana and OpenSearch/Elasticsearch is made via unsecure HTTP calls, and thus can be sniffed.

Please check the `openearch.yml`/`elasticsearch.yml` file and see whether TLS on the REST layer is enabled:

```
searchguard.ssl.http.enabled: true
```

Elasticsearch and Kibana ship in two flavors: Bundled with X-Pack and a pure OSS flavor. If you are running the bundled version, make sure to disable X-Pack security by setting:

```
xpack.security.enabled: false
```

## Installing the Search Guard Plugin

* Download the [Search Guard Dashboards/Kibana plugin zip](../_docs_versions/versions_versionmatrix.md) matching your exact Dashboards/Kibana version from Maven
* Stop Dashboards/Kibana
* cd into your Dashboards/Kibana installaton directory
* For OpenSearch Dashboards, execute:  `bin/opensearch-dashboards-plugin install file:///path/to/plugin.zip`
* For Kibana, execute: `bin/kibana-plugin install file:///path/to/plugin.zip`

After the plugin has been installed, Dashboards/Kibana will run the optimization process. Depending on your system this might take a couple of minutes. This is an Dashboards/Kibana internal process required for each installed plugin and cannot be skipped. The [optimization process is shaky](https://github.com/elastic/kibana/issues/19678){:target="_blank"} and problems are typically not related to Search Guard. 

Most issues can be resolved by giving the process more memory by setting `NODE_OPTIONS="--max-old-space-size=8192"`. 

## Configuring the Dashboards/Kibana server user

For management calls to OpenSearch/Elasticsearch, such as setting the index pattern, saving and retrieving visualizations and dashboards etc., Dashboards/Kibana uses a service user, called the **Dashboards/Kibana server user**.

This user needs certain privileges for the Dashboards/Kibana index. When using the sample users and roles that ship with Search Guard, you can use the preconfigured `kibanaserver` user. If you want to set up your own user, please see chapter "Configuring OpenSearch/Elasticsearch" below.

For OpenSearch, edit `config/opensearch_dashboards.yml` and add:

```yaml
opensearch.username: "kibanaserver"
opensearch.password: "kibanaserver"
```

For Kibana, edit  `kibana.yml` and add:

```yaml
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"
```

## Setting up SSL/TLS

If you use TLS on the OpenSearch/Elasticsearch REST layer, you need to configure Dashboards/Kibana accordingly. Set the protocol on the entry `opensearch.hosts`/`elasticsearch.hosts` to `https`:

OpenSearch:

```yaml
opensearch.hosts: "https://localhost:9200"
```

Elasticsearch:

```yaml
elasticsearch.hosts: "https://localhost:9200"
```

All requests that Dashboards/Kibana makes to OpenSearch/Elasticsearch will now use HTTPS instead of HTTP.

### Configuring the Root CA

If you use your own root CA on OpenSearch/Elasticsearch, you need to either disable certificate validation or provide the root CA and all intermediate certififcates (if any) to Dashboards/Kibana. Otherwise, you'll see the following error message in the Dashboards/Kibana logfile:

```
Request error, retrying -- self signed certificate in certificate chain
```

You can disable certificate validation in `opensearch_dashboards.yml`/`kibana.yml` by setting:


OpenSearch:

```yaml
opensearch.ssl.verificationMode: none
```

Elasticsearch:


```yaml
elasticsearch.ssl.verificationMode: none
```

Or you can provide the root CA in PEM format by setting:


```yaml
opensearch.ssl.certificateAuthorities: "/path/to/your/root-ca.pem"
```

Elasticsearch:

```yaml
elasticsearch.ssl.certificateAuthorities: "/path/to/your/root-ca.pem"
```

In this case, you can leave the setting `opensearch.ssl.verify`/`elasticsearch.ssl.verify` set to `certificate` or to `full`. `full` performs hostname verification, while `certificate` does not.

## Start Dashboards/Kibana

After you restart Dashboards/Kibana, it will start optimizing and caching browser bundles. This process may take a few minutes and cannot be skipped. After the plugin is installed and optimized, Dashboards/Kibana will continue to start.

## Upgrading the Search Guard Dashboards/Kibana Plugin

In order to upgrade the Search Guard Dashboards/Kibana Plugin:

* Stop Dashboards/Kibana
* Delete the Search Guard Dashboards/Kibana plugin from the `plugins` directory 
* Restart Dashboards/Kibana, which will clear all cached files
* Stop Dashboards/Kibana, and install the new version of the plugin

## Configuring OpenSearch/Elasticsearch: The Dashboards/Kibana server user

### Adding the Dashboards/Kibana server user

Dashboards/Kibana uses a special user internally to talk to OpenSearch/Elasticsearch when performing management calls. The username and password for this user is configured in `opensearch_dashboards.yml`/`kibana.yml`. 

On the OpenSearch/Elasticsearch side, make sure that this user has the required permissions. If you use the Search Guard demo configuration, you can either use the `kibanaserver` user account, or you can map a different user to the  built-in role `SGS_KIBANA_SERVER`.

Dashboards/Kibana uses HTTP Basic Authentication for the Dashboards/Kibana server user, so make sure you have set up an authentication domain which supports HTTP Basic Authentication.

### Example: Internal authentication

Typically you set up the Dashboards/Kibana server user in the Search Guard Internal User Database backend, and configure any other authentication methods you have in place second in the chain:


```yaml
---
_sg_meta:
  type: "config"
  config_version: 2

sg_config:
  dynamic:
    http:
     ...
    authc:
      kibana_auth_domain:
        enabled: true
        order: 0
        http_authenticator:
          type: basic
          challenge: false
        authentication_backend:
          type: internal
      ldap_auth_domain:
        enabled: true
        order: 1
        http_authenticator:
          type: basic
          challenge: false
        authentication_backend:
          type: ldap
          ...
```

## Configuring OpenSearch/Elasticsearch: Adding Dashboards/Kibana users

All Dashboards/Kibana users must be mapped to the built-in `SGS_KIBANA_USER` role.
This role has the minimum permissions to access Dashboards/Kibana.

In addition, the users need to have READ permissions to all indices they should be allowed to use with Dashboards/Kibana. Typically you will want to set up different roles for different users, and give them the `SGS_KIBANA_USER` role in additions.


## Client certificates: elasticsearch.ssl.certificate

In `opensearch_dashboards.yml`/`kibana.yml`, you can configure Dashboards/Kibana to use a TLS certificate by setting the following options:

OpenSearch:

```
# Optional settings that provide the paths to the PEM-format SSL certificate and key files.
# These files validate that your backend uses the same key files.
opensearch.ssl.certificate: /path/to/your/client.crt
opensearch.ssl.key: /path/to/your/client.key
```

Elasticsearch:

```
# Optional settings that provide the paths to the PEM-format SSL certificate and key files.
# These files validate that your backend uses the same key files.
elasticsearch.ssl.certificate: /path/to/your/client.crt
elasticsearch.ssl.key: /path/to/your/client.key
```

When these options are defined, Dashboards/Kibana will include the configured certificate in every request to OpenSearch/Elasticsearch. This happens in the backend and is not related to your browser’s configuration.

If the certificate is an admin certificate, this means that all actions from all users will be allowed, regardless of other authorization settings. While this may be useful in cases where you need complete admin access, it isn’t always clear what these configuration settings actually do and what their implications are.

Hence, in order to avoid elevating the user permissions by mistake, Search Guard will check if a certificate has been defined and, by default, switch its status to red.

You can override this behaviour explicitly by using the following option in your kibana.yml:

```
# Allow using a client certificate defined in elasticsearch.ssl.certificate
searchguard.allow_client_certificates: true
# If you are on Dashboards/Kibana >= 6.5.0 you might want to also set
#elasticsearch.ssl.alwaysPresentCertificate: true
# see https://github.com/elastic/kibana/pull/24304
```

## Where to go next

* [Set up Dashboards/Kibana authentication](../_docs_kibana/kibana_authentication.md)
* [Use the config GUI for administering Search Guard](../_docs_configuration_changes/configuration_config_gui.md)
* [Set up Dashboards/Kibana Multitenancy](../_docs_kibana/kibana_multitenancy.md)
