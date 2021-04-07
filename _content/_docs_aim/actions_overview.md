---
title: Actions Overview
html_title: Actions Overview
slug: automated-index-management-actions
category: aim-actions
order: 0
layout: docs
edition: community
description: Using Automated Index Management Actions
---

<!--- Copyright 2020 floragunn GmbH -->

# Actions Overview
{: .no_toc}

{% include toc.md %}

Actions define what should happen to the index when executed. You can define multiple actions per state that are executed sequentially in the order you define them. The actions of a state get only executed if at least one condition of the same state is met.

## Available Actions

|Action name|Description|Async|
|-|-|-|
|[allocation](actions_allocation.md)|Sets the index allocation to a new configuration|no|
|[close](actions_close.md)|Closes the index|no|
|[delete](actions_delete.md)|Deletes the index|no|
|[force_merge](actions_force_merge.md)|Force merges index segments to a given number|yes|
|[rollover](actions_rollover.md)|Rolls the index over|no|
|[set_priority](actions_set_priority.md)|Sets the index priority to a given (numeric) value|no|
|[set_read_only](actions_set_read_only.md)|Sets the index read only|no|
|[set_replica_count](actions_set_replica_count.md)|Sets the replica count to a given number|no|
|[snapshot](actions_snapshot.md)|Creates a snapshot of the index|yes|

## Async Actions

Some of the actions featured by Automated Index Management are async. This means they are not executed in the main thread of Automated Index Management. Especially on tasks that potentially create a bigger workload like creating a snapshot this feature is useful since running them in sync would slow down the system.

In case you defined a async action in your policy a internal state containing a respective condition gets automatically created that waits for the action to finish before continuing on the policy instance. This mechanism guarantees that actions do not clash.

> **Note:** By default internal states are not visible using the policy GET API. To see the internal result of your policy use the GET Policy API with the `show_internal_states` parameter set to true.

### Examples

#### Single async action

If you define a policy with a single async action a internal state gets added internally automatically.

```JSON
{
    "states":[
        ...
        {
            "name":"warm",
            "conditions":{},
            "actions":{
                "snapshot":{
                    "snapshot_name":"my_snapshot",
                    "snapshot_repository":"my_repo"
                }
            }
        },
        ...
    ]
}
```

This policy would be automatically complemented by a internal state that holds a `snapshot_created` condition.

The internal result would look like this:

```JSON
{
    "states":[
        ...
        {
            "name":"warm",
            "conditions":{},
            "actions":{
                "snapshot":{
                    "snapshot_name":"my_snapshot",
                    "snapshot_repository":"my_repo"
                }
            }
        },
        {
            "name":"warm_0",
            "conditions":{
                "snapshot_created":{
                    "snapshot_name":"my_snapshot",
                    "snapshot_repository":"my_repo"
                }
            },
            "actions":{}
        },
        ...
    ]
}
```

#### Async action with actions following

If you have actions defined after a async action in the same state two additional internal state gets created.

```JSON
{
    "states":[
        ...
        {
            "name":"warm",
            "conditions":{},
            "actions":{
                "snapshot":{
                    "snapshot_name":"my_snapshot",
                    "snapshot_repository":"my_repo"
                },
                "close":{}
            }
        },
        ...
    ]
}
```

The internal result would look like this:

```JSON
{
    "states":[
        ...
        {
            "name":"warm",
            "conditions":{},
            "actions":{
                "snapshot":{
                    "snapshot_name":"my_snapshot",
                    "snapshot_repository":"my_repo"
                }
            }
        },
        {
            "name":"warm_0",
            "conditions":{
                "snapshot_created":{
                    "snapshot_name":"my_snapshot",
                    "snapshot_repository":"my_repo"
                }
            },
            "actions":{}
        },
        {
            "name":"warm_1",
            "conditions":{},
            "actions":{
                "close":{}
            }
        },
        ...
    ]
}
```
