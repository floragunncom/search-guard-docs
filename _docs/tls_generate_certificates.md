---
title: Generating Certificates
slug: generating-tls-certificates
category: tls
subcategory: generating-certificates
order: 100
layout: docs
edition: community
description: Various options for generating TLS certificates that you can use with Search Guard.
resources:
  - https://search-guard.com/generating-certificates-tls-tool/|Generating production-ready certificates with the TLS tool (blog post)
  - https://search-guard.com/elasticsearch-searchguard-tls-introduction/|An introduction to TLS (blog post)
  - https://search-guard.com/elasticsearch-tls-certificates/|An introduction to TLS certificates (blog post)

---
<!---
Copyright 2017 floragunn GmbH
-->

# Generating TLS certificates
{: .no_toc}

Search Guard relies heavily on the use of TLS, both for the REST and the transport layer of Elasticsearch. While TLS on the REST layer is optional (but recommended), TLS on the transport layer is mandatory.

By using TLS:

* You can be sure that nobody is spying on the traffic.
* You can be sure that nobody tampered with the traffic.
* Only trusted nodes can join your cluster.

Search Guard also supports OpenSSL for improved performance and modern cipher suites.

The first step after installing Search Guard is to generate the necessary TLS certificates and to configure them on each node in the `elasticsearch.yml` configuration file.

Note that each change to this file requires a node restart.

For generating certificates you have the following options:

* Use the [Search Guard demo installation script](tls_generate_installation_script.md)  (not safe for production)
* Download the [Search Guard demo certificates](tls_download_certificates.md) (not safe for production)
* Use the [Online TLS generator service](tls_generate_online.md) (not safe for production)
* Use the [Offline TLS Tool](tls_generate_tlstool.md) (safe for production)
* Use and customize the [example PKI scripts](tls_generate_example_scripts.md) (safe for production)
* Create a CSR and send it to your existing PKI infrastructure, if any (safe for production)
* Using tools like OpenSSL and/or keytool (safe for production)

If you have your own PKI infrastructure and are already familiar with TLS certificates, you can jump directly to [TLS certificates for production environments](tls_certificates_production.md).
