---
title: Overview
html_title: Search Guard Configuration Overview
permalink: search-guard-index
layout: docs
edition: community
description: Search Guard stores its configuration in an Elasticsearch index. This
  allows for configuration hot-reloading
---
<!--- Copyright 2022 floragunn GmbH -->

# Search Guard configuration overview
{: .no_toc}

Most configuration settings for Search Guard - including users, roles and permissions - are stored as documents in the Search Guard configuration index and can be manipulated only using the `sgctl` tool, API or the Search Guard Configuration UI.

This index is secured so that only an admin user with an admin TLS certificate may write or read this index. Admin certificates are configured in `elasticsearch.yml`.

Keeping the configuration settings in an Elasticsearch index enables hot config reloading. This means that you can change any of the user, role and permission or authentication settings at runtime, without restarting your nodes. Configuration changes will take effect immediately.

You can load and change the settings from any machine which has access to your Elasticsearch cluster. You do not need to keep any configuration files on the nodes.

The core configuration consists of the following files:

* `sg_authc.yml`: [authentication](authentication-authorization-configuration)
* `sg_roles.yml`: [roles and the associated permissions](action-groups)
* `sg_roles_mapping.yml`: [mapping users to roles](mapping-users-roles)
* `sg_internal_users.yml`: [locally defined users, roles and attributes](internal-users-database)
* `sg_action_groups.yml`: [named permission groups](action-groups)

If you are running Kibana you might also need the following configuration:

* `sg_frontend_authc.yml`: [authentication for Kibana](kibana-authentication-types)
* `sg_frontend_multi_tenancy.yml`: [basic multi-tenancy settings for Kibana](kibana-multi-tenancy)
* `sg_tenants.yml`: [tenants for multi-tenancy](kibana-multi-tenancy)
* `sg_license_key.yml`: [enterprise license key](changelog-searchguard-flx-1_0_0#sg_license_key)

For special features or configuration, you have also the following files:

* `sg_authz.yml`: authorization-specific settings
* `sg_auth_token_service.yml`: [API auth token service](authentication-authorization-configuration)
* `sg_blocks.yml`: defines blocked users and IP addresses


Configuration settings are applied by pushing the content of one or more configuration files to the Search Guard secured cluster by using the `sgctl` tool. For details, refer to the [sgctl docs](sgctl).

