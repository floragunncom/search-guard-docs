---
title: Handling Timezones
html_title: Timezones
permalink: elasticsearch-alerting-triggers-timezones
category: triggers
order: 200
layout: docs
edition: community
description: Signals Alerting for Elasticsearch supports different timezones for triggers that control when a watch is executed.
---

<!--- Copyright 2020 floragunn GmbH -->

# Handling Timezones for Alerting triggers
{: .no_toc}

Signals supports different [time zones](triggers_timezones.md). If no time zone is specified, the default JVM time zone is used.

You can specify the timezone of each trigger by adding a `timezone` ID  to the schedule of a trigger:

```json
{
    "trigger":
    {
        "schedule":
        {
            "timezone": "Europe/Berlin",
            "weekly":[ {"on":["monday","wednesday"], "at":["12:00","18:00"]} ]
        }
    },
}
```

A timezone ID can be either something like "Europe/Berlin" or "UTC+01:00". For details on timezone IDs, refer to the [JavaDocs on timezones](https://docs.oracle.com/javase/8/docs/api/java/time/ZoneId.html).
