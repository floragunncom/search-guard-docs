<!---
Copryight 2016-2017 floragunn GmbH
-->

# Search Guard Documentation

This is the official documentation for Search Guard 5 and Search Guard 2. If you find any errors, or want to contribute, feel free to fork this repository and issue pull requests.

Unless stated otherwise, all instructions apply for  Search Guard 5 and Search Guard 2. If there are differences between the versions, this will be made clear in the documentation.

Search Guard is a trademark of floragunn GmbH, registered in the U.S. and in other countries

Elasticsearch, Kibana, Logstash, and Beats are trademarks of Elasticsearch BV, registered in the U.S. and in other countries.

floragunn GmbH is not affiliated with Elasticsearch BV.

Copyright 2016-2017 floragunn GmbH

## Table of contents

### Preface

* [Frontmatter](frontmatter.md)
* [Quickstart](quickstart.md)
* [Search Guard Main Concepts](overview.md)

### Installation

* [Installing Search Guard](installation.md)
* [Upgrading Search Guard](upgrading.md)
* [Disabling or Removing Search Guard](removing.md)
* [Compatibility with other plugins](compatibility.md)

### Configuring TLS

* [Generating demo TLS certificates](tls_generate_demo_certificates.md)
* [Configuring TLS](tls_configuration.md)
* [Moving TLS to production](tls_certificates_production.md)
* [Using OpenSSL](tls_openssl.md)
* [Troubleshooting TLS problems](tls_troubleshooting.md)
* [Expert features: Custom implementations and SSLContext](tls_expert.md)

### Configuring Users, Roles and Permissions

* [Using sgadmin](sgadmin.md)
* [sgadmin Examples](sgadmin_examples.md)
* [Troubleshooting sgadmin](sgadmin_troubleshooting.md)
* [Configuring authentication and authorisation](configuration_auth.md)
* [Adding users to the internal user database](configuration_internalusers.md)
* [Mapping users to Search Guard roles](configuration_roles_mapping.md)
* [Defining roles and permissions](configuration_roles_permissions.md)
* [Using and defining action groups](configuration_action_groups.md)
* [Moving the configuration to production](configuration_production.md)
* [User cache settings](configuration_cache.md)
* [Index alias handling](configuration_alias.md)

### Configuring Authentication and Authorisation modules

* [HTTP Basic Authentication](httpbasic.md)
* [LDAP and Active Directory](ldap.md)
* [Kerberos](kerberos.md)
* [JSON Web token](jwt.md)
* [Proxy Authentication](proxy_auth.md)
* [Client Certificate Authentication](clientcert_auth.md)

### Document- and Field-Level-Security
* [Document and field level security](dlsfls.md)

### Audit Logging
* [Audit Logging](auditlogging.md)

### REST Management API
* [REST management API](managementapi.md)

### Search Guard index management
* [Search Guard index management](sgindex.md)

### Running Search Guard behind a Proxy
* [Running Search Guard behind a proxy](proxies.md)

### Integrating with the Elastic Stack
* [Using Search Guard with Kibana](kibana.md)
* [Using Kibana Multitenancy](multitenancy.md)
* [Using Search Guard with logstash](logstash.md)
* [Snapshot & Restore](snapshots.md)
* [Tribe nodes](tribenodes.md)

### Integrating with X-Pack
* [Using Search Guard with X-Pack Monitoring](x_pack_monitoring.md)
* [Using Search Guard with X-Pack Alerting](x_pack_alerting.md)
* [Using Search Guard with X-Pack Machine Learning](x_pack_machine_learning.md)

### Integrating with X-Pack Alternatives
* [Using Search Guard with ElastAlert](elastalert.md)

### Addendum
* [Addendum A: Configuration Examples](addendum_a_configuration_examples.md)
* [Addendum B: Permission settings Examples](addendum_b_permission_settings_examples.md)
* [Addendum C: TLS explained](addendum_c_tls_primer.md)

### Search Guard End Of Life policy
* [Search Guard End Of Life policy](eol.md)