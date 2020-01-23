---
title: Logstash
html_title: Logstash
slug: elasticsearch-logstash-search-guard
category: elasticstack
order: 100
layout: docs
edition: community
description: How to configure and use logstash with a Search Guard secured cluster.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Using logstash with Search Guard
{: .no_toc}

{% include toc.md %}

Logstash connects to Elasticserch on the REST layer, just like a browser or curl. In order to use logstash with a Search Guard secured cluster:

* set up a logstash user with permissions to read and write to the logstash and beats indices
* configure logstash to use HTTPS instead of HTTP (optional, only applicable if you enabled HTTPS on the REST layer).

## Logstash user

The sample configuration files that ship with Search Guard already contain a `logstash` user with all required permissions. This user is configured in the internal user database and can be used as-is.

The corresponding built-in Search Guard role is `SGS_LOGSTASH`. You can map any user to this logstash role in `sg_roles_mapping.yml`.


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

### Using custom logstash index names

If you are writing to a different index than the default logstash index, you need to give the logstash user access to this index.

For example, if you configured the index to be `mylogstashindex`: 

```json
output {
    elasticsearch {
       user => logstash
       password => logstash
       ...
       index => "mylogstashindex"
    }
}
```

The logstash user must have permissions to manage this index:

```yaml
sg_my_custom_logstash:
  cluster_permissions:
    - ...
  index_permissions:
    - index_patterns:
      - 'mylogstashindex'
      allowed_actions:
        - CRUD
        - CREATE_INDEX
```
