---
title: TLS Tool 1.2
permalink: changelog-tlstool_1_2
category: changelogs-tlstool
order: 800
layout: changelogs
description: Changelog for the Search Guard TLS Tool 1.2
---

<!---
Copyright 2020 floragunn GmbH
-->

# Search Guard TLS Tool 1.2

**Release Date: 24.04.2018**

## Fixes

* Fixes issues with configs without intermediate cert
  * Always load the configured root certificate into ctx.rootCaFile
  * Do not add root cert to PEM file of generated certificates for nodes
and clients
