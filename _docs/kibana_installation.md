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
Copryight 2016-2017 floragunn GmbH
-->

# Installing the Search Guard Kibana plugin
{: .no_toc}

{% include_relative _includes/toc.md %}

Search Guard is compatible with [Kibana](https://www.elastic.co/products/kibana){:target="_blank"} and you can use nearly all features of Search Guard with Kibana, including SSO with Kerberos and JWT and DLS/FLS.

In the following description, we assume that you have already set up a Search Guard secured Elasticsearch cluster. We'll walk through all additional steps needed for integrating Kibana with your setup.

We also assume that you have enabled TLS support on the REST layer via Search Guard SSL. While this is optional, we strongly recommend using this feature. Otherwise, traffic between Kibana and Elasticsearch is made via unsecure HTTP calls, and thus can be sniffed.

Please check the `elasticsearch.yml` file and see whether TLS on the REST layer is enabled:

```
searchguard.ssl.http.enabled: true
```

Since 6.3.0 Elasticsearch and Kibana ship in two flavors: Bundled with X-Pack and a pure OSS flavor. If you are running the bundled version, make sure to disable X-Pack security by setting:

```
xpack.security.enabled: false
```

Since 6.5.0 you need to disable Kibana Spaces because we are not supporting them currently:

```
xpack.spaces.enabled: false
```


## Installing the Search Guard Plugin

Copy the URL of the [Search Guard Kibana plugin zip](https://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22search-guard-kibana-plugin%22){:target="_blank"} matching your exact Kibana version from Maven:

* Stop Kibana
* cd into your Kibana installaton directory
* Execute: `NODE_OPTIONS="--max-old-space-size=8192" bin/kibana-plugin install https://url/to/search-guard-kibana-plugin-<version>.zip`

### Offline installation

Download the [Search Guard Kibana plugin zip](https://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22search-guard-kibana-plugin%22){:target="_blank"} matching your exact Kibana version from Maven:

* Stop Kibana
* cd into your Kibana installation directory
* Execute: `NODE_OPTIONS="--max-old-space-size=8192" bin/kibana-plugin install file:///path/to/search-guard-kibana-plugin-<version>.zip`

After the plugin has been installed, Kibana will run the optimization process. Depending on your system this might take a couple of minutes. This is an Kibana internal process required for each installed plugin and cannot be skipped. The Kibana optimization process is shaky and problems are typically not related to Search Guard. Most issues can be resolved by giving the process more memory by setting `NODE_OPTIONS="--max-old-space-size=8192"`. If you are on ES 6.5.x or higher you can also try with `--no-optimize` (especially if you install the plugin in a Dockerfile). Kibana also currently [has a bug in the optimization step if you use X-Pack, but disable reporting](https://github.com/elastic/kibana/issues/25728). Please check if your Kibana version is affected and correct your `kibana.yml` accordingly.


## Configuring the Kibana server user

For management calls to Elasticsearch, such as setting the index pattern, saving and retrieving visualizations and dashboards etc., Kibana uses a special user, called the *Kibana server user*.

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

## Configuring Elasticsearch: Enable "do not fail on forbidden"

In some cases, Kibana will use a wildcard as index name if no index name is given. For example, if you access timelion. If the user does not have `READ` permissions on all indices, a security exception will be generated.

Search Guard can be run `do not fail on forbidden` mode. With this mode enabled Search Guard filters all indices from a query a user does not have access to. Thus not security exception is raised.

If you are using the Enterprise Edition of Search Guard, enable the `do not fail on forbidden` mode in `sg_config.yml` like:

```
searchguard:
  dynamic:
    kibana:
      do_not_fail_on_forbidden: true
      ...
```

While this is also the default behavior of competitor products, it may result in incorrect return values, especially if aggregations are used: If a user creates aggregations, and they include indices where he/she has no access to, the aggregation will be executed, but it will lack values from these indices. Since no exception is raised, the user will not be aware of this.
{: .note .js-note .note-warning}

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
```

## Where to go next

* [Set up Kibana authentication](kibana_authentication_types.md)
* [Use the config GUI for administering Search Guard](kibana_config_gui.md)
* [Set up Kibana Multitenancy](kibana_multitenancy.md)
