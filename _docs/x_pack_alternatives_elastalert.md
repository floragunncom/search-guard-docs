---
title: ElastAlert
slug: search-guard-elastalert
category: x-pack-alternatives
order: 100
layout: docs
description: How to configure and use Search Guard and ElastAlert for Elasticsearch as an alternative to X-Pack.
---
<!---
Copryight 2017 floragunn GmbH
-->
# Using Search Guard with ElastAlert

As an alternative to X-Pack Alerting, we recommend ElastAlert.

ElastAlert, under active development by Yelp

> is a simple framework for alerting on anomalies, spikes, or other patterns of interest from data in Elasticsearch. ElastAlert works with all versions of Elasticsearch. [...] It works by combining Elasticsearch with two types of components, rule types and alerts. Elasticsearch is periodically queried and the data is passed to the rule type, which determines when a match is found. When a match occurs, it is given to one or more alerts, which take action based on the match.

([https://github.com/Yelp/elastalert](https://github.com/Yelp/elastalert){:target="_blank"})

It's completely free, Open Source, compatible with Search Guard, and a perfect alternative to X-Pack Alerting.

In the following description, we assume that you have already installed Elasticsearch and Search Guard.

## Installing ElastAlert

ElastAlert is a Python application and is platform independant. For an in-depth description on installing and configuring ElastAlert, please follow the official [documentation](http://elastalert.readthedocs.io/en/latest/index.html){:target="_blank"}. In this document, we mainly show how to configure ElastAlert for Search Guard.

### Requirements

* Elasticsearch
* ISO8601 or Unix timestamped data
* Python 2.7
* pip, see requirements.txt
* Packages on Ubuntu 14.x: python-pip python-dev libffi-dev libssl-dev

### Installation

To install ElastAlert, simply run

```bash
$ pip install elastalert
```

Depending on the version of Elasticsearch, you may need to manually install the correct version of elasticsearch-py.

Elasticsearch 5.0+:

```bash
$ pip install "elasticsearch>=5.0.0"
```

## Configuring ElastAlert for Search Guard

All configuration options for ElastAlert reside in `config.yaml`. You can find a sample [configuration file](https://github.com/Yelp/elastalert/blob/master/config.yaml.example){:target="_blank"} in the official [ElastAlert repository](https://github.com/Yelp/elastalert/){:target="_blank"} for a quick start. 

The Search Guard relevant configuration settings are as follows:

```yaml
es_host: elastic.example.com
es_port: 9200
use_ssl: True
verify_certs: True
ca_certs: '/path/to/chain.pem'
es_username: elastalert
es_password: elastalert
writeback_index: elastalert_status
```

| Name | Description |
|---|---|
|es_host| String, Hostname of your Elasticsearch node |
|es_port| String, HTTP(S) port of your Elasticsearch node |
|use_ssl| Boolean, if set to true, ElastAlert will connect via HTTPS, if set to false HTTP is used |
|verify_certs| Boolean, whether to verify the certificate used by Elasticsearch/Search Guard or not. If you use self-signed certificates, you need to either set this to false, or configure the Root CA via the `ca_certs` configuration key. If certificate validation is disabled and self-signed certificates are used, you will see several warning messages in the ElastALert logs. |
|ca_certs| String, path to the Root certificate (and intermediate certificates if any) in PEM format. If verify_certs is set to true, and you use self-sgned certificates, this entry is mandatory.|
|es_username| String, the username that ElastAlert uses when connecting to Elasticsearch |
|es_password| String, the password that ElastAlert uses when connecting to Elasticsearch |
|writeback_index| String, the name of the index in which ElastAlert will store data |

If you're working with self-signed certificates, we recommend to provide ElastAlert with the certificate chain containing the root certificate and all intermediate certificates. You can extract this certificate chain from a `truststore.jks` by using the `keytool` command:

```
keytool -list -keystore truststore.jks -rfc > chain.pem
```

## Configuring the ElastAlert user

ElastAlert connects to Elasticsearch on the REST layer, and provides the configured `es_username` and `es_password` as `HTTP Basic Authentication` header. If this user does not exist in your Search Guard setup, add it.

The required permissions of this user depend on the indices you want to run your alerts on. As a rule of thumb:

* The ElastAlert user needs full permissions on the configured `writeback_index` index. This is where ElastAlert will store its data.
* The ElastAlert user needs at least READ permissions on the indices against which the rules and alerts should be executed

For example, if you collect audit events with the [Search Guard audit log](auditlogging.md) module in an index called `auditlog`, and your `writeback_index` is called `elastalert_status`, the corresponding role definition looks like:

```yaml
sg_elastalert:
  cluster:
    - CLUSTER_COMPOSITE_OPS_RO
    - "indices:data/write/bulk"
  indices:
    'auditlog':
      '*':
        - READ
    'elastalert_status':
      '*':
        - '*'
```

## Create the ElastAlert index

Next we set up the `writeback_index` index and the corresponding mapping. ElastAlert can do that automatically for you: 

```
elastalert-create-index
```

## Testing the connection settings

Now we can test if the connection to Elasticsearch works by simply starting ElastAlert:

```
elastalert
```

If you configured everything correctly, ElastAlert should start up without errors.

## Rules and Multi-Cluster monitoring

Rules are what actually powers ElastAlert:

> Each rule defines a query to perform, parameters on what triggers a match, and a list of alerts to fire for each match.

[Source: ElastAlert Documentation](http://elastalert.readthedocs.io/en/latest/running_elastalert.html#creating-a-rule)

Each rule can be executed against a different cluster if necessary, so it's possible to monitor several clusters at once, and collect the results in one central cluster.

Each rule is defined in it's own file, and all rules files are placed in the rules folder configured in `config.yaml`:

```
rules_folder: rules 
```

Each rule can overwrite any setting in `config.yaml`, including connection settings like `es_host` and `es_port`. 

Changes in the rules folder are detected automatically, so you can add, remove and change any rule in real time.

You can read more about how to set up rules and alerts in the [ElastAlert documentation](http://elastalert.readthedocs.io/en/latest/running_elastalert.html#creating-a-rule). 

## Alerts

Each rule can have one or more alerts attached to it. They define where the actual alerts are shipped to. ElastAlert supports a wide range of endpoints, for example:

* Email
* PagerDuty
* Slack
* JIRA
* MS Teams
* RabbitMQ / ActiveMQ
* ...

And of course you can execute an [arbitrary command](http://elastalert.readthedocs.io/en/latest/ruletypes.html#command), or [provide your own implementation](http://elastalert.readthedocs.io/en/latest/recipes/adding_alerts.html){:target="_blank"}.

## Sample rule

The following sample rule will query for FAILED_LOGIN events in the Search Guard audit log cluster, and will output a message when more than 5 attempts within the last minute are detected.

```yaml
name: Monitor Login Attempts
type: frequency
index: auditlog
num_events: 5
timeframe:
    minutes: 1
filter:
- query:
    query_string:
      query: "audit_category: FAILED_LOGIN"
timestamp_field: "audit_utc_timestamp"
alert:
- "debug"
```

## Testing rules

You can test your rules without actually firing an alert by executing:

```
elastalert-test-rule rules/bute_force_login.yaml
```
