---
title: TLS Reload
html_title: TLS Reload
permalink: sgctl-tls-reload
category: sgctl
order: 350
layout: docs
edition: community
description: How to use sgctl to reload TLS certificates on a running Elasticsearch cluster
---
<!---
Copyright 2020 floragunn GmbH
-->

# TLS reload
{: .no_toc}

The sgctl tool can be used to trigger a reload of the TLS certificates on a running cluster. You can use this feature to change certificates, including the root CA without the need for a cluster restart.

Please read the [TLS reload instruction guide](../_docs_tls/tls_hot_reload.md) before changing the certificates on a production Elasticsearch cluster
{: .note .js-note note-info}

Trigger a reload of the certificates on the HTTP layer
`./sgctl.sh rest POST /_searchguard/api/ssl/http/reloadcerts`

Trigger a reload of the certificates on the transport layer
`./sgctl.sh rest POST /_searchguard/api/ssl/transport/reloadcerts`


