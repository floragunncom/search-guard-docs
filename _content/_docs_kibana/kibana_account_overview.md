---
title: Account overview
slug: kibana-account-overview
category: kibana
order: 150
layout: docs
edition: community
description: How to enable the account overview page in Kibana.
---

<!---
Copyright 2019 floragunn GmbH
-->

# Account overview page
{: .no_toc}

Search Guard can display an optional account overview page in Kibana, which lists:

* username
* backend roles
* Search Guard roles

Activate the account overview page in `kibana.yml` like:

```
searchguard.accountinfo.enabled: true
```