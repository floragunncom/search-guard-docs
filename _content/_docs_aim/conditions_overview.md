---
title: Conditions Overview
html_title: Conditions Overview
slug: automated-index-management-conditions
category: aim-conditions
order: 0
layout: docs
edition: community
description: Using Automated Index Management Conditions
---

<!--- Copyright 2020 floragunn GmbH -->

# Conditions Overview
{: .no_toc}

{% include toc.md %}

Conditions define under what circumstances the state should be entered and actions executed. Conditions get executed sequentially and are connected by a logical 'or'. This means only one of the specified conditions must be met to enter the state.

|Condition name|Description|Internal|
|-|-|-|
|[age](conditions_age.md)|Returns true if the index age is greater than the given time value|no|
|[doc_count](conditions_doc_count.md)|Returns true if the number of docs in the index is greater than the given number|no|
|[size](conditions_size.md)|Returns true if the total size of the index is greater than the given size value|no|
|force_merge_done|Returns true if the force merge action is done|yes|
|snapshot_done|Returns true if the snapshot action is done|yes|
