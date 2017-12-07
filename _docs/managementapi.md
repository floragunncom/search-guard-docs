---
title: Access Control
slug: rest-api-access-control
category: restapi
order: 300
layout: docs
description: How to use a TLS admin certificate to access the Search Guard REST management API.
---
<!---
Copryight 2017 floragunn GmbH
-->

# REST management API

This module adds the capability of managing users, roles, roles mapping and action groups via a REST Api.

## Installation

Download the REST management API enterprise module from Maven Central:

[Maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-rest-api%22){:target="_blank"} 

and place it in the folder

* `<ES installation directory>/plugins/search-guard-2`

or

* `<ES installation directory>/plugins/search-guard-5`

if you are using Search Guard 5.

**Choose the module version matching your Elasticsearch version, and download the jar with dependencies.**

After that, restart all nodes to activate the module.

## Prerequisites

The Search Guard index can only be accessed with an admin certificate. This is the same certificate that you use when executing [sgadmin](sgadmin.md).

In order for Search Guard to pick up this certificate on the REST layer, you need to set the `clientauth_mode` in `elasticsearch.yml` to either `OPTIONAL` or `REQUIRE`:

```yaml
searchguard.ssl.http.clientauth_mode: OPTIONAL
```

If you plan to use the REST API via a browser, you will need to install the admin certificate in your browser. This varies from browser to browser, so please refer to the documentation of your browser-of-choice to learn how to do that. 

For curl, you need to specify the admin certificate with it's complete certificate chain, and also the key:

```bash
curl --insecure --cert chain.pem --key kirk.key.pem "<API Endpoint>"
```

If you use the example PKI scripts provided by Search Guard SSL, the `kirk.key.pem` is already generated for you. You can generate the chain file by `cat`ing the certificate and the ca chain file:

```bash
cd search-guard-sll
cat example-pki-scripts/kirk.crt.pem example-pki-scripts/ca/chain-ca.pem > chain.pem
```