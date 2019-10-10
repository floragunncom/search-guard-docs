---
title: sgadmin Examples
slug: sgadmin-examples
category: configuration
order: 200
layout: docs
description: Example sgadmin calls that you can use as template and blueprint.
---
<!---
Copyright 2017 floragunn GmbH
-->
# sgadmin Examples

#### Apply default configuration with Keystore and Truststore files

```bash
./sgadmin.sh \
   -cd /path/to/sgconfig/ \
   -ks /path/to/keystore.jks \
   -kspass changeit \
   -ts /path/to/truststore.jks \
   -tspass changeit
   -nhnv
   -icl
```

#### Apply default configuration with PEM certificates
```bash
./sgadmin.sh \
   -cd /path/to/sgconfig/ \
   -cacert /path/to/root-ca.pem \
   -cert /path/to/kirk.crt.pem \
   -key /path/to/kirk.key.pem  \
   -keypass changeit
   -nhnv
   -icl
```

#### Apply single file to cluster named "myclustername"
```bash
./sgadmin.sh \ \
   -f /path/to/sg_internal_users.yml \
   -t internalusers \
   -ks /path/to/keystore.jks \
   -kspass changeit
   -ts /path/to/truststore.jks \
   -tspass changeit
   -cn myclustername \
   -nhnv
```

#### Apply single file, ignoring clustername but specifying host and port
```bash
./sgadmin.sh \
   -h esnode1.mycompany.com \
   -p 9301 \
   -f /path/to/updated_internal_users.yml \
   -t internalusers \
   -ks /path/to/keystore.jks \
   -kspass changeit
   -ts /path/to/truststore.jks \
   -tspass changeit
   -icl
```
#### Retrieving the current active Search Guard configuration from a cluster
```bash
./sgadmin.sh \
   -ks /path/to/keystore.jks \
   -kspass changeit
   -ts /path/to/truststore.jks  \
   -tspass changeit
   -r
```

#### Reload the current configuration, thus flushing the Search Guard user caches

```bash
plugins/search-guard-2/tools/sgadmin.sh \
   -ks plugins/search-guard-2/sgconfig/keystore.jks \
   -kspass changeit
   -ts plugins/search-guard-2/sgconfig/truststore.jks  \
   -tspass changeit
   -r  
```

#### Setting the number of replica shards to 5

```bash
./sgadmin.sh \
   -ks /path/to/keystore.jks \
   -kspass changeit
   -ts /path/to/truststore.jks \
   -tspass changeit
   -us 5
```

#### Enabling replica auto expansion
```bash
plugins/search-guard-2/tools/sgadmin.sh \
   -ks plugins/search-guard-2/sgconfig/keystore.jks \
   -kspass changeit
   -ts plugins/search-guard-2/sgconfig/truststore.jks \
   -tspass changeit
   -era
```
