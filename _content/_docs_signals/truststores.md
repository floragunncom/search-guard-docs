---
title: Trust Stores
html_title: Trust Stores
permalink: elasticsearch-alerting-trust-stores
category: signals
order: 800
layout: docs
edition: community
description: How to use trust stores
---

<!--- Copyright 2022 floragunn GmbH -->

# Trust stores
{: .no_toc}

{% include toc.md %}

Some signals' actions (e.g. [Webhook action](elasticsearch-alerting-actions-webhook)) and [HTTP Input](elasticsearch-alerting-inputs-http)
need to establish a TLS connection to do their jobs. If no additional TLS related configuration is provided for the action or input then 
the TLS certificate used by the destination server is considered to be trusted when the server's certificate is issued by a trusted CA 
(certificate authority). JVM considers CA to be trusted when its, so-called, root certificate is placed in the Java trust store. 
The trust store is usually a file provided with JVM (usually `lib/security/cacerts`) therefore its content depends on the Java version. 
Such behaviour may block connection during the TLS handshake phase when self-signed certificates are used or when private PKI is used. 
To overcome this inconvenience, a Signals component that uses a TLS connection can be configured so that it is possible to define which 
certificates are trusted.  An example of such a configuration is visible below.
```json
{
  "tls": {
    "trusted_certs": "-----BEGIN CERTIFICATE-----\n....\n-----END CERTIFICATE-----\n"
  }
}
```

The above configuration defines trusted CA certificates which are present in the field `trusted_certs` encoded with the usage of
[PEM format](https://www.rfc-editor.org/rfc/rfc7468). It is possible to place multiple certificates in `trusted_certs`. This means that it 
might be necessary to repeat such verbose configuration multiple times in many various Signals components when for example the system 
administrator wants to add another trusted certificate to the configuration. Therefore, updates of such configurations can be challenging.

To simplify trust store management Search Guard offers a REST API which can be used for trust stores management. The trust stores are created
via the REST API and then referenced by id in the TLS configuration like in the below example
```json
{
  "tls": {
    "truststore_id": "private-pki-truststore"
  }
}
```

The trust store can be modified with the REST API and all Signals components which referenced the trust store by id will start using the newer configuration
on the fly.

It is worth mentioning that the configuration options `trusted_certs` and `truststore_id` are mutually exclusive.

## Trust store management

The following REST API is defined to perform CRUD (create, read, update, delete) operations on the trust stores.
* [Get one trust store](./rest_api_trust_store_get_one.md)
* [Get all trust stores](./rest_api_trust_store_get_all.md)
* [Create or replace trust store](./rest_api_trust_store_create_or_replace.md)
* [Delete truststore](./rest_api_trust_store_delete.md)
 
## TLS session timeout
To increase performance Java is able to reuse a single TLS session multiple times in some circumstances. If an existing TLS session is reused
then the check if certificates are trusted is omitted. The certificates must be trusted when the TLS session is established. Therefore,
modifications of trust stores performed by REST API might not be immediately reflected because some Signals components might reuse existing
TLS sessions. If this behaviour is not desired, it is possible to provide a session timeout in the TLS configuration, so that the TLS
session will be not reused after the defined timeout. The TLS timeout may be set with the
parameter `client_session_timeout` is used. The parameter value is expressed in seconds. When the value of `client_session_timeout` is
set to `0` then the TLS session timeout is infinite. The below TLS configuration contains a TLS session timeout set to 1 second.
Therefore, all operations performed on trust stored via REST API should be reflected almost immediately in the Signals components.

```json
{
  "tls": {
    "truststore_id": "iot-truststore",
    "client_session_timeout": 1
  }
}
```
For more information please see 
[the documentation](https://docs.oracle.com/javase/8/docs/api/javax/net/ssl/SSLSessionContext.html#setSessionTimeout-int-).

## Example
The following watch uses trust stores in the [HTTP Input](elasticsearch-alerting-inputs-http) and 
[Webhook action](elasticsearch-alerting-actions-webhook) configuration.
```json
{
  "severity": {
    "value": "data.maxtmp.temperature",
    "order": "ascending",
    "mapping": [
      {
        "threshold": 20,
        "level": "warning"
      },
      {
        "threshold": 23,
        "level": "error"
      },
      {
        "threshold": 26,
        "level": "critical"
      }
    ]
  },
  "checks": [
    {
      "type": "static",
      "name": "constants used in watch definition",
      "target": "constants",
      "value": {
        "device_id": 444,
        "time_range": "5s",
        "temperature_threshold": 20
      }
    },
    {
      "type": "http",
      "name": "httptemp",
      "target": "maxtmp",
      "request": {
        "url": "https://localhost:8999/current-temperature",
        "method": "GET"
      },



      "tls": {
        "truststore_id": "iot-truststore",
        "client_session_timeout" : 1
      }



    },
    {
      "type": "condition",
      "name": "too high temperature",
      "source": "data.maxtmp.temperature > data.constants.temperature_threshold"
    }
  ],
  "trigger": {
    "schedule": {
      "interval": [
        "1s"
      ]
    }
  },
  "actions": [
    {
      "type": "webhook",
      "name": "http-via-tls",


      "tls": {
        "truststore_id": "iot-truststore",
        "client_session_timeout" : 1
      },


      "severity": [
        "critical"
      ],
      "throttle_period": "1s",
      "request": {
        "method": "POST",
        "url": "https://localhost:8999/temperature_limit_exceeded",
        "body": "{\"time\": \"{{execution_time}}\", \"value\":{{data.maxtmp.temperature}}},\"device_id\":{{data.constants.device_id}}",
        "headers": {
          "Content-Type": "application/json"
        }
      }
    }
  ]
}
```
