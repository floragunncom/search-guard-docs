---
title: TLS Reload
html_title: TLS Reload
slug: sgadmin-tls-reload
category: sgadmin
order: 350
layout: docs
edition: community
description: How to use sgadmin to reload TLS certificates on a running Elasticsearch cluster
---
<!---
Copyright 2020 floragunn GmbH
-->

# TLS reload
{: .no_toc}

{% include toc.md %}

The sgadmin tool can be used to trigger a reload of the TLS certificates on a running cluster. You can use this feature to change certificates, including the root CA without the need for a cluster restart.

Please read the TLS reload instruction guide before changing the certificates on a production Elasticsearch cluster
{: .note .js-note note-info}

| Name | Description |
|---|---|
| -rlhttpcerts,--reload-http-certs  | Trigger a reload of the certificates on the HTTP layer |
| -rltransportcerts,--reload-transport-cert  | Trigger a reload of the certificates on the HTTP layer |
{: .config-table}

