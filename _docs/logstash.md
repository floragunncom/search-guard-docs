---
title: Logstash
html_title: Logstash
slug: logstash
category: esstack
order: 200
layout: docs
edition: community
description: How to configure and use logstash with a Search Guard secured cluster.
---
<!---
Copryight 2016-2017 floragunn GmbH
-->

# Using logstash with Search Guard

Logstash connects to Elasticserch on the REST layer, just like a browser or curl. In order to use logstash with a Search Guard secured cluster:

* set up a logstash user with permissions to read and write to the logstash and beats indices
* configure logstash to use HTTPS instead of HTTP (optional, only applicable if you enabled HTTPS on the REST layer).

## Logstash user

The sample configuration files that ship with Search Guard already contain a `logstash` user with all required permissions. This user is configured in the internal user database and can be used as-is.

The corresponding Search Guard role in `sg_roles.yml` is `sg_logstash`. If you don't use the internal user database, map your logstash user to this role in `sg_roles_mapping.yml`.


The logtsash user is configured in the `elasticsearch` output section of `logstash.conf`:

```json
output {
    elasticsearch {
       user => logstash
       password => logstash
       ...
    }
}
```

## Setting up TLS/SSL

If you use TLS on the REST layer you need to configure logstash to use HTTPS instead of HTTP when talking to Elasticsearch. This is done in the `elasticsearch` output section of `logstash.conf`:

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

## logstash configuration example


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

## Permissions for the logstash user

The required permissions for the logstash user are as follows:

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