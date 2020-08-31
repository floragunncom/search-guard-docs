---
title: Scripting
html_title: Scripting in Signals Alerting
slug: signals-alerting-scripting
category: signals
order: 710
layout: docs
edition: community
description: 
---

<!--- Copyright 2020 floragunn GmbH -->

# Scripting in Signals
{: .no_toc}

{% include toc.md %}

## Basics

Scripts are used in many parts of Signals. Examples are [conditions](conditions.md), [transformations](transformations.md), [severity mappings](severity.md). These scripts are typically implemented using the Painless language. Mustache templates which are used for generating text content, for example in [e-mail actions](actions_email.md), are technically speaking also scripts and share the same runtime environment.

Stored scripts are not supported by Signals because the owner semantics of stored scripts don't integrate well with the owner semantics of Signals watches.

## Supported Scripting Languages

Elasticsearch comes out of the box with support for the scripting languages Painless and Mustache. You can get support for more scripting languages using [Elasticsearch plugins](https://www.elastic.co/guide/en/elasticsearch/reference/master/modules-scripting-engine.html).

In many cases, Signals allows using the `lang` attribute to choose the language to be used. Examples are [conditions](conditions.md) and [transformations](transformations_overview.md). In some cases, however, changing the language is not supported. This includes text templates in actions such as email or slack.

## Runtime Environment

All scripts share the same runtime environment. However, some attributes in these environments might be only available in certain situations or features.

To have a look at the actual attribute values during the execution of a watch, you can use the [Execute Watch REST API](rest_api_watch_execute.md) with `show_all_runtime_attributes` set to `true`. 

### `data` 

**Availability:** anywhere

**Writable:** yes

The `data` attribute is available in all scripts. Its structure is freely definable by the checks of a watch.

Checks defined inside an action can also modify this attribute. These modifications are however scoped to the single action. They won't become visible to other actions.

### `watch`

**Availability:** anywhere

**Writable:** no

The `watch` attribute contains some meta data about the watch which is currently executing. It has these attributes:

**watch.id:** The id of the currently executing watch. This does not include the tenant name.

**watch.tenant:** The name of the tenant the watch belongs to.

### `trigger`

**Availability:** anywhere, exempt are watches executed via the REST API

**Writable:** no

The `trigger` attribute contains information about the trigger schedule of the watch. It is thus only available if the watch was triggered via its schedule. 

The information in the `trigger` attribute is particularly useful for defining time windows for queries. For the time windows, the attributes `scheduled_time` and `previous_scheduled_time` should be preferred over `triggered_time`, as these allow the definition of precise, non-overlapping time windows.

The attributes of the `trigger`  attribute in detail:

**trigger.scheduled_time:** The time the watch was scheduled to be triggered at. Type: [JodaCompatibleZonedDateTime](https://www.elastic.co/guide/en/elasticsearch/painless/master/painless-api-reference-shared-org-elasticsearch-script.html#painless-api-reference-shared-JodaCompatibleZonedDateTime)

**trigger.triggered_time:** The time the watch was actually triggered. This will be slightly after `scheduled_time`. The difference might get larger if there are lots of long running watches for a tenant, which cause congestion in the thread pool. Type: [JodaCompatibleZonedDateTime](https://www.elastic.co/guide/en/elasticsearch/painless/master/painless-api-reference-shared-org-elasticsearch-script.html#painless-api-reference-shared-JodaCompatibleZonedDateTime)

**trigger.previous_scheduled_time:** The time the watch was scheduled to run before this run. Type: [JodaCompatibleZonedDateTime](https://www.elastic.co/guide/en/elasticsearch/painless/master/painless-api-reference-shared-org-elasticsearch-script.html#painless-api-reference-shared-JodaCompatibleZonedDateTime)

**trigger.next_scheduled_time:** The time the watch is scheduled to run at after this run. Type: [JodaCompatibleZonedDateTime](https://www.elastic.co/guide/en/elasticsearch/painless/master/painless-api-reference-shared-org-elasticsearch-script.html#painless-api-reference-shared-JodaCompatibleZonedDateTime)

### `severity`

**Availability:** In actions when a watch uses a severity mapping.

**Writable:** no

The `severity` attribute contains information about the current severity level of a watch. It is therefore only available after the severity level has been determined, i.e., only in actions and in the checks defined in these actions.

It has these attributes:

**severity.level.id:** The ID of the severity level. One of `none`, `info`, `warning`, `error`, `critical`. 

**severity.level.level:** An ordinal number identifying the severity level. The level `none` corresponds to `0`, the level `critical` to `4`.

**severity.level.name:** A human-readable name of the severity level.

**severity.value:** The value determined by the `value` expression configured in the severity mapping. This is always a number.

**severity.threshold:** The threshold that was passed by `value` so that the current severity level was reached.



### `execution_time`  

**Availability:** anywhere

**Writable:** no

The time the watch started executing. This is similar to `trigger.triggered_time`. However, `execution_time` is also set when watches are executed via API.

Type: [JodaCompatibleZonedDateTime](https://www.elastic.co/guide/en/elasticsearch/painless/master/painless-api-reference-shared-org-elasticsearch-script.html#painless-api-reference-shared-JodaCompatibleZonedDateTime)


### `resolved` 

**Availability:** Inside resolve actions

**Writable:** no

The `resolved` attribute is only available for resolve actions. It contains a snapshot of all the runtime data of the time when the watch entered the severity level which is not being resolved.

It has these attributes:

**resolved.data:** A snapshot of the `data` attribute at the time the watch entered the resolved severity level. See [data](#data) for details.

**resolved.trigger:** The trigger times when the watch entered the severity level which is now resolved. See  [trigger](#trigger) for details.

**resolved.severity:** A snapshot of the `severity` attribute at the time the watch entered the severity level which is now resolved. See [severity](#severity) for details.


### `item` 

**Availability:** Only inside actions with the `foreach` attribute.

**Writable:** yes

This is only relevant for the `foreach` functionality of actions, which allows the execution of the action for all the elements of a collection. In this case, the `item` attribute will be set to the element of the collection the action is executed for right now. 

Like the `data` attribute, checks defined inside the action can modify this attribute. These modifications are however scoped to the single action. They won't become visible to other actions.



