---
title: TLS Tool 1.1
permalink: changelog-tlstool_1_1
category: changelogs-tlstool
order: 900
layout: changelogs
description: Changelog for the Search Guard TLS Tool 1.1
---

<!---
Copyright 2020 floragunn GmbH
-->

# Search Guard TLS Tool 1.1

**Release Date: 25.02.2018**

## Fixes

* Extension requests were not linked to generated CSRs
* Do not write nodes_dn if an oid is present
* add "verify" and "resolve_hostnames" to generated config
* Fixed TLS Diagnose: Subject and Issuer DN is the same
* Fixed wrong pemtrustedcas_filepath when transport certs were reused as HTTP certs
