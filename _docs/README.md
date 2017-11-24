<!---
Copryight 2016-2017 floragunn GmbH
-->

# Search Guard 6 Beta1 Documentation

This is the official documentation for Search Guard 6 Beta1. If you find any errors, or want to contribute, feel free to fork this repository and issue pull requests.

Search Guard is a trademark of floragunn GmbH, registered in the U.S. and in other countries

Elasticsearch, Kibana, Logstash, and Beats are trademarks of Elasticsearch BV, registered in the U.S. and in other countries.

floragunn GmbH is not affiliated with Elasticsearch BV.

Copyright 2016-2017 floragunn GmbH

## Table of contents

### Preface

* [Frontmatter](frontmatter.md)
* [Search Guard Main Concepts](overview.md)
* [Quickstart: Using the demo installer](quickstart.md)
* [Demo installer: generated artefacts](demo_installer_artefacts.md)

### Installation

* [Installing Search Guard on Elasticsearch](installation.md)
* [Upgrading Search Guard](upgrading.md)
* [Upgrading Enterprise modules manually](upgrading_enterprise_modules.md)
* [Removing Enterprise modules manually](removing_enterprise_modules.md)
* [Disabling or Removing Search Guard](removing.md)
* [Compatibility with other plugins](compatibility.md)


### License Handling

* [Enterprise Edition](license_enterprise.md)
* [Community Edition](license_community.md)

### TLS settings

* [Generating demo TLS certificates](tls_generate_demo_certificates.md)
* [TLS settings](tls_configuration.md)
* [Moving TLS to production](tls_certificates_production.md)
* [Using OpenSSL](tls_openssl.md)
* [Expert features: Custom implementations and SSLContext](tls_expert.md)

### Search Guard configuration with sgadmin

* [Using sgadmin](sgadmin.md)
* [sgadmin Examples](sgadmin_examples.md)
* [Moving the configuration to production](configuration_production.md)

### Configuring Authentication and Authorization modules

* [Configuring authentication and authorisation](configuration_auth.md)
* [HTTP Basic Authentication](httpbasic.md)
* [LDAP and Active Directory](ldap.md)
* [Kerberos](kerberos.md)
* [JSON Web token](jwt.md)
* [Proxy Authentication](proxy_auth.md)
* [Client Certificate Authentication](clientcert_auth.md)
* [Custom authentication modules](custom_auth.md)

### Configuring Users, Roles and Permissions
* [Adding users to the internal user database](configuration_internalusers.md)
* [Using and defining action groups](configuration_action_groups.md)
* [Defining roles and permissions](configuration_roles_permissions.md)
* [Mapping users to Search Guard roles](configuration_roles_mapping.md)
* [Expert: Role Mapping Modes](configuration_roles_mapping_modes.md)

### Document- and Field-Level-Security
* [Document and field level security](dlsfls.md)

### Audit Logging
* [Audit Logging](auditlogging.md)

### REST Management API
* [REST management API](managementapi.md)

### Using Search Guard with Kibana
* [Installing Search Guard on Kibana](kibana.md)
* [Authentication](kibana_authentication.md)
* [Using Kibana Multitenancy](multitenancy.md)
* [Using the Search Guard configuration GUI](kibana_config_gui.md)

### Using Search Guard with Logstash
* [Using Search Guard with logstash](logstash.md)

### Cross Cluster Search and Tribe Node support
* [Cross Cluster Search](crossclustersearch.md)
* [Tribe nodes](tribenodes.md)

### Integrating with X-Pack
* [Using Search Guard with X-Pack Monitoring](x_pack_monitoring.md)
* [Using Search Guard with X-Pack Alerting](x_pack_alerting.md)
* [Using Search Guard with X-Pack Machine Learning](x_pack_machine_learning.md)

### Integrating with X-Pack Alternatives
* [Using Search Guard with ElastAlert](elastalert.md)

### Various
* [Running Search Guard behind a proxy](proxies.md)
* [User cache settings](configuration_cache.md)
* [Snapshot & Restore](snapshots.md)
* [Index alias handling](configuration_alias.md)
* [Search Guard index management](sgindex.md)

### Addendum
* [Addendum A: Configuration Examples](addendum_a_configuration_examples.md)
* [Addendum B: Permission settings Examples](addendum_b_permission_settings_examples.md)
* [Addendum C: TLS explained](addendum_c_tls_primer.md)

### Search Guard End Of Life policy
* [Search Guard End Of Life policy](eol.md)

### Changelogs

* [Search Guard 6.0.0-17.beta1](changelogs/changelog_6.0.0-17.beta1.md)