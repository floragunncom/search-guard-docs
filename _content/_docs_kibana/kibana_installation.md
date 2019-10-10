---
title: Installing the Kibana plugin
html_title: Kibana Plugin
slug: kibana-plugin-installation
category: kibana
order: 100
layout: docs
edition: community
description: How to install the Search Guard Kibana plugin which adds authentication, multi tenany and the configuration GUI.
---
<!---
Copyright 2019 floragunn GmbH
-->

# Installing the Search Guard Kibana plugin
{: .no_toc}

{% include toc.md %}

Search Guard is compatible with [Kibana](https://www.elastic.co/products/kibana){:target="_blank"} and you can use nearly all features of Search Guard with Kibana, including SSO with Kerberos and JWT and DLS/FLS.

In the following description, we assume that you have already set up a Search Guard secured Elasticsearch cluster. We'll walk through all additional steps needed for integrating Kibana with your setup.

We also assume that you have enabled TLS support on the REST layer via Search Guard SSL. While this is optional, we strongly recommend using this feature. Otherwise, traffic between Kibana and Elasticsearch is made via unsecure HTTP calls, and thus can be sniffed.

Please check the `elasticsearch.yml` file and see whether TLS on the REST layer is enabled:

```
searchguard.ssl.http.enabled: true
```

Elasticsearch and Kibana ship in two flavors: Bundled with X-Pack and a pure OSS flavor. If you are running the bundled version, make sure to disable X-Pack security by setting:

```
xpack.security.enabled: false
```

## Installing the Search Guard Plugin

* Download the [Search Guard Kibana plugin zip](../_docs_versions/versions_versionmatrix.md) matching your exact Kibana version from Maven
* Stop Kibana
* cd into your Kibana installaton directory
* Execute: `bin/kibana-plugin install file:///path/to/kibana-plugin.zip`

After the plugin has been installed, Kibana will run the optimization process. Depending on your system this might take a couple of minutes. This is an Kibana internal process required for each installed plugin and cannot be skipped. The Kibana [optimization process is shaky](https://github.com/elastic/kibana/issues/19678){:target="_blank"} and problems are typically not related to Search Guard. 

Most issues can be resolved by giving the process more memory by setting `NODE_OPTIONS="--max-old-space-size=8192"`. 

## Configuring the Kibana server user

For management calls to Elasticsearch, such as setting the index pattern, saving and retrieving visualizations and dashboards etc., Kibana uses a service user, called the **Kibana server user**.

This user needs certain privileges for the Kibana index. When using the sample users and roles that ship with Search Guard, you can use the preconfigured `kibanaserver` user. If you want to set up your own user, please see chapter "Configuring Elasticsearch" below.

The username and password for the Kibana server user can be configured in `kibana.yml` by setting:

```yaml
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"
```

## Setting up SSL/TLS

If you use TLS on the Elasticsearch REST layer, you need to configure Kibana accordingly. Set the protocol on the entry `elasticsearch.hosts` to `https`:

```yaml
elasticsearch.hosts: "https://localhost:9200"
```

All requests that Kibana makes to Elasticsearch will now use HTTPS instead of HTTP.

### Configuring the Root CA

If you use your own root CA on Elasticsearch, you need to either disable certificate validation or provide the root CA and all intermediate certififcates (if any) to Kibana. Otherwise, you'll see the following error message in the Kibana logfile:

```
Request error, retrying -- self signed certificate in certificate chain
```

You can disable certificate validation in `kibana.yml` by setting:

```yaml
elasticsearch.ssl.verificationMode: none
```

Or you can provide the root CA in PEM format by setting:

```yaml
elasticsearch.ssl.certificateAuthorities: "/path/to/your/root-ca.pem"
```

In this case, you can leave the `elasticsearch.ssl.verify` set to `certificate` or to `full`. `full` performs hostname verification, while `certificate` does not.

## Start Kibana

After you restart Kibana, it will start optimizing and caching browser bundles. This process may take a few minutes and cannot be skipped. After the plugin is installed and optimized, Kibana will continue to start.

## Upgrading the Search Guard Kibana Plugin

In order to upgrade the Search Guard Kibana Plugin:

* Stop Kibana
* Delete the Search Guard Kibana plugin from the `plugins` directory 
* Restart Kibana, which will clear all cached files
* Stop Kibana, and install the new version of the plugin

## Configuring Elasticsearch: The Kibana server user

### Adding the Kibana server user

Kibana uses a special user internally to talk to Elasticsearch when performing management calls. The username and password for this user is configured in `kibana.yml`. 

On the Elasticsearch side, make sure that this user has the required permissions. If you use the Search Guard demo configuration, you can either use the `kibanaserver` user account, or you can map a different user to the  built-in role `SGS_KIBANA_SERVER`.

Kibana uses HTTP Basic Authentication for the Kibana server user, so make sure you have set up an authentication domain which supports HTTP Basic Authentication.

### Example: Internal authentication

Typically you set up the Kibana server user in the Search Guard Internal User Database backend, and configure any other authentication methods you have in place second in the chain:


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

## Configuring Elasticsearch: Adding Kibana users

All Kibana users must be mapped to the built-in `SGS_KIBANA_USER` role.
This role has the minimum permissions to access Kibana.

In addition, the users need to have READ permissions to all indices they should be allowed to use with Kibana. Typically you will want to set up different roles for different users, and give them the `SGS_KIBANA_USER` role in additions.

## Configuring Elasticsearch: Enable "do not fail on forbidden"

In some cases, Kibana will use a wildcard as index name if no index name is given. For example, if you access timelion. If the user does not have `READ` permissions on all indices, a security exception will be generated.

Search Guard can be run in `do not fail on forbidden` mode. With this mode enabled Search Guard filters all indices from a query a user does not have access to. Thus not security exception is raised.

Enable the `do not fail on forbidden` mode in `sg_config.yml` like:

```
---
_sg_meta:
  type: "config"
  config_version: 2

sg_config:
  dynamic:
    do_not_fail_on_forbidden: true
    ...
```

## Client certificates: elasticsearch.ssl.certificate

In kibana.yml, you can configure Kibana to use a TLS certificate by setting the following options:

```
# Optional settings that provide the paths to the PEM-format SSL certificate and key files.
# These files validate that your Elasticsearch backend uses the same key files.
elasticsearch.ssl.certificate: /path/to/your/client.crt
elasticsearch.ssl.key: /path/to/your/client.key
```

When these options are defined, Kibana will include the configured certificate in every request to Elasticsearch. This happens in the backend and is not related to your browser’s configuration.

If the certificate is an admin certificate, this means that all actions from all users will be allowed, regardless of other authorization settings. While this may be useful in cases where you need complete admin access, it isn’t always clear what these configuration settings actually do and what their implications are.

Hence, in order to avoid elevating the user permissions by mistake, Search Guard will check if a certificate has been defined and, by default, switch its status to red.

You can override this behaviour explicitly by using the following option in your kibana.yml:

```
# Allow using a client certificate defined in elasticsearch.ssl.certificate
searchguard.allow_client_certificates: true
# If you are on Kibana >= 6.5.0 you might want to also set
#elasticsearch.ssl.alwaysPresentCertificate: true
# see https://github.com/elastic/kibana/pull/24304
```

## Where to go next

* [Set up Kibana authentication](../_docs_kibana/kibana_multitenancy.md)
* [Use the config GUI for administering Search Guard](../_docs_configuration_changes/configuration_config_gui.md)
* [Set up Kibana Multitenancy](../_docs_kibana/kibana_multitenancy.md)
