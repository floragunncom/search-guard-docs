---
title: Administration
html_title: Signals Alerting Administration
slug: elasticsearch-alerting-administration
category: signals
subcategory: administration
order: 1100
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Signals Administration
{: .no_toc}

{% include toc.md %}

This chapter describes the admin's point of view of a Signals installation.

## Configuration Options

The following configuration options can be made in the elasticsearch.yml configuration file. A restart of the respective node is necessary to bring these options into effect.

**signals.index_names.log:** Specifies the name of the watch log index. Optional, defaults to `<.signals_log_{now/d}>`.

**signals.enabled:** Can be used to enable or disable Signals on the respective node. Optional, boolean, defaults to true.

**signals.tenant.{tenant_name}.node_filter:** Can be used to restrict the nodes a tenant runs on. Optional. The value is a node filter as documented here: https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster.html

**Note:** Be careful to configure these options consistently for the whole cluster. Having inconsistent configuration across different nodes can cause watches not to be executed at all. Also it can happen that watches are executed multiple times.

