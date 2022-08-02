---
title: Overview
html_title: Migrating older SG authentication configuration
permalink: sg-classic-config-migration
category: kibana-authentication-migration-overview
order: 100
layout: docs
edition: community
description: How to migrate older Kibana authentication configurations to sg_frontend_config.yml
---
<!---
Copyright 2022 floragunn GmbH
-->

# Migrating from Search Guard 53 and before
{: .no_toc}

If you have an existing cluster running Search Guard 53 or earlier, you need to migrate your configuration. 

The easiest way to do so is to use the `sgctl` command which can automatically convert most configurations. We provide you the necessary instructions to perform the update in the following sections:

**[Quick Start](sg53_migration_quick.md):** If you want to quickly shoot up a new test cluster using a migrated configuration, follow this guide.

**[Production Cluster](sg53_migration_prod.md):** If you are running a production cluster and must achieve a migration without an outage, you have to follow a specific update sequence. 


## Advanced Topics

For some advanced configurations, automatic conversion might be not available. 

**[Feature Map](sg53_migration_feature_map.md):** For reference, we provide you an overview which describes how the classic authentication features map to the new authentication features.