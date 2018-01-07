---
title: Active Directory and LDAP
html_title: Active Directory and LDAP
slug: active-directory-ldap
category: authauth
subcategory: ldap
order: 300
layout: docs
description: Use Search Guard's Active Directory and LDAP module to protect your Elasticsearch cluster against unauthorized access.
---
<!---
Copryight 2016-2017 floragunn GmbH
-->

# Active Directory and LDAP

Active Directory and LDAP can be used for authentication and authorisation thus it can be used both in the `authc` and `authz` section of the configuration. 

The `authc` section is used for configuring authentication, which means to check if the user has entered the correct credentials. The `authz` is used for authorisation, which defines how the role(s) for an authenticated user are retrieved and mapped.

In most cases, you want to configure both authentication and authorization, however, it is also possible to use authentication only and map the users retrieved from LDAP directly to Search Guard roles. 

## Where to go next

* Configure the [connection settings](ldap_connection.md) for your Active Directory or LDAP server
* Use Active Directory and LDAP for [user authentication](ldap_authentication.md).
* Use Active Directory and LDAP for [user authorisation](ldap_authorisation.md).
