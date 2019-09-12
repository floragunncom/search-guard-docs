---
title: Conditions
html_title: Creating Conditions for Signals Alerting
slug: elasticsearch-alerting-conditions
category: signals
subcategory: conditions
order: 600
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Conditions
{: .no_toc}

{% include toc.md %}

Conditions are used to control the execution flow. A condition can be used anywhere in the execution chain for watches and actions. 

A condition must return a boolean value. If the condition returns true, the execution continues. If the condition returns false, the execution is stopped.

In watches, a condition controls whether a certain value or threshold is reached, to decide whether the watch should continue execution.

In actions, conditions can be used to control if a certain action should be executed. For example, you can decide to send an email to an administrator if the error level in  your log files is too high. In addition, if the error level stays high for a certain amount of time, you can send another email, escalating the issue to another person. 

Currently, the following condition types are supported

* [condition.script](conditions_script.md)
  * a condition that uses a Painless script 