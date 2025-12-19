---
title: Search Guard 7.x-41.0.0
permalink: changelog-searchguard-7x-41_0_0
layout: docs
section: security
description: Changelog for Search Guard 7.x-41.0.0
---
<!--- Copyright 2020 floragunn GmbH -->

# Changelog for Search Guard 7.x-41.0.0

**Release Date: 05.05.2020**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7){:target="_blank"}

## Features

* [JWT: Support for nested keys](/latest/json-web-tokens){:target="_blank"}
  * Makes it possible to extract username and roles from a nested JSON structure by using JSON Path expressions
  * Tracking number: SGD-19
<br /><br />


* [Introduce "skip_users" for all authenticators and authorizers](/latest/authentication-authorization){:target="_blank"}
  * Makes it possible to skip certain users globally when performing authc/authz
  * Tracking number: SGD-15
<br /><br />

* [Block users on a global level](/latest/rest-api-blocks){:target="_blank"}
  * Makes it possible to block user accounts on a global level
  * Tracking number: SGD-335
<br /><br />

* [IP filtering](/latest/rest-api-blocks){:target="_blank"}
  * Makes it possible to block IPs and netmasks on a global level  
  * Tracking number: SGD-302
<br /><br />

* [Signals: Implement watch id and tenant as runtime attribute](/latest/signals-alerting-scripting){:target="_blank"}
  * The watch id and the tenant attributes can now be used in Painless scripts 
  * Tracking number: SGD-446
<br /><br />

* [Signals: Add a flag to Execute Watch REST API which allows to view scope of scripts](/latest/elasticsearch-alerting-rest-api-watch-execute){:target="_blank"}
  * If `show_all_runtime_attributes`is set to true, the API response will contain the  the complete set of attributes that are available to scripts and templates after all checks have been finished. 
  * Tracking number: SGD-443
<br /><br />

* Added support for X-Pack SQL
  * Makes it possible to use X-Pack SQL with Search Guard
  * Tracking number: SGD-23   

## Fixes 

* Signals: Broken InternalAuthTokenProvider due to all nodes believing they are master on startup
  * During Signals startup, under certain circumstances, more than one node may start to create Signals indices
  * This has no runtime impact, but leads to exceptions in the logs
  * Tracking number: SGD-225   
<br />

* Signals: Painless whitelist and Mustache map attributes disagree about the structure of SeverityMapping.EvaluationResult
  * Tracking number: SGD-452     
<br />

* Signals: Monthly trigger allows only to configure the day of month 1 to 12
  * Tracking number: SGD-449 
<br /><br />

* Update Jackson Databind
  * Jackson reports a [security vulnerability](https://github.com/FasterXML/jackson-databind/issues/2653){:target="_blank"} which affects jackson-databind-2.8.11.1
  * Search Guard is not affected by this vulnerability:
     * No direct input from untrusted sources, no polymorphic type deserialisation, not use of "gadget types" in JSON POJOs
  * Jackson has been upgraded nonetheless in Search Guard and the TLS Tool  

## Security Fixes 

 * n/a