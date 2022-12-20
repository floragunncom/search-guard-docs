---
title: Search Guard 7.x-53.6.0
permalink: changelog-searchguard-7x-53_6_0
category: changelogs-searchguard
order: -460
layout: changelogs
description: Changelog for Search Guard 7.x-53.6.0
---

<!--- Copyright 2022 floragunn GmbH -->

# Search Guard Suite 53.6

**Release Date: 2022-12-19**

### Switch for disabling alias resolution

Search Guard by default resolves any index alias names to the concrete underlying index name. While this has the advantage that
real index names and index alias names are treated the same way, this can lead to performance problems on clusters with a lot of
indices and aliases.

This fix introduces a switch which makes it possible to disable index alias resolution. This improves performance at the
cost of losing the ability to specify aliases and date math in index patterns.

To disable alias resolution, add the following to sg_config.yml:

```yml
sg_config:
  dynamic:
    support_aliases_in_index_privileges: false
```

**Details:**

* [Search Guard Forum](https://forum.search-guard.com/t/high-cpu-usage-after-es-update-to-7-17-7/2387/6){:target="_blank"}

* [Commit](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/commit/cf31c473b64be352f54b6d6b0838e73a158a55e6){:target="_blank"}