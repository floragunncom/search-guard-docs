---
title: Curator
html_title: Using curator with Search Guard
slug: elasticsearch-curator-search-guard
category: elasticstack
order: 300
layout: docs
edition: community
description: How to configure and use curator with a Search Guard secured cluster.
---

<!---
Copyright floragunn GmbH
-->

# Using curator with Search Guard
{: .no_toc}

{% include toc.md %}

Search Guard is compatible with curator. Since curator is written in Python, depending on the Python version you are using you may experience some challenges with the SSL setup.

Please read the Elasticsearch documentation on [curator, Python and security](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/python-security.html){:target="_blank"}
{: .note .js-note .note-warning}

## Curator user

First set up a curator role and allow access to all indices that you want to manage via curator. For example, if you use logstash and want to manage your daily rolling logstash index a matching role might look like:

**sg\_roles.yml:**

```
sg_curator:
  cluster_permissions:
    - SGS_CLUSTER_MONITOR  
    - SGS_CLUSTER_COMPOSITE_OPS_RO
  index_permissions:
    - index_patterns:
      - 'logstash-*'
      allowed_actions:
        - SGS_UNLIMITED
```
        
If you use the Search Guard internal user database, set up a curator user.

**sg\_internal\_users.yml:**

```
curator:
  hash: $2y$12$Y7znAYZWqJBTJSrT8.iHreCyCVhRE5RQ4dKbbLKXtnutdTE2IP2n.
```

Last, map the `curator` user to the `sg_curator` Search Guard role:


**sg\_roles\_mapping.yml:**

```
sg_curator:
  users:
    - curator
```
## Setting up TLS/SSL

If you use `HTTPS` instead of `HTTP`, configure curator to use `HTTPS`:

```yml
client:
  hosts:
    - 127.0.0.1
  port: 9200
  use_ssl: True
  certificate: /path/to/root_CA
  ssl_no_validate: True
  ...
```

| Name | Description |
|---|---|
| use\_ssl | If set to True, curator will connect with HTTPS instead of HTTP |
| certificate | Absolute path to the root CA |
| ssl\_no\_validate | If set to True curator will not validate the certificate it receives from Elasticsearch. Enable this if you are using self-signed certificates. |


Setting ssl_no_validate to True will likely result in a warning message that your SSL certificates are not trusted. This is expected behavior.
{: .note .js-note .note-warning}

## HTTP Basic Authentication

In case you are using HTTP Basic Authentication, add the username and password like:

```yml
client:
  hosts:
    - 127.0.0.1
  port: 9200
  ...
  http_auth: "curator:curator"
  ...
```

You can also set the credentials via the command line: `curator_cli --http_auth 'user:pass' ...`
{: .note .js-note .green}

### Full example

```yml
client:
  hosts:
    - 127.0.0.1
  port: 9200
  url_prefix:
  use_ssl: True
  certificate: /etc/elasticsearch/config/root-ca.pem
  ssl_no_validate: True
  http_auth: curator:curator
  timeout: 30
  master_only: False
```

## Client Certificate Authentication

You can also use client certificates for authentication:

```yml
client:
  hosts:
    - 127.0.0.1
  port: 9200
  ...
  client_cert: /path/to/client_certificate
  client_key: /path/to/private_key
  ...
```

| Name | Description |
|---|---|
| client\_cert | Absolute path to the client TLS certificate that is sent with each request. |
| client_key | Absolute path to the private key of the client certificate. |

Curator only supports unencrypted private keys.
{: .note .js-note .note-warning}

If you use client certificates, you also need to set up a [client certificate authentication domain.](../_docs_auth_auth/auth_auth_clientcert.md){:target="_blank"}

### Full example

**Curator:**

```yaml
client:
  hosts:
    - 127.0.0.1
  port: 9200
  url_prefix:
  use_ssl: True
  certificate: /etc/elasticsearch/config/root-ca.pem
  client_cert: /etc/elasticsearch/config/spock.pem
  client_key: /etc/elasticsearch/config/spock-key.pem
  ssl_no_validate: True
  timeout: 30
  master_only: False

```

**sg_config.yml:**

```yaml
clientcert_auth_domain:
  enabled: true
  order: 1
  http_authenticator:
    type: clientcert
    config:
      username_attribute: cn
    challenge: false
  authentication_backend:
    type: noop
```