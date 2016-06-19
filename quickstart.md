<!---
Copryight 2016 floragunn UG (haftungsbeschränkt)
-->

# Quick start: Search Guard Bundle

Start easy with Search Guard. The bundle ships Elasticsearch + Search Guard with a preconfigured environment, which allows easy testing and evaluation. The bundle contains the latest version of Search Guard, Search Guard SSL and all commercial modules like Ldap Authentication, Kerberos Authentication, Document- and Fieldlevel Security as well as Audit Logging.

This feature is still in Beta, but if you want to give it a try, download the Search Guard Bundle here:

[https://github.com/floragunncom/search-guard/wiki/Search-Guard-Bundle](https://github.com/floragunncom/search-guard/wiki/Search-Guard-Bundle)

## How to use it
* ``tar -xzvf elasticsearch-<UUID>.tar.gz``
* ``./elasticsearch-2.3.3-localhost/bin/elasticsearch``
* Open a new shell and ``cd`` into the directory where you unpacked the bundle
* ``cd searchguard-client``
* ``./sgadmin.sh``
 * This will install the configuration from ``searchguard-client/plugins/search-guard-2/sgconfig/`` (.yml files)
 * If you like to change the configuration do this in that directory
 * If you need to configure SSL and a few other options which are not hot reloadable you have to do this in elasticsearch.yml which is here: ``elasticsearch-2.3.3-localhost/config/elasticsearch.yml``
* If you like to test LDAP and/or Kerberos Authentication and you have no proper LDAP/Kerberos environment pls. refer to https://github.com/floragunncom/kerberos_ldap_environment
* run ``curl -k -u admin:admin https://localhost:9200/_searchguard/authinfo``