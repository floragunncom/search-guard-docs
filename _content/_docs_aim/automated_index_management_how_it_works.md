---
title: How Automated Index Management Works
html_title: How Automated Index Management Works
permalink: how-automated-index-management-works
layout: docs
edition: community
description: How Automated Index Management works
---
<!--- Copyright 2023 floragunn GmbH -->

{% include beta_warning.html %}

# How Automated Index Management Works
{: .no_toc}

{% include toc.md %}

Automated Index Management can be used to create policies that perform management operations on indices automatically based on index stats.

A policy acts as a template that describes the lifecycle of one, or multiple, indices.
Once an index with a policy assigned is created, AIM internally creates a *policy instance* with a corresponding *state* for this index.
The state can now be retrieved using the [state API](automated-index-management-rest-policy-instance-state).

If not otherwise configured (see `execution.default.schedule` in the [settings](automated-index-management-settings) section), AIM automatically checks every 5 minutes for each managed index if one condition of the current step is met.
If one condition is met all actions of the current *step* get executed in their defined order and the next step is entered.

## Technical Preview Version Download

The Technical Preview version is available [here](https://maven.search-guard.com//search-guard-flx-release/com/floragunn/search-guard-flx-elasticsearch-plugin/aim-tp-4-es-8.18.0/)

## Building Blocks of a Policy

- `schedule` (optional) add a schedule to define how and when policy instances of this policy get triggered. If this is not set the default schedule is used.
- `steps` define a set of *actions* and *conditions* that should be executed. Every *step* must contain at least one *condition* or *action*
  - `name` which represents the step. Every step must have a policy wide unique name
  - `schedule` (optional) overrides the policy (or default) schedule for this step
  - `conditions` analyzing the status of the index that should be checked once the *step* is triggered
  - `actions` that should be executed sequentially once at least one *condition* is met

## Assigning a Policy

A Policy is assigned to an index on index creation in the index settings.
It is recommended to use index or component templates in combination with AIM.

```
PUT /_index_template/my-index-template
{
  "index_patterns": [
    "my-index*"
  ],
  "template": {
    "settings": {
      "index.aim.policy_name": "my-policy"
    }
  }
}
```

### Assigning a Policy with rollover action

If the policy also uses the rollover action, a write alias has to be configured.

```
PUT /_index_template/my-rolling-index-template
{
  "index_patterns": [
    "my-rolling-index*"
  ],
  "template": {
    "settings": {
      "index.aim.policy_name": "my-rollover-policy",
      "index.aim.alias_mapping": {
        "rollover_alias": "my-write-alias"
      }
    }
  }
}
```

Once the template is set up an index with a write alias using this template can be created.

```
PUT /my-rolling-index-000001
{
  "aliases": {
    "my-write-alias": {
      "is_write_index": true
    }
  }
}
```
