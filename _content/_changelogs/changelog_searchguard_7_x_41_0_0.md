---
title: Search Guard 7.x-41.0.0
slug: changelog-searchguard-7.x-41_0_0
category: changelogs-searchguard
order: 600
layout: changelogs
description: Changelog for Search Guard 7.x-41.0.0
---

<!--- Copyright 2020 floragunn GmbH -->

# Search Guard 7.x-41.0.0

**Release Date: 11.05.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Security Fixes 

* Update Jackson Databind
  * Jackson reports a [security vulnerability](https://github.com/FasterXML/jackson-databind/issues/2653) which affects jackson-databind-2.8.11.1
  * Search Guard is not affected by this vulnerability:
    * No direct input from untrusted sources
    * No polymorphic type deserialisation
    * not use of "gadget types" in JSON POJOs
  * Jackson has been upgraded nonetheless in Search Guard and the TLS Tool

## Features

* JWT: Support for nested keys
  * Makes it possible to extract username and roles from a nested JSPON structure

* Introduce "skip_users" for all authenticators and authorizers
  * Makes it possible to skip certain users globally when performing authc/authz

* Block users on a global level
  * Makes it possible to block user accounts on a global level

* IP filtering
  * Makes it possible to block IPs and hostnames on a global level  