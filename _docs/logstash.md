---
title: Logstash
html_title: Logstash
slug: logstash
category: esstack
order: 200
layout: docs
description: How to configure and use logstash with a Search Guard secured cluster.
---
<!---
Copryight 2016-2017 floragunn GmbH
-->

# Using Search Guard with logstash

Configuring logstash is similar to configuring Kibana, so we recommend that you read the Kibana chapter. Most principles, especially the Kibana server user / logstash user, are nearly identical.

The sample configuration files that ship with Search Guard already contains a `logstash` user with the necessary permissions.  So you can use the sample config files to quickly set up a Search Guard secured logstash installation for testing purposes.

## Principles

From an Elasticsearch / Search Guard point of view, logstash is a HTTP client just like curl or a browser. Logstash connects to Elasticsearch via the REST API, creates indices and reads and writes documents to and from these indices. In order to use Search Guard in conjunction with logstash, you need to perform the following steps:

* Configure logstash to use HTTPS instead of HTTP.
* Configure the logstash user's username and password.
 * When talking to Elasticsearch, logstash uses this username and password.
 * You can use the sample config files shipped with Search Guard for a quick start. 

## Setting up TLS/SSL

If you use TLS on the REST layer you need to configure logstash to use HTTPS instead of HTTP when talking to Elasticsearch. This can be configured in the `elasticsearch` output section of `logstash.conf`:

```json
output {
    elasticsearch {
       ...
       ssl => true
       ssl_certificate_verification => true
       truststore => "/path/to/elasticsearch-2.3.3/config/truststore.jks"
       truststore_password => changeit
    }
}
```

Setting `ssl` to true ensures that logstash uses HTTPS.

Logstash requires you to set the trusted root CAs via the `truststore` or `cacert` parameter in the configuration. This is the absolute path to either the truststore or the root CA in PEM format that contains the Certificate Authority’s certificate.

If you want logstash to verify the hostname of the certificate it receives from Elasticsearch, set the `ssl_certificate_verification` property to true. 

## Configuring the logstash user

Similar to Kibana, logstash needs to authenticate itself to Elasticsearch. You need to configure the username and password logstash should use for this. This is configured in the `elasticsearch` output section of the `logstash.conf`:

```json
output {
    elasticsearch {
       user => logstash
       password => logstash
       ...
    }
}
```

If you use the internal Search Guard user database make sure the user exists in the `sg_internal_users.yml` file. If you use another authenticaton backend, such as LDAP, you need to configure the user and password there.

## Complete logstash configuration

The complete configuration file now should look similar to this:

```json
output {
    elasticsearch {
       user => logstash
       password => logstash
       ssl => true
       ssl_certificate_verification => true
       truststore => "/path/to/truststore.jks"
       truststore_password => changeit
    }
}
```

## Setting up permissions for the logstash user

The default permissions, which are also used in the sample configuration files, are as follows:

```yaml
sg_logstash:
  readonly: true
  cluster:
    - CLUSTER_MONITOR
    - CLUSTER_COMPOSITE_OPS
    - indices:admin/template/get
    - indices:admin/template/put
  indices:
    'logstash-*':
      '*':
        - CRUD
        - CREATE_INDEX
    '*beat*':
      '*':
        - CRUD
        - CREATE_INDEX
```