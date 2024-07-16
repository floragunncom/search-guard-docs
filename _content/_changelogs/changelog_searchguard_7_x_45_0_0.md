---
title: Search Guard 7.x-45.0.0
permalink: changelog-searchguard-7x-45_0_0
category: changelogs-searchguard
order: 200
layout: changelogs
description: Changelog for Search Guard 7.x-45.0.0	
---

<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 01.09.2020**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## Improvements



### User Attributes

This release of Search Guard introduces a new mechanism for providing custom user attributes to be used inside dynamic DLS queries and dynamic index patterns.

The old mechanism, which used attributes prefixed with `${attr.ldap...}`, `${attr.jwt...}` had a number of issues and limitations. For example, it was not possible to construct DLS queries which could be used both with an LDAP and a JWT auth domain. Also, multi-valued or other complex attributes were not supported. The old mechanism remains available for now, but should be considered as deprecated.
 
The new mechanism makes changes both to the source and to the sink of the attributes:

- Attributes now need to be explicitely mapped by the auth domains in order to be included in the Search Guard user attributes. For example, this allows to map an attribute which is called `dept_no` in JWT claims and `departmentNumber` in LDAP attributes to the unified name `department` in the Search Guard user attributes.
- Inside DLS queries and index patterns, these mapped attributes are now made available under the prefix `${user.attrs...}`. The variable substitution syntax has been extended to have greater control over the format of the substituted string. For example, the expression `${user.attrs.department?:["99"]|toList|toJson}` makes sure that the value stored in the attribute called `department` is a list and converts it to JSON syntax. If the attribute is unset, `["99"]` is used as fallback value.

The new mechanism is available for JWT and Proxy authenticators and the LDAP authc backends. It is not yet available for the internal user database. Support for this will follow soon.

More details can be found here:
- [Index Patterns](https://search-guard.com/docs/latest/roles-permissions)
- [DLS](https://search-guard.com/docs/latest/document-level-security)
<p />


### Audit Logging

* Introduced new audit logging categories for accesses from blocked IPs and accesses using blocked user accounts.
<p />


## Bug Fixes



### Signals

* Executing a watch with a severity mapping where the actual value was below all thresholds would have caused a NullPointerException. Fixed.
<p />


### Privileges and Permissions

* User blocking was not effective for requests originating from transport clients. Fixed.
<p />


