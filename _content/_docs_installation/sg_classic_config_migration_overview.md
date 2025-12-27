---
title: Migrating to FLX
html_title: Migrating from older Search Guard versions to FLX
permalink: sg-classic-config-migration-overview
layout: docs
section: security
edition: community
description: How to migrate older Search Guard authentication configurations
---
<!---
Copyright 2022 floragunn GmbH
-->

# Migrating from Search Guard 53 and before to Search Guard FLX
{: .no_toc}

If you have an existing cluster running Search Guard 53 or earlier, you need to migrate your configuration. 

The easiest way to do so is to use the `sgctl` command which can automatically convert most configurations. We provide you the necessary instructions to perform the update in the following sections:

**[Quick Start](sg-classic-config-migration-quick):** If you want to quickly shoot up a new test cluster using a migrated configuration, follow this guide.

**[Production Cluster](sg-classic-config-migration-prod):** If you are running a production cluster and must achieve a migration without an outage, you have to follow a specific update sequence. 


## Advanced Topics

For some advanced configurations, automatic conversion might be not available. 

**[Feature Map](config-migration-feature-map):** For reference, we provide you an overview which describes how the classic authentication features map to the new authentication features.

