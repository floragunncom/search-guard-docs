---
title: Index Management Glossary
html_title: Index Management Glossary
permalink: index-management-glossary
layout: docs
section: index_management
edition: community
description: Technical glossary of key index management terms and concepts in AIM
---

# Index Management Glossary

This glossary provides definitions of key technical terms and concepts used throughout the Automated Index Management (AIM) documentation.

## A

**Action**
: An operation performed on an index when a step's conditions are met, such as closing, deleting, or changing allocation settings.

**Age Condition**
: A condition that triggers based on how long ago an index was created or rolled over.

**AIM**
: Automated Index Management - Search Guard's feature for lifecycle management of indices.

**Alias**
: An alternate name for one or more indices, used in rollover operations and index management.

**Allocation Action**
: An action that changes where index shards are allocated within the cluster based on node attributes.

## C

**Close Action**
: An action that closes an index, making it unavailable for read or write operations while preserving data on disk.

**Condition**
: A rule that determines when a step's actions should be executed, based on index properties like age, size, or document count.

## D

**Delete Action**
: An action that permanently removes an index and all its data from the cluster.

**Doc Count Condition**
: A condition that triggers based on the number of documents in an index.

## E

**Execution Delay**
: The time period AIM waits before evaluating policies after startup or configuration changes.

## F

**Force Merge Action**
: An action that merges index segments to reduce their number, improving search performance and reducing storage.

## I

**Index Count Condition**
: A condition that triggers when the number of indices associated with an alias exceeds a threshold.

**Index Priority**
: A setting that determines the order in which indices are recovered after cluster restarts.

**Instance**
: A specific index being managed by a policy, including its current state and step.

## M

**Managed Index**
: An index that has a policy assigned and is being monitored by AIM.

## P

**Policy**
: A complete lifecycle management configuration consisting of steps, conditions, and actions for managing indices.

**Policy Instance**
: The association between a policy and a specific index, including execution state and history.

**Priority Action**
: An action that sets the recovery priority for an index.

## R

**Read-Only Action**
: An action that makes an index read-only, preventing write operations while allowing reads.

**Replica Count Action**
: An action that changes the number of replica shards for an index.

**Rollover Action**
: An action that creates a new index and redirects writes when conditions are met, commonly used with time-series data.

**Rollover Alias**
: An alias used in rollover operations that points to the active index for writes.

## S

**Segment**
: A Lucene index component; force merge reduces the number of segments to improve performance.

**Set Priority Action**
: An action that configures the index recovery priority.

**Set Read-Only Action**
: An action that changes an index to read-only mode.

**Set Replica Count Action**
: An action that modifies the number of index replicas.

**Size Condition**
: A condition that triggers based on the total storage size of an index.

**Snapshot Action**
: An action that creates a backup snapshot of an index.

**Step**
: A stage in a policy lifecycle containing conditions and actions to be executed.

**State**
: The current execution status of a policy instance on an index.

## T

**Transition**
: The movement of an index from one policy step to another when conditions are met.

## W

**Write Index**
: In a rollover scenario, the index currently receiving write operations.
