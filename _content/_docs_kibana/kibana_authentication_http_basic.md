---
title: Quick Start
html_title: Username/password based authentication for Kibana
permalink: kibana-authentication-http-basic
layout: docs
edition: community
description: How to configure Kibana for Username/password based authentication. Secure Kibana access with a login screen.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Password-based authentication for Kibana
{: .no_toc}

This approach is the most simple and most commonly used authentication type. If a user tries to access Kibana:  

* Search Guard checks whether the user has an active session with valid username/password credentials
* If so, the user is allowed to access Kibana and the underlying Elasticsearch cluster.
* If the user does not have an active session, Search Guard will show a login form. The user now has to log in using their username and password.

This approach can be used to authenticate users using the [Search Guard internal user database](internal-users-database)  or using [LDAP](active-directory-ldap).

Suppose the Search Guard Elasticsearch backend has been already configured with username/password-based authentication. In that case, this should also work out of the box for Kibana.<br>You only have to make sure that users who are supposed to log into Kibana have the role `SGS_KIBANA_USER`.

{: .note .js-note .note-warning}

To verify the configuration for this approach, follow the steps described in the following sections.

## Search Guard Setup

Ensure that you configured authentication domains of type `basic` in the Search Guard `sg_authc` or `sg_config` configuration. In most cases, you already created this configuration when configuring the Elasticsearch backend.

For the internal user database, such an entry in `sg_authc.yml` might look like this:

```yaml
auth_domains:
  - type: basic/internal_users_db
```

See the chapters on the [Search Guard internal user database](internal-users-database) and [LDAP](active-directory-ldap) for more details on setting up such auth domains.

The Kibana-specific part of the authentication configuration is done in the file `sg_frontend_authc.yml`. By default, this file contains this entry:

```yaml
default:
  auth_domains:
  - type: basic
    label: "Login"
```

This makes Kibana use the username/password-based authentication domains available in the backend.

Username/password-based authentication requires no specific settings in the `kibana.yml` configuration file.