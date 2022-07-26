---
title: Signals Indices
html_title: Alerting Indices
permalink: elasticsearch-alerting-security-indices
category: security
order: 50
layout: docs
edition: community
description: How Signals for Elasticsearch uses a protected confguration index to protect sensitive data
---

<!--- Copyright 2020 floragunn GmbH -->

# Signals Indices
{: .no_toc}

The Signals configuration index, as the Search Guard configuration index, may contain sensitive data.

Access to the Signals configuration index is thus protected. In particular, you cannot access the index data directly by any of the Elasticsearch APIs.

To access and change configuration data, use the [Signals REST API](rest_api.md).

Alternatively, direct access is possible by using an [Admin Certificate](configuring-tls#configuring-admin-certificates). An admin certificate will bypass any Search Guard or Signals access control checks and thus gives you full access to the cluster.