---
title: Alerting Glossary
html_title: Alerting Glossary
permalink: alerting-glossary
layout: docs
section: alerting
edition: community
description: Technical glossary of key alerting terms and concepts in Signals
---

# Alerting Glossary

This glossary provides definitions of key technical terms and concepts used throughout the Signals Alerting documentation.

## A

**Account**
: A configured destination for notifications, such as an email server, Slack workspace, or PagerDuty service. Accounts are defined once and can be reused across multiple watches.

**Acknowledge**
: The process of marking a watch as acknowledged to suppress action execution until conditions change. Acknowledged watches continue to run but do not execute actions.

**Action**
: An operation executed when a watch's conditions are met, such as sending an email, posting to Slack, or indexing data.

**Active Watch**
: A watch that is currently scheduled and executing according to its trigger configuration.

**Aggregation**
: An Elasticsearch feature that summarizes data, often used in watches to calculate metrics like counts, averages, or percentiles.

## C

**Check**
: A combination of inputs, conditions, and transformations that analyze data and determine whether actions should be executed.

**Condition**
: A script or expression that evaluates data gathered by inputs to determine whether the watch should proceed with executing actions.

**Cron Schedule**
: A time-based trigger that uses cron syntax to specify when a watch should execute.

## D

**Data Source**
: A system from which a watch retrieves data, such as an Elasticsearch index, HTTP endpoint, or static values.

**Daily Schedule**
: A trigger that executes a watch at specific times each day.

## E

**Execution**
: A single run of a watch, triggered by its schedule, that evaluates conditions and potentially executes actions.

**Execution Context**
: The runtime environment containing all data gathered during watch execution, accessible to conditions, transformations, and actions.

## H

**HTTP Input**
: An input type that retrieves data from an HTTP endpoint using GET, POST, or other HTTP methods.

**Hourly Schedule**
: A trigger that executes a watch at specific minutes within each hour.

## I

**Input**
: A component that gathers data from external sources and makes it available to the watch's runtime data.

**Interval Schedule**
: A trigger that executes a watch at regular time intervals, such as every 5 minutes or every hour.

## J

**Jira Action**
: An action that creates or updates Jira issues when watch conditions are met.

## M

**Monthly Schedule**
: A trigger that executes a watch on specific days of the month at specified times.

**Mustache Template**
: A template syntax used in actions to dynamically insert runtime data into messages, using `{{variable}}` notation.

## P

**PagerDuty Action**
: An action that creates incidents in PagerDuty when watch conditions are met.

**Painless Script**
: The scripting language used in Signals for conditions and transformations, providing secure sandboxed execution.

## R

**Resolve Action**
: An action executed when a watch's severity decreases from a previously elevated level, indicating that a problem has been resolved.

**Runtime Data**
: The hierarchical data structure containing all information gathered during watch execution, accessible to scripts and templates.

## S

**Schedule**
: The trigger configuration that determines when and how often a watch executes.

**Search Input**
: An input that executes an Elasticsearch query and makes the results available to the watch.

**Severity**
: A classification of watch results into levels (info, warning, error, critical) based on configured thresholds.

**Severity Mapping**
: Configuration that maps numeric values from watch data to severity levels.

**Signals**
: The name of Search Guard's alerting and monitoring feature.

**Slack Action**
: An action that sends messages to Slack channels or users when watch conditions are met.

**Static Input**
: An input that provides fixed values to the watch runtime data, useful for constants and configuration.

**State**
: The current status of a watch, such as active, acknowledged, or error.

## T

**Target**
: The destination location in runtime data where an input stores its results.

**Template**
: A Mustache template used to format output in actions, allowing dynamic content generation.

**Throttle Period**
: A time duration during which action execution is suppressed after the action has been executed once, preventing excessive notifications.

**Transform**
: A component that modifies or processes data in the runtime context, often used to prepare data for conditions or actions.

**Trigger**
: The configuration that determines when a watch executes, such as a schedule or webhook event.

## W

**Watch**
: A complete alerting configuration including triggers, checks, and actions that monitors data and responds to conditions.

**Watch Execution**
: The process of running a watch, including gathering data, evaluating conditions, and executing actions.

**Watch Log**
: The index where Signals stores execution history, including timestamps, results, and action outcomes.

**Watch State**
: The persistent information about a watch's current condition, including severity level and last execution time.

**Webhook Action**
: An action that makes HTTP requests to external endpoints when watch conditions are met.

**Weekly Schedule**
: A trigger that executes a watch on specific days of the week at specified times.
