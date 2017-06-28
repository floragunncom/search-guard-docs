<!---
Copryight 2016 floragunn GmbH
-->

# Search Guard Documentation

This is the official documentation for Search Guard 2 and Search Guard 5. If you find any errors, or want to contribute, feel free to fork this repository and issue pull requests.

Unless stated otherwise, all instructions apply for Search Guard 2 and Search Guard 5. If there are differences between the versions, this will be made clear in the documentation.

floragunn GmbH is not affiliated with Elasticsearch BV.

Search Guard is a trademark of floragunn GmbH, registered in the U.S. and in other countries

Elasticsearch, Kibana, Logstash, and Beats are trademarks of Elasticsearch BV, registered in the U.S. and in other countries.

Copyright 2016-2017 floragunn GmbH

## Table of contents

### Preface

* [Frontmatter](frontmatter.md)
* [Quickstart](quickstart.md)
* [Simple ELK Example](exampleELK.md)
* [Search Guard Overview](overview.md)

### Installation

* [Installing Search Guard](installation.md)
* [Upgrading Search Guard](upgrading.md)

### Configuring Search Guard SSL

* [Generating TLS certificates](tls_overview.md)
* [Configuring TLS](tls_configuration.md)
* [TLS node certificates](tls_node_certificates.md)
* [Using OpenSSL](tls_openssl.md)
* [Expert features: Custom SSLContext and PrincipalExtractor](tls_expert.md)

### Configuring Search Guard

* [Search Guard configuration](configuration.md)
* [Using sgadmin to change configuration](sgadmin.md)
* [Search Guard index management](sgindex.md)
* [Running Search Guard behind a proxy](proxies.md)

### Authentication and Authorisation

* [Internal user database](internalusers.md)
* [HTTP Basic Authentication](httpbasic.md)
* [LDAP and Active Directory](ldap.md)
* [Kerberos](kerberos.md)
* [JSON Web token](jwt.md)
* [Proxy Authentication](proxy_auth.md)

### Document- and Field-Level-Security
* [Document and field level security](dlsfls.md)

### Audit Logging
* [Audit Logging](auditlogging.md)

### REST Management API
* [REST management API](managementapi.md)

### Integrating with the Elastic Stack
* [Using Search Guard with Kibana](kibana.md)
* [Kibana Multitenancy](multitenancy.md)
* [Using Search Guard with logstash](logstash.md)
* [Using Search Guard with X-Pack Monitoring](monitoring.md)
* [Tribe nodes](tribenodes.md)
* [Snapshot & Restore](snapshots.md)

### Addendum
* [Addendum A: Configuration Examples](addendum_a_configuration_examples.md)
* [Addendum B: Permission settings Examples](addendum_b_permission_settings_examples.md)
* [Addendum C: TLS explained](addendum_c_tls_primer.md)

### Search Guard End Of Life policy
* [Search Guard End Of Life policy](eol.md)