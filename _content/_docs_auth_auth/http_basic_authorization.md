---
title: Overview
permalink: http-basic-authorization
layout: docs
edition: community
description: How to set up HTTP Basic Authentication on the REST layer of Elasticsearch
  with Search Guard.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Password-based authentication
{: .no_toc}

If you want to use a user name and password to log into Elasticsearch, you need to use the `basic` authentication frontend combined with an authentication backend. For the authentication backend, you have the following options:

* The simplest setup uses the Search Guard **internal users database** as the authentication backend; for this, you just have to define the users. No further configuration is necessary. See the section [internal users database](internal-users-database) for more details on this.

* If you want to use **Active Directory/LDAP** for authenticating users, you can use the `ldap` authentication backend. This requires a bit more configuration; see the [LDAP and Active Directory docs](active-directory-ldap) for more information.

**Note:** Users of older Search Guard versions might know the `challenge` flag which controls whether Search Guards sends HTTP Basic challenges for unauthenticated requests. The new version of Search Guard is capable of sending multiple challenges at once. Thus, this flag is no longer needed.

