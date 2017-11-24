---
title: Installing Search Guard with Kibana
html_title: Kibana Plugin
slug: kibana-installation-search-guard
category: esstack
order: 100
layout: docs
description: How to install the Search Guard Kibana plugin which adds authentication, multi tenany and the configuration GUI.
---
<!---
Copryight 2016-2017 floragunn GmbH
-->

# Installing Search Guard with Kibana

Search Guard is compatible with [Kibana](https://www.elastic.co/products/kibana){:target="_blank"} and you can use nearly all features of Search Guard with Kibana, including SSO with Kerberos and JWT and DLS/FLS.

In the following description, we assume that you have already set up a Search Guard secured Elasticsearch cluster. We'll walk through all additional steps needed for integrating Kibana with your setup.

We also assume that you have enabled TLS support on the REST layer via Search Guard SSL. While this is optional, we strongly recommend using this feature. Otherwise, traffic between Kibana and Elasticsearch is made via unsecure HTTP calls, and thus can be sniffed.

Please check the `elasticsearch.yml` file and see whether TLS on the REST layer is enabled:

```
searchguard.ssl.http.enabled: true
```

## Installing the Search Guard Plugin

Download the [Search Guard Kibana plugin](https://search.maven.org/#search%7Cga%7C1%7Ca%3A%22search-guard-kibana-plugin%22){:target="_blank"} matching your  exact Kibana version from Maven:

* Stop Kibana
* cd into your Kibana installaton directory.
* Execute: `bin/kibana-plugin install file:///path/to/search-guard-kibana-plugin-<version>.zip`. 

## Configuring the Kibana server user

For management calls to Elasticsearch, such as setting the index pattern, saving and retrieving visualizations and dashboards etc., Kibana uses a special user, called the Kibana server users.

This user needs certain privileges for the Kibana index. When using the sample users and roles that ship with Search Guard, you can use the preconfigured `kibanaserver` user. If you want to set up your own user, please see chapter "Configuring Elasticsearch" below.

The username and password for the Kibana server user can be configured in `kibana.yml` by setting:

```yaml
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"
```

## Setting up SSL/TLS

If you use TLS on the Elasticsearch REST layer, you need to configure Kibana accordingly. Set the protocol on the entry `elasticsearch.url` to `https`:

```yaml
elasticsearch.url: "https://localhost:9200"
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

You can also provide the root CA in PEM format by setting:

```yaml
elasticsearch.ssl.ca: "/path/to/your/root-ca.pem"
```

In this case, you can leave the `elasticsearch.ssl.verify` set to `true`.

## Start Kibana

After you restart Kibana, it will start optimizing and caching browser bundles. This process may take a few minutes and cannot be skipped. After the plugin is installes and optimized, Kibana will continue to start.

## Upgrading the Search Guard Kibana Plugin

In order to upgrade the Search Guard Kibana Plugin:

* Stop Kibana
* Delete the Search Guard Kibana plugin from the `plugins` directory 
* Restart Kibana, which will clear all cached files
* Stop Kibana, and install the new version of the plugin

## Configuring Elasticsearch: The Kibana server user

### Adding the Kibana server user

As outlined above, Kibana uses a special user internally to talk to Elasticsearch when performing management calls. The username and password for this user is configured in `kibana.yml`. 

On the Elasticsearch side, make sure that this user has the required permissions. If you use the Search Guard demo configuration, you can either use the `kibanaserver` user account, or you can map a different user to the role `sg_kibana_server`.

The definition of this `sg_kibana_server` role can be found in the sample [sg_roles.yml](https://github.com/floragunncom/search-guard/blob/master/sgconfig/sg_roles.yml) that ships with Search Guard.

Kibana uses HTTP Basic Authentication for the server user, so make sure you have set up an authentication domain which supports HTTP Basic Authentication.

### Example: Internal authentication

Typically you set up the Kibana server user in the Search Guard Internal User Database backend, and configure any other authentication methods you have in place second in the chain:


```yaml
searchguard:
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

If you use the Search Guard demo configuration, assign all users that should have access to Kibana to the `sg_kibana_user` role. This role has the minimum permissions to use Kibana.

The definition of this `sg_kibana_user` role can be found in the sample [sg_roles.yml](https://github.com/floragunncom/search-guard/blob/master/sgconfig/sg_roles.yml){:target="_blank"} that ships with Search Guard.

In addition, the users need to have READ permissions to all indices they should be allowed to use with Kibana. Typically you will want to set up different roles for different users, and give them the `sg_kibana_user` role in additions.

## Where to go next

* [Set up Kibana authentication](kibana_authentication.md)
* [Use the config GUI for administering Search Guard](kibana_config_gui.md)
* [Set up Kibana Multitenancy](multitenancy.md)