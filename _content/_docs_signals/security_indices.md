---
title: Signals Indices
html_title: How sensitive data in the Signals indices are used
slug: elasticsearch-alerting-security-indices
category: security
order: 50
layout: docs
edition: community
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Signals Indices
{: .no_toc}

{% include toc.md %}

The Signals configuration index, as the Search Guard configuration index, may contain sensitive data.

Access to the Signals configuration index is thus protected. In particular, you cannot access the index data directly by any of the Elasticsearch APIs.

To access and change configuration data, use the [Signals REST API](rest_api.md).

Alternatively, direct access is possible by using an [Admin Certificate](configuring-tls#configuring-admin-certificates). An admin certificate will bypass any Search Guard or Signals access control checks and thus gives you full access to the cluster.